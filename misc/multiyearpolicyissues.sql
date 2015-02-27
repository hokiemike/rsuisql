select s.sub_effective_date, cp.effectivedate, s.sub_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
--and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and ( clms.DateOfLoss > cp.expirationDate or clms.DateOfLoss < cp.effectivedate)
order by clms.DateOfLoss


select s.sub_effective_date, cp.effectivedate, s.sub_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
--and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and ( clms.DateOfLoss > cp.expirationDate or clms.DateOfLoss < cp.effectivedate)
 and s.sub_policy_number IN 
(
)
order by clms.DateOfLoss


select s.sub_policy_symbol, s.sub_policy_number, s.sub_policy_number,s.sub_effective_date, cp.effectivedate, s.sub_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
--and ( clms.DateOfLoss > cp.expirationDate or clms.DateOfLoss < cp.effectivedate)
 and s.sub_record_number IN 
(
select distinct s2.sub_record_number as sub_record_number
from Submission s2 
 join 
(
select s1.sub_policy_number as policynum, 
count(s1.sub_policy_suffix) as suffixcount
from Submission s1
where 1=1
and s1.sub_policy_number != 0
group by s1.sub_policy_number
having count(s1.sub_policy_suffix) > 1
) t on t.policynum = s2.sub_policy_number
union
select distinct s1.sub_record_number as sub_record_number
from Submission s1
where 1=1
and s1.sub_policy_number != 0
and (   s1.prior_sub_record_number is not null
 	or s1.sub_record_number IN 
	( select distinct s2.prior_sub_record_number from submission s2	)
     )
)
order by clms.DateOfLoss

-- claims against "multi-year" policies with dates of loss outside of the curr date range of the submission
select  s.sub_policy_number,clms.claimOffice, clms.claimNumber, s.sub_current_effective_date, cp.effectivedate, s.sub_current_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
--select distinct clms.claimTA
--select s.sub_policy_number, clms.claimOffice, clms.claimNumber, clms.DateOfLoss
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and (   s.prior_sub_record_number is not null
 	or s.sub_record_number IN 
	( select distinct s2.prior_sub_record_number from submission s2	)
     )
and clms.DateOfLoss > '6/30/2003 23:59' 
and not exists 
( select 1 from endorsement e where e.endtype_record_number = 12 and e.sub_record_number = s.sub_record_number )
and not exists
( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.sub_record_number )
order by clms.DateOfLoss

select *
from endorsement_type

select *
from submission where sub_policy_number = 704009

select * from endorsement where sub_record_number = 651279

select * from LossHeader where GLMOnth = 11


select  s.sub_policy_number,clms.claimOffice, clms.claimNumber, s.sub_current_effective_date, cp.effectivedate, s.sub_current_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
--select distinct s.sub_policy_number
--select s.sub_policy_number, count(s.sub_record_number)
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and (   s.prior_sub_record_number is not null 	or s.sub_record_number IN 
	( select distinct s2.prior_sub_record_number from submission s2	where s2.prior_sub_record_number is not null )
    )
and clms.DateOfLoss > '6/30/2003 23:59' 
-- filter out policies with a discovery endorsement
and not exists 
( select 1 from endorsement e where e.endtype_record_number = 12 and e.sub_record_number = s.sub_record_number )
-- filter out policies that were cancelled
and ( exists ( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.sub_record_number )
-- filter out prior policy cancellations
     or exists ( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.prior_sub_record_number )
     )
--group by s.sub_policy_number
--order by count(s.sub_record_number) DESC
--order by s.sub_policy_number
order by clms.DateOfLoss


select  s.sub_policy_number,clms.claimOffice, clms.claimNumber, s.sub_current_effective_date, cp.effectivedate, s.sub_current_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and (   s.prior_sub_record_number is not null 	or s.sub_record_number IN 
	( select distinct s2.prior_sub_record_number from submission s2	where s2.prior_sub_record_number is not null )
    )
-- filter out policies that were cancelled
and ( exists ( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.sub_record_number )
-- filter out prior policy cancellations
     or exists ( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.prior_sub_record_number )
     )
order by clms.DateOfLoss


select  s.sub_policy_number,clms.claimOffice, clms.claimNumber, s.sub_current_effective_date, cp.effectivedate, s.sub_current_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
--select distinct s.sub_policy_number
--select s.sub_policy_number, count(s.sub_record_number)
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and (   s.prior_sub_record_number is null   )
and s.sub_record_number NOT IN ( select distinct s2.prior_sub_record_number from submission s2 
                                 where s2.prior_sub_record_number is not null )
