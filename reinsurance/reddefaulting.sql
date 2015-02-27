-- query to locate the old treaties
-- 
--select Prior_Profile_Skey,*
-- from TREATY_PROFILE 
--where DEPARTMENT_NUMBER = 300
--and LastModified > '06-01-2007'


--
-- this query finds policies with out of date treaties 
--
select h.HEADER_LEVEL_SKEY, h.IsDefault, s.ProgramKey,  s.SUB_POLICY_NUMBER, s.SUB_EFFECTIVE_DATE, s.SUB_EXPIRATION_DATE, 
s.STATUS_CODE, s.SUB_INSURED_NAME, s.SUB_RECORD_NUMBER
from dbo.RI_HEADER_LEVEL h 
inner join submission s on	h.sub_record_number = s.sub_record_number and h.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
 where s.SUB_RECORD_NUMBER IN
( select distinct s.SUB_RECORD_NUMBER
    from SUBMISSION s
   join QUOTE_BINDER qb on qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER and qb.QB_SEQUENCE_no = s.QB_SEQUENCE_NO
   join RI_HEADER_LEVEL rih on s.SUB_RECORD_NUMBER = rih.SUB_RECORD_NUMBER 
   join RI_LAYER_LEVEL rill on rill.HEADER_LEVEL_SKEY = rih.HEADER_LEVEL_SKEY
   join RI_MARKET_LEVEL riml on riml.LAYER_LEVEL_SKEY = rill.LAYER_LEVEL_SKEY
   join TREATY_PROFILE tp on riml.PROFILE_SKEY = tp.PROFILE_SKEY
  where 1=1
   and ( s.SUB_CURRENT_EFFECTIVE_DATE < tp.PROFILE_EFFECTIVE_DATE  OR s.SUB_CURRENT_EFFECTIVE_DATE > tp.PROFILE_EXPIRATION_DATE )
   --and tp.profile_skey in (244,246,248,247,245,243)
   and s.DEPARTMENT_NUMBER = 300
   --and s.STATUS_CODE = 'B'
   --and rih.IsDefault = 0
   and s.SUB_EFFECTIVE_DATE > '6/30/2003'
)
order by h.IsDefault ASC


--
-- check how many AMWINS have multiple treaties
-- 


select distinct s.SUB_RECORD_NUMBER, s.SUB_INSURED_NAME, s.SUB_EFFECTIVE_DATE, tp.PROFILE_NAME, tp.PROFILE_SKEY, qb.QB_GROSS_PREMIUM
    from SUBMISSION s
   join QUOTE_BINDER qb on qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER and qb.QB_SEQUENCE_no = s.QB_SEQUENCE_NO
   join RI_HEADER_LEVEL rih on s.SUB_RECORD_NUMBER = rih.SUB_RECORD_NUMBER 
   join RI_LAYER_LEVEL rill on rill.HEADER_LEVEL_SKEY = rih.HEADER_LEVEL_SKEY
   join RI_MARKET_LEVEL riml on riml.LAYER_LEVEL_SKEY = rill.LAYER_LEVEL_SKEY
   join TREATY_PROFILE tp on riml.PROFILE_SKEY = tp.PROFILE_SKEY
  where 1=1
   and s.DEPARTMENT_NUMBER = 300
   and s.ProgramKey = 201
   and tp.URC = 'N'
order by s.SUB_EFFECTIVE_DATE  

select * from RIDefault where PROFILE_SKEY = 228
select * from RIDefault where PROFILE_SKEY = 214
select * from TREATY_PROFILE where PROFILE_SKEY = 228

select sum(qb.QB_GROSS_PREMIUM)
    from SUBMISSION s
   join QUOTE_BINDER qb on qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER and qb.QB_SEQUENCE_no = s.QB_SEQUENCE_NO
   join RI_HEADER_LEVEL rih on s.SUB_RECORD_NUMBER = rih.SUB_RECORD_NUMBER 
   join RI_LAYER_LEVEL rill on rill.HEADER_LEVEL_SKEY = rih.HEADER_LEVEL_SKEY
   join RI_MARKET_LEVEL riml on riml.LAYER_LEVEL_SKEY = rill.LAYER_LEVEL_SKEY
   join TREATY_PROFILE tp on riml.PROFILE_SKEY = tp.PROFILE_SKEY
  where 1=1
   and s.DEPARTMENT_NUMBER = 300
   and s.ProgramKey = 201
   and tp.URC = 'N'

