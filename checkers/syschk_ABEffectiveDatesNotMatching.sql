select * from
(


select a.agentsbalancekey, b.SUB_RECORD_NUMBER as subrecnbr, null as endrsment_key
from agentsbalance a
join submission b on a.sub_record_number = b.sub_record_number
where a.iscurrent = 1
and (a.sub_effective_date != b.sub_effective_date or a.sub_expiration_date != a.sub_expiration_date or a.currenteffectivedate != b.sub_current_effective_date)
and endorsement_skey is null
and b.sub_effective_date >= '01/01/2007'

union all

select a.agentsbalancekey, null as subrecnbr, b.endorsement_skey as endrsment_key
from agentsbalance a
join endorsement b on a.endorsement_skey = b.endorsement_skey
where a.iscurrent = 1
and (a.currenteffectivedate != b.endorsement_effective_date)
and a.endorsement_skey is not null
and b.endorsement_effective_date >= '01/01/2007'


)q1
GO

--select * from SUBMISSION where SUB_RECORD_NUMBER = 1431176