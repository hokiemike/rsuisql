select CededAmount
from PaymentTreatyMarket

select p.paymentkey,p.indemnityamount, p.expenseamount, ptm.cededamt
from PaymentTreatyMarket ptm

 inner join PaymentMarket pm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
where claimkey = 49285
order by p.paymentkey

select p.paymentkey,p.indemnityamount, p.expenseamount, ptri.cededamt
from PaymentTreatyReinsurer ptri
 inner join PaymentTreatyMarket ptm on ptri.PaymentTreatyMarketKey = ptm.PaymentTreatyMarketKey
 inner join RI_treaty_market_level rtml on rtml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rtml.profile_mkt_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentMarket pm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
where claimkey = 49285
 and rtmlco.reins_type = 22
 order by p.paymentkey

select c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey,p.indemnityamount, p.expenseamount
from PaymentTreatyMarket ptm
 inner join RI_treaty_market_level rtml on rtml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rtml.profile_mkt_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentMarket pm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 order by p.paymentkey 

select c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey,p.indemnityamount, p.expenseamount, ptm.cededamt
from PaymentTreatyMarket ptm
 inner join RI_treaty_market_level rtml on rtml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rtml.profile_mkt_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentMarket pm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 --and c.claimkey = 7022
intersect
select c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey,p.indemnityamount, p.expenseamount, pm.cededamt
from PaymentMarket pm
 inner join RI_market_level rml on rml.mkt_level_skey = pm.mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rml.profile_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 --and c.claimkey = 7022
 order by p.paymentkey


select mike.claimkey, mike.claimsuffix, sum(mike.ind)
from (
select c.claimkey as claimkey, p.claimsuffixkey as claimsuffix, 'PTM' as ind
from PaymentTreatyMarket ptm
 inner join RI_treaty_market_level rtml on rtml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rtml.profile_mkt_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentMarket pm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 --and c.claimkey = 7022
union
select c.claimkey as claimkey, p.claimsuffixkey as claimsuffix, 'PM' as ind
from PaymentMarket pm
 inner join RI_market_level rml on rml.mkt_level_skey = pm.mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rml.profile_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 --and c.claimkey = 7022
order by claimkey, claimsuffixkey
) mike
group by mike.claimkey, mike.claimsuffix
having sum(mike.ind) > 1

select mike.claimkey, mike.claimsuffix, sum(mike.ind)
from (
select c.claimkey as claimkey, p.claimsuffixkey as claimsuffix, 'A' as ind
from PaymentTreatyMarket ptm
 inner join RI_treaty_market_level rtml on rtml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rtml.profile_mkt_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentMarket pm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 --and c.claimkey = 7022
union
select c.claimkey as claimkey, p.claimsuffixkey as claimsuffix, 'B' as ind
from PaymentMarket pm
 inner join RI_market_level rml on rml.mkt_level_skey = pm.mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rml.profile_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 --and c.claimkey = 7022
) mike
group by mike.claimkey, mike.claimsuffix
--having sum(mike.ind) > 1
order by mike.claimkey, mike.claimsuffix

select distinct cs.claimkey, cs.claimsuffixkey , xref_ptm.ind
from ClaimSuffix cs
inner join (
select c.claimkey as claimkey, p.claimsuffixkey as claimsuffix, 'A' as ind
from PaymentTreatyMarket ptm
 inner join RI_treaty_market_level rtml on rtml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rtml.profile_mkt_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentMarket pm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
) xref_ptm on xref_ptm.claimkey = cs.claimkey AND xref_ptm.claimsuffix = cs.claimsuffixkey
inner join (
select c.claimkey as claimkey, p.claimsuffixkey as claimsuffix, 'B' as ind
from PaymentMarket pm
 inner join RI_market_level rml on rml.mkt_level_skey = pm.mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rml.profile_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
) xref_pm on xref_pm.claimkey = cs.claimkey AND xref_pm.claimsuffix = cs.claimsuffixkey





select c.claimkey as claimkey, p.claimsuffixkey as claimsuffix, 'A' as ind
from PaymentTreatyMarket ptm
 inner join RI_treaty_market_level rtml on rtml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rtml.profile_mkt_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentMarket pm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 --and c.claimkey = 7022
union
select c.claimkey as claimkey, p.claimsuffixkey as claimsuffix, 'B' as ind
from PaymentMarket pm
 inner join RI_market_level rml on rml.mkt_level_skey = pm.mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rml.profile_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
