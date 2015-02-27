select  r.ReserveKey,
	pn.IndReserveChange,
	pn.ExpReserveChange,
	pn.ExpReserveChangeALAE,
	pn.ExpReserveChangeULAE,
	rm.CededIndReserveChange as MarketIndReserveChange,
	rm.CededExpReserveChange as MarketExpReserveChange,
	rm.CededALAEExpReserveChange as MarketALAEExpReserveChange,
	rm.CededULAEExpReserveChange as MarketULAEExpReserveChange,
	isnull(tp.URC,'N') as IsRic,
	rr.CededIndReserveChange as ReinsurerIndReserveChange,
	rr.CededExpReserveChange as ReinsurerExpReserveChange,
	rr.CededALAEExpReserveChange as ReinsurerALAEExpReserveChange,
	rr.CededULAEExpReserveChange as ReinsurerULAEExpReserveChange,
	ricomp.company_skey,	
	rtm.CededIndReserveChange as TreatyMarketIndReserveChange,
	rtm.CededExpReserveChange as TreatyMarketExpReserveChange,
	rtm.CededALAEExpReserveChange as TreatyMarketALAEExpReserveChange,
	rtm.CededULAEExpReserveChange as TreatyMarketULAEExpReserveChange,
	rtr.CededIndReserveChange as TreatyReinsurerIndReserveChange,
	rtr.CededExpReserveChange as TreatyReinsurerExpReserveChange,
	rtr.CededALAEExpReserveChange as TreatyReinsurerALAEExpReserveChange,
	rtr.CededULAEExpReserveChange as TreatyReinsurerULAEExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 left outer join ReserveLayer rl on r.ReserveKey = rl.ReserveKey
 left outer join ReserveMarket rm on rl.ReserveLayerKey = rm.ReserveLayerKey
 inner join RI_MARKET_LEVEL riml on riml.mkt_level_skey = rm.mkt_level_skey
 inner join Treaty_Profile tp on tp.profile_skey = riml.profile_skey
 left outer join ReserveReinsurer rr on rr.ReserveMarketKey = rm.ReserveMarketKey
 left outer join RI_REINSURER_LEVEL rirrl on rirrl.reins_level_skey = rr.reins_level_skey
 left outer join Location loc on loc.location_skey = rirrl.location_skey
 left outer join Company ricomp on loc.company_skey = ricomp.company_skey
 left outer join ReserveTreatyMarket rtm on rtm.ReserveMarketKey = rm.ReserveMarketKey
 left outer join ReserveTreatyReinsurer rtr on rtr.ReserveTreatyMarketKey = rtm.ReserveTreatyMarketKey
where ic.org_number = 2
  and r.reservekey = 206358

order by r.ReserveKey
 
select *
from Reserve r
order by ReserveKey

select *
from ProofNotice
order by ReserveKey

select *
from ReserveLayer
where ReserveKey = 201922


select * from ProofNotice where ReserveKey = 176357

select * from Claims where ClaimKey = 48985





-- RIC reserve cedes
--  use for type 2 and 3, or type 4 and 5 if RSA
select  r.ReserveKey,
        ic.org_number,
	rm.CededIndReserveChange as MarketIndReserveChange,
	rm.CededExpReserveChange as MarketExpReserveChange,
	rm.CededALAEExpReserveChange as MarketALAEExpReserveChange,
	rm.CededULAEExpReserveChange as MarketULAEExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 left outer join ReserveLayer rl on r.ReserveKey = rl.ReserveKey
 left outer join ReserveMarket rm on rl.ReserveLayerKey = rm.ReserveLayerKey
 inner join RI_MARKET_LEVEL riml on riml.mkt_level_skey = rm.mkt_level_skey
 inner join Treaty_Profile tp on tp.profile_skey = riml.profile_skey
 left outer join ReserveReinsurer rr on rr.ReserveMarketKey = rm.ReserveMarketKey
 left outer join RI_REINSURER_LEVEL rirrl on rirrl.reins_level_skey = rr.reins_level_skey
 left outer join Location loc on loc.location_skey = rirrl.location_skey
 left outer join Company ricomp on loc.company_skey = ricomp.company_skey
 left outer join ReserveTreatyMarket rtm on rtm.ReserveMarketKey = rm.ReserveMarketKey
 left outer join ReserveTreatyReinsurer rtr on rtr.ReserveTreatyMarketKey = rtm.ReserveTreatyMarketKey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
