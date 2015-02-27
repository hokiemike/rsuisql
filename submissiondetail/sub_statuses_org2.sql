



select st.department_number, st.status_description, count(s.sub_record_number) 
from Status st                             
left outer join Submission s on 
( st.status_code = s.status_code and st.department_number = s.department_number 
   and s.company_record_number in (select company_record_number from insurance_companies where org_number = 2))
where 1=1
group by  st.department_number, st.status_description
order by st.department_number, st.status_description





select d.department_description, st.status_description, count(subs.sub_record_number) as submission_count
from Status st 
left outer join
(
select s.status_code, s.department_number, s.sub_record_number as sub_record_number
from Submission s
join INSURANCE_COMPANIES ic on ic.COMPANY_RECORD_NUMBER = s.company_record_number
 where 1=1
  and s.createDate > '07/01/2003'
  and ic.org_number = 2 
) subs  on subs.status_code = st.status_code and subs.department_number = st.department_number                     
join Departments d on st.department_number = d.department_number
where 1=1
and d.IsActive = 1
group by d.department_description, st.status_description
order by d.department_description

select s.department_number, st.status_description, count(s.sub_record_number) 
from Status st                             
left outer join Submission s on ( st.status_code = s.status_code and st.department_number = s.department_number )
right outer join INSURANCE_COMPANIES ic on ic.COMPANY_RECORD_NUMBER = s.company_record_number
--left outer join Status st on ( st.status_code = s.status_code )
where 1=1
and s.createDate > '07/01/2003'
and ic.org_number = 2
group by s.department_number, st.status_description
order by s.department_number





select s.department_number, st.status_description, count(s.sub_record_number) 
from Submission s                             
--left outer join INSURANCE_COMPANIES ic on ic.COMPANY_RECORD_NUMBER = s.company_record_number
--left outer join Status st on ( st.status_code = s.status_code and st.department_number = s.department_number )
left outer join Status st on ( st.status_code = s.status_code )
where 1=1
--and s.createDate > '07/01/2003'
--and ic.org_number = 2
group by s.department_number, st.status_description
order by s.department_number


select st.status_code, count(s.sub_record_number) 
from Submission s                             
right outer join Status st on ( st.status_code = s.status_code and s.department_number = st.department_number )
where 1=1
group by st.status_code
