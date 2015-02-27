create procedure usp_rpt_Claims_Policy_Loss_Info
--drop procedure usp_rpt_Claims_Policy_Loss_Info
--exec           usp_rpt_Claims_Policy_Loss_Info 90000, 'Y'
--exec           usp_rpt_Claims_Policy_Loss_Info 7160, 'Y'
--exec           usp_rpt_Claims_Policy_Loss_Info 12446, 'Y'

@Policy_Number int,
@History       varchar(02)

as

set nocount ON

-- ----------------------------------------------------------------------------------------------------------------------------
--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[#SubHistory]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [dbo].[#SubHistory]
--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[#ClaimDetail]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [dbo].[#ClaimDetail]

create table [#SubHistory] (
	[SORT_BY]           [int] not NULL ,
	[SUB_RECORD_NUMBER] [int] not NULL 
) on [PRIMARY]

-- Create temp table for all data to be returned
create table [#ClaimDetail](
        [Sub_Record_Number] [int] not NULL,
        [InsuredName] [varchar](60) NULL,
        [TotalIndPaid] [numeric] (18,2) NULL,
        [TotalExpPaid] [numeric] (18,2) NULL, 
        [IndReserve] [numeric] (18,2) NULL,
        [ExpReserve] [numeric] (18,2) NULL,
        [ClaimNumber] [varchar] (10) NULL,
        [ClaimStatus] [varchar] (2) NULL,
        [DateofLoss] [datetime] NULL,
        [AccidentCity] [varchar] (30) NULL,
        [AccidentState] [varchar] (10) NULL,
        [LongDescription] [varchar] (250) NULL,
        [SuffixNumber] [varchar] (3) NULL,
        [ClaimantName] [varchar] (60) NULL,
        [DateReported] [datetime] NULL,
        [PolicyNumber] [varchar] (12) NULL,
        [PolicyLimit] [numeric] (18,2) NULL,
        [DeductibleComment] [varchar] (2000) NULL,
        [EffectiveDate] [datetime] NULL,
        [ExpirationDate] [datetime] NULL,
        [PolicySymbol] [varchar] (10) NULL,
        [PolicySuffix] [varchar] (3) NULL,
        [UnderwriterName] [varchar] (30) NULL,
        [ClaimOffice] [varchar] (3) NULL,
        [SuffixStatus] [varchar] (2) NULL,
        [ClaimPro] [varchar] (20) NULL,
	[ShortDescription] [varchar] (50) NULL
) on [PRIMARY]

-- ----------------------------------------------------------------------------------------------------------------------------
declare @sortby               as int
declare @subrecnbr            as int
declare @prior_subrecnbr      as int

set @sortby        = 1

if @Policy_Number <> 0 and @Policy_Number is not NULL
   begin
      set @subrecnbr = ( select      SUB_RECORD_NUMBER 
                         from        SUBMISSION sub
                         where       1=1
                           and       sub.SUB_POLICY_NUMBER = @Policy_Number
                           and       sub.SUB_POLICY_SUFFIX = ( select     max( sub.SUB_POLICY_SUFFIX ) 
                                                               from       SUBMISSION sub
                                                               where      1=1
                                                                 and      sub.SUB_POLICY_NUMBER = @Policy_Number) )
   end

if @subrecnbr is not NULL 
   begin
   --print ltrim( str( @subrecnbr ) )
   
      insert #SubHistory
      select @sortby, @subrecnbr

      --select * from #SubHistory

      --Loop through all prior submissions if user specified to include history...
      if upper( @History ) = 'Y' 
         begin
      
            --Initialize prior sub record number
            set @prior_subrecnbr = ( select     sub.PRIOR_SUB_RECORD_NUMBER
                                     from       SUBMISSION sub
                                     where      1=1
                                       and      sub.SUB_RECORD_NUMBER = @subrecnbr )
            --print ltrim( str( @prior_subrecnbr ) )
      
            while ( @prior_subrecnbr is not NULL ) and ( @prior_subrecnbr <> @subrecnbr )
               begin
                  set @sortby = @sortby + 1                       --increment @sortby by 1
                  set @subrecnbr = @prior_subrecnbr               --assign prior sub record number to sub record number
         
                  insert #SubHistory
                  select @sortby, @prior_subrecnbr
      
                  set @prior_subrecnbr = ( select     sub.PRIOR_SUB_RECORD_NUMBER
                                           from       SUBMISSION sub 
                                           where      1=1
                                             and      sub.SUB_RECORD_NUMBER = @subrecnbr )
               end
         end
   end
--truncate table #SubHistory

--truncate table #ClaimDetail

declare policy_cursor cursor for
     select    t1.SUB_RECORD_NUMBER
     from      #SubHistory t1
     where     1=1
     order by  t1.SORT_BY
open policy_cursor

fetch next from policy_cursor into @subrecnbr
--print ltrim( str( @subrecnbr ) )

while @@FETCH_STATUS = 0
  begin
    insert    #ClaimDetail 
    select    sub.SUB_RECORD_NUMBER,
              cast(sub.Sub_Insured_Name as varchar(60)), 
              cs.TotalIndPaid, 
              cs.TotalExpPaid,
              cs.IndReserve,
              cs.ExpReserve,
              cast(c.ClaimNumber as varchar(10)), 
              cast(c.ClaimStatus as varchar(02)), 
              c.DateofLoss, 
              cast(c.AccidentCity as varchar(30)), 
              cast(c.AccidentState as varchar(10)), 
              cast(c.LongDescription as varchar(250)), 
              cast(cs.SuffixNumber as varchar(03)), 
              cast(cs.ClaimantName as varchar(60)), 
              c.DateReported, 
              cast( (ic.COMPANY_CODE + ps.POLICY_CODE + convert(varchar,sub.Sub_Policy_Number)) as varchar(12)) as PolicyNumber,
              isnull( sum(qbpl.Occur_LIMIT), 0 ) as PolicyLimit, 
              cast(cp.DeductibleComment as varchar(2000)), 
              sub.Sub_Current_Effective_Date, 
              sub.Sub_Current_Expiration_Date, 
              cast(cp.PolicySymbol as varchar(10)), 
              cast(sub.Sub_Policy_Suffix as varchar(03)), 
              cast(emp.EMP_LAST_NAME as varchar(30)), 
              cast(c.ClaimOffice as varchar(03)), 
              cast(cs.SuffixStatus as varchar(02)), 
              cast(Emp1.Emp_Last_Name as varchar(20)) as ClaimPro,
              cast(c.ShortDescription as varchar(50))
     from     SUBMISSION sub inner join DEPARTMENTS dept        on sub.DEPARTMENT_NUMBER     = dept.DEPARTMENT_NUMBER 
                             inner join EMPLOYEE emp            on sub.EMP_RECORD_NUMBER     = emp.EMP_RECORD_NUMBER
                             inner join INSURANCE_COMPANIES ic  on sub.COMPANY_RECORD_NUMBER = ic.COMPANY_RECORD_NUMBER
                             inner join POLICY_SYMBOL ps        on sub.SUB_POLICY_SYMBOL     = ps.SYMBOL_SKEY
                             inner join QB_POLICY_LIMITS qbpl   on sub.SUB_RECORD_NUMBER     = qbpl.SUB_RECORD_NUMBER
                                                               and sub.QB_Sequence_No        = qbpl.QB_Sequence_No
                        left outer join CLAIMPOLICY cp          on sub.SUB_RECORD_NUMBER     = cp.SubRecordNumber 
                        left outer join claims C                on cp.ClaimPolicyKey         = c.ClaimPolicyKey         
                        left outer join ClaimSuffix CS          on c.ClaimKey                = cs.ClaimKey 
                        left outer join EMPLOYEE emp1           on c.ClaimProfessional       = emp1.EMP_RECORD_NUMBER
    where     1=1
      and     sub.SUB_RECORD_NUMBER   = @subrecnbr
      and dept.Underwriting_Flag  = 'Y'
    group by  sub.SUB_RECORD_NUMBER,
              sub.Sub_Insured_Name, 
              cs.TotalIndPaid,
              cs.TotalExpPaid, 
	      cs.TotalIndPaid, 
              cs.TotalExpPaid, 
              cs.IndReserve, 
              cs.ExpReserve, 
	      cs.IndReserve, 
              cs.ExpReserve, 
              c.ClaimNumber, 
              c.ClaimStatus, 
              c.DateofLoss, 
	      c.AccidentCity, 
              c.AccidentState, 
              c.LongDescription, 
              cs.SuffixNumber, 
	      cs.ClaimantName, 
              c.DateReported, 
              ic.COMPANY_CODE, 
              ps.POLICY_CODE,
	      sub.Sub_Policy_Number, 
              cp.DeductibleComment, 
              sub.Sub_Current_Effective_Date,
	      sub.Sub_Current_Expiration_Date, 
              cp.PolicySymbol, 
              sub.Sub_Policy_Suffix,
	      emp.EMP_LAST_NAME, 
              c.ClaimOffice, 
              cs.SuffixStatus, 
              Emp1.Emp_last_name,
              c.ShortDescription

  fetch next from policy_cursor into @subrecnbr

end
close policy_cursor
deallocate policy_cursor

--select * from #ClaimDetail

-- Return results (excludes submissions that have no claims)
select    InsuredName, 
          TotalIndPaid, 
          TotalExpPaid, 
          TotalIndPaid + TotalExpPaid as totalpaid, 
          IndReserve, 
          ExpReserve, 
          IndReserve + ExpReserve as TotalReserve, 
          IndReserve + TotalIndPaid as IndIncurred, 
          ExpReserve + TotalExpPaid as ExpIncurred, 
          ClaimNumber, 
          ClaimStatus, 
          DateofLoss, 
          AccidentCity, 
          AccidentState, 
          LongDescription, 
          SuffixNumber, 
          ClaimantName,
          DateReported, 
          PolicyNumber, 
          PolicyLimit, 
          DeductibleComment, 
          EffectiveDate, 
          ExpirationDate, 
          PolicySymbol, 
          PolicySuffix, 
          UnderwriterName, 
          ClaimOffice, 
          SuffixStatus, 
          ClaimPro,
          ShortDescription
from      #ClaimDetail
where     1=1
order by  ExpirationDate desc,
          PolicyNumber,
          PolicySuffix desc, 
          ClaimNumber, 
          SuffixNumber

-- ----------------------------------------------------------------------------------------------------------------------
-- Version History
-- ---------------   
-- Date          Developer       Comment(s)
-- ----------    --------------  ----------------------------------------------------------------------------------------
-- 08/22/2003    mwisor          Removed all references to org number.
-- 12/16/2002    sonnyb          Updated.
--                               1) Change data type of @Policy_Number from varchar(10) to int;
--                               2) Added tests for Policy Number being 0 or NULL;
-- 08/15/2002    sonnyb          I discovered that there is a potential of duplicate policy numbers between organizations.
--                               As a result, I added table, organization, to beginning queries.
-- 08/07/2002    sonnyb          Yesterday's rewrite changed an expected behaviour:  even though there are no claims, the
--                               user expects to get the header info (e.g. insured name, policy number, etc.).  This 
--                               requires 'left outer joins' to claims-related tables. 
-- 08/05/2002    sonnyb          Rewritten.
-- ??/??/????    shelms          Original.