order by claimkey, claimsuffix




select max(claimkey) from claims

select c.*
from claims c
 inner join Payment p on p.ClaimKey = c.claimkey
where c.DateOfLoss > '1/1/2004'
order by c.ClaimKey

--PAYMENTS FLATTENED
-- Get Direct TreatyMarkets
select c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt,
 pm.mkt_level_skey, pm.cededamt,
 ptm.treaty_mkt_level_skey, ptm.cededamt,
 null as treaty_reinsurer_key, null treaty_reinsurer_ceded_amt
from PaymentTreatyMarket ptm
 inner join RI_treaty_market_level rtml on rtml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rtml.profile_mkt_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentMarket pm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 and c.claimkey = 7022
union
-- Get Direct Markets
select c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt,
 pm.mkt_level_skey, pm.cededamt,
 null as treaty_market_key, null as treaty_market_ceded_amt,
 null as treaty_reinsurer_key, null treaty_reinsurer_ceded_amt
from PaymentMarket pm
 inner join RI_market_level rml on rml.mkt_level_skey = pm.mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rml.profile_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 and c.claimkey = 7022
 order by p.paymentkey

select c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt,
 pm.mkt_level_skey, pm.cededamt, 
 pri.reins_level_skey, pri.cededamt,
 ptm.treaty_mkt_level_skey, ptm.cededamt,
 ptri.treaty_reins_level_skey, ptri.cededamt
 from Payment p
 inner join PaymentLayer pl on pl.PaymentKey = p.PaymentKey
 left outer join PaymentMarket pm on pl.PaymentLayerKey = pm.PaymentLayerKey
      inner join RI_MARKET_LEVEL riml on riml.mkt_level_skey = pm.mkt_level_skey
      inner join TREATY_PROFILE tp on tp.profile_skey = riml.profile_skey
      inner join COMPANY comp on comp.company_skey = tp.
 left outer join PaymentTreatyMarket ptm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 left outer join PaymentTreatyReinsurer ptri on ptri.PaymentTreatyMarketKey = ptm.PaymentTreatyMarketKey
 left outer join PaymentReinsurer pri on pri.PaymentMarketKey = pm.PaymentMarketKey
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
where c.claimkey = 49183 
 order by c.claimkey, cs.claimsuffixkey, p.paymentkey, pl.layer_level_skey, pm.mkt_level_skey, ptm.treaty_mkt_level_skey 


-- Capital (695) treaty_reinsurers (ceded to non-affiliates, type 4)
select policy_comp.name, policy_comp.company_skey, c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt,
 pm.PaymentMarketKey,
 ptri.treaty_reins_level_skey, comp.name, ptri.cededamt
 from Payment p
 inner join PaymentLayer pl on pl.PaymentKey = p.PaymentKey
 left outer join PaymentMarket pm on pl.PaymentLayerKey = pm.PaymentLayerKey
 left outer join PaymentTreatyMarket ptm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 left outer join PaymentTreatyReinsurer ptri on ptri.PaymentTreatyMarketKey = ptm.PaymentTreatyMarketKey
      inner join RI_TREATY_REINSURER_LEVEL ritrl on ritrl.treaty_reins_level_skey = ptri.treaty_reins_level_skey
      inner join TREATY_PROFILE_REINSURER_LEVEL tprl on tprl.profile_reins_skey = ritrl.profile_reins_skey
      inner join COMPANY comp on comp.company_skey = tprl.company_skey
 left outer join PaymentReinsurer pri on pri.PaymentMarketKey = pm.PaymentMarketKey
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
 inner join ClaimPolicy cp on c.ClaimPolicyKey = cp.ClaimPolicyKey
 inner join Insurance_Companies ic on cp.company_record_number = ic.company_record_number
 inner join Company policy_comp on ic.company_skey = policy_comp.company_skey
where 1=1
 --and policy_comp.company_skey = 695 
 and ic.org_number = 2
 and pl.cededamt > 0
 and comp.company_type = 2
 --and c.claimkey = 49183
 order by c.claimkey, cs.claimsuffixkey, p.paymentkey, pl.layer_level_skey, pm.PaymentMarketKey

