select 	rh.header_level_skey, 
	ic.company_code, 
	ps.policy_code, 
	s.sub_policy_number, 
	count(rll.layer_level_skey) 
from RI_HEADER_LEVEL rh
 inner join RI_LAYER_LEVEL rll on rll.header_level_skey = rh.header_level_skey
 inner join submission s on s.sub_record_number = rh.sub_record_number
 inner join policy_symbol ps on ps.symbol_skey = s.sub_policy_symbol
 inner join insurance_companies ic on ic.company_record_number = s.company_record_number
group by rh.header_level_skey, 
	 ic.company_code,
	 ps.policy_code, 
	 s.sub_policy_number
 having count(rll.layer_level_skey) > 1

select 	s.sub_record_number, 
	ps.policy_code, 
	s.sub_policy_number, 
	count(lpa.localc_record_no) 
from submission s
  inner join location_premium_allocation lpa on s.sub_record_number = lpa.sub_record_no
 inner join policy_symbol ps on ps.symbol_skey = s.sub_policy_symbol
 inner join insurance_companies ic on ic.company_record_number = s.company_record_number
group by s.sub_record_number, 
	 ic.company_code,
	 ps.policy_code, 
	 s.sub_policy_number
 having count(lpa.localc_record_no) > 1
 

select ic.company_code, ps.policy_code, s.sub_policy_number 
from submission s
inner join policy_symbol ps on ps.symbol_skey = s.sub_policy_symbol
inner join insurance_companies ic on ic.company_record_number = s.company_record_number
where sub_policy_number = 315749

select * from Policy_type_codes

select * from insurance_companies