--and clms.DateOfLoss > '6/30/2003 23:59' 
-- filter out policies with a discovery endorsement
and not exists 
( select 1 from endorsement e where e.endtype_record_number = 12 and e.sub_record_number = s.sub_record_number )
-- filter out policies that were cancelled
and not exists
( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.sub_record_number )
-- filter out prior policy cancellations
and not exists
( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.prior_sub_record_number )
group by s.sub_policy_number
order by count(s.sub_record_number) DESC
order by s.sub_policy_number
order by clms.DateOfLoss




-- instances where submission date does not match claim policy date
select  s.sub_policy_number,s.sub_current_effective_Date, cp.effectivedate, s.sub_current_expiration_date, cp.expirationDate, clms.DateOfLoss, clms.*
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
and ( s.sub_current_expiration_Date != cp.expirationDate
	or s.sub_current_effective_date != cp.effectivedate )
order by clms.DateOfLoss



select distinct (s.sub_policy_number)
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
--and ( clms.DateOfLoss > cp.expirationDate or clms.DateOfLoss < cp.effectivedate)
 and s.sub_record_number IN 
(
select s2.sub_record_number
from Submission s2 
 join 
(
select s1.sub_policy_number as policynum, 
count(s1.sub_policy_suffix) as suffixcount
from Submission s1
where 1=1
and s1.sub_policy_number != 0
group by s1.sub_policy_number
having count(s1.sub_policy_suffix) > 1
) t on t.policynum = s2.sub_policy_number
)
order by clms.DateOfLoss



select distinct s2.sub_record_number as sub_record_number
from Submission s2 
 join 
(
select s1.sub_policy_number as policynum, 
count(s1.sub_policy_suffix) as suffixcount
from Submission s1
where 1=1
and s1.sub_policy_number != 0
group by s1.sub_policy_number
having count(s1.sub_policy_suffix) > 1
) t on t.policynum = s2.sub_policy_number
union
select distinct s1.sub_record_number as sub_record_number
from Submission s1
where 1=1
and s1.sub_policy_number != 0
and (   s1.prior_sub_record_number is not null
 	or s1.sub_record_number IN 
	( select distinct s2.prior_sub_record_number from submission s2	)
     )
order by sub_record_number
 

select count(*) from submission




select s1.sub_policy_number as policynum, 
count(s1.sub_record_number) as suffixcount
from Submission s1
where 1=1
and s1.sub_policy_number != 0
group by s1.sub_policy_number
having count(s1.sub_record_number) > 1







select count(*) from submission 
where 1=1
and prior_sub_record_number is not null
and sub_policy_number != 0


--


create procedure usp_tst_SubmissionHistory
--drop procedure usp_tst_SubmissionHistory
--exec             usp_tst_SubmissionHistory 90000, 'Y'
--exec           usp_rpt_Claims_Policy_Loss_Info 7160, 'Y'
--exec           usp_rpt_Claims_Policy_Loss_Info 12446, 'Y'

@Policy_Number int,
@History       varchar(02)

as

set nocount ON


begin

-- ----------------------------------------------------------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[mls_SubGrouping]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[mls_SubGrouping]

create table [mls_SubGrouping] (
	[SUB_GROUP_ID]      [int] not NULL ,
	[SUB_RECORD_NUMBER] [int] not NULL 
) on [PRIMARY]



-- ----------------------------------------------------------------------------------------------------------------------------
declare @groupid              as int
declare @subrecnbr            as int
declare @prior_subrecnbr      as int
declare @next_policy_number   as int

set @groupid        = 1

--select 1 policynumber  not already grouped


while ( @next_policy_number is not NULL )
begin 


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
   
      insert mls_SubHistory
      select @sortby, @subrecnbr

      --select * from mls_SubHistory

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
         
                  insert mls_SubHistory
                  select @sortby, @prior_subrecnbr
      
                  set @prior_subrecnbr = ( select     sub.PRIOR_SUB_RECORD_NUMBER
                                           from       SUBMISSION sub 
                                           where      1=1
                                             and      sub.SUB_RECORD_NUMBER = @subrecnbr )
               end
         end
   end


--get next policy


end -- nextpolicy

end






