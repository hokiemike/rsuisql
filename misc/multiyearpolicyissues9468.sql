-- claims against "multi-year" policies with dates of loss outside of the curr date range of the submission
select  s.sub_policy_number,s.sub_policy_suffix, clms.claimOffice, clms.claimNumber, s.sub_current_effective_date, cp.effectivedate, s.sub_current_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
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
--and clms.DateOfLoss > '6/30/2003 23:59' 
and not exists 
( select 1 from endorsement e where e.endtype_record_number = 12 and e.sub_record_number = s.sub_record_number )
and not exists
( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.sub_record_number )
and s.sub_policy_number = 9468
order by s.sub_policy_number



select  distinct cp.claimpolicykey, s.sub_policy_number, s.sub_record_number, cp.policysuffix
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
--and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and s.sub_policy_number = 9468


select * from Submission where sub_policy_number = 9468
-- 91145
-- 92649
-- 98830
--107799


-- what is the right suffix
select  s.sub_policy_number,s.sub_policy_suffix, s2.sub_policy_suffix, clms.claimOffice, clms.claimNumber, s.sub_current_effective_date, cp.effectivedate, s.sub_current_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
 join Submission s2 on s2.sub_policy_number = s.sub_policy_number and ( clms.DateOfLoss < s2.sub_current_expiration_Date and clms.DateOfLoss >= s2.sub_current_effective_date)
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and s.sub_policy_number = 9468

order by clms.DateOfLoss



select  clms.claimkey, cp.claimpolicykey
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
 join Submission s2 on s2.sub_policy_number = s.sub_policy_number and ( clms.DateOfLoss < s2.sub_current_expiration_Date and clms.DateOfLoss >= s2.sub_current_effective_date)
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and s.sub_policy_number = 9468

--6094 to 19756


--
-- update to fix policy 9468
--
update Claims
set ClaimPolicyKey = 19756
where ClaimKey IN
(
select  clms.claimkey
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
 join Submission s2 on s2.sub_policy_number = s.sub_policy_number and ( clms.DateOfLoss < s2.sub_current_expiration_Date and clms.DateOfLoss >= s2.sub_current_effective_date)
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and s.sub_policy_number = 9468
)
and ClaimPolicyKey = 6094





-- count of claims against "multi-year" policies with dates of loss outside of the curr date range of the submission
select s.sub_policy_number, count(s.sub_record_number)
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and (   s.prior_sub_record_number is not null
 	or s.sub_record_number IN 
	( select distinct s2.prior_sub_record_number from submission s2	)
     )
--and clms.DateOfLoss > '6/30/2003 23:59' 
and not exists 
( select 1 from endorsement e where e.endtype_record_number = 12 and e.sub_record_number = s.sub_record_number )
and not exists
( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.sub_record_number )
and not exists
( select 1 from endorsement e where e.endtype_record_number IN (4,5,6) and e.sub_record_number = s.prior_sub_record_number )
group by s.sub_policy_number
order by count(s.sub_record_number) DESC



-- what is the right suffix
--select  s.sub_policy_number,s.sub_policy_suffix, s2.sub_policy_suffix, clms.claimOffice, clms.claimNumber, s.sub_current_effective_date, cp.effectivedate, s.sub_current_expiration_Date, cp.expirationDate, clms.DateOfLoss, clms.*
select clms.claimkey, clms.Dateofloss
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
 left outer join Submission s2 on s2.sub_policy_number = s.sub_policy_number and ( clms.DateOfLoss < s2.sub_current_expiration_Date and clms.DateOfLoss >= s2.sub_current_effective_date)
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and s.sub_policy_number = 9682
order by clms.DateOfLoss

select * from Submission where sub_policy_number = 9682
select sub_current_effective_date, sub_current_expiration_date, prior_sub_record_number from Submission where sub_record_number = 88489
select sub_current_effective_date, sub_current_expiration_date, prior_sub_record_number from Submission where sub_record_number = 87093
select sub_current_effective_date, sub_current_expiration_date, prior_sub_record_number from Submission where sub_record_number = 85711
select sub_current_effective_date, sub_current_expiration_date, prior_sub_record_number from Submission where sub_record_number = 84314

-- 84314  91-92
-- 85711  92-93
-- 87093  93-94
-- 88489  94-95

--15297	1992-02-01 00:00:00.000 84314  6872
--23210	1992-11-11 00:00:00.000 85711  4737
--19056	1993-11-25 00:00:00.000 87093  4978
--22285	1994-05-07 00:00:00.000 87093  "
--21926	1995-04-29 00:00:00.000 88489  5218
--22958	1995-05-27 00:00:00.000 88489  "
--18396	1995-07-23 00:00:00.000 88489  "
--22282	1995-08-20 00:00:00.000 88489  "
--18397	1995-09-02 00:00:00.000 88489  "
--22283	1995-09-04 00:00:00.000 88489  "
--22957	1995-09-27 00:00:00.000 88489  "

select * from claimpolicy where subrecordnumber IN ( 84314,85711, 87093, 88489 )



select  clms.claimkey, cp.claimpolicykey
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
 left join Submission s2 on s2.sub_policy_number = s.sub_policy_number and ( clms.DateOfLoss < s2.sub_current_expiration_Date and clms.DateOfLoss >= s2.sub_current_effective_date)
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and s.sub_policy_number = 9682

select * from Submission where sub_policy_number = 9682
-- 91145
-- 92649
-- 98830
--107799

select claimpolicykey
from ClaimPolicy
where POlicyNumber = '009682'
--7972	91256   0
--8165	92855   1
--8338	100225  2
--8543	109292  3
--9818	182207



--
-- Set the 9682 claims that should be on suffix 1
--
update Claims
set ClaimPolicyKey = 8165
where ClaimKey IN 
(
select  clms.ClaimKey
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
 left outer join Submission s2 on s2.sub_policy_number = s.sub_policy_number and ( clms.DateOfLoss < s2.sub_current_expiration_Date and clms.DateOfLoss >= s2.sub_current_effective_date)
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and s.sub_policy_number = 9682
and s2.sub_policy_suffix = 1
)
and ClaimPOlicyKey = 7972


--
-- Set the 9682 claims that should be on suffix 2
--
update Claims
set ClaimPolicyKey = 8338
where ClaimKey IN 
(
select  clms.ClaimKey
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
 left outer join Submission s2 on s2.sub_policy_number = s.sub_policy_number and ( clms.DateOfLoss < s2.sub_current_expiration_Date and clms.DateOfLoss >= s2.sub_current_effective_date)
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and s.sub_policy_number = 9682
and s2.sub_policy_suffix = 2
)
and ClaimPOlicyKey = 7972


--
-- Set the 9682 claims that should be on suffix 3
--
update Claims
set ClaimPolicyKey = 8543
where ClaimKey IN 
(
select  clms.ClaimKey
from Submission s
 join ClaimPolicy cp on s.sub_record_number = cp.subrecordnumber
 join Claims clms on clms.ClaimPolicyKey = cp.ClaimPolicyKey
 left outer join Submission s2 on s2.sub_policy_number = s.sub_policy_number and ( clms.DateOfLoss < s2.sub_current_expiration_Date and clms.DateOfLoss >= s2.sub_current_effective_date)
where 1=1
and ( clms.DateOfLoss > s.sub_current_expiration_Date or clms.DateOfLoss < s.sub_current_effective_date)
and s.sub_policy_number = 9682
and s2.sub_policy_suffix = 3
)
and ClaimPOlicyKey = 7972