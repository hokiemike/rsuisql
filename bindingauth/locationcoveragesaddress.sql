select * from Address where AddressKey = 566825

select * from QB_POLICY_LIMITS where SUB_RECORD_NUMBER = 1340604

select * from CoveragePartLocationXRef where QBLIMIT_SKEY IN ( 859290,859291)

select * from ScheduledLocation where ScheduledLocationKey IN (49352,49353,49354)

select * from Address where AddressKey IN (566826,566827)

update address set addressline1 = '304 Main' where AddressKey IN (566826,566827)