select distinct s.SUB_RECORD_NUMBER, s.SUB_EFFECTIVE_DATE, e.ENDORSEMENT_SKEY, riml.MARKET_REINSURANCE_PERCENT, tp.PROFILE_NAME
from endorsement e
join submission s on s.sub_record_number = e.sub_record_number
join QUOTE_BINDER qb on qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER and qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
join ri_header_level rih on rih.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and rih.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
join ri_layer_level rill on rill.HEADER_LEVEL_SKEY = rih.HEADER_LEVEL_SKEY
join ri_market_level riml on riml.LAYER_LEVEL_SKEY = rill.LAYER_LEVEL_SKEY
join insurance_companies ic on ic.company_record_number = s.company_record_number
join endorsement_type et on et.endtype_record_number = e.endtype_record_number
left join treaty_profile tp on tp.profile_skey = riml.profile_skey
where 1=1
--and s.SUB_EFFECTIVE_DATE > '10/1/2006'
and s.department_number = 1900
and ic.org_number = 2
and e.endtype_record_number not in (5)
and e.endorsement_gross_premium > 0 
and (tp.URC = 'N' or tp.URC is null)
and rih.SpreaderType = 203
and not exists 
(
            select 1
            from ri_market_level riml2
            join ri_layer_level rill2 on rill2.layer_level_skey = riml2.layer_level_skey
            join ri_header_level rih2 on rih2.header_level_skey = rill2.header_level_skey
            join endorsement e2 on e2.endorsement_skey = rih2.endorsement_skey
            left join treaty_profile tp2 on tp2.profile_skey = riml2.profile_skey
            where 1=1
            and e2.ENDORSEMENT_SKEY = e.ENDORSEMENT_SKEY
            and ( tp2.URC = 'N' or tp2.URC is null )
)
order by s.SUB_EFFECTIVE_DATE
