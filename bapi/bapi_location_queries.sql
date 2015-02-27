SELECT pcp.PolicyNumber,  pcp.InsuredName, pcp.EffectiveDate, c.Name, loc.INTERNAL_NAME
 FROM dbo.QUOTE_BINDER_BINDING_AUTH qbba 
JOIN dbo.QUOTE_BINDER qb ON qbba.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
JOIN dbo.SUBMISSION s ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER AND qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
JOIN dbo.QB_POLICY_LIMITS qbpl ON s.QB_SEQUENCE_NO = qbpl.QB_SEQUENCE_NO AND s.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
JOIN dbo.PIPCommonPolicyDeclaration pcp ON s.SUB_RECORD_NUMBER = pcp.SUB_RECORD_NUMBER
JOIN dbo.PIPPropertyDeclaration ppd ON pcp.PIPCommonPolicyDeclarationId = ppd.PIPCommonPolicyDeclarationID
JOIN dbo.PIPGLDeclaration pggl ON ppd.PIPCommonPolicyDeclarationID = pggl.PIPCommonPolicyDeclarationId
JOIN dbo.LOCATION loc ON pcp.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY 
WHERE 1=1
AND s.DEPARTMENT_NUMBER = 10006
AND pcp.IssuedDate IS NOT NULL
AND pcp.ReadOnlyCopy != 1



SELECT * FROM dbo.PIPEndorsementPropertyBuilding AS pepb WHERE OldBuildingNumber IS NOT null

-- 
-- Scheduled Location table (entire history, policies and endorsements) for a given policy 
--
SELECT DISTINCT s.SUB_RECORD_NUMBER, s.SUB_POLICY_NUMBER, c.NAME, loc.INTERNAL_NAME,  
cp.CoveragePartDesc, sl.ScheduledLocationKey, sl.PremisesNumber, sl.BuildingNumber, sl.EffectiveDate, sl.ExpirationDate,
 a.Name, a.AddressLine1, a.City, a.STATE_ABBREVIATION, a.ZipCode
 FROM submission s
JOIN dbo.QUOTE_BINDER qb ON qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO 
      AND s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
JOIN dbo.QB_POLICY_LIMITS qbpl ON qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER 
     AND qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
JOIN dbo.CoveragePart cp ON cp.CoveragePartKey = qbpl.CoveragePartKey
JOIN dbo.CoveragePartLocationXRef cplxr ON qbpl.QBLIMIT_SKEY = cplxr.QBLIMIT_SKEY
JOIN dbo.ScheduledLocation sl ON cplxr.ScheduledLocationKey = sl.ScheduledLocationKey
JOIN dbo.Address a ON sl.AddressKey = a.AddressKey
JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = s.LOCATION_SKEY
JOIN dbo.COMPANY c ON c.COMPANY_SKEY = loc.COMPANY_SKEY
WHERE 1=1
AND s.SUB_POLICY_NUMBER = 178905
AND s.STATUS_CODE = 'I'
AND s.DEPARTMENT_NUMBER = 10006
--AND cp.CoveragePartKey = 1 --property
ORDER BY cp.CoveragePartDesc, sl.EffectiveDate, sl.PremisesNumber, sl.BuildingNumber ASC

--
-- BAPI - Prem/Bldgs for a policy
--
SELECT pcp.PolicyNumber, pcp.InsuredName, pcp.EffectiveDate, c.Name, loc.INTERNAL_NAME,
       ppl.PremisesNumber, a.AddressLine1, a.City, a.STATE_ABBREVIATION, a.ZipCode,
       ppb.BuildingNumber
FROM dbo.PIPCommonPolicyDeclaration pcp 
JOIN dbo.PIPPropertyDeclaration ppd ON pcp.PIPCommonPolicyDeclarationId = ppd.PIPCommonPolicyDeclarationID
JOIN dbo.PIPPropertyLocation AS ppl ON ppd.PIPPropertyDeclarationID = ppl.PIPPropertyDeclarationID
JOIN dbo.PIPPropertyBuilding AS ppb ON ppl.PIPPropertyLocationID = ppb.PIPPropertyLocationId
JOIN dbo.Address AS a ON a.AddressKey = ppl.AddressKey
JOIN dbo.LOCATION loc ON pcp.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY
WHERE 1=1
AND pcp.PolicyNumber = 178905

--
-- BAPI - Prem/Bldgs for an endorsement
--
SELECT pcpd.PolicyNumber, pcpd.InsuredName, c.Name, c.Name, loc.INTERNAL_NAME, pe.EndorsementNumber, pe.EffectiveDate,
       pel.PremisesNumber, pel.ScheduledLocationKey, a.AddressLine1, pepb.BuildingNumber, pepb.OldBuildingNumber, pepb.Construction_Trans_Code, pepb.OccupancyCodeKey