-- Capital (695) direct  treaty_markets (ceded to non-affiliates, type 4)
select policy_comp.name, policy_comp.company_skey, c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt,
 pm.PaymentMarketKey,
 ptm.treaty_mkt_level_skey, comp.name, ptm.cededamt
 from Payment p
 inner join PaymentLayer pl on pl.PaymentKey = p.PaymentKey
 left outer join PaymentMarket pm on pl.PaymentLayerKey = pm.PaymentLayerKey
 left outer join PaymentTreatyMarket ptm on ptm.PaymentMarketKey = pm.PaymentMarketKey
      inner join RI_TREATY_MARKET_LEVEL ritml on ritml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
      inner join TREATY_PROFILE_MARKET_LEVEL tpml on tpml.profile_mkt_skey = ritml.profile_mkt_skey
      inner join COMPANY comp on comp.company_skey = tpml.company_skey
 left outer join PaymentReinsurer pri on pri.PaymentMarketKey = pm.PaymentMarketKey
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
 inner join ClaimPolicy cp on c.ClaimPolicyKey = cp.ClaimPolicyKey
 inner join Insurance_Companies ic on cp.company_record_number = ic.company_record_number
 inner join Company policy_comp on ic.company_skey = policy_comp.company_skey
where 1=1
 --and policy_comp.company_skey = 695 
 and ic.org_number = 2
 and pl.cededamt > 0
 and comp.company_type = 3 and comp.reins_type = 22
 and c.claimkey = 49183
 order by c.claimkey, cs.claimsuffixkey, p.paymentkey, pl.layer_level_skey, pm.PaymentMarketKey


-- Capital (695) direct  markets (ceded to non-affiliates, type 4)
select policy_comp.name, policy_comp.company_skey, c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt,
 pm.PaymentMarketKey, comp.name, pm.cededamt
 from Payment p
 inner join PaymentLayer pl on pl.PaymentKey = p.PaymentKey
 left outer join PaymentMarket pm on pl.PaymentLayerKey = pm.PaymentLayerKey
      inner join RI_MARKET_LEVEL riml on riml.mkt_level_skey = pm.mkt_level_skey
      inner join LOCATION loc on riml.location_skey = loc.location_skey
      inner join COMPANY comp on comp.company_skey = loc.company_skey
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
 inner join ClaimPolicy cp on c.ClaimPolicyKey = cp.ClaimPolicyKey
 inner join Insurance_Companies ic on cp.company_record_number = ic.company_record_number
 inner join Company policy_comp on ic.company_skey = policy_comp.company_skey
where 1=1
 --and policy_comp.company_skey = 695 and ic.org_number = 2
 and ic.org_number = 2
 and pl.cededamt != 0
 --and comp.company_type = 3 
 and comp.reins_type = 23
 -- and c.claimkey = 49183
 order by policy_comp.name, c.claimkey, cs.claimsuffixkey, p.paymentkey, pl.layer_level_skey, pm.PaymentMarketKey



-- reinsurers (ceded to non-affiliates, type 4)
select policy_comp.name, policy_comp.company_skey, 
 c.claimkey, c.claimnumber, c.claimoffice,
 cs.claimsuffixkey, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt,
 pm.PaymentMarketKey, comp.name, pm.cededamt,
 pr.PaymentReinsurerKey, pr.cededamt
 from Payment p
 inner join PaymentLayer pl on pl.PaymentKey = p.PaymentKey
 left outer join PaymentMarket pm on pl.PaymentLayerKey = pm.PaymentLayerKey
 left outer join PaymentReinsurer pr on pm.PaymentMarketKey = pr.PaymentMarketKey
      inner join RI_REINSURER_LEVEL rirl on rirl.reins_level_skey = pr.reins_level_skey
      inner join LOCATION loc on rirl.location_skey = loc.location_skey
      inner join COMPANY comp on comp.company_skey = loc.company_skey
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
 inner join ClaimPolicy cp on c.ClaimPolicyKey = cp.ClaimPolicyKey
 inner join Insurance_Companies ic on cp.company_record_number = ic.company_record_number
 inner join Company policy_comp on ic.company_skey = policy_comp.company_skey
where 1=1
 --and policy_comp.company_skey = 695 and ic.org_number = 2
 --and not processed
 and p.paymenttypekey = 2
 and p.voided != 'Y'
 and ic.org_number = 2
 and pl.cededamt != 0
 and comp.company_type = 2 
 -- and c.claimkey = 49183
 order by policy_comp.name, c.claimkey, cs.claimsuffixkey, p.paymentkey, pl.layer_level_skey, pm.PaymentMarketKey



