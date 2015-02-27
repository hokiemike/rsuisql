--Endorsements that have ceded records but zero premium on the endorsement
select * FROM (select a.endorsement_skey, sum(cededpremiumamt) as cededpremiumamt
                        from riacctgmarket a 
                        where a.createdate > '01/01/2005'
                        group by a.endorsement_skey
                        having sum(cededpremiumamt) != 0)q1
where exists (select 1 from endorsement b where q1.endorsement_skey = b.endorsement_skey and endorsement_gross_premium = 0)

--Missing qb_policy_limits
select *
from agentsbalance a
where not exists (select 1 from qb_policy_limits b where a.endorsement_skey = b.endorsement_skey)
and a.gldate is null
and a.endorsement_skey is not null
and a.createdate > '01/01/2009'

--limits matching
select a.endorsement_skey, a.endorsement_gross_premium, sum(b.premium)
from endorsement a
join qb_policy_limits b on a.endorsement_skey = b.endorsement_skey
where 1=1
and b.premium is not null
and a.endorsement_skey > 100000
and a.endorsement_gross_premium != 0
and exists (select 1 from agentsbalance c where a.endorsement_skey = c.endorsement_skey)
group by a.endorsement_skey, a.endorsement_gross_premium
having sum(b.premium) != a.endorsement_gross_premium

--null premium in qbpolicylimits
select  b.premium
from qb_policy_limits b
where 1=1
and exists (select 1 from agentsbalance c where b.endorsement_skey = c.endorsement_skey)
and b.premium is null



select a.endorsement_skey, a.endorsement_gross_premium, sum(b.premium)
from endorsement a
join qb_policy_limits b on a.endorsement_skey = b.endorsement_skey
where 1=1
and a.endorsement_skey > 100000
and a.endorsement_gross_premium != 0
and exists (select 1 from agentsbalance c where a.endorsement_skey = c.endorsement_skey)
group by a.endorsement_skey, a.endorsement_gross_premium
having sum(b.premium) != a.endorsement_gross_premium



--endorsements on a different coverage than policy
select a.*
from qb_policy_limits a
join endorsement b on a.endorsement_skey = b.endorsement_skey
join submission c on b.sub_record_number = c.sub_record_number
where not exists (select 1 from qb_policy_limits d where c.sub_record_number = d.sub_record_number and a.polcov_skey = d.polcov_skey)
and c.department_number in (300, 10006)
and a.premium != 0

select *
from qb_policy_limits a
join submission b on a.sub_record_number = b.sub_record_number
where b.department_number = 300
and a.occurclaimsmade is null

select *
from qb_policy_limits a
join endorsement c on a.endorsement_skey = c.endorsement_skey
join submission b on b.sub_record_number = c.sub_record_number
where b.department_number = 300
and a.occurclaimsmade is null
