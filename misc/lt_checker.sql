if exists (select * from dbo.sysobjects where id = object_id(N'[syschk_LossTrackingPaids]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
   drop procedure syschk_LossTrackingPaids
go

create procedure syschk_LossTrackingPaids 

--exec           syschk_LossTrackingPaids 7 2004

@GLMonth as int,
@GLYear as int
as

-- --------------------------------------------------------------------------------------------------------------------------------------
set nocount on

declare @StartDate  as datetime

declare @Landmark   as int
declare @RIC        as int
declare @Capitol    as int

declare @Dir        as int 
declare @AssAff     as int 
declare @CedAff     as int 
declare @CedNonAff  as int 
declare @AssNonAff  as int 


set @StartDate = '6/30/2003 23:59:59'


set @Landmark  = 693
set @RIC       = 694
set @Capitol   = 695

set @Dir       = 1
set @AssAff    = 2
set @CedAff    = 3
set @CedNonAff = 4
set @AssNonAff = 5

--set @QryType   = 0    
                      --   0) Initialize

                      --  1) All; Payments; Direct
                      --  2) Landmark; Payments; Ceded Affiliate
                      --  3) Landmark; Payments; Ceded Non-Affiliate
	


                      
                      --  23) Capitol; Payments; Ceded Affiliate

                      --  31) RSUI Indemnity; Payments; Direct
                      --  32) RSUI Indemnity; Payments; Assumed Affiliate
                      --  34) RSUI Indemnity; Payments; Ceded Non-Affiliate
                      --  35) RSUI Indemnity; Payments; Assumed Non-Affiliate

                      --  99) Apply final update rule(s)

                      --1000) Import into StatutoryStateLOB
                      --1001) Import into StatutoryCompanyLOB

-- --------------------------------------------------------------------------------------------------------------------------------------
-- Initialization...
-- --------------------------------------------------------------------------------------------------------------------------------------
begin

