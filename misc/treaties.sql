select * 
from treaty_profile_market_address tpma
 join company comp on comp.company_skey = tpma.company_skey

select * from treaty_profile 
order by profile_name


select *
from treaty_profile_market_level tpml
 join treaty_profile_market_address tpma on tpma.profile_mkt_addr_skey = tpml.profile_mkt_addr_skey
 join company comp on comp.company_skey = tpma.company_skey
where profile_skey = 202

where department_number = 1800


select * 
from treaty_profile_market_address tpma
 join company comp on comp.company_skey = tpma.company_skey
where tpma.profile_skey = 202

