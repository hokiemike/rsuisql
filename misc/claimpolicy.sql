select distinct c.name, ic.org_number, c.active_code, c.company_type
from ProofNotice pn
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = pn.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
  inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
  inner join Company c on c.company_skey = ic.company_skey
where clms.DateCreated >= '7/1/2003'


select distinct(companycode)
from ClaimPolicy