FROM dbo.PIPEndorsement AS pe
JOIN dbo.PIPEndorsementPropertyLocation AS pel ON pe.PIPEndorsementID = pel.PIPEndorsementID
JOIN dbo.PIPCommonPolicyDeclaration AS pcpd ON pe.PIPCommonPolicyDeclarationId = pcpd.PIPCommonPolicyDeclarationId
JOIN dbo.PIPEndorsementPropertyBuilding AS pepb ON pel.PIPEndorsementPropertyLocationID = pepb.PIPEndorsementPropertyLocationID
JOIN dbo.Address AS a ON a.AddressKey = pel.AddressKey
JOIN dbo.LOCATION loc ON pcpd.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY
WHERE 1=1
AND pcpd.PolicyNumber = 178905
ORDER BY pcpd.PolicyNumber, pe.EndorsementNumber, pel.PremisesNumber, pepb.BuildingNumber


--
-- Property Only Policies
-- 
SELECT DISTINCT pcp.PolicyNumber,  s.SUB_RECORD_NUMBER, pcp.InsuredName, pcp.EffectiveDate, c.Name, loc.INTERNAL_NAME
 FROM dbo.QUOTE_BINDER_BINDING_AUTH qbba 
JOIN dbo.QUOTE_BINDER qb ON qbba.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
JOIN dbo.SUBMISSION s ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER AND qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
JOIN dbo.QB_POLICY_LIMITS qbpl ON s.QB_SEQUENCE_NO = qbpl.QB_SEQUENCE_NO AND s.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
JOIN dbo.PIPCommonPolicyDeclaration pcp ON s.SUB_RECORD_NUMBER = pcp.SUB_RECORD_NUMBER
JOIN dbo.PIPPropertyDeclaration ppd ON pcp.PIPCommonPolicyDeclarationId = ppd.PIPCommonPolicyDeclarationID
JOIN dbo.LOCATION loc ON pcp.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY 
WHERE 1=1
AND s.DEPARTMENT_NUMBER = 10006
AND pcp.IssuedDate IS NOT NULL
AND pcp.ReadOnlyCopy != 1
and qbpl.POLCOV_SKEY = 54
AND NOT EXISTS (SELECT 1 FROM QB_POLICY_LIMITS qbpl2 WHERE qbpl2.POLCOV_SKEY != 54 
AND qbpl2.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER 
AND qbpl2.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO)


--
-- BAPI location queries
--

SELECT pcp.PolicyNumber, pcp.InsuredName, pcp.EffectiveDate, c.Name, loc.INTERNAL_NAME,
       ppl.PremisesNumber, a.AddressLine1, a.City, a.STATE_ABBREVIATION, a.ZipCode,
       ppb.BuildingNumber
FROM dbo.PIPCommonPolicyDeclaration pcp 
JOIN dbo.PIPPropertyDeclaration ppd ON pcp.PIPCommonPolicyDeclarationId = ppd.PIPCommonPolicyDeclarationID
JOIN dbo.PIPPropertyLocation AS ppl ON ppd.PIPPropertyDeclarationID = ppl.PIPPropertyDeclarationID
JOIN dbo.PIPPropertyBuilding AS ppb ON ppl.PIPPropertyLocationID = ppb.PIPPropertyLocationId
JOIN dbo.Address AS a ON a.AddressKey = ppl.AddressKey
JOIN dbo.LOCATION loc ON pcp.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY
JOIN 
(
SELECT pcp2.PIPCommonPolicyDeclarationId AS decid, ppl2.PIPPropertyLocationID AS premid, COUNT(ppb2.PIPPropertyBuildingId) AS bldgcnt
FROM dbo.PIPCommonPolicyDeclaration pcp2 
JOIN dbo.PIPPropertyDeclaration ppd2 ON pcp2.PIPCommonPolicyDeclarationId = ppd2.PIPCommonPolicyDeclarationID
JOIN dbo.PIPPropertyLocation AS ppl2 ON ppd2.PIPPropertyDeclarationID = ppl2.PIPPropertyDeclarationID
JOIN dbo.PIPPropertyBuilding AS ppb2 ON ppl2.PIPPropertyLocationID = ppb2.PIPPropertyLocationId
GROUP BY pcp2.PIPCommonPolicyDeclarationId, ppl2.PIPPropertyLocationID
HAVING COUNT(ppb2.PIPPropertyBuildingId) > 2
) multiplebldgs ON multiplebldgs.decid = pcp.PIPCommonPolicyDeclarationId
WHERE 1=1
ORDER BY pcp.EffectiveDate DESC, pcp.PolicyNumber, ppl.PremisesNumber, ppb.BuildingNumber



SELECT pcp2.PIPCommonPolicyDeclarationId, ppl2.PIPPropertyLocationID, COUNT(ppb2.PIPPropertyBuildingId)
FROM dbo.PIPCommonPolicyDeclaration pcp2 
JOIN dbo.PIPPropertyDeclaration ppd2 ON pcp2.PIPCommonPolicyDeclarationId = ppd2.PIPCommonPolicyDeclarationID
JOIN dbo.PIPPropertyLocation AS ppl2 ON ppd2.PIPPropertyDeclarationID = ppl2.PIPPropertyDeclarationID
JOIN dbo.PIPPropertyBuilding AS ppb2 ON ppl2.PIPPropertyLocationID = ppb2.PIPPropertyLocationId
GROUP BY pcp2.PIPCommonPolicyDeclarationId, ppl2.PIPPropertyLocationID
HAVING COUNT(ppb2.PIPPropertyBuildingId) > 2