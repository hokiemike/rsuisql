select emp.emp_department_number, depts.department_description, emp.emp_last_name, emp2.emp_first_name + ' ' + emp2.emp_last_name as employee
 from employee_xref emp_xref
 join employee emp on emp_xref.primary_emp_record_number = emp.emp_record_number
 join employee emp2 on emp_xref.secondary_emp_record_number = emp2.emp_record_number
 join departments depts on depts.department_number = emp.emp_department_number
where 1=1
 and emp.emp_type like '%Claim%'
 --and primary_emp_record_number = 32
 and emp.emp_active_code = 'A'
 and emp2.emp_active_code = 'A'

order by emp.emp_department_number, emp.emp_last_name

select * from employee 
order by emp_last_name

select emp.emp_last_name, emp2.emp_first_name + ' ' + emp2.emp_last_name
 from employee_xref emp_xref
 join employee emp on emp_xref.primary_emp_record_number = emp.emp_record_number
 join employee emp2 on emp_xref.secondary_emp_record_number = emp2.emp_record_number
where primary_emp_record_number = 5296
 and emp.emp_active_code = 'A'
 and emp2.emp_active_code = 'A'


select * from departments

select * from branches

select * from Payment where PaymentKey = 90878

select * from Claims

update Payment
set DraftNumber = 61198040
where PaymentKey = 90878
 and DraftNUmber is null

select * from TypePayCode

insert into TypePayCode
values (78,2,"Declaratory Judgement Expenses",


select * from TypePayCategory

select * from TypePayCodeGroup

select * from ClaimSuitType



