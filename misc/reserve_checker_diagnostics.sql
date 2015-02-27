--
--  BEGIN  determine cause of type 4 errors
-- 
--


--select  sum(t.ThirdPartyALAEExpReserveChange),
--	sum(t.ThirdPartyULAEExpReserveChange),
--	sum(diffALAE),
--        sum(diffULAE)
select reservekey,
	diffALAE,
	diffULAE,
	ThirdPartyULAEExpReserveChange,
	LTULAEChange
from
(
select rd.ReserveKey,
	rd.ClaimOffice,
	rd.ClaimNumber,
	rd.ProofNoticeKey,
	rd.InsuranceCompany,
	pn.PNNUmber,
	-rd.ThirdPartyALAEExpReserveChange as ThirdPartyALAEExpReserveChange,
	th.exprsvchangeALAE as LTALAEChange,
	-rd.ThirdPartyULAEExpReserveChange as ThirdPartyULAEExpReserveChange,
	th.exprsvchangeULAE as LTULAEChange,
	(-rd.ThirdPartyALAEExpReserveChange - th.exprsvchangeALAE) as diffALAE,
	(-rd.ThirdPartyULAEExpReserveChange - th.exprsvchangeULAE) as diffULAE
from 
(select  lh.ProofNoticeKey,
	r.ReserveKey,
        sum(ExpenseReserveChange) as exprsvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 4
 and GLMOnth = 10
 and GLYear = 2004
 and InsuranceCompanySkey = 694
group by lh.ProofNoticeKey, r.ReserveKey

) th
 inner join ms_SIDReserveDetails rd on rd.ProofNoticeKey = th.ProofNoticeKey
 inner join ProofNotice pn on pn.ProofNoticeKey = th.ProofNoticeKey
where 1=1
and ( rd.ThirdPartyALAEExpReserveChange != th.exprsvchangeALAE 
	or rd.ThirdPartyULAEExpReserveChange != th.exprsvchangeULAE )
) t

select * from ms_SIDReserveDetails where ProofNoticeKey = 239300

select * from Reserve where ReserveKey = 216521
select * from ProofNotice where ReserveKey = 216521
select * from LossHeader where ProofNoticeKey = 243556
select * from Claims where ClaimKey = 54838

select * from ProofNotice where ReserveKey = 216521
select * from ProofNotice where ReserveKey = 216524


-- (1) delete from LossDetail
select * from LossDetail
where LossHeaderKey
IN
(
	select LossHeaderKey from LossHeader
	where ProofNoticeKey IN ( 243556, 243557 )
)

-- (2) delete from LossHeader
select * from LossHeader
where ProofNoticeKey IN ( 243556, 243557 )


-- (3) update ProofNotice to reset processed flag
-- update ProofNotice set LossTrackingProcessedDate = NULL
-- where ProofNoticeKey IN ( 243556, 243557 )



--
--  END  determine cause of type 4 errors
-- 
--

-- (3) update ProofNotice set LossTrackingProcessedDate = NULL
-- where pn.LossTrackingProcessedDate > '10/31/2004 17:00'
select pn.
from ProofNotice pn
where 	pn.LossTrackingProcessedDate > '10/31/2004 17:00'

-- (2) delete from LossHeader
select LossHeaderKey from LossHeader
where ProofNoticeKey IN (
select pn.ProofNoticeKey 
from ProofNotice pn
where 	pn.LossTrackingProcessedDate > '10/31/2004 17:00'
)



-- (1) delete from LossDetail
select * from LossDetail
where LossHeaderKey
IN
(
	select LossHeaderKey from LossHeader
	where ProofNoticeKey IN (
	select pn.ProofNoticeKey 
	from ProofNotice pn
	where 	pn.LossTrackingProcessedDate > '10/31/2004 17:00'
	)
)


select claimsuffixkey, count(claimhistorykey)
from ClaimHistory
where claimsuffixkey In ( select claimsuffixkey from ClaimHistory where DateCreated > '10/2/2004' )
group by claimsuffixkey
having count(claimhistorykey) > 1

select claimKey from ClaimHistory where DateCreated > '10/2/2004'


















