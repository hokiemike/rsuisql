DECLARE @RC int
-- Set parameter values
EXEC @RC = [RSMSMIRROR].[dbo].[syschk_RIOrg2Policies] 


DECLARE @RC int
-- Set parameter values
EXEC @RC = [RSMSMIRROR].[dbo].[syschk_RIOrg2Endorsements] 




select * from Submission where sub_record_number IN ( 979477, 1033164, 1035672)


-- in RSMS/2 but not in acctg at all
select * from RIAcctgMarket where sub_record_number = 1033164

select riml.* from dbo.RI_MARKET_LEVEL riml
join dbo.RI_LAYER_LEVEL rill on rill.LAYER_LEVEL_SKEY = riml.LAYER_LEVEL_SKEY
join dbo.RI_HEADER_LEVEL rihl on rihl.HEADER_LEVEL_SKEY = rill.HEADER_LEVEL_SKEY
where rihl.SUB_RECORD_NUMBER = 1033164


-- in RSMS/2 but one less market in acctg
select * from RIAcctgMarket where sub_record_number = 1035672

select riml.* from dbo.RI_MARKET_LEVEL riml
join dbo.RI_LAYER_LEVEL rill on rill.LAYER_LEVEL_SKEY = riml.LAYER_LEVEL_SKEY
join dbo.RI_HEADER_LEVEL rihl on rihl.HEADER_LEVEL_SKEY = rill.HEADER_LEVEL_SKEY
where rihl.SUB_RECORD_NUMBER = 1035672


-- in RSMS/2 but not in acctg at all
select * from RIAcctgMarket where sub_record_number = 979477

select riml.* from dbo.RI_MARKET_LEVEL riml
join dbo.RI_LAYER_LEVEL rill on rill.LAYER_LEVEL_SKEY = riml.LAYER_LEVEL_SKEY
join dbo.RI_HEADER_LEVEL rihl on rihl.HEADER_LEVEL_SKEY = rill.HEADER_LEVEL_SKEY
where rihl.SUB_RECORD_NUMBER = 979477



-- syschk_MatchABRIAcctg
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


-------------------------------------

DROP PROCEDURE syschk_RIOrg2Policies
GO

exec syschk_RIOrg2Policies


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO



--exec syschk_RIOrg2Policies

CREATE PROCEDURE syschk_RIOrg2Policies

AS


--Create temp table of rsms2 records, by market
select a.sub_record_number, a.sub_policy_number, isnull(f.company_skey, 0) as company_skey, isnull(d.location_skey, 0) as location_skey, isnull(profile_skey, 0) as profile_skey, sum(market_ceded_premium) as cededpremium
into #tk_a1
from submission a, 
ri_header_level b, 
ri_layer_level c,
ri_market_level d,
insurance_companies e,
location f
where a.sub_record_number = b.sub_record_number
and b.header_level_skey = c.header_level_skey
and c.layer_level_skey = d.layer_level_skey
and e.company_record_number = a.company_record_number
and e.org_number = 2
and b.endorsement_skey is null
and b.claim_skey is null
--and a.sub_record_number = 506347
and d.location_skey *= f.location_skey
--and a.sub_record_number in (select distinct sub_record_number from premiumheader where premiumtypeskey = 5)
group by a.sub_record_number, a.sub_policy_number, f.company_skey, d.location_skey, profile_skey
order by 1

--now update the company_skey from the company table for records that do not have a profile or location
--these are the result of an adjustment
update #tk_a1
set company_skey = b.company_skey
from location b
where #tk_a1.location_skey = b.location_skey
and #tk_a1.location_skey = 0 
and #tk_a1.Profile_Skey = 0

--now group into another temp table by company
select sub_record_number, sub_policy_number, company_skey, profile_skey, sum(cededpremium) as cededpremium
into #tk_a 
from #tk_a1
group by sub_record_number, sub_policy_number, company_skey, profile_skey
order by 1


--Create temp table of accounting records, by market
select a.sub_record_number, a.sub_policy_number, b.company_skey as company_skey, isnull(b.location_skey, 0) as location_skey, isnull(profile_skey, 0) as profile_skey, sum(cededpremiumamt) *-1 as cededpremium
into #tk_b1
from submission a, 
riacctgmarket b,
insurance_companies e
where a.sub_record_number = b.sub_record_number
and e.company_record_number = a.company_record_number
and e.org_number = 2
and b.endorsement_skey is null
--and (b.adjustment is null or b.adjustment = 'N')
--and a.sub_record_number = 506347
--and a.sub_record_number in (select distinct sub_record_number from premiumheader where premiumtypeskey = 5)
group by a.sub_record_number, a.sub_policy_number, b.company_skey, b.location_skey, b.profile_skey
having sum(cededpremiumamt) <> 0
order by 1