-- and ic.org_number = 2 
 and (tp.Profile_Skey is not NULL and (tp.URC is not NULL and tp.URC = 'Y')) 
 --and r.reservekey = 206358



-- 3rd party reserve cedes
--  used for type 4 (cede non aff) and 5 (ass non aff) 
select  clms.claimoffice,
	clms.claimnumber,
	pn.pnnumber,
	r.ReserveKey,
        ic.org_number,
	comp.company_skey,
	IndReserveChange,
	ExpReserveChange,
	( pn.IndReserveChange - isnull(pn.InterCompanyIndReserveCededChange,0) ) as ThirdPartyIndReserveChange,
	( pn.ExpReserveChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) as ThirdPartyExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveChange) * ( pn.ExpReserveChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveChange) * ( pn.ExpReserveChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyULAEExpReserveChange,
	isnull(pn.InterCompanyIndReserveCededChange,0)  as RICIndReserveChange,
	isnull(pn.InterCompanyExpReserveCededChange,0)  as RICExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyULAEExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7

-- type 1, directs
select  t.CompanyKey,
	sum(t.IndReserveChange) as IndReserveChange,
	sum(t.ExpReserveChange) as ExpReserveChange
from
(

select  clms.claimoffice,
	clms.claimnumber,
	pn.pnnumber,
	r.ReserveKey,
        ic.org_number,
	comp.company_skey as CompanyKey,
	IndReserveChange,
	ExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7
 and comp.company_skey IN (693,694,695)
 and ic.org_number = 2
) t
group by t.CompanyKey 


-- type 2s RSUI to Landmark
select  t.CompanyKey,
	sum(t.RICIndReserveChange) as RICIndReserveChange,
	sum(t.RICExpReserveChange) as RICExpReserveChange
from
(

select  clms.claimoffice,
	clms.claimnumber,
	pn.pnnumber,
	r.ReserveKey,
        ic.org_number,
	comp.company_skey as CompanyKey,
	IndReserveChange,
	ExpReserveChange,
	( pn.IndReserveCededChange - isnull(pn.InterCompanyIndReserveCededChange,0) ) as ThirdPartyIndReserveChange,
	( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) as ThirdPartyExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveCededChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveCededChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyULAEExpReserveChange,
	isnull(pn.InterCompanyIndReserveCededChange,0)  as RICIndReserveChange,
	isnull(pn.InterCompanyExpReserveCededChange,0)  as RICExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveCededChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as RICALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveCededChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as RICULAEExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7
 and comp.company_skey = 693
 and ic.org_number = 2
) t
group by t.CompanyKey

-- type 2, RSUI from Capitol 
-- select the type 1 from table for Capitol


-- type 3s Landmark
select  t.CompanyKey,
	sum(t.RICIndReserveChange) as RICIndReserveChange,
	sum(t.RICExpReserveChange) as RICExpReserveChange
from
(

select  clms.claimoffice,
	clms.claimnumber,
	pn.pnnumber,
	r.ReserveKey,
        ic.org_number,
	comp.company_skey as CompanyKey,
	IndReserveChange,
	ExpReserveChange,
	( pn.IndReserveCededChange - isnull(pn.InterCompanyIndReserveCededChange,0) ) as ThirdPartyIndReserveChange,
	( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) as ThirdPartyExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveCededChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveCededChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyULAEExpReserveChange,
	isnull(pn.InterCompanyIndReserveCededChange,0)  as RICIndReserveChange,
	isnull(pn.InterCompanyExpReserveCededChange,0)  as RICExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveCededChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as RICALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveCededChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as RICULAEExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7
 and comp.company_skey = 693
 and ic.org_number = 2
) t
group by t.CompanyKey 


-- type 3, Capitol to RSUI 
-- select the type 1 from table for Capitol



-- type 4s RIC and Landmark
select  t.CompanyKey,
	sum(t.ThirdPartyIndReserveChange) as ThirdPartyIndReserveChange,
	sum(t.ThirdPartyExpReserveChange) as ThirdPartyExpReserveChange,
	sum(t.ThirdPartyALAEExpReserveChange) as ThirdPartyALAEExpReserveChange,
	sum(t.ThirdPartyULAEExpReserveChange) as ThirdPartyULAEExpReserveChange
from
(

select  clms.claimoffice,
	clms.claimnumber,
	pn.pnnumber,
	r.ReserveKey,
        ic.org_number,
	case
		when ic.org_number = 2 then 
			case
			 when comp.company_skey = 695 then 694
			 else comp.company_skey
			end
		else 999
	end as CompanyKey,
	IndReserveChange,
	ExpReserveChange,
	( pn.IndReserveCededChange - isnull(pn.InterCompanyIndReserveCededChange,0) ) as ThirdPartyIndReserveChange,
	( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) as ThirdPartyExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyULAEExpReserveChange,
	isnull(pn.InterCompanyIndReserveCededChange,0)  as RICIndReserveChange,
	isnull(pn.InterCompanyExpReserveCededChange,0)  as RICExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveCededChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as RICALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveCededChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as RICULAEExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7
 and comp.company_skey IN (693,694,695)
 and ic.org_number = 2
) t
group by t.CompanyKey 



-- type 5s
select  t.CompanyKey,
	sum(t.RICIndReserveChange) as RICIndReserveChange,
	sum(t.RICExpReserveChange) as RICExpReserveChange
from
(

select  clms.claimoffice,
	clms.claimnumber,
	pn.pnnumber,
	r.ReserveKey,
        ic.org_number,
	case
		when ic.org_number = 2 then 
			case
			 when comp.company_skey = 695 then 694
			 else comp.company_skey
			end
		else 999
	end as CompanyKey,
	IndReserveChange,
	ExpReserveChange,
	( pn.IndReserveCededChange - isnull(pn.InterCompanyIndReserveCededChange,0) ) as ThirdPartyIndReserveChange,
	( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) as ThirdPartyExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveCededChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveCededChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyULAEExpReserveChange,
	isnull(pn.InterCompanyIndReserveCededChange,0)  as RICIndReserveChange,
	isnull(pn.InterCompanyExpReserveCededChange,0)  as RICExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveCededChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as RICALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveCededChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveCededChange) * isnull(pn.InterCompanyExpReserveCededChange,0) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as RICULAEExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7
 and ic.org_number = 1
) t
group by t.CompanyKey 