-- payments, not voided (assumed from affiliate, type 2)
select policy_comp.name, policy_comp.company_skey, 
 c.claimkey, c.claimnumber, c.claimoffice,c.dateofloss, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt,
 pm.PaymentMarketKey, comp.name, pm.cededamt
 from Payment p
 inner join PaymentLayer pl on pl.PaymentKey = p.PaymentKey
 left outer join PaymentMarket pm on pl.PaymentLayerKey = pm.PaymentLayerKey
 left outer join PaymentTreatyMarket ptm on ptm.PaymentMarketKey = pm.PaymentMarketKey
      inner join RI_TREATY_MARKET_LEVEL ritml on ritml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
      inner join TREATY_PROFILE_MARKET_LEVEL tpml on tpml.profile_mkt_skey = ritml.profile_mkt_skey
      inner join COMPANY comp on comp.company_skey = tpml.company_skey
      inner join Treaty_Profile tp on tp.profile_skey = tpml.profile_skey
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
 inner join ClaimPolicy cp on c.ClaimPolicyKey = cp.ClaimPolicyKey
 inner join Insurance_Companies ic on cp.company_record_number = ic.company_record_number
 inner join Company policy_comp on ic.company_skey = policy_comp.company_skey
where 1=1
 --and policy_comp.company_skey = 695 and ic.org_number = 2
 and ic.org_number = 1
 and p.voided != 'Y'
 and p.paymenttypekey = 2
 and pl.cededamt != 0
 --and comp.company_type = 3 
 -- and c.claimkey = 49183
 and tp.URC is not NULL and tp.URC = 'Y'
 order by c.dateofloss asc, policy_comp.name,c.claimkey, cs.claimsuffixkey, p.paymentkey, pl.layer_level_skey, pm.PaymentMarketKey




-- Landmark payments, not voided (ceded to affiliate, type 3) 
select policy_comp.name, policy_comp.company_skey, 
 c.claimkey, c.claimnumber, c.claimoffice,c.dateofloss, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt,
 pm.PaymentMarketKey, comp.name, pm.cededamt
 from Payment p
 inner join PaymentLayer pl on pl.PaymentKey = p.PaymentKey
 left outer join PaymentMarket pm on pl.PaymentLayerKey = pm.PaymentLayerKey
 left outer join PaymentTreatyMarket ptm on ptm.PaymentMarketKey = pm.PaymentMarketKey
      inner join RI_TREATY_MARKET_LEVEL ritml on ritml.treaty_mkt_level_skey = ptm.treaty_mkt_level_skey
      inner join TREATY_PROFILE_MARKET_LEVEL tpml on tpml.profile_mkt_skey = ritml.profile_mkt_skey
      inner join COMPANY comp on comp.company_skey = tpml.company_skey
      inner join Treaty_Profile tp on tp.profile_skey = tpml.profile_skey
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
 inner join ClaimPolicy cp on c.ClaimPolicyKey = cp.ClaimPolicyKey
 inner join Insurance_Companies ic on cp.company_record_number = ic.company_record_number
 inner join Company policy_comp on ic.company_skey = policy_comp.company_skey
where 1=1
 --and policy_comp.company_skey = 695 and ic.org_number = 2
 and ic.org_number = 2
 and p.voided != 'Y'
 and p.paymenttypekey = 2
 and pl.cededamt != 0
 --and comp.company_type = 3 
 -- and c.claimkey = 49183
 and (tp.URC is not NULL and tp.URC = 'Y')
 order by c.dateofloss asc, policy_comp.name,c.claimkey, cs.claimsuffixkey, p.paymentkey, pl.layer_level_skey, pm.PaymentMarketKey



-- Capitol payments, not voided (direct and ceded to affiliate, type 3)
-- the entire payment amount is type 3 from Capitol to RIC
--  and type 1 Direct to Capitol
select policy_comp.name, policy_comp.company_skey, 
 c.claimkey, c.claimnumber, c.claimoffice,c.dateofloss, 
 p.paymentkey, p.indemnityamount, p.expenseamount
 from Payment p
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
 inner join ClaimPolicy cp on c.ClaimPolicyKey = cp.ClaimPolicyKey
 inner join Insurance_Companies ic on cp.company_record_number = ic.company_record_number
 inner join Company policy_comp on ic.company_skey = policy_comp.company_skey
