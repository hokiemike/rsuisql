update ProofNotice
set LossTrackingProcessedDate = '03/16/04'
where ClaimKey IN 
  (select ClaimKey
from Claims c
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.Company_Record_number = cp.Company_record_number
 where ic.org_number = 1 and c.dateofloss <= '6/30/03')

select count(ClaimKey)
from Claims c
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.Company_Record_number = cp.Company_record_number
 where 1=1
       and ic.org_number = 2 
       or  ( ic.org_number = 1 and c.dateofloss > '6/30/03')

select ClaimKey
from Claims c
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.Company_Record_number = cp.Company_record_number
 where 1=1
       and ic.org_number = 2 
       or  ( ic.org_number = 1 and c.dateofloss > '6/30/03')

select count(ClaimKey)
from Claims c
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.Company_Record_number = cp.Company_record_number
 where ic.org_number = 1 and c.dateofloss <= '6/30/03'

select count(*)
from ProofNotice
where LossTrackingProcessed IS NULL

update ProofNotice
set LossTrackingProcessedDate = '1/2/1970'
where LossTrackingProcessedDate is NULL 

ALTER TABLE dbo.ProofNotice ADD
 LossTrackingProcessedDate DateTime NULL


select top 10 *
from ProofNotice
where LossTrackingProcessedDate < '1/1/1980'
order by ProofNoticeKey


delete from lossdetail
delete from lossheader