select sum(IndemnityPaid) as indpaid, 
       sum(ExpensePaid) as exppaid, 
       sum(ExpenseReserveChange) as exprsvchange,  
       sum(IndemnityReserveChange) as indreservechange,  
       InsuranceCompanySkey,
       RecordType
from LossHeader
where InsuranceCompanySkey IN (693,694,695)
 and GLMonth = 7
 and GLYear = 2004 
and org_number = 2
group by InsuranceCompanySkey, RecordType 
order by RecordType, InsuranceCompanySkey



  

select  r.reservekey,
	IndReserveChange,
	ExpReserveChange
from Reserve r 
 left outer join ReserveLayer rl on rl.ReserveKey = r.ReserveKey
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7
 and comp.company_skey = 693
 and ic.org_number = 2
 and rl.ReserveLayerKey is null 





select  pn2.ReserveKey, 
	pn2.ExpReserveChange, 
	pn2.ExpReserveCededChange,
	pn2.ExpReserveChangeALAE,
	pn2.ExpReserveChangeULAE, 
	t.ExpReserveChange,
	t.ThirdPartyALAEExpReserveChange,
	t.ThirdPartyULAEExpReserveChange
from ProofNotice pn2
join  
(
select  clms.claimoffice,
	clms.claimnumber,
	pn.pnnumber,
	r.ReserveKey,
  	ic.org_number,
	case
		when ic.org_number = 2 then 
			case
			 when comp.company_skey = 695 then 694
			 else comp.company_skey
			end
		else 999
	end as CompanyKey,
	IndReserveChange,
	ExpReserveChange,
	( pn.IndReserveCededChange - isnull(pn.InterCompanyIndReserveCededChange,0) ) as ThirdPartyIndReserveChange,
	( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) as ThirdPartyExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyULAEExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7
 and comp.company_skey = 693
 and ic.org_number = 2
) t on t.ReserveKey = pn2.ReserveKey




select  pn2.ReserveKey, 
	pn2.ExpReserveChange, 
	pn2.ExpReserveCededChange,
	pn2.ExpReserveChangeALAE,
	pn2.ExpReserveChangeULAE, 
	t.ExpReserveChange,
	t.ThirdPartyALAEExpReserveChange,
	t.ThirdPartyULAEExpReserveChange
