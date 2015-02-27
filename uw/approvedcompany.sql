select * from ApprovedCompanyProgram where type_skey = 202

select distinct ic.company_record_number, ic.Company_Name, ac.CompanyName 
from ApprovedCompany ac
join Insurance_companies ic on ic.company_record_number = ac.company_record_number
order by  ic.company_record_number
