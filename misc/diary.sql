select * 
from Payment
where Lower(VendorName) like '%gab%'

select * 
from claims
where DateCreated > '2/16/04'

select p.* 
from claims c
inner join payment p on p.claimkey = c.claimkey
where c.ClaimKey = 49751

select c.ClaimKey 
from DiaryEntry de
  inner join Claims c on c.claimkey = de.claimkey
  inner join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
  inner join Employee e on e.emp_record_number = c.claimprofessional
where de.SecUserID = 415
 and c.claimprofessional = 4921
 and cp.department = 300

Select diaryentrykey, secuserid from DiaryEntry 
where DiaryEntryKey IN 
( select c.ClaimKey 
from DiaryEntry de
  inner join Claims c on c.claimkey = de.claimkey
  inner join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
  inner join Employee e on e.emp_record_number = c.claimprofessional
where de.SecUserID = 415
 and c.claimprofessional = 4921
 and cp.department = 300 )

update diaryentry set secuserid = 7 
where diaryentrykey IN (47818, 47792, 47791, 47833, 47845, 47879)

update diaryentry set secuserid = 130 
where diaryentrykey IN (47793, 47829)


select c.ClaimKey 
from DiaryEntry de
  inner join Claims c on c.claimkey = de.claimkey
  inner join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
  inner join Employee e on e.emp_record_number = c.claimprofessional
where de.SecUserID = 415
 and c.claimprofessional = 4921
 and cp.department = 300


select *
from DiaryEntry  
where ClaimKey IN 
( select c.ClaimKey 
from DiaryEntry de
  inner join Claims c on c.claimkey = de.claimkey
  inner join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
  inner join Employee e on e.emp_record_number = c.claimprofessional
where de.SecUserID = 415
 and c.claimprofessional = 4921
 and cp.department = 300 )
and SecUserID != 415

Update DiaryEntry Set SecUserId = 122
Where DiaryEntryKey IN (145685,145686,145605,145606,145608,145609,145602,145603,145717,145718,145728,145729,145764,145765,145867,145868)