from LossHeader lh
join  
(
select  clms.claimoffice,
	clms.claimnumber,
	pn.pnnumber,
	r.ReserveKey,
  	ic.org_number,
	case
		when ic.org_number = 2 then 
			case
			 when comp.company_skey = 695 then 694
			 else comp.company_skey
			end
		else 999
	end as CompanyKey,
	IndReserveChange,
	ExpReserveChange,
	( pn.IndReserveCededChange - isnull(pn.InterCompanyIndReserveCededChange,0) ) as ThirdPartyIndReserveChange,
	( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) as ThirdPartyExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeALAE / pn.ExpReserveChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyALAEExpReserveChange,
	case 
        	when isnull(pn.ExpReserveChange, 0) != 0 
                  then ( (pn.ExpReserveChangeULAE / pn.ExpReserveChange) * ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) ) 
        	else cast(0 as [numeric](18, 2)) 
        end as ThirdPartyULAEExpReserveChange
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7
 and comp.company_skey = 693
 and ic.org_number = 2
) t on t.ReserveKey = pn2.ReserveKey



select InsuranceCompanySkey,
       sum(ExpenseReserveChange)
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
where RecordType = 4
 and GLMOnth = 7
 and GLYear = 2004
 and InsuranceCompanySkey = 693
group by InsuranceCompanySkey


select lh.ProofNoticeKey,
       sum(ExpenseReserveChange)
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 4
 and GLMOnth = 7
 and GLYear = 2004
 and InsuranceCompanySkey = 693
group by lh.ProofNoticeKey



drop table zms_Type4Headers

select  lh.ProofNoticeKey,
	r.ReserveKey,
        sum(ExpenseReserveChange) as exprsvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
into zms_Type4Headers
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 3
 and GLMOnth = 7
 and GLYear = 2004
 and InsuranceCompanySkey = 693
group by lh.ProofNoticeKey, r.ReserveKey
order by lh.proofnoticekey



drop table zms_Type4Notices

select  s.ClaimOffice,
	s.ClaimNumber,
	s.ProofNoticeKey,
	s.ReserveKey,
	s.OrgNumber,
	s.ThirdPartyCedePct,
	s.RICCedePct,
	-s.ExpReserveChange as ExpReserveChange,
	-s.ThirdPartyIndReserveChange as ThirdPartyIndReserveChange,
	-s.ThirdPartyExpReserveChange as ThirdPartyExpReserveChange,
	-s.ExpReserveChangeALAE * s.ThirdPartyCedePct as ThirdPartyALAEExpReserveChange,
	-s.ExpReserveChangeULAE * s.ThirdPartyCedePct as ThirdPartyULAEExpReserveChange
into zms_Type4Notices
from
(
select  clms.claimoffice as ClaimOffice,
	clms.claimnumber as ClaimNumber,
	pn.proofnoticekey as ProofNoticeKey,
	r.ReserveKey as ReserveKey,
  	ic.org_number as OrgNumber,
	ExpReserveChange as ExpReserveChange,
	( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) as ThirdPartyExpReserveChange,
	( pn.IndReserveCededChange - isnull(pn.InterCompanyIndReserveCededChange,0) ) as ThirdPartyIndReserveChange,
	case 
        	when isnull(pn.ExpReserve, 0) != 0 
                  then	( ( pn.ExpReserveCeded - isnull(pn.InterCompanyExpReserveCeded,0) ) / pn.ExpReserve ) 
        	else 
			case 
        			when isnull(pn.ExpReserveChange, 0) != 0 
                  		then	( ( pn.ExpReserveCededChange - isnull(pn.InterCompanyExpReserveCededChange,0) ) / pn.ExpReserveChange ) 
        			else cast(0 as [numeric](18, 2))
		        end 
        end as ThirdPartyCedePct,
	ExpReserveChangeALAE,
	ExpReserveChangeULAE,
	isnull(pn.InterCompanyIndReserveCededChange,0)  as RICIndReserveChange,
	isnull(pn.InterCompanyExpReserveCededChange,0)  as RICExpReserveChange,
	case 
        	when isnull(pn.ExpReserve, 0) != 0 
                  then ( ( isnull(pn.InterCompanyExpReserveCeded,0) ) / pn.ExpReserve ) 
        	else cast(0 as [numeric](18, 2)) 
        end as RICCedePct
from Reserve r 
 inner join ProofNotice pn on r.ReserveKey = pn.ReserveKey
 inner join ClaimSuffix cs on cs.ClaimSuffixKey = r.ClaimSuffixKey
 inner join Claims clms on clms.ClaimKey = cs.ClaimKey
 inner join ClaimPolicy cp on cp.ClaimPolicyKey = clms.ClaimPolicyKey
 inner join Insurance_Companies ic on ic.company_record_number = cp.company_record_number
 inner join Company comp on ic.company_skey = comp.company_skey
where 1=1
 and clms.DateOfLoss > '6/30/2003 23:59:59'
 and DATEPART(year,r.TransactionDate) = 2004
 and DATEPART(month,r.TransactionDate) = 7
 and comp.company_skey IN (693,694,695)
 and ic.org_number = 2
) s
order by s.proofnoticekey


