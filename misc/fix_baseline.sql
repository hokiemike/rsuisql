-- lhkey 25, 26
select * from LossHeader where ClaimKey = 55332

-- ldkey 25,26
select ld.* from LossDetail ld
join LossHeader lh on lh.LossHeaderKey = ld.LossHeaderKey 
where lh.ClaimKey = 55332

-- claimkey 55332
select * from Claims where ClaimNumber = '0003331' 

--pn keys: 245220, 245221
select * from ProofNotice where ClaimKey = 55332

-- suffix key 62357
select * from ClaimSuffix where ClaimKey = 55332

--payment key 98934
select * from Payment where ClaimSuffixKey = 62357
select * from PaymentLayer where PaymentKey = 98934
select * from PaymentMarket where PaymentKey = 98934

--reserve keys 218207, 218208 
select * from Reserve where ClaimSuffixKey = 62357
select * from ReserveLayer where ReserveKey IN (218207,218208)
select * from ReserveMarket where ReserveKey IN (218207,218208)

select * from DiaryEntry where ClaimKey = 55332
select * from ClaimLimit where ClaimKey = 55332

delete from LossDetail where LossHeaderKey in (25,26)
delete from LossHeader where ClaimKey = 55332
delete from ClaimHistory where ClaimKey = 55332

delete from ProofNotice where ClaimKey = 55332
delete from Payment where ClaimSuffixKey = 62357
delete from Reserve where ClaimSuffixKey = 62357
DELETE FROM Narrative WHERE ClaimKey = 55332
DELETE FROM Document WHERE ClaimKey = 55332
DELETE FROM Comment WHERE ClaimKey = 55332
DELETE FROM ProofNoticeComment WHERE ClaimKey = 55332
DELETE FROM CoverageDetail WHERE ClaimKey = 55332
delete from DiaryEntry where ClaimKey = 55332
delete from ClaimLimit where ClaimKey = 55332 
delete from ClaimSuffix where ClaimKey = 55332
delete from Claims where ClaimKey = 55332

 