if exists (select * from dbo.sysobjects where id = object_id(N'[zms_LossTrackingPaid]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
   drop table zms_LossTrackingPaid

create table [zms_LossTrackingPaid] (
	[StepId]                           [int]            NULL ,
	[GLMonth]		           [int]            NULL ,
	[GLYear]			   [int]            NULL ,
	[InsuranceCompanySkey]             [int]            NULL ,
	[RecordType]                       [int]            NULL ,
	[IndemnityPaid]                    [numeric](18, 2) NULL ,
	[ExpensePaid]                      [numeric](18, 2) NULL ,
) on [PRIMARY]


-- --------------------------------------------------------------------------------------------------------------------------------------
-- Landmark Section
-- --------------------------------------------------------------------------------------------------------------------------------------

-- Direct Payments Info...
print 'Step 1 -- Populating All: Direct Info'
delete from zms_LossTrackingPaid
where StepId = 1

insert into zms_LossTrackingPaid
select      1 as StepId,
            @GLMonth as GLMonth,
            @GLYear as GLYear,
            t.InsuranceCompanySkey,
            @Dir as RecordType,
            sum(t.IndemnityPaid) as IndemnityPaid,
            sum(t.ExpensePaid) as ExpensePaid
from        (
              select      --top 10 
                          clms.ClaimKey,
                          csfx.ClaimSuffixKey,
                          p.PaymentKey,
                          cp.SubRecordNumber as Sub_Record_Number, 
                          pc.TypePayCode,
                          pc.TypePayCategoryKey, 
                          ic.COMPANY_SKEY as InsuranceCompanySkey,
                          cast(NULL as int) as AssociatedCompanySkey,
                          ct.[Description] as ClaimTypeDesc,
                          p.TypeRecoveryCode,
                          cp.Department,
                          isnull(p.IndemnityAmount, 0) as IndemnityPaid, 
                          isnull(p.ExpenseAmount, 0)   as ExpensePaid
              -- select top 10 *
              from       Claims clms  inner join ClaimSuffix csfx       on clms.ClaimKey            = csfx.ClaimKey
                                      inner join Payment p              on csfx.ClaimSuffixKey      = p.ClaimSuffixKey 
                                      inner join TypePayCode pc         on p.TypePayCodeKey         = pc.TypePayCodeKey
                                      inner join ClaimType ct           on csfx.ClaimTypeKey        = ct.ClaimTypeKey
                                      inner join CLAIMPOLICY cp         on clms.ClaimPolicyKey      = cp.ClaimPolicyKey 
                                      inner join Insurance_Companies ic on cp.Company_Record_Number = ic.Company_Record_Number 
                                      inner join TypePayCode tpc        on p.TypePayCodeKey         = tpc.TypePayCodeKey
                                      inner join TypePayCategory tpcc   on tpc.TypePayCategoryKey   = tpcc.TypePayCategoryKey
                                 left outer join GENINFO gi             on cp.SubRecordNumber       = gi.SUB_RECORD_NO
              where      1=1
                and      DATEPART(year,p.PaymentDate) = @GLYear
                and      DATEPART(month,p.PaymentDate) = @GLMonth
                and      clms.DateOfLoss >= @StartDate
                and      (ic.COMPANY_SKEY IN (@Landmark, @Capitol, @RIC) and ic.ORG_NUMBER = 2)
           ) t
where      1=1
group by t.InsuranceCompanySkey



print 'Step 2 -- Ceded Affiliate Info'
delete from zms_LossTrackingPaid
where StepId = 2

insert into zms_LossTrackingPaid
select 2 as StepId,
       @GLMonth as GLMonth,
       @GLYear as GLYear,
       InsuranceCompany,
       @CedAff as RecordType,
       -sum(IndemnityPaid) as IndemnityPaid,
       -sum(ExpensePaid) as ExpensePaid
from 
(
select      t.InsuranceCompanySkey as InsuranceCompany,
	    case 
               when t.TypePayCategoryKey = 1 then t.CededTotalAmt
               else cast(0 as [numeric](18, 2)) 
            end as IndemnityPaid,
            case 
               when t.TypePayCategoryKey = 2 then t.CededTotalAmt
               else cast(0 as [numeric](18, 2))
            end as ExpensePaid
from        (
              select      clms.ClaimKey,
                          csfx.ClaimSuffixKey,
                          p.PaymentKey,
                          cp.SubRecordNumber as Sub_Record_Number, 
                          pc.TypePayCode,
                          pc.TypePayCategoryKey, 
                          @Landmark as InsuranceCompanySkey,                      
                          ct.[Description] as ClaimTypeDesc,
                          p.TypeRecoveryCode,
                          cp.Department,
                          case
                             when rr.RIAcctgReinsurerKey is NULL then isnull(rm.CededAmtDue, 0) 
                             else isnull(rr.CededAmtDue, 0) 
                          end  as CededTotalAmt
            from        RIAcctgMarket rm join ClaimSuffix csfx       on rm.ClaimSuffixKey        = csfx.ClaimSuffixKey 
                                           join Claims clms            on csfx.Claimkey            = clms.ClaimKey 
                                           join ClaimType ct           on csfx.ClaimTypeKey        = ct.ClaimTypeKey
                                           join ClaimPolicy cp         on clms.ClaimPolicyKey      = cp.ClaimPolicyKey 
                                           join Payment p              on rm.PaymentKey            = p.PaymentKey 
                                           join TypePayCode pc         on p.TypePayCodeKey         = pc.TypePayCodeKey
                                           join Insurance_Companies ic on cp.Company_Record_Number = ic.Company_Record_Number
                                left outer join RIAcctgReinsurer rr    on rm.RIAcctgMarketKey      = rr.RIAcctgMarketKey
                                left outer join Company co             on rm.Company_Skey          = co.Company_Skey
                                left outer join Company co2            on rr.Company_Skey          = co2.Company_Skey
                                left outer join Treaty_Profile tp      on rm.Profile_Skey          = tp.Profile_Skey
                                left outer join GENINFO gi             on cp.SubRecordNumber       = gi.SUB_RECORD_NO
              where       1=1 
                and       rm.RIAcctgTypeKey in (2,3) 
                and       rm.PaymentKey is not NULL 
                and       DATEPART(year,p.PaymentDate) = @GLYear
                and       DATEPART(month,p.PaymentDate) = @GLMonth
                and       clms.DateOfLoss >= @StartDate
                and       (ic.COMPANY_SKEY = @Landmark and ic.ORG_NUMBER = 2)
                and       ( (tp.Profile_Skey is not NULL and (tp.URC is not NULL and tp.URC = 'Y'))  )
            ) t
where       1=1
) t2
where 1=1
group by InsuranceCompany


-- Get direct from Capitol and treat as ceded affiliate to RSUI Indemnity
insert into zms_LossTrackingPaid
select      2 as StepId,
            @GLMonth as GLMonth,
            @GLYear as GLYear,
            @Capitol as InsuranceCompanySkey,
            @CedAff as RecordType,
            -sum(t.IndemnityPaid) as IndemnityPaid,
            -sum(t.ExpensePaid) as ExpensePaid
from        (
              select      --top 10 
                          clms.ClaimKey,
                          csfx.ClaimSuffixKey,
                          p.PaymentKey,
                          cp.SubRecordNumber as Sub_Record_Number, 
                          pc.TypePayCode,
                          pc.TypePayCategoryKey, 
                          ic.COMPANY_SKEY as InsuranceCompanySkey,
                          cast(NULL as int) as AssociatedCompanySkey,
                          ct.[Description] as ClaimTypeDesc,
                          p.TypeRecoveryCode,
                          cp.Department,
                          isnull(p.IndemnityAmount, 0) as IndemnityPaid, 
                          isnull(p.ExpenseAmount, 0)   as ExpensePaid
              -- select top 10 *
              from       Claims clms  inner join ClaimSuffix csfx       on clms.ClaimKey            = csfx.ClaimKey
                                      inner join Payment p              on csfx.ClaimSuffixKey      = p.ClaimSuffixKey 
                                      inner join TypePayCode pc         on p.TypePayCodeKey         = pc.TypePayCodeKey
                                      inner join ClaimType ct           on csfx.ClaimTypeKey        = ct.ClaimTypeKey
                                      inner join CLAIMPOLICY cp         on clms.ClaimPolicyKey      = cp.ClaimPolicyKey 
                                      inner join Insurance_Companies ic on cp.Company_Record_Number = ic.Company_Record_Number 
                                      inner join TypePayCode tpc        on p.TypePayCodeKey         = tpc.TypePayCodeKey
                                      inner join TypePayCategory tpcc   on tpc.TypePayCategoryKey   = tpcc.TypePayCategoryKey
                                 left outer join GENINFO gi             on cp.SubRecordNumber       = gi.SUB_RECORD_NO
              where      1=1
                and      DATEPART(year,p.PaymentDate) = @GLYear
                and      DATEPART(month,p.PaymentDate) = @GLMonth
                and      clms.DateOfLoss >= @StartDate
                and      (ic.COMPANY_SKEY = @Capitol and ic.ORG_NUMBER = 2)
           ) t
where      1=1
group by t.InsuranceCompanySkey




print 'Step 3 -- Ceded Non-Affiliate Info'
delete from zms_LossTrackingPaid
where StepId = 3

insert into zms_LossTrackingPaid
select 3 as StepId,
       @GLMonth as GLMonth,
       @GLYear as GLYear,
       InsuranceCompany,
       @CedNonAff as RecordType,
       -(sum(IndemnityPaid)) as IndemnityPaid,
       -(sum(ExpensePaid)) as ExpensePaid
from 
(
select      t.InsuranceCompanySkey as InsuranceCompany,
	    case 
               when t.TypePayCategoryKey = 1 then t.CededTotalAmt
               else cast(0 as [numeric](18, 2)) 
            end as IndemnityPaid,
            case 
               when t.TypePayCategoryKey = 2 then t.CededTotalAmt
               else cast(0 as [numeric](18, 2))
            end as ExpensePaid
from        (
              select      clms.ClaimKey,
                          csfx.ClaimSuffixKey,
                          p.PaymentKey,
                          cp.SubRecordNumber as Sub_Record_Number, 
                          pc.TypePayCode,
                          pc.TypePayCategoryKey,
			  case
                             when ic.COMPANY_SKEY = @Capitol then @RIC 
                             else ic.COMPANY_SKEY 
                          end as InsuranceCompanySkey,                       
                          ct.[Description] as ClaimTypeDesc,
                          p.TypeRecoveryCode,
                          cp.Department,
                          case
                             when rr.RIAcctgReinsurerKey is NULL then isnull(rm.CededAmtDue, 0) 
                             else isnull(rr.CededAmtDue, 0) 
                          end  as CededTotalAmt
            from        RIAcctgMarket rm join ClaimSuffix csfx       on rm.ClaimSuffixKey        = csfx.ClaimSuffixKey 
                                           join Claims clms            on csfx.Claimkey            = clms.ClaimKey 
                                           join ClaimType ct           on csfx.ClaimTypeKey        = ct.ClaimTypeKey
                                           join ClaimPolicy cp         on clms.ClaimPolicyKey      = cp.ClaimPolicyKey 
                                           join Payment p              on rm.PaymentKey            = p.PaymentKey 
                                           join TypePayCode pc         on p.TypePayCodeKey         = pc.TypePayCodeKey
                                           join Insurance_Companies ic on cp.Company_Record_Number = ic.Company_Record_Number
                                left outer join RIAcctgReinsurer rr    on rm.RIAcctgMarketKey      = rr.RIAcctgMarketKey
                                left outer join Company co             on rm.Company_Skey          = co.Company_Skey
                                left outer join Company co2            on rr.Company_Skey          = co2.Company_Skey
                                left outer join Treaty_Profile tp      on rm.Profile_Skey          = tp.Profile_Skey
                                left outer join GENINFO gi             on cp.SubRecordNumber       = gi.SUB_RECORD_NO
              where       1=1 
                and       rm.RIAcctgTypeKey in (2,3) 
                and       rm.PaymentKey is not NULL 
                and       DATEPART(year,p.PaymentDate) = @GLYear
                and       DATEPART(month,p.PaymentDate) = @GLMonth
                and       clms.DateOfLoss >= @StartDate
                and       (ic.COMPANY_SKEY IN (@Landmark,@RIC,@Capitol) and ic.ORG_NUMBER = 2)
                and       ( 
                            not (tp.Profile_Skey is not NULL and (tp.URC is not NULL and tp.URC = 'Y'))
                          )
            ) t
where       1=1
) t2
where 1=1
group by InsuranceCompany







print 'Step 4 -- RSUI: Assumed Affiliate'
delete from zms_LossTrackingPaid
where StepId = 4

-- Get ceded transactions to URC from Landmark and treat as assumed affiliate to RSUI Indemnity
select      4 as StepId,
            @GLMonth as GLMonth,
	    @GLYear  as GLYear,
            InsuranceCompany as InsuranceCompanySKey,          
            @AssAff as RecordType,
            sum(IndemnityPaid) as IndemnityPaid,
       	    sum(ExpensePaid) as ExpensePaid
into #temp_assaff
from
(
select      t.InsuranceCompanySkey as InsuranceCompany,
	    case 
               when t.TypePayCategoryKey = 1 then t.CededTotalAmt
               else cast(0 as [numeric](18, 2)) 
            end as IndemnityPaid,
            case 
               when t.TypePayCategoryKey = 2 then t.CededTotalAmt
               else cast(0 as [numeric](18, 2))
            end as ExpensePaid
from        (
              select      --top 10 
                          clms.ClaimKey,
                          csfx.ClaimSuffixKey,
                          p.PaymentKey,
                          cp.SubRecordNumber as Sub_Record_Number, 
                          pc.TypePayCode,
                          pc.TypePayCategoryKey,
			  @RIC as InsuranceCompanySkey,
                          ic.COMPANY_SKEY as AssociatedCompanySkey,               
                          ct.[Description] as ClaimTypeDesc,
                          p.TypeRecoveryCode,
                          cp.Department,
			  case
                             when rr.RIAcctgReinsurerKey is NULL then isnull( rm.CededAmtDue, 0) 
                             else isnull( rr.CededAmtDue, 0) 
                          end  as CededTotalAmt
              -- select top 10 *
              from        RIAcctgMarket rm join ClaimSuffix csfx       on rm.ClaimSuffixKey        = csfx.ClaimSuffixKey 
                                           join Claims clms            on csfx.Claimkey            = clms.ClaimKey 
                                           join ClaimType ct           on csfx.ClaimTypeKey        = ct.ClaimTypeKey
                                           join ClaimPolicy cp         on clms.ClaimPolicyKey      = cp.ClaimPolicyKey 
                                           join Payment p              on rm.PaymentKey            = p.PaymentKey 
                                           join TypePayCode pc         on p.TypePayCodeKey         = pc.TypePayCodeKey
                                           join Insurance_Companies ic on cp.Company_Record_Number = ic.Company_Record_Number
                                left outer join RIAcctgReinsurer rr    on rm.RIAcctgMarketKey      = rr.RIAcctgMarketKey
                                left outer join Company co             on rm.Company_Skey          = co.Company_Skey
                                left outer join Company co2            on rr.Company_Skey          = co2.Company_Skey
                                left outer join Treaty_Profile tp      on rm.Profile_Skey          = tp.Profile_Skey                                           
                                left outer join GENINFO gi             on cp.SubRecordNumber       = gi.SUB_RECORD_NO
              where       1=1 
                and       rm.RIAcctgTypeKey in (2,3) 
                and       rm.PaymentKey is not NULL 
                and       DATEPART(year,p.PaymentDate) = @GLYear
                and       DATEPART(month,p.PaymentDate) = @GLMonth
                and       clms.DateOfLoss >= @StartDate
                and       (ic.COMPANY_SKEY = @Landmark and ic.ORG_NUMBER = 2) 
		and       (tp.Profile_Skey is not NULL and (tp.URC is not NULL and tp.URC = 'Y'))                 
            ) t
where       1=1
) t2
where 1=1
group by InsuranceCompany



-- Get direct from Capitol and treat as assumed affiliate to RSUI Indemnity
insert into #temp_assaff
select      4 as StepId,
            @GLMonth as GLMonth,
            @GLYear as GLYear,
            @RIC as InsuranceCompanySKey,
            @AssAff as RecordType,
            sum(t.IndemnityPaid) as IndemnityPaid,
            sum(t.ExpensePaid) as ExpensePaid
from        (
              select      --top 10 
                          clms.ClaimKey,
                          csfx.ClaimSuffixKey,
                          p.PaymentKey,
                          cp.SubRecordNumber as Sub_Record_Number, 
                          pc.TypePayCode,
                          pc.TypePayCategoryKey, 
                          @RIC as InsuranceCompanySkey,
                          cast(NULL as int) as AssociatedCompanySkey,
                          ct.[Description] as ClaimTypeDesc,
                          p.TypeRecoveryCode,
                          cp.Department,
                          isnull(p.IndemnityAmount, 0) as IndemnityPaid, 
                          isnull(p.ExpenseAmount, 0)   as ExpensePaid
              -- select top 10 *
              from       Claims clms  inner join ClaimSuffix csfx       on clms.ClaimKey            = csfx.ClaimKey
                                      inner join Payment p              on csfx.ClaimSuffixKey      = p.ClaimSuffixKey 
                                      inner join TypePayCode pc         on p.TypePayCodeKey         = pc.TypePayCodeKey
                                      inner join ClaimType ct           on csfx.ClaimTypeKey        = ct.ClaimTypeKey
                                      inner join CLAIMPOLICY cp         on clms.ClaimPolicyKey      = cp.ClaimPolicyKey 
                                      inner join Insurance_Companies ic on cp.Company_Record_Number = ic.Company_Record_Number 
                                      inner join TypePayCode tpc        on p.TypePayCodeKey         = tpc.TypePayCodeKey
                                      inner join TypePayCategory tpcc   on tpc.TypePayCategoryKey   = tpcc.TypePayCategoryKey
                                 left outer join GENINFO gi             on cp.SubRecordNumber       = gi.SUB_RECORD_NO
              where      1=1
                and      DATEPART(year,p.PaymentDate) = @GLYear
                and      DATEPART(month,p.PaymentDate) = @GLMonth
                and      clms.DateOfLoss >= @StartDate
                and      (ic.COMPANY_SKEY =@Capitol and ic.ORG_NUMBER = 2)
           ) t
where      1=1
group by t.InsuranceCompanySkey

--combine
insert into zms_LossTrackingPaid
select      4 as StepId,
            @GLMonth as GLMonth,
            @GLYear as GLYear,
            InsuranceCompanySkey,
            @AssAff as RecordType,
            sum(IndemnityPaid) as IndemnityPaid,
            sum(ExpensePaid) as ExpensePaid
from #temp_assaff
group by InsuranceCompanySkey


print 'Step 5 -- RSUI: Assumed Non-Affiliate'
delete from zms_LossTrackingPaid
where StepId = 5

insert into zms_LossTrackingPaid
select      5 as StepId,
            @GLMonth as GLMonth,
	    @GLYear  as GLYear,
            InsuranceCompany,          
            @AssNonAff as RecordType,
            sum(IndemnityPaid) as IndemnityPaid,
       	    sum(ExpensePaid) as ExpensePaid
from
(
select      t.InsuranceCompanySkey as InsuranceCompany,
	    case 
               when t.TypePayCategoryKey = 1 then t.CededTotalAmt
               else cast(0 as [numeric](18, 2)) 
            end as IndemnityPaid,
            case 
               when t.TypePayCategoryKey = 2 then t.CededTotalAmt
               else cast(0 as [numeric](18, 2))
            end as ExpensePaid
from        (
              select      --top 10 
                          clms.ClaimKey,
                          csfx.ClaimSuffixKey,
                          p.PaymentKey,
                          cp.SubRecordNumber as Sub_Record_Number, 
                          pc.TypePayCode,
                          pc.TypePayCategoryKey, 
                          @RIC as InsuranceCompanySkey,
                          ic.COMPANY_SKEY as AssociatedCompanySkey,               
                          ct.[Description] as ClaimTypeDesc,
                          p.TypeRecoveryCode,
                          cp.Department,
			  case
                             when rr.RIAcctgReinsurerKey is NULL then isnull( rm.CededAmtDue, 0) 
                             else isnull( rr.CededAmtDue, 0) 
                          end  as CededTotalAmt
              -- select top 10 *
              from        RIAcctgMarket rm join ClaimSuffix csfx       on rm.ClaimSuffixKey        = csfx.ClaimSuffixKey 
                                           join Claims clms            on csfx.Claimkey            = clms.ClaimKey 
                                           join ClaimType ct           on csfx.ClaimTypeKey        = ct.ClaimTypeKey
                                           join ClaimPolicy cp         on clms.ClaimPolicyKey      = cp.ClaimPolicyKey 
                                           join Payment p              on rm.PaymentKey            = p.PaymentKey 
                                           join TypePayCode pc         on p.TypePayCodeKey         = pc.TypePayCodeKey
                                           join Insurance_Companies ic on cp.Company_Record_Number = ic.Company_Record_Number
                                left outer join RIAcctgReinsurer rr    on rm.RIAcctgMarketKey      = rr.RIAcctgMarketKey
                                left outer join Company co             on rm.Company_Skey          = co.Company_Skey
                                left outer join Company co2            on rr.Company_Skey          = co2.Company_Skey
                                left outer join Treaty_Profile tp      on rm.Profile_Skey          = tp.Profile_Skey                                           
                                left outer join GENINFO gi             on cp.SubRecordNumber       = gi.SUB_RECORD_NO
              where       1=1 
                and       rm.RIAcctgTypeKey in (2,3) 
                and       rm.PaymentKey is not NULL 
                and       DATEPART(year,p.PaymentDate) = @GLYear
                and       DATEPART(month,p.PaymentDate) = @GLMonth
                and       clms.DateOfLoss >= @StartDate
                and       (ic.ORG_NUMBER = 1)
                and       ( 
                            (tp.Profile_Skey is not NULL and (tp.URC is not NULL and tp.URC = 'Y'))
                           )
            ) t
where       1=1
) t2
where 1=1
group by InsuranceCompany


--
-- validate that paid amounts match loss tracking
--
--select indpaid, 
--       cntrl.IndemnityPaid,
--       exppaid, 
--       cntrl.ExpensePaid,  
--       cntrl.InsuranceCompanySkey,
--       cntrl.RecordType
select count(*)
from zms_LossTrackingPaid cntrl
join
(
select sum(lh.IndemnityPaid) as indpaid, 
       sum(lh.ExpensePaid) as exppaid, 
       lh.InsuranceCompanySkey,
       lh.RecordType
from LossHeader lh
where lh.InsuranceCompanySkey IN (695, 694, 693)
 and lh.GLMonth = @GLMonth
 and lh.GLYear = @GLYear
and org_number = 2
group by lh.InsuranceCompanySkey, lh.RecordType 
) lt on lt.insurancecompanyskey = cntrl.insurancecompanyskey 
       and lt.RecordType = cntrl.RecordType
where 1=1
 and cntrl.GLMonth = @GLMonth
 and cntrl.GLYear = @GLYear
 and ( indpaid != IndemnityPaid or exppaid != cntrl.ExpensePaid )
  


end