select tn.ReserveKey,
	tn.ClaimOffice,
	tn.ClaimNumber,
	tn.ProofNoticeKey,
	pn.PNNUmber,
	tn.ThirdPartyALAEExpReserveChange,
	th.exprsvchangeALAE,
	tn.ThirdPartyULAEExpReserveChange,
	th.exprsvchangeULAE,
	(tn.ThirdPartyALAEExpReserveChange - th.exprsvchangeALAE) as diffALAE,
	(tn.ThirdPartyULAEExpReserveChange - th.exprsvchangeULAE) as diffULAE
from zms_Type4Notices tn
 left outer join zms_Type4Headers th on tn.ProofNoticeKey = th.ProofNoticeKey
 inner join ProofNotice pn on pn.ProofNoticeKey = th.ProofNoticeKey
where 1=1
and ( tn.ThirdPartyALAEExpReserveChange != th.exprsvchangeALAE 
	or tn.ThirdPartyULAEExpReserveChange != th.exprsvchangeULAE )


select 2 as StepId,
       7 as GLMonth,
       2004 as GLYear,
       InsuranceCompany,
       3 as RecordType,
       -sum(t.RICIndReserveChange) as IndReserveChange,
       -sum(t.RICExpReserveChange) as ExpReserveChange,
	     -sum( t.RICALAEExpReserveChange) as ExpReserveChangeALAE,
	     -sum( t.RICULAEExpReserveChange ) as ExpReserveChangeULAE
from temp_resvdetails t
where t.InsuranceCompany = 693
group by t.InsuranceCompany


select sum(ThirdPartyALAEChange),
	sum(ThirdPartyULAEChange),
	sum(diffALAE),
        sum(diffULAE)