--
--  BEGIN  determine cause of type 5 errors
-- 
--


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
from 
(select  lh.ProofNoticeKey,
	r.ReserveKey,
        sum(ExpenseReserveChange) as exprsvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 5
 and GLMOnth = 4
 and GLYear = 2004
 and InsuranceCompanySkey = 694
group by lh.ProofNoticeKey, r.ReserveKey

) th
 inner join ms_SIDReserveDetails rd on rd.ProofNoticeKey = th.ProofNoticeKey
 inner join ProofNotice pn on pn.ProofNoticeKey = th.ProofNoticeKey
where 1=1
and ( rd.RICALAEExpReserveChange != th.exprsvchangeALAE 
	or rd.RICULAEExpReserveChange != th.exprsvchangeULAE )
) t

select * from ms_SIDReserveDetails where ProofNoticeKey = 218856

select * from ProofNotice where ProofNoticeKey = 218856

--
--  END  determine cause of type 5 errors
-- 
--


--
--  BEGIN  determine cause of type 2 errors
-- 
--


select sum(LTIndReserveChange),
	sum(RICIndReserveChange),	
	 sum(diffInd),
	sum(diffExp),
       sum(t.RICALAEExpReserveChange),
       sum(t.RICULAEExpReserveChange),
       sum(diffALAE),
       sum(diffULAE)
from
(
select rd.ReserveKey,
	rd.ClaimOffice,
	rd.ClaimNumber,
	rd.ProofNoticeKey,
	694 as InsuranceCompany,
	pn.PNNUmber,
	case
	   when rd.InsuranceCOmpany = 695 then rd.IndReserveChange
	   else rd.RICIndReserveChange
	end as RICIndReserveChange, 
	th.indresvchange as LTIndReserveChange,
	case
	   when rd.InsuranceCOmpany = 695 then ( rd.IndReserveChange - th.indresvchange)
	   else ( rd.RICIndReserveChange - th.indresvchange)
	end as diffInd,
	case
	   when rd.InsuranceCOmpany = 695 then rd.ExpReserveChange
	   else rd.RICExpReserveChange
	end as RICExpReserveChange,
	th.expresvchange as LTExpReserveChange,
	case
	   when rd.InsuranceCOmpany = 695 then ( rd.ExpReserveChange - th.expresvchange)
	   else ( rd.RICExpReserveChange - th.expresvchange)
	end as diffexp,
	rd.RICALAEExpReserveChange as RICALAEExpReserveChange,
	th.exprsvchangeALAE as LTALAEChange,
	rd.RICULAEExpReserveChange as RICULAEExpReserveChange,
	th.exprsvchangeULAE as LTULAEChange,
	(rd.RICALAEExpReserveChange - th.exprsvchangeALAE) as diffALAE,
	(rd.RICULAEExpReserveChange - th.exprsvchangeULAE) as diffULAE
from 
(select lh.ProofNoticeKey,
	r.ReserveKey,
        sum(IndemnityReserveChange) as indresvchange,
        sum(ExpenseReserveChange) as expresvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 3
 and GLMOnth = 1
 and GLYear = 2004
group by lh.ProofNoticeKey, r.ReserveKey
) th
 left outer join ms_SIDReserveDetails rd on rd.ProofNoticeKey = th.ProofNoticeKey
 left outer join  ProofNotice pn on pn.ProofNoticeKey = th.ProofNoticeKey
where 1=1
and rd.InsuranceCompany = 693
--and (   rd.RICIndReserveChange != th.indresvchange
--        or rd.RICIndReserveChange != th.expresvchange
--        or rd.RICALAEExpReserveChange != th.exprsvchangeALAE 
--	or rd.RICULAEExpReserveChange != th.exprsvchangeULAE )
) t



select  sum(IndemnityReserveChange) as indresvchange,
        sum(ExpenseReserveChange) as expresvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 3
 and GLMOnth = 1
 and GLYear = 2004
 and InsuranceCompanySkey = 693