where 1=1
 and policy_comp.company_skey = 695
 and ic.org_number = 2
 and p.voided != 'Y'
 and p.paymenttypekey = 2
 order by c.dateofloss asc, policy_comp.name,c.claimkey, cs.claimsuffixkey, p.paymentkey






select c.claimnumber, c.claimoffice, c.ClaimKey, ic.company_name
from Payment p
 inner join Claims c on c.ClaimKey = p.ClaimKey
inner join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
inner join INsurance_companies ic on ic.company_record_number = cp.company_record_number
where ic.org_number = 2
 and p.paymenttypekey = 2
 and p.voided != 'Y'
 and c.DateOfLoss >= '7/1/2003'

select distinct paymenttypekey
from Payment

select * from Paymenttype

select * from 
Reserve
where ExpReserve != 0
 and ExpReserve < 100
 -- and isCurrent = 'Y'



select  distinct flat_ri.layer_level_skey, flat_ri.layer_ceded_amt
from (
select c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt as layer_ceded_amt,
 pm.mkt_level_skey, pm.cededamt as market_ceded_amt,
 pri.reins_level_skey, pri.cededamt as reinsurer_ceded_amt,
 ptm.treaty_mkt_level_skey, ptm.cededamt as treaty_market_ceded_amt,
 ptri.treaty_reins_level_skey, ptri.cededamt as treaty_reinsurer_ceded_amt
 from Payment p
 inner join PaymentLayer pl on pl.PaymentKey = p.PaymentKey
 left outer join PaymentMarket pm on pl.PaymentLayerKey = pm.PaymentLayerKey
 left outer join PaymentTreatyMarket ptm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 left outer join PaymentTreatyReinsurer ptri on ptri.PaymentTreatyMarketKey = ptm.PaymentTreatyMarketKey
 left outer join PaymentReinsurer pri on pri.PaymentMarketKey = pm.PaymentMarketKey
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
where c.claimkey = 49183 ) flat_ri
group by flat_ri.layer_level_skey

select  flat_ri.layer_level_skey, sum(flat_ri.layer_ceded_amt)
from (
select c.claimkey, c.claimnumber, c.claimoffice, 
 p.paymentkey, p.indemnityamount, p.expenseamount, 
 pl.layer_level_skey, pl.appliedamt, pl.cededamt as layer_ceded_amt,
 pm.mkt_level_skey, pm.cededamt as market_ceded_amt,
 pri.reins_level_skey, pri.cededamt as reinsurer_ceded_amt,
 ptm.treaty_mkt_level_skey, ptm.cededamt as treaty_market_ceded_amt,
 ptri.treaty_reins_level_skey, ptri.cededamt as treaty_reinsurer_ceded_amt
 from Payment p
 inner join PaymentLayer pl on pl.PaymentKey = p.PaymentKey
 left outer join PaymentMarket pm on pl.PaymentLayerKey = pm.PaymentLayerKey
 left outer join PaymentTreatyMarket ptm on ptm.PaymentMarketKey = pm.PaymentMarketKey
 left outer join PaymentTreatyReinsurer ptri on ptri.PaymentTreatyMarketKey = ptm.PaymentTreatyMarketKey
 left outer join PaymentReinsurer pri on pri.PaymentMarketKey = pm.PaymentMarketKey
 inner join ClaimSuffix cs on cs.ClaimKey = p.ClaimKey and cs.ClaimSuffixKey = p.ClaimSuffixKey
 inner join Claims c on c.ClaimKey = p.ClaimKey
where c.claimkey = 49183 ) flat_ri
group by flat_ri.layer_level_skey
 




 inner join RI_market_level rml on rml.mkt_level_skey = pm.mkt_level_skey
 inner join treaty_profile_market_level tpml on tpml.profile_mkt_skey = rml.profile_skey
 inner join Company rtmlco on rtmlco.company_skey = tpml.company_skey
 inner join PaymentLayer pl on pl.PaymentLayerKey = pm.PaymentLayerKey
 inner join Payment p on pl.PaymentKey = p.PaymentKey
 inner join Claims c on p.claimkey = c.claimkey
where rtmlco.reins_type = 22
 and c.claimkey = 7022
 order by p.paymentkey

select distinct(claimoffice)
from claims

select * from 
ClaimOffice

select * 
from secuser