from
(
select tn.ReserveKey,
	tn.ClaimOffice,
	tn.ClaimNumber,
	tn.ProofNoticeKey,
	pn.PNNUmber,
	-tn.ThirdPartyALAEExpReserveChange as ThirdPartyALAEChange,
	th.exprsvchangeALAE,
	-tn.ThirdPartyULAEExpReserveChange as ThirdPartyULAEChange,
	th.exprsvchangeULAE,
	(-tn.ThirdPartyALAEExpReserveChange - th.exprsvchangeALAE) as diffALAE,
	(-tn.ThirdPartyULAEExpReserveChange - th.exprsvchangeULAE) as diffULAE
from temp_resvdetails tn
 left outer join zms_Type4Headers th on tn.ProofNoticeKey = th.ProofNoticeKey
 inner join ProofNotice pn on pn.ProofNoticeKey = tn.ProofNoticeKey
where 1=1
 and tn.InsuranceCompany = 693



select sum(t.RICALAEExpReserveChange),
	sum(t.RICULAEExpReserveChange),
	sum(diffALAE),
        sum(diffULAE)
from
(
select tn.ReserveKey,
	tn.ClaimOffice,
	tn.ClaimNumber,
	tn.ProofNoticeKey,
	pn.PNNUmber,
	-tn.RICALAEExpReserveChange as RICALAEExpReserveChange,
	th.exprsvchangeALAE as LTALAEChange,
	-tn.RICULAEExpReserveChange as RICULAEExpReserveChange,
	th.exprsvchangeULAE as LTULAEChange,
	(-tn.RICALAEExpReserveChange - th.exprsvchangeALAE) as diffALAE,
	(-tn.RICULAEExpReserveChange - th.exprsvchangeULAE) as diffULAE
from temp_resvdetails tn
 inner join zms_Type4Headers th on tn.ProofNoticeKey = th.ProofNoticeKey
 inner join ProofNotice pn on pn.ProofNoticeKey = tn.ProofNoticeKey
where 1=1
 and tn.InsuranceCompany = 693
 and th.
and ( tn.RICALAEExpReserveChange != th.exprsvchangeALAE 
	or tn.RICULAEExpReserveChange != th.exprsvchangeULAE )
) t

select * from temp_resvdetails where ProofNoticeKey = 229116


--
--  BEGIN Checking
--

drop table zms_Type4Headers

select  lh.ProofNoticeKey,
	r.ReserveKey,
        sum(ExpenseReserveChange) as exprsvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
into zms_Type4Headers
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 5
 and GLMOnth = 4
 and GLYear = 2004
 and InsuranceCompanySkey = 694
group by lh.ProofNoticeKey, r.ReserveKey
order by lh.proofnoticekey


select sum(t.RICALAEExpReserveChange),
	sum(t.RICULAEExpReserveChange),
	sum(diffALAE),
        sum(diffULAE)
from
(
select rd.ReserveKey,
	rd.ClaimOffice,
	rd.ClaimNumber,
	rd.ProofNoticeKey,
	rd.InsuranceCompany,
	pn.PNNUmber,
	rd.RICALAEExpReserveChange as RICALAEExpReserveChange,
	th.exprsvchangeALAE as LTALAEChange,
	rd.RICULAEExpReserveChange as RICULAEExpReserveChange,
	th.exprsvchangeULAE as LTULAEChange,
	(rd.RICALAEExpReserveChange - th.exprsvchangeALAE) as diffALAE,
	(rd.RICULAEExpReserveChange - th.exprsvchangeULAE) as diffULAE
from zms_Type4Headers th
 inner join ms_SIDReserveDetails rd on rd.ProofNoticeKey = th.ProofNoticeKey
 inner join ProofNotice pn on pn.ProofNoticeKey = th.ProofNoticeKey
where 1=1
-- and rd.InsuranceCompany = 694
and ( rd.RICALAEExpReserveChange != th.exprsvchangeALAE 
	or rd.RICULAEExpReserveChange != th.exprsvchangeULAE )
) t




select distinct ProofNoticeKey from ms_SIDReserveDetails

select distinct ProofNoticeKey from zms_Type4Headers

select * from ms_SIDReserveDetails rd
where 1=1
 and rd.ProofNoticeKey not in (select ProofNoticeKey from zms_Type4Headers)


--
--  END
--


select 2 as StepId,
       7 as GLMonth,
       2004 as GLYear,
       InsuranceCompany,
       3 as RecordType,
       -sum(t.RICIndReserveChange) as IndReserveChange,
       -sum(t.RICExpReserveChange) as ExpReserveChange,
	     -sum( t.RICALAEExpReserveChange) as ExpReserveChangeALAE,
	     -sum( t.RICULAEExpReserveChange ) as ExpReserveChangeULAE
from temp_resvdetails t
where t.InsuranceCompany = 693
group by t.InsuranceCompany


select *
from temp_resvdetails

select 	sum(-(tn.ThirdPartyALAEExpReserveChange) - th.exprsvchangeALAE) as diffALAE,
	sum(-(tn.ThirdPartyULAEExpReserveChange) - th.exprsvchangeULAE) as diffULAE
from zms_Type4Notices tn
 left outer join zms_Type4Headers th on tn.ProofNoticeKey = th.ProofNoticeKey
where 1=1
and ( tn.ThirdPartyALAEExpReserveChange != th.exprsvchangeALAE 
	or tn.ThirdPartyULAEExpReserveChange != th.exprsvchangeULAE )
 and th.ProofNoticeKey NOT IN ( 230527, 230536 )


select * 
from zms_Type4Notices where ProofNoticeKey = 228975

select * 
from ProofNotice where ProofNoticeKey = 228975


select * 
from ProofNotice where ProofNoticeKey = 228238

select * 
from ProofNotice where ProofNoticeKey IN ( 230527, 230536)

select * from ProofNotice
where ClaimKey = 48985 and ClaimSuffixKey = 55256

select sum(expensereservechange) 
from LossHeader where ProofNoticeKey = 230527
and RecordType = 4
 and InsuranceCompanySkey = 693
order by AssociatedCompanySkey
 and AssociatedCompanySkey = 694


select *
from LossHeader where ProofNoticeKey = 230527
and RecordType = 4
 and InsuranceCompanySkey = 693
order by AssociatedCompanySkey
 and AssociatedCompanySkey = 694


select *
from Claim



 