select count( distinct ReserveKey)
from
(
select rd.ReserveKey,
	rd.ClaimOffice,
	rd.ClaimNumber,
	rd.ProofNoticeKey,
	694 as InsuranceCompany,
	pn.PNNUmber,
	case
	   when rd.InsuranceCOmpany = 695 then rd.IndReserveChange
	   else rd.RICIndReserveChange
	end as RICIndReserveChange, 
	th.indresvchange as LTIndReserveChange,
	case
	   when rd.InsuranceCOmpany = 695 then ( rd.IndReserveChange - th.indresvchange)
	   else ( rd.RICIndReserveChange - th.indresvchange)
	end as diffInd,
	case
	   when rd.InsuranceCOmpany = 695 then rd.ExpReserveChange
	   else rd.RICExpReserveChange
	end as RICExpReserveChange,
	th.expresvchange as LTExpReserveChange,
	case
	   when rd.InsuranceCOmpany = 695 then ( rd.ExpReserveChange - th.expresvchange)
	   else ( rd.RICExpReserveChange - th.expresvchange)
	end as diffexp,
	rd.RICALAEExpReserveChange as RICALAEExpReserveChange,
	th.exprsvchangeALAE as LTALAEChange,
	rd.RICULAEExpReserveChange as RICULAEExpReserveChange,
	th.exprsvchangeULAE as LTULAEChange,
	(rd.RICALAEExpReserveChange - th.exprsvchangeALAE) as diffALAE,
	(rd.RICULAEExpReserveChange - th.exprsvchangeULAE) as diffULAE
from 
(select lh.ProofNoticeKey,
	r.ReserveKey,
        sum(IndemnityReserveChange) as indresvchange,
        sum(ExpenseReserveChange) as expresvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 3
 and GLMOnth = 1
 and GLYear = 2004
group by lh.ProofNoticeKey, r.ReserveKey
) th
 left outer join ms_SIDReserveDetails rd on rd.ProofNoticeKey = th.ProofNoticeKey
 left outer join  ProofNotice pn on pn.ProofNoticeKey = th.ProofNoticeKey
where 1=1
and rd.InsuranceCompany = 693
--and (   rd.RICIndReserveChange != th.indresvchange
--        or rd.RICIndReserveChange != th.expresvchange
--        or rd.RICALAEExpReserveChange != th.exprsvchangeALAE 
--	or rd.RICULAEExpReserveChange != th.exprsvchangeULAE )
) t

select * from ms_SIDReserveDetails where ProofNoticeKey = 218856

select * from ProofNotice where ProofNoticeKey = 218856

--
--  END  determine cause of type 2 errors
-- 
--

select *
from ms_SIDReserveDetails
where abs(IndReserveChange) between 3500 and 3700


select  sum(IndemnityReserveChange) as indresvchange,
        sum(ExpenseReserveChange) as expresvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 3
 and GLMOnth = 1
 and GLYear = 2004
 and InsuranceCompanySkey = 693

select 2 as StepId,
       1 as GLMonth,
       2004 as GLYear,
       InsuranceCompany,
       3 as RecordType,
       -sum(t.RICIndReserveChange) as IndReserveChange,
       -sum(t.RICExpReserveChange) as ExpReserveChange,
	     -sum( t.RICALAEExpReserveChange) as ExpReserveChangeALAE,
	     -sum( t.RICULAEExpReserveChange ) as ExpReserveChangeULAE
from dbo.ms_SIDReserveDetails t
where t.InsuranceCompany = 693
   and t.OrgNumber = 2
group by t.InsuranceCompany


select distinct t.proofnoticekey, t.ReserveKey, s.ReserveKey, s.ProofNoticeKey
from dbo.ms_SIDReserveDetails t
left outer join 
(
select rd.ReserveKey,
	rd.ClaimOffice,
	rd.ClaimNumber,
	rd.ProofNoticeKey,
	694 as InsuranceCompany,
	pn.PNNUmber,
	case
	   when rd.InsuranceCOmpany = 695 then rd.IndReserveChange
	   else rd.RICIndReserveChange
	end as RICIndReserveChange, 
	th.indresvchange as LTIndReserveChange,
	case
	   when rd.InsuranceCOmpany = 695 then ( rd.IndReserveChange - th.indresvchange)
	   else ( rd.RICIndReserveChange - th.indresvchange)
	end as diffInd,
	case
	   when rd.InsuranceCOmpany = 695 then rd.ExpReserveChange
	   else rd.RICExpReserveChange
	end as RICExpReserveChange,
	th.expresvchange as LTExpReserveChange,
	case
	   when rd.InsuranceCOmpany = 695 then ( rd.ExpReserveChange - th.expresvchange)
	   else ( rd.RICExpReserveChange - th.expresvchange)
	end as diffexp,
	rd.RICALAEExpReserveChange as RICALAEExpReserveChange,
	th.exprsvchangeALAE as LTALAEChange,
	rd.RICULAEExpReserveChange as RICULAEExpReserveChange,
	th.exprsvchangeULAE as LTULAEChange,
	(rd.RICALAEExpReserveChange - th.exprsvchangeALAE) as diffALAE,
	(rd.RICULAEExpReserveChange - th.exprsvchangeULAE) as diffULAE
from 
(select lh.ProofNoticeKey,
	r.ReserveKey,
        sum(IndemnityReserveChange) as indresvchange,
        sum(ExpenseReserveChange) as expresvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 3
 and GLMOnth = 1
 and GLYear = 2004
group by lh.ProofNoticeKey, r.ReserveKey
) th
 left outer join ms_SIDReserveDetails rd on rd.ProofNoticeKey = th.ProofNoticeKey
 left outer join  ProofNotice pn on pn.ProofNoticeKey = th.ProofNoticeKey
where 1=1
and rd.InsuranceCompany = 693
) s on s.ReserveKey = t.ReserveKey
where t.InsuranceCompany = 693
   and t.OrgNumber = 2
 and s.ReserveKey is NUll

