--policies
SELECT  DISTINCT pcpd.PIPCommonPolicyDeclarationId ,
        pcpd.PolicyNumber ,
        pcpd.EffectiveDate,
        l.INTERNAL_NAME ,
        p.LAST_NAME,
        p.FIRST_NAME
        
FROM    dbo.PIPCommonPolicyDeclaration AS pcpd
        JOIN dbo.PEOPLE AS p ON pcpd.CreatedByPeopleSKey = p.PEOPLE_SKEY
        JOIN dbo.LOCATION AS l ON l.LOCATION_SKEY = pcpd.LocationSKey
       JOIN dbo.PIPPropertyDeclaration AS ppd ON pcpd.PIPCommonPolicyDeclarationId = ppd.PIPCommonPolicyDeclarationID
        JOIN dbo.PIPPropertyLocation AS ppl ON ppd.PIPPropertyDeclarationID = ppl.PIPPropertyDeclarationID
        JOIN dbo.PIPPropertyBuilding AS ppb ON ppl.PIPPropertyLocationID = ppb.PIPPropertyLocationId
        
WHERE   1 = 1
        AND pcpd.EffectiveDate >= '5/1/2011'
        AND NOT EXISTS (SELECT 1
                        FROM dbo.PIPPropertyCoverage AS ppc 
                        WHERE ppc.PIPPropertyBuildingId = ppb.PIPPropertyBuildingId
                        AND ISNULL(ppc.CauseOfLossCodeKey,-1) NOT IN (7,8))
        
        AND NOT EXISTS ( SELECT 1 --make sure we dont find excluded wind at any location
                         FROM   dbo.PIPCommonPolicyDeclaration AS pcpd2
                                JOIN dbo.SUBMISSION s ON pcpd2.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
                                JOIN dbo.QUOTE_BINDER qb ON qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
                                                      AND s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
                                JOIN dbo.QB_POLICY_LIMITS qbpl ON qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
                                                      AND qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
                                JOIN dbo.CoveragePart cp ON cp.CoveragePartKey = qbpl.CoveragePartKey
                                JOIN dbo.CoveragePartLocationXRef cplxr ON qbpl.QBLIMIT_SKEY = cplxr.QBLIMIT_SKEY
                                JOIN dbo.ScheduledLocation sl ON cplxr.ScheduledLocationKey = sl.ScheduledLocationKey
                         WHERE  1 = 1
                                AND sl.ExpirationDate IS NULL
                                AND qbpl.POLCOV_SKEY = 54 --property
                                AND ISNULL(sl.ExcludeWind, 0) = 1
                                AND pcpd2.PIPCommonPolicyDeclarationId = pcpd.PIPCommonPolicyDeclarationId )
        AND pcpd.ReadOnlyCopy = 0
ORDER BY 
pcpd.EffectiveDate,l.INTERNAL_NAME ,
       pcpd.PolicyNumber
go