select tp.PROFILE_NAME, sum(riml.MARKET_CEDED_PREMIUM)
    from SUBMISSION s
   join QUOTE_BINDER qb on qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER and qb.QB_SEQUENCE_no = s.QB_SEQUENCE_NO
   join RI_HEADER_LEVEL rih on s.SUB_RECORD_NUMBER = rih.SUB_RECORD_NUMBER 
   join RI_LAYER_LEVEL rill on rill.HEADER_LEVEL_SKEY = rih.HEADER_LEVEL_SKEY
   join RI_MARKET_LEVEL riml on riml.LAYER_LEVEL_SKEY = rill.LAYER_LEVEL_SKEY
   join TREATY_PROFILE tp on riml.PROFILE_SKEY = tp.PROFILE_SKEY
  where 1=1
   and s.DEPARTMENT_NUMBER = 300
   and s.ProgramKey = 201
   and tp.URC = 'N'
 group by tp.PROFILE_NAME
 




 






select * from RI_HEADER_LEVEL where header_level_skey = 471727
select * from RI_LAYER_LEVEL where HEADER_LEVEL_SKEY = 471727
select * from RI_MARKET_LEVEL where LAYER_LEVEL_SKEY = 559824


-- this transaction is used to delete reinsurance in the case of non-default policies
-- that have reinsurance with the old treaties
begin tran
--get the headers
select h.HEADER_LEVEL_SKEY, s.SUB_EFFECTIVE_DATE, s.SUB_EXPIRATION_DATE, s.STATUS_CODE, s.SUB_INSURED_NAME, s.SUB_RECORD_NUMBER
--into #Headers 
from dbo.RI_HEADER_LEVEL h 
inner join submission s on	h.sub_record_number = s.sub_record_number and h.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
 where s.SUB_RECORD_NUMBER IN
( select distinct s.SUB_RECORD_NUMBER
    from SUBMISSION s
   join QUOTE_BINDER qb on qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER and qb.QB_SEQUENCE_no = s.QB_SEQUENCE_NO
   join RI_HEADER_LEVEL rih on s.SUB_RECORD_NUMBER = rih.SUB_RECORD_NUMBER 
   join RI_LAYER_LEVEL rill on rill.HEADER_LEVEL_SKEY = rih.HEADER_LEVEL_SKEY
   join RI_MARKET_LEVEL riml on riml.LAYER_LEVEL_SKEY = rill.LAYER_LEVEL_SKEY
   join TREATY_PROFILE tp on riml.PROFILE_SKEY = tp.PROFILE_SKEY
  where 1=1
   and ( s.SUB_CURRENT_EFFECTIVE_DATE < tp.PROFILE_EFFECTIVE_DATE  OR s.SUB_CURRENT_EFFECTIVE_DATE > tp.PROFILE_EXPIRATION_DATE )
   --and tp.profile_skey in (244,246,248,247,245,243)
   and s.DEPARTMENT_NUMBER = 300
   --and s.STATUS_CODE = 'B'
   and rih.IsDefault = 0
)

-- check for endorsements
select * from Endorsement where SUB_RECORD_NUMBER IN (1133722, 1127018, 1133724)


--get the layers for the headers
select LAYER_LEVEL_SKEY into #Layers  from dbo.RI_LAYER_LEVEL where HEADER_LEVEL_SKEY in
(select HEADER_LEVEL_SKEY from #Headers)

--get the markets for the layers
select MKT_LEVEL_SKEY into #Markets  from dbo.RI_MARKET_LEVEL where LAYER_LEVEL_SKEY in
(select LAYER_LEVEL_SKEY from #Layers)

--get the Treaty Market Levels for the markets
select TREATY_MKT_LEVEL_SKEY into #TML  from dbo.RI_TREATY_MARKET_LEVEL where MKT_LEVEL_SKEY in
(select MKT_LEVEL_SKEY from #Markets)

--get the Treaty Reinsurer Levels for the Treaty Market Levels
select TREATY_REINS_LEVEL_SKEY into #TRL  from dbo.RI_TREATY_REINSURER_LEVEL where TREATY_MKT_LEVEL_SKEY in
(select TREATY_MKT_LEVEL_SKEY from #TML)


select * from #Headers
select * from #Layers
select * from #Markets
select * from #TML
select * from #TRL

--delete from RI_TREATY_REINSURER_LEVEL where TREATY_REINS_LEVEL_SKEY in (select TREATY_REINS_LEVEL_SKEY from #TRL)
--delete from RI_TREATY_MARKET_LEVEL where TREATY_MKT_LEVEL_SKEY in (select TREATY_MKT_LEVEL_SKEY from #TML)
--delete from RI_MARKET_LEVEL where MKT_LEVEL_SKEY in (select MKT_LEVEL_SKEY from #Markets)
--delete from RI_LAYER_LEVEL where LAYER_LEVEL_SKEY in (select LAYER_LEVEL_SKEY from #Layers)
--delete from RI_HEADER_LEVEL where HEADER_LEVEL_SKEY in (select HEADER_LEVEL_SKEY from #Headers)

drop table #TRL
drop table #TML
drop table #Markets
drop table #Layers
drop table #Headers

commit tran