--take out company_skey if its a treaty
update #tk_b1
set company_skey = 0
where profile_skey > 0



select sub_record_number, sub_policy_number, company_skey, profile_skey, sum(cededpremium) as cededpremium
into #tk_b 
from #tk_b1
group by sub_record_number, sub_policy_number, company_skey, profile_skey
order by 1

/******************************************************************
These are policies that have adjustments that are showing as not in sync, but are ok
because of adjustments
******************************************************************/
delete from #tk_a
where sub_record_number in ( 545956, 673051, 583691, 613523)

delete from #tk_b
where sub_record_number in ( 545956, 673051, 583691, 613523)

--select count(*) from
select * from 
(
--in rsms2, not in accounting
select a.sub_policy_number, a.sub_record_number,  b.name as TreatyOrCompany,  a.cededpremium as value, 'in rsms2, not in accounting '  as msg
from #tk_a a, company b
where a.cededpremium <> 0
and not exists (select 1 from #tk_b b
where a.sub_record_number = b.sub_record_number
and a.company_skey = b.company_skey
and a.profile_skey = b.profile_skey)
and a.company_skey = b.company_skey
union
select a.sub_policy_number, a.sub_record_number, b.profile_name,   a.cededpremium as value, 'in rsms2, not in accounting'  as msg
from #tk_a a, treaty_profile b
where a.cededpremium <> 0
and not exists (select 1 from #tk_b b
where a.sub_record_number = b.sub_record_number
and a.company_skey = b.company_skey
and a.profile_skey = b.profile_skey)
and a.profile_skey = b.profile_skey
union
select  a.sub_policy_number, a.sub_record_number, 'No Profile or Company',  a.cededpremium as value, 'in rsms2, not in accounting'  as msg
from #tk_a a
where a.cededpremium <> 0
and not exists (select 1 from #tk_b b
where a.sub_record_number = b.sub_record_number
and a.company_skey = b.company_skey
and a.profile_skey = b.profile_skey)
and a.profile_skey = 0 and a.company_skey = 0


--in accounting, not in rsms2
union
select  a.sub_policy_number, a.sub_record_number, b.name,  a.cededpremium as value, 'in accounting, not rsms2'  as msg
from #tk_b a, company b
where not exists (select 1 from #tk_a b
where a.sub_record_number = b.sub_record_number
and a.company_skey = b.company_skey
and a.profile_skey = b.profile_skey)
and a.company_skey = b.company_skey
union
select a.sub_policy_number, a.sub_record_number, b.profile_name,   a.cededpremium as value, 'in accounting, not rsms2'  as msg
from #tk_b a, treaty_profile b
where not exists (select 1 from #tk_a b
where a.sub_record_number = b.sub_record_number
and a.company_skey = b.company_skey
and a.profile_skey = b.profile_skey)
and a.profile_skey = b.profile_skey
union
select a.sub_policy_number, a.sub_record_number, 'No Profile or Company',   a.cededpremium as value, 'in accounting, not rsms2'  as msg
from #tk_b a
where not exists (select 1 from #tk_a b
where a.sub_record_number = b.sub_record_number
and a.company_skey = b.company_skey
and a.profile_skey = b.profile_skey)
and a.profile_skey = 0 and a.company_skey = 0


--in both, premium different
union
select a.sub_policy_number, a.sub_record_number, c.name,   a.cededpremium - b.cededpremium as value, 'in both, this is difference'  as msg
from #tk_a a, #tk_b b, company c
where a.sub_record_number = b.sub_record_number
and a.company_skey = b.company_skey
and a.profile_skey = b.profile_skey
and abs(a.cededpremium - b.cededpremium) > .05
and c.company_skey = a.company_skey
union
select a.sub_policy_number, a.sub_record_number, c.profile_name,   a.cededpremium - b.cededpremium as value, 'in both, this is difference'  as msg
from #tk_a a, #tk_b b, treaty_profile c
where a.sub_record_number = b.sub_record_number
and a.company_skey = b.company_skey
and a.profile_skey = b.profile_skey
and abs(a.cededpremium - b.cededpremium) > .05
and c.profile_skey = a.profile_skey
union
select a.sub_policy_number, a.sub_record_number, 'No Profile or Company',   a.cededpremium - b.cededpremium as value, 'in both, this is difference'  as msg
from #tk_a a, #tk_b b
where a.sub_record_number = b.sub_record_number
and a.company_skey = b.company_skey
and a.profile_skey = b.profile_skey
and abs(a.cededpremium - b.cededpremium) > .05
and a.profile_skey = 0 and a.company_skey = 0
--order by 2

)q1

--select * from #tk_a where sub_record_number = 835483
--select * from #tk_b where sub_record_number = 835483


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



