

SELECT loc.INTERNAL_NAME, pcp.PolicyNumber, 
 FROM dbo.QUOTE_BINDER_BINDING_AUTH qbba 
JOIN dbo.QUOTE_BINDER qb ON qbba.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
JOIN dbo.SUBMISSION s ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER AND qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
JOIN dbo.QB_POLICY_LIMITS qbpl ON s.QB_SEQUENCE_NO = qbpl.QB_SEQUENCE_NO AND s.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
JOIN dbo.PIPCommonPolicyDeclaration pcp ON s.SUB_RECORD_NUMBER = pcp.SUB_RECORD_NUMBER
JOIN dbo.PIPPropertyDeclaration ppd ON pcp.PIPCommonPolicyDeclarationId = ppd.PIPCommonPolicyDeclarationID
JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = pcp.LocationSKey
WHERE 1=1
AND s.DEPARTMENT_NUMBER = 10006

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
AND c.COMPANY_SKEY = 809
ORDER BY pcp.EffectiveDate DESC, pcp.PolicyNumber, ppl.PremisesNumber, ppb.BuildingNumber


--
-- look at policies with multpile property locations
--
SELECT DISTINCT pcp.PolicyNumber, pcp.InsuredName, pcp.EffectiveDate, c.Name, loc.INTERNAL_NAME, premcount       
FROM dbo.PIPCommonPolicyDeclaration pcp 
JOIN dbo.PIPPropertyDeclaration ppd ON pcp.PIPCommonPolicyDeclarationId = ppd.PIPCommonPolicyDeclarationID
JOIN dbo.PIPPropertyLocation AS ppl ON ppd.PIPPropertyDeclarationID = ppl.PIPPropertyDeclarationID
JOIN dbo.PIPPropertyBuilding AS ppb ON ppl.PIPPropertyLocationID = ppb.PIPPropertyLocationId
JOIN dbo.Address AS a ON a.AddressKey = ppl.AddressKey
JOIN dbo.LOCATION loc ON pcp.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY
JOIN 
(
SELECT pcp2.PIPCommonPolicyDeclarationId AS decid, ppd2.PIPPropertyDeclarationID AS propdecid, COUNT(DISTINCT ppb2.PIPPropertyLocationId) AS premcount
FROM dbo.PIPCommonPolicyDeclaration pcp2 
JOIN dbo.PIPPropertyDeclaration ppd2 ON pcp2.PIPCommonPolicyDeclarationId = ppd2.PIPCommonPolicyDeclarationID
JOIN dbo.PIPPropertyLocation AS ppl2 ON ppd2.PIPPropertyDeclarationID = ppl2.PIPPropertyDeclarationID
JOIN dbo.PIPPropertyBuilding AS ppb2 ON ppl2.PIPPropertyLocationID = ppb2.PIPPropertyLocationId
GROUP BY pcp2.PIPCommonPolicyDeclarationId, ppd2.PIPPropertyDeclarationID
HAVING COUNT( DISTINCT ppb2.PIPPropertyLocationId) > 2
) multipleprems ON multipleprems.decid = pcp.PIPCommonPolicyDeclarationId
WHERE 1=1
ORDER BY pcp.EffectiveDate DESC, pcp.PolicyNumber

--
-- Get location schedule for property coverage
--
SELECT DISTINCT sl.ScheduledLocationKey, s.SUB_RECORD_NUMBER, s.SUB_POLICY_NUMBER, c.NAME, loc.INTERNAL_NAME,  
cp.CoveragePartDesc, sl.PremisesNumber, sl.BuildingNumber, sl.EffectiveDate, sl.ExpirationDate,
 a.Name, a.AddressLine1, a.City, a.STATE_ABBREVIATION, a.ZipCode
 FROM submission s
JOIN dbo.QUOTE_BINDER qb ON qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO 
      AND s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
JOIN dbo.QB_POLICY_LIMITS qbpl ON qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER 
     AND qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
JOIN dbo.CoveragePart cp ON cp.CoveragePartKey = qbpl.CoveragePartKey
JOIN dbo.CoveragePartLocationXRef cplxr ON qbpl.QBLIMIT_SKEY = cplxr.QBLIMIT_SKEY
JOIN dbo.ScheduledLocation sl ON cplxr.ScheduledLocationKey = sl.ScheduledLocationKey
JOIN dbo.LocationCoverageDetail lcd ON sl.ScheduledLocationKey = lcd.ScheduledLocationKey
JOIN dbo.Address a ON sl.AddressKey = a.AddressKey
JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = s.LOCATION_SKEY
JOIN dbo.COMPANY c ON c.COMPANY_SKEY = loc.COMPANY_SKEY
JOIN dbo.BuildingCoverageCode bcc ON bcc.BuildingCoverageCodeKey = lcd.BuildingCoverageCodeKey
WHERE 1=1
AND s.SUB_POLICY_NUMBER = 288720
AND s.STATUS_CODE = 'I'
AND s.DEPARTMENT_NUMBER = 10006
AND cp.CoveragePartKey = 1 --property
ORDER BY sl.ExpirationDate,  sl.PremisesNumber, sl.BuildingNumber ASC








SELECT DISTINCT 
s.SUB_RECORD_NUMBER
, s.SUB_POLICY_NUMBER
, s.SUB_EFFECTIVE_DATE
, sl.PremisesNumber
, sl.BuildingNumber
, a.AddressLine1
, sl.EffectiveDate
, sl.ExpirationDate
, bcc.BuildingCoverageCodeDesc
, lcd.LocationCoverageDetailKey
, lcd.Premium
FROM dbo.ScheduledLocation AS sl 
JOIN dbo.CoveragePartLocationXRef AS cplxr ON sl.ScheduledLocationKey = cplxr.ScheduledLocationKey 
JOIN dbo.QB_POLICY_LIMITS AS qpl ON cplxr.QBLIMIT_SKEY = qpl.QBLIMIT_SKEY 
JOIN dbo.SUBMISSION AS s ON qpl.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO AND qpl.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER 
JOIN dbo.Address AS a ON sl.AddressKey = a.AddressKey
JOIN dbo.LocationCoverageDetail AS lcd ON lcd.ScheduledLocationKey = sl.ScheduledLocationKey
JOIN dbo.BuildingCoverageCode bcc ON lcd.BuildingCoverageCodeKey = bcc.BuildingCoverageCodeKey
WHERE DEPARTMENT_NUMBER = 10006 
AND s.SUB_POLICY_NUMBER = 288720
--AND qpl.POLCOV_SKEY = 53
ORDER BY PremisesNumber, BuildingNumber, LocationCoverageDetailKey
                                                                       
SELECT * FROM dbo.COVERAGE	

SELECT * FROM dbo.POLICY_COVERAGE																  
																	 
SELECT * FROM dbo.POLICY_COVERAGE_CODES	


SELECT * FROM dbo.QB_POLICY_LIMITS WHERE SUB_RECORD_NUMBER = 2585068																 

--1784165

SELECT DISTINCT sl.* 
FROM dbo.CoveragePartLocationXRef cxr
JOIN dbo.ScheduledLocation sl ON sl.ScheduledLocationKey = cxr.ScheduledLocationKey
WHERE QBLIMIT_SKEY = 1784165
ORDER BY PremisesNumber, BuildingNumber


																	  
