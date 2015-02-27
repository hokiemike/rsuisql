-- Property Code Tables

SELECT * FROM dbo.PROPERTY_COVERAGE_CODES

SELECT * FROM dbo.PropertyCoveragePart

SELECT * FROM dbo.COVERAGE WHERE DEPARTMENT_NUMBER = 200

SELECT * FROM dbo.PerilType

SELECT * FROM peril p

SELECT * FROM dbo.Deductible
SELECT * FROM dbo.DeductibleBasis
SELECT * FROM dbo.DeductibleCategory



SELECT pt.Description, p.Description
FROM PerilTypePeril ptp
JOIN Peril p ON p.perilkey = ptp.perilkey
JOIN dbo.PerilType pt ON pt.periltypekey = ptp.periltypekey

--
-- Deductibles
--

SELECT  qbp.PriorToRewriteFlag
qb.QB_DEDUCTIBLE_COMMENT,
qbd.description, qbd.DeductibleKey, 
dc.Description, dc.DeductibleCategoryKey,
qbdd.BasisAmount, db.Description, db.DeductibleBasisKey, qbdd.BasisAmountIsMoney,
qbdd.Maximum, qbdd.Minimum,
qbdd.SubjectToWait, 
qbdd.WaitPeriod, 
dwp.Description,
qbdd.DeductibleWaitPeriodKey,
qbdd.ExcessOfNFIP, qbdd.ExcessOfStateWindPool,
qbdd.FurtherQualifiers,
qbdd.Underlying, 
qbdd.Ordinal
FROM dbo.Quote_Binder_DeductibleDetail qbdd
LEFT OUTER JOIN dbo.Quote_Binder_Deductible qbd ON qbdd.QuoteBinderDeductibleDetailKey = qbd.QuoteBinderDeductibleDetailKey
JOIN dbo.DeductibleCategory dc ON qbdd.DeductibleCategoryKey = dc.DeductibleCategoryKey
JOIN dbo.DeductibleBasis db ON db.DeductibleBasisKey = qbdd.DeductibleBasisKey
JOIN dbo.DeductibleWaitPeriod dwp ON qbdd.DeductibleWaitPeriodKey = dwp.DeductibleWaitPeriodKey
JOIN dbo.QUOTE_BINDER qb ON qb.SUB_RECORD_NUMBER = qbdd.Sub_Record_Number AND qb.QB_SEQUENCE_NO = qbdd.QB_Sequence_No
JOIN dbo.QUOTE_BINDER_PROPERTY qbp ON qbdd.QB_Sequence_No = qbp.QB_SEQUENCE_NO AND qbdd.Sub_Record_Number = qbp.SUB_RECORD_NUMBER
WHERE 1=1
--AND qbdd.Sub_Record_Number = 1546475
AND qbp.PriorToRewriteFlag = 0
ORDER BY qbdd.Ordinal, qbd.description


SELECT * 
FROM quote_binder_periltypeperil
WHERE sub_record_number = 1546475

--
-- perils
--
SELECT qbptp.Description, qbptp.Exclude, 
qbptp.SubLimit, qbptp.QBPerilAggregateLimitKey, 
p.PerilKey, p.Description AS perildescription,
pt.PerilTypeKey, pt.Description AS periltypedescription,
qbp.PerilComment
FROM dbo.QUOTE_BINDER qb
left outer join quote_binder_periltypeperil qbptp ON qb.QB_SEQUENCE_NO = qbptp.QB_SEQUENCE_NO
										AND qb.SUB_RECORD_NUMBER = qbptp.SUB_RECORD_NUMBER
JOIN dbo.PerilTypePeril ptp ON ptp.PerilTypePerilKey = qbptp.PerilTypePerilKey
JOIN dbo.Peril p ON ptp.PerilKey = p.PerilKey
JOIN dbo.PerilType pt ON pt.PerilTypeKey = ptp.PerilTypeKey
JOIN dbo.QUOTE_BINDER_PROPERTY qbp ON qbptp.QB_Sequence_No = qbp.QB_SEQUENCE_NO AND qbptp.Sub_Record_Number = qbp.SUB_RECORD_NUMBER
WHERE 1=1
AND qbp.PriorToRewriteFlag = 0
AND qb.SUB_RECORD_NUMBER = 1546475