select clms.*
from ProofNotice pn
 join Claims clms on pn.ClaimKey = clms.ClaimKey
 join ClaimHistory ch on ch.ClaimKey = clms.ClaimKey
Where pn.ReserveKey in (183623,184163,184197,184574,185538,191389)

select rd.ReserveKey,
	rd.ClaimOffice,
	rd.ClaimNumber,
	rd.ProofNoticeKey,
	694 as InsuranceCompany,
	pn.PNNUmber,
	case
	   when rd.InsuranceCOmpany = 695 then rd.IndReserveChange
	   else rd.RICIndReserveChange
	end as RICIndReserveChange, 
	th.indresvchange as LTIndReserveChange,
	case
	   when rd.InsuranceCOmpany = 695 then ( rd.IndReserveChange - th.indresvchange)
	   else ( rd.RICIndReserveChange - th.indresvchange)
	end as diffInd,
	case
	   when rd.InsuranceCOmpany = 695 then rd.ExpReserveChange
	   else rd.RICExpReserveChange
	end as RICExpReserveChange,
	th.expresvchange as LTExpReserveChange,
	case
	   when rd.InsuranceCOmpany = 695 then ( rd.ExpReserveChange - th.expresvchange)
	   else ( rd.RICExpReserveChange - th.expresvchange)
	end as diffexp,
	rd.RICALAEExpReserveChange as RICALAEExpReserveChange,
	th.exprsvchangeALAE as LTALAEChange,
	rd.RICULAEExpReserveChange as RICULAEExpReserveChange,
	th.exprsvchangeULAE as LTULAEChange,
	(rd.RICALAEExpReserveChange - th.exprsvchangeALAE) as diffALAE,
	(rd.RICULAEExpReserveChange - th.exprsvchangeULAE) as diffULAE
from 
(select lh.ProofNoticeKey,
	r.ReserveKey,
        sum(IndemnityReserveChange) as indresvchange,
        sum(ExpenseReserveChange) as expresvchange,
        sum(ExpenseReserveALAEChange) as exprsvchangeALAE,
	sum(ExpenseReserveULAEChange) as exprsvchangeULAE
from LossHeader lh
 join ProofNotice pn on lh.ProofNoticeKey = pn.ProofNoticeKey
 join Reserve r on r.ReserveKey = pn.ReserveKey
where RecordType = 3
 and GLMOnth = 1
 and GLYear = 2004
group by lh.ProofNoticeKey, r.ReserveKey
) th
 left outer join ms_SIDReserveDetails rd on rd.ProofNoticeKey = th.ProofNoticeKey
 left outer join  ProofNotice pn on pn.ProofNoticeKey = th.ProofNoticeKey
where 1=1
and rd.InsuranceCompany = 693
 and rd.ReserveKey IN (183623,184163,184197,184574,185538,191389)



select * from LossHeader where ProofNoticeKey = 210632
select * from LossHeader where ProofNoticeKey IN (211114,211649, 211683, 212059, 213018, 218842)


select * from LossHeader lh
join RI_MARKET_LEVEL riml on lh.mkt_level_skey = riml.mkt_level_skey
join Treaty_Profile tp on tp.profile_skey = riml.profile_skey
where lh.GlMonth = 1
 and tp.URC = 'Y'
 and tp.profile_skey = 193


where ProofNoticeKey IN (211114,211649, 211683, 212059, 213018, 218842)

select * from Treaty_Profile where URC = 'Y'

select * from Claims where ClaimKey = 49330

