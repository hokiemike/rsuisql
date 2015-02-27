
--
--  Endorsement gross premium changed (an UPDATE) but no UPDATES done to reinsurance
--

--
--  note on audit_skey 57404436 the gross premium changed from 2172 to 2851
--
select * from AUDIT_LOG 
where TABLE_NAME = 'Endorsement' and table_key like '%222449%'
order by AUDIT_DATE, AUDIT_TIME


--
--  note that the only thing done to the reinsurance was the initial inserts
--
select top 100 * from AUDIT_LOG 
where TABLE_NAME = 'RI_LAYER_LEVEL' and
(  table_key like '%581374%' OR TABLE_KEY like '%581375%')
order by AUDIT_DATE, AUDIT_TIME


--
-- supporting queries
--
select * from RI_HEADER_LEVEL where ENDORSEMENT_SKEY = 222449 --492266
select * from RI_LAYER_LEVEL where HEADER_LEVEL_SKEY = 492266