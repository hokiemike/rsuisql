select s.sub_record_number, s.sub_policy_number,  count(DBA_SEQUENCE_NO)
from Submission s 
left outer join dbo.DOING_BUSINESS_AS_NAMES dban on dban.SUB_RECORD_NUMBER =  
 where 1=1
 and s.CreateDate > '07/01/2003'
group by s.sub_record_number, s.sub_policy_number
having count(DBA_SEQUENCE_NO) > 0


select s.sub_record_number, s.sub_policy_number,  s.sub_insured_name, dban.DBA_NAME,  dban.DBA_SEQUENCE_NO
from Submission s 
 join dbo.DOING_BUSINESS_AS_NAMES dban on dban.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER 
 where 1=1
 and s.CreateDate > '07/01/2003'

