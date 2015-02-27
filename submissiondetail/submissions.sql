select s.SUB_RECORD_NUMBER as new_sub_rec, s.SUB_POLICY_NUMBER as new_policy_num, 
 priorsub.SUB_RECORD_NUMBER as this_sub_rec, priorsub.SUB_POLICY_NUMBER as this_policy_num, 
 s.DEPARTMENT_NUMBER, priorsub.SUB_RENEWAL_FLAG
from Submission s
join Submission priorsub on s.PRIOR_SUB_RECORD_NUMBER = priorsub.SUB_RECORD_NUMBER
where 1=1
and s.CreateDate > '1/1/2004'
--and s.SUB_POLICY_NUMBER <> priorsub.SUB_POLICY_NUMBER
and s.department_number = 200 
and s.sub_policy_number is null

select * from Submission where SUB_RECORD_NUMBER = 1060167


select s.SUB_POLICY_NUMBER, priorsub.SUB_POLICY_NUMBER, s.DEPARTMENT_NUMBER, s.SUB_RENEWAL_FLAG
from Submission s
join Submission priorsub on s.PRIOR_SUB_RECORD_NUMBER = priorsub.SUB_RECORD_NUMBER
where 1=1
and s.CreateDate > '1/1/2004'
and s.SUB_POLICY_NUMBER = priorsub.SUB_POLICY_NUMBER
and s.department_number = 200

select count(*) from Submission
select count(*) from Address
select * from DOING_BUSINESS_AS_NAMES where DBA_NAME is null and VersionTimestamp > '2003-01-01'




