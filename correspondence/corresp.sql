select * from message_recipient where message_skey = 4329967

select m.* from MESSAGE m
join MESSAGE_RECIPIENT mr on mr.MESSAGE_SKEY = m.MESSAGE_SKEY
where 1=1
--and STATUS_TYPE
and SENT_DATE > '7/7/09'

select distinct m.MESSAGE_SKEY, mr.EMAIL_ADDRESS, m.CREATE_DATE from MESSAGE m
join MESSAGE_RECIPIENT mr on mr.MESSAGE_SKEY = m.MESSAGE_SKEY
where 1=1
--and STATUS_TYPE
and SENT_DATE > '7/7/09'
and m.STATUS_TYPE = 129 --Error

select distinct m.MESSAGE_SKEY, mr.EMAIL_ADDRESS from MESSAGE m
join MESSAGE_RECIPIENT mr on mr.MESSAGE_SKEY = m.MESSAGE_SKEY
where 1=1
--and STATUS_TYPE
and SENT_DATE > '7/7/09'
and m.STATUS_TYPE = 128 --Sent

select * from REFERENCE_TYPE where CATEGORY_SKEY = 20
select * from REFERENCE_CATEGORY