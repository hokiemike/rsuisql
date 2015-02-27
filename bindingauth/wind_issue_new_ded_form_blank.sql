SELECT  pcpd.EffectiveDate ,
        pcpd.IssuedDate ,
        pcpd.PolicyNumber ,
        pcpd.SUB_RECORD_NUMBER,
        l.INTERNAL_NAME ,
        pcpd.InsuredName, 
        c.NAME ,
        p.LAST_NAME ,
        p.FIRST_NAME
FROM    dbo.PIPCommonPolicyDeclaration AS pcpd 
        JOIN dbo.PEOPLE AS p ON pcpd.CreatedByPeopleSKey = p.PEOPLE_SKEY
        JOIN dbo.LOCATION AS l ON l.LOCATION_SKEY = pcpd.LocationSKey
        JOIN dbo.COMPANY AS c ON l.COMPANY_SKEY = c.COMPANY_SKEY
        JOIN dbo.PIPPolicyForm AS ppf ON pcpd.PIPCommonPolicyDeclarationId = ppf.PIPCommonPolicyDeclarationId
        LEFT OUTER JOIN dbo.PIPEndorsement AS pe ON ppf.PIPCommonPolicyDeclarationId = pe.PIPCommonPolicyDeclarationId
WHERE   1 = 1
        AND pcpd.DepartmentNumber = 10006
        AND pcpd.EffectiveDate <= GETDATE()
        AND pcpd.ExpirationDate >= GETDATE()
        AND ppf.DocId IN ( 16105 ) --old GBA 404011
        AND ppf.PIPFormStatusId = 1
        AND pcpd.StatusCode = 1 --issued
        AND pe.PIPEndorsementID is null
        AND NOT EXISTS ( SELECT 1 --make sure we dont find deductible info at any location
                         FROM   dbo.PIPCommonPolicyDeclaration AS pcpd2
                         JOIN dbo.SUBMISSION s ON pcpd2.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
                         JOIN dbo.QUOTE_BINDER qb ON qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO 
							AND s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
						JOIN dbo.QB_POLICY_LIMITS qbpl ON qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER 
							AND qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
						JOIN dbo.CoveragePart cp ON cp.CoveragePartKey = qbpl.CoveragePartKey
						JOIN dbo.CoveragePartLocationXRef cplxr ON qbpl.QBLIMIT_SKEY = cplxr.QBLIMIT_SKEY
						JOIN dbo.ScheduledLocation sl ON cplxr.ScheduledLocationKey = sl.ScheduledLocationKey
                         WHERE  1=1
                         AND sl.ExpirationDate IS NULL
                         AND qbpl.POLCOV_SKEY = 54 --property
                         AND (ISNULL(sl.WindDeductibleDollar,0)!=0
							OR ISNULL(sl.WindDeductibleDollarMinimum,0)!=0
							OR ISNULL(sl.WindDeductiblePercent,0)!=0
							)
                         AND pcpd2.PIPCommonPolicyDeclarationId =pcpd.PIPCommonPolicyDeclarationId )
ORDER BY pcpd.IssuedDate
