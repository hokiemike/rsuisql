select c.claimoffice + c.claimnumber as claimnumber, 
	r.transactiondate, r.PNNUmber, r.indreserve, r.ExpReserve
from reserve r 
join claims c on r.claimkey = c.claimkey
where r.reservekey IN
(
select 
	q1.reservekey
	--isnull(q2.facdirectmarketceded,0) as facdirectmarketceded, 
	--isnull(q3.facreinsurerceded,0) as facreinsurerceded,
	--isnull(q4.treatydirectmarketceded,0) as treatydirectmarketceded,
	--isnull(q5.treatyreinsurerceded,0) as treatyreinsurerceded,
	--isnull(q6.layerapplied,0) as layerapplied,
	--isnull(q6.layerceded,0) as layerceded
from
(
select
	c.claimoffice + c.claimnumber as claimnumber,
	r.reservekey,
	r.transactiondate,
	sum(r.indreserve + r.expreserve) as reserveamount
from
	reserve r
	inner join claims c on c.claimkey = r.claimkey
where
	1 = 1
	and r.transactiondate > '1/1/2004'
	and r.iscurrent = 'Y'
	--and r.reservekey = 114244

group by
	r.reservekey,
	r.transactiondate,
	c.claimoffice + c.claimnumber 
)q1
left join
(
select reservekey, isnull(sum(rm.cededindreserve + rm.cededexpreserve),0) as facdirectmarketceded
from
	reservemarket rm 
	left join ri_market_level ml on ml.mkt_level_skey = rm.mkt_level_skey
	left join location l on l.location_skey = ml.location_skey
	left join company c on c.company_skey = l.company_skey
where
c.reins_type <> 23
group by reservekey
)q2 on q1.reservekey = q2.reservekey

left join
(
select rr.reservekey,isnull(sum(rr.cededindreserve + rr.cededexpreserve),0) as facreinsurerceded
from
	reservereinsurer rr
group by reservekey
)q3
on q1.reservekey = q3.reservekey
left join
(
select 
	reservekey,
	isnull(sum(rtm.cededindreserve + rtm.cededexpreserve),0) as treatydirectmarketceded
from 
	reservetreatymarket rtm 
	left join ri_treaty_market_level tml on tml.treaty_mkt_level_skey = rtm.treaty_mkt_level_skey
	left join treaty_profile_market_level tpml on tpml.profile_mkt_skey = tml.profile_mkt_skey
	left join company c1 on c1.company_skey = tpml.company_skey
where
	c1.reins_type <> 23
group by reservekey)q4
on q1.reservekey = q4.reservekey

left join
(

select rtr.reservekey,isnull(sum(rtr.cededindreserve + rtr.cededexpreserve),0) as treatyreinsurerceded
from
	reservetreatyreinsurer rtr
group by reservekey)q5
on q1.reservekey = q5.reservekey

left join
(
select 
	reservekey,	
	isnull(sum(rl.appliedindamt + rl.appliedexpamt),0) as layerapplied,
	isnull(sum(rl.cededindreserve + rl.cededexpreserve),0) as layerceded
from reservelayer rl

group by reservekey
)q6
on q1.reservekey = q6.reservekey

where
	1 = 1
	and abs(q1.reserveamount) > 3
	--and abs(q6.layerapplied) < 3 and abs(q6.layerapplied) > 0
	and 
	( 
	( abs(q1.reserveamount - isnull(q6.layerapplied,0)) / q1.reserveamount > .05) -- reserve has not been applied to the layers by more than $1
	or
	(
	  abs(q6.layerceded -
		(
		isnull(q2.facdirectmarketceded,0) +
		isnull(q3.facreinsurerceded,0) +
		isnull(q4.treatydirectmarketceded,0) +
		isnull(q5.treatyreinsurerceded,0) 
		) ) / q1.reserveamount
	> .05 ) -- direct ceded amounts do not total layer ceded amount by more than $1
	) 
)
order by r.reservekey