--policy qbpl
SELECT pcpd.InsuredName, pcpd.PolicyNumber, s.SUB_RECORD_NUMBER,
 qpl.POLCOV_SKEY, pcc.COVERAGE_DESCRIPTION, qpl.CoveragePremium, qpl.TERRORISM_PREMIUM, qpl.OtherCharges,
 qbba.OtherCharges, qbba.EarthquakeIncluded, qbba.FastQuote, qbba.MinimumPremium, qbba.WindExcluded,
 qpl.AGGR_LIMIT, qpl.OCCUR_LIMIT, qpl.PrCoLimit, qpl.Deductible, qpl.PersAdvInjuryLimit, qpl.OtherCoverages, 
 qpl.PropDamageDeductibleClaim, qpl.PropDamageDeductibleOccur
 FROM dbo.PIPCommonPolicyDeclaration AS pcpd 
JOIN dbo.SUBMISSION AS s ON s.SUB_RECORD_NUMBER = pcpd.SUB_RECORD_NUMBER
JOIN dbo.QUOTE_BINDER AS qb ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
JOIN dbo.QUOTE_BINDER_BINDING_AUTH AS qbba ON qbba.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
JOIN dbo.QB_POLICY_LIMITS AS qpl ON (qpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER AND qpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO)
JOIN dbo.POLICY_COVERAGE AS pc ON pc.POLCOV_SKEY = qpl.POLCOV_SKEY
JOIN dbo.POLICY_COVERAGE_CODES AS pcc ON pcc.COVERAGE_SKEY = pc.COVERAGE_SKEY
WHERE PIPCommonPolicyDeclarationId = 164675


--endorsements qbpl
SELECT pcpd.InsuredName, pcpd.PolicyNumber, s.SUB_RECORD_NUMBER,
 qpl.POLCOV_SKEY, pcc.COVERAGE_DESCRIPTION, qpl.CoveragePremium, qpl.TERRORISM_PREMIUM, qpl.OtherCharges,
 qbba.OtherCharges, qbba.EarthquakeIncluded, qbba.FastQuote, qbba.MinimumPremium, qbba.WindExcluded,
 qpl.AGGR_LIMIT, qpl.OCCUR_LIMIT, qpl.PrCoLimit, qpl.Deductible, qpl.PersAdvInjuryLimit, qpl.OtherCoverages, 
 qpl.PropDamageDeductibleClaim, qpl.PropDamageDeductibleOccur
 FROM dbo.PIPCommonPolicyDeclaration AS pcpd 
 JOIN dbo.PIPEndorsement AS pe ON pe.PIPCommonPolicyDeclarationId = pcpd.PIPCommonPolicyDeclarationId
JOIN dbo.SUBMISSION AS s ON s.SUB_RECORD_NUMBER = pcpd.SUB_RECORD_NUMBER
JOIN dbo.ENDORSEMENT AS e on e.ENDORSEMENT_SKEY = pe.ENDORSEMENT_SKEY
JOIN dbo.QUOTE_BINDER AS qb ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
JOIN dbo.QUOTE_BINDER_BINDING_AUTH AS qbba ON qbba.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
JOIN dbo.QB_POLICY_LIMITS AS qpl ON (qpl.ENDORSEMENT_SKEY = e.ENDORSEMENT_SKEY)
JOIN dbo.POLICY_COVERAGE AS pc ON pc.POLCOV_SKEY = qpl.POLCOV_SKEY
JOIN dbo.POLICY_COVERAGE_CODES AS pcc ON pcc.COVERAGE_SKEY = pc.COVERAGE_SKEY
WHERE pe.PIPCommonPolicyDeclarationId = 164675



SELECT pcpd.InsuredName, pcpd.PolicyNumber, s.SUB_RECORD_NUMBER,
 qpl.POLCOV_SKEY, pcc.COVERAGE_DESCRIPTION, qpl.CoveragePremium,
  sl.PremisesNumber, sl.BuildingNumber, a.AddressLine1, a.STATE_ABBREVIATION, sl.EffectiveDate, sl.ExpirationDate, sl.ExcludeWind,
  bcc.BuildingCoverageCodeDesc, colc.CauseOfLossCodeDesc
 FROM dbo.PIPCommonPolicyDeclaration AS pcpd 
JOIN dbo.SUBMISSION AS s ON s.SUB_RECORD_NUMBER = pcpd.SUB_RECORD_NUMBER
JOIN dbo.QUOTE_BINDER AS qb ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
JOIN dbo.QUOTE_BINDER_BINDING_AUTH AS qbba ON qbba.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
JOIN dbo.QB_POLICY_LIMITS AS qpl ON (qpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER AND qpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO)
JOIN dbo.POLICY_COVERAGE AS pc ON pc.POLCOV_SKEY = qpl.POLCOV_SKEY
JOIN dbo.POLICY_COVERAGE_CODES AS pcc ON pcc.COVERAGE_SKEY = pc.COVERAGE_SKEY
JOIN dbo.CoveragePartLocationXRef AS cplxr ON cplxr.QBLIMIT_SKEY = qpl.QBLIMIT_SKEY
JOIN dbo.ScheduledLocation AS sl ON sl.ScheduledLocationKey = cplxr.ScheduledLocationKey
JOIN dbo.Address AS a ON a.AddressKey = sl.AddressKey
LEFT OUTER JOIN dbo.LocationCoverageDetail AS lcd ON lcd.ScheduledLocationKey = sl.ScheduledLocationKey
LEFT OUTER JOIN dbo.BuildingCoverageCode AS bcc on bcc.BuildingCoverageCodeKey = lcd.BuildingCoverageCodeKey
LEFT OUTER JOIN dbo.CauseOfLossCode AS colc on colc.CauseOfLossCodeKey = lcd.CauseOfLossCodeKey
WHERE PIPCommonPolicyDeclarationId = 164554
ORDER BY sl.PremisesNumber, sl.BuildingNumber

--gresham
--164648

--2590852

SELECT * FROM dbo.QUOTE_BINDER AS qb WHERE SUB_RECORD_NUMBER = 2595214
--SELECT * FROM dbo.QUOTE_BINDER_PROPERTY AS qbp WHERE SUB_RECORD_NUMBER = 2590852
--SELECT * FROM dbo.QUOTE_BINDER_SIR AS qbp WHERE SUB_RECORD_NUMBER = 2590852
SELECT * FROM dbo.QUOTE_BINDER_BINDING_AUTH AS qbba  WHERE SUB_RECORD_NUMBER = 2595214
SELECT * FROM dbo.QB_POLICY_LIMITS AS qpl WHERE qpl.SUB_RECORD_NUMBER = 2595214
SELECT * FROM dbo.CoveragePartLocationXRef AS cplxr WHERE QBLIMIT_SKEY IN (1794229,1794230) 

SELECT * FROM dbo.ScheduledLocation AS sl 
JOIN dbo.CoveragePartLocationXRef AS cplxr on cplxr.ScheduledLocationKey = sl.ScheduledLocationKey
JOIN dbo.QB_POLICY_LIMITS AS qpl ON qpl.QBLIMIT_SKEY = cplxr.QBLIMIT_SKEY
JOIN dbo.SUBMISSION AS s on s.SUB_RECORD_NUMBER = qpl.SUB_RECORD_NUMBER
WHERE s.SUB_RECORD_NUMBER = 2595214

SELECT * FROM dbo.RuleBasedDocSubType AS rbdst
WHERE NOT EXISTS (SELECT 1 FROM dbo.RuleBasedDocSubTypeXref AS rbdstx WHERE rbdstx.SubTypeId = rbdst.SubTypeId)

SELECT * FROM dbo.RuleBasedDocSubType AS rbdst WHERE Department_Number = 1900

SELECT * FROM dbo.RuleBasedDocSubTypeXref AS rbdstx WHERE rbdstx.SubTypeId = 4035




SELECT * FROM dbo.INLAND_MARINE_CLASS AS imc WHERE IsCoverage=1