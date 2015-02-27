select distinct a.sub_record_number, a.endorsement_skey 
from agentsbalance a join submission s 
on a.sub_record_number = s.sub_record_number join insurance_companies c 
on s.company_record_number = c.company_record_number 
where 1=1 
and a.endorsement_skey 
is null and c.org_number = 2 
and s.status_code in ('I', 'B', 'X') 
and a.sub_record_number not in ( select a1.sub_record_number from agentsbalance a1 join ri_header_level r 
on a1.sub_record_number = r.sub_record_number 
where 1=1 
and a1.endorsement_skey is null 
and r.endorsement_skey is null 
and r.claim_skey is null ) 
group by a.sub_record_number, a.endorsement_skey 
having sum(a.grosspremiumamt) <> 0 
/* get ab records (with $) for org2 (not fee only) endorsements that don't have reinsurance */
union select distinct a.sub_record_number, a.endorsement_skey 
from agentsbalance a join submission s 
on a.sub_record_number = s.sub_record_number join insurance_companies c
on s.company_record_number = c.company_record_number 
where 1=1 and c.org_number = 2 and s.status_code in ('I', 'B', 'X') 
and a.endorsement_skey not in ( select endorsement_skey from endorsement 
where endorsement_gross_premium = 0 ) and a.endorsement_skey not in ( select a1.endorsement_skey 
from agentsbalance a1 join ri_header_level r on a1.endorsement_skey = r.endorsement_skey 
where 1=1 and a1.endorsement_skey is not null and r.claim_skey is null 
and r.endorsement_skey is not null ) group by a.sub_record_number, a.endorsement_skey 
having sum(a.grosspremiumamt) <> 0 


select * from Submission where SUB_RECORD_NUMBER = 1273542

select * from ENDORSEMENT where ENDORSEMENT_SKEY = 277293

select * from RI_HEADER_LEVEL where ENDORSEMENT_SKEY = 277293
