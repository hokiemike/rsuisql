update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 1900 where EMP_RECORD_NUMBER = 5300
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 100 where EMP_RECORD_NUMBER = 5300
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 1800 where EMP_RECORD_NUMBER = 5300
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 300 where EMP_RECORD_NUMBER = 5300
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 200 where EMP_RECORD_NUMBER = 5300
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 10006 where EMP_RECORD_NUMBER = 5300
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 10005 where EMP_RECORD_NUMBER = 5300
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 10006, EMP_BRANCH_NUMBER=100 where EMP_RECORD_NUMBER = 5300
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 200, EMP_BRANCH_NUMBER=200 where EMP_RECORD_NUMBER = 5300
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 600 where EMP_RECORD_NUMBER = 5300

select * from Departments


select * from RI_HEADER_LEVEL where SUB_RECORD_NUMBER = 1335594

update RI_HEADER_LEVEL set IsDefault = 1 where SUB_RECORD_NUMBER = 1335594     

select * from RI_LAYER_LEVEL where HEADER_LEVEL_SKEY = 615756

select * from RI_MARKET_LEVEL where LAYER_LEVEL_SKEY = 709327

select * from DepartmentOption




select * from 


select sub_record_number, 
       SUB_SUBMISSION_NUMBER,
       SUB_INSURED_NAME,
       e.EMP_LAST_NAME + ", " + e.EMP_FIRST_NAME
       SUB_CURRENT_EFFECTIVE_DATE,
       SUB_CURRENT_EXPIRATION_DATE,
       ModDate
from Submission s
join EMPLOYEE e on e.EMP_RECORD_NUMBER = s.EMP_RECORD_NUMBER 
   where ModDate >= :begin and ModDate <= :end
   and DEPARTMENT_NUMBER NOT IN (10006)

update DepartmentOption set InitialScreenID = 1 where OptionID = 3


update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 100 , EMP_BRANCH_NUMBER=200 where EMP_RECORD_NUMBER = 5482
update EMPLOYEE set EMP_DEPARTMENT_NUMBER = 300 , EMP_BRANCH_NUMBER=100 where EMP_RECORD_NUMBER = 5300