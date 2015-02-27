

SELECT COUNT(DISTINCT(s.SUB_RECORD_NUMBER))
FROM dbo.SUBMISSION s
JOIN dbo.QUOTE_BINDER qb ON s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER AND s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
JOIN dbo.QB_POLICY_LIMITS qbpl ON qb.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER AND qb.QB_SEQUENCE_NO = qbpl.QB_SEQUENCE_NO
JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = s.LOCATION_SKEY
JOIN dbo.COMPANY c ON c.COMPANY_SKEY = loc.COMPANY_SKEY
LEFT OUTER JOIN PGInput pgi ON RIGHT('000000' + CONVERT(VARCHAR, s.sub_policy_Number), 6) = pgi.PolicyNumber 
WHERE 1=1
AND s.SUB_CURRENT_EFFECTIVE_DATE <= '1/7/10' 
AND s.SUB_CURRENT_EXPIRATION_DATE > '1/7/10'
AND s.DEPARTMENT_NUMBER = 10006
AND s.STATUS_CODE = 'I'
AND qbpl.CoveragePartKey = 2 --GL
AND NOT EXISTS (SELECT 1 FROM dbo.PGInputForm pgif 
WHERE pgif.PGInputKey = pgi.PGInputKey 
 AND (pgif.Name LIKE 'G106059' OR pgif.Name LIKE 'G106060'))
 
 
SELECT DISTINCT
        s.SUB_POLICY_NUMBER ,
        pgi.PGInputKey ,
        c.NAME,
        loc.INTERNAL_NAME ,
        s.SUB_CURRENT_EFFECTIVE_DATE ,
        s.SUB_CURRENT_EXPIRATION_DATE ,
        s.SUB_INSURED_NAME 
FROM    dbo.SUBMISSION s
        JOIN dbo.QUOTE_BINDER qb ON s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
                                    AND s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
        JOIN dbo.QB_POLICY_LIMITS qbpl ON qb.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
                                          AND qb.QB_SEQUENCE_NO = qbpl.QB_SEQUENCE_NO
        JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = s.LOCATION_SKEY
        JOIN dbo.COMPANY c ON c.COMPANY_SKEY = loc.COMPANY_SKEY
        JOIN PGInput pgi ON RIGHT('000000'+ CONVERT(VARCHAR, s.sub_policy_Number),6) = pgi.PolicyNumber
        JOIN dbo.PGTransaction pgt ON pgi.PGInputKey = pgt.PGInputKey
WHERE   1 = 1
        AND s.SUB_CURRENT_EFFECTIVE_DATE <= '1/7/10'
        AND s.SUB_CURRENT_EXPIRATION_DATE > '1/7/10'
        AND s.DEPARTMENT_NUMBER = 10006
        AND s.STATUS_CODE = 'I'
        AND qbpl.CoveragePartKey = 2 --GL
        AND PGInputTypeKey = 1 --just new policies
        AND NOT EXISTS ( SELECT 1
                         FROM   dbo.PGInputForm pgif
                         WHERE  pgif.PGInputKey = pgi.PGInputKey
                                AND ( pgif.Name LIKE 'G106059'
                                      OR pgif.Name LIKE 'G106060'
                                    ) )
        AND pgt.PGTransactionTypeKey = 2 -- only want the successful transactions
ORDER BY c.NAME, loc.INTERNAL_NAME, s.SUB_CURRENT_EFFECTIVE_DATE

                                    
                                 
 
 
SELECT * FROM dbo.PGInputForm WHERE PGInputKey = 96055
 
 SELECT * FROM PGInput WHERE PGInputKey = 105298
 
 SELECT * FROM dbo.PGInputType
 SELECT * FROM dbo.CoveragePart

SELECT TOP 100 * FROM dbo.PGInput pgi
   JOIN dbo.PGInputForm pgif ON pgi.PGInputKey = pgif.PGInputKey 
   
SELECT PolicyNumber
FROM PGInput


SELECT TOP 100 * 
FROM dbo.PGInputForm
WHERE Name LIKE 'g106%'