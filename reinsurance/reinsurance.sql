--for bound quote reinsurance, reinsurers whose commission amount does not equal their pct * ceded_premium
select s.sub_policy_number, s.department_number, e.emp_last_name, 
s.sub_current_effective_date, s.sub_current_expiration_date, 
rirl.REINSURER_EFFECTIVE_DATE, rirl.REINSURER_EXPIRATION_DATE, rirl.REINSURER_CEDED_PREMIUM, 
rirl.REINSURER_COMMISSION_AMOUNT, REINSURER_COMMISSION_PERCENT, rirl.VersionTimestamp
 from ri_reinsurer_level rirl 
 join ri_market_level riml on riml.MKT_LEVEL_SKEY = rirl.MKT_LEVEL_SKEY
 join ri_layer_level rill on rill.layer_level_skey = riml.layer_level_skey
 join ri_header_level rihl on rihl.header_level_skey = rill.header_level_skey
 join submission s on s.sub_record_number = rihl.sub_record_number
 join employee e on s.emp_record_number = e.emp_record_number
where 1=1
and isnull(rihl.endorsement_skey,0) = 0 and isnull(rihl.claim_skey,0) = 0
and abs(rirl.REINSURER_COMMISSION_AMOUNT - 
      ( rirl.REINSURER_CEDED_PREMIUM * ( REINSURER_COMMISSION_PERCENT / 100) ) ) > .01

--for endorsements, reinsurers whose commission amount does not equal their pct * ceded_premium
select s.sub_policy_number, e.endorsement_number, e.ENDORSEMENT_EFFECTIVE_DATE, e.ENDORSEMENT_EXPIRATION_DATE, 
rirl.REINSURER_EFFECTIVE_DATE, rirl.REINSURER_EXPIRATION_DATE, rirl.REINSURER_CEDED_PREMIUM, 
rirl.REINSURER_COMMISSION_AMOUNT, REINSURER_COMMISSION_PERCENT, rirl.VersionTimestamp
 from ri_reinsurer_level rirl 
 join ri_market_level riml on riml.MKT_LEVEL_SKEY = rirl.MKT_LEVEL_SKEY
 join ri_layer_level rill on rill.layer_level_skey = riml.layer_level_skey
 join ri_header_level rihl on rihl.header_level_skey = rill.header_level_skey
 join endorsement e on e.endorsement_skey = rihl.endorsement_skey
 join submission s on e.sub_record_number = s.sub_record_number
where 1=1
and isnull(rihl.claim_skey,0) = 0
and abs(rirl.REINSURER_COMMISSION_AMOUNT - 
      ( rirl.REINSURER_CEDED_PREMIUM * ( REINSURER_COMMISSION_PERCENT / 100) ) ) > .01


--------------


select * from treaty_profile where profile_skey = 941


select * from dbo.TREATY_PROFILE_REINSURER_LEVEL where PROFILE_REINS_SKEY = 941
select * from dbo.TREATY_PROFILE_MARKET_LEVEL where PROFILE_MKT_SKEY = 354
select * from dbo.TREATY_PROFILE where PROFILE_SKEY = 236


select * from RI_MARKET_LEVEL where profile_skey = 236


select s.*
from ri_reinsurer_level rir
join ri_market_level rim on rir.mkt_level_skey = rim.mkt_level_skey
join ri_layer_level ril on rim.layer_level_skey = ril.layer_level_skey
join ri_header_level rih on ril.header_level_skey = rih.header_level_skey
join submission s on rih.sub_record_number = s.sub_record_number and rih.endorsement_skey is null and rih.claim_skey is null
where 1=1
and rir.location_skey = 659
and s.sub_effective_date > '1/1/2007'



select * from company where company_skey = 383
select * from treaty_profile_market_level where company_skey = 383
select * from treaty_profile_reinsurer_level where company_skey = 383



select s.*
from ri_treaty_reinsurer_level ritr
join ri_treaty_market_level ritm on ritr.treaty_mkt_level_skey = ritm.treaty_mkt_level_skey
join ri_market_level rim on ritm.mkt_level_skey = rim.mkt_level_skey
join ri_layer_level ril on rim.layer_level_skey = ril.layer_level_skey
join ri_header_level rih on ril.header_level_skey = rih.header_level_skey
join submission s on rih.sub_record_number = s.sub_record_number and rih.endorsement_skey is null and rih.claim_skey is null
where 1=1
and profile_reins_skey = 941
and s.sub_effective_date > '1/1/2007'

