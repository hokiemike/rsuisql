

select qb.*
from QUOTE_BINDER qb
join Submission s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
join QB_POLICY_LIMITS qbpl on qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO and qb.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
where 1=1
and s.DEPARTMENT_NUMBER = 10006
and qbpl.CoveragePartKey = 4


SELECT  s.SUB_SUBMISSION_NUMBER ,
        s.SUB_RECORD_NUMBER ,
        s.SUB_INSURED_NAME ,
        s.SUB_EFFECTIVE_DATE,
        loc.INTERNAL_NAME ,
        COUNT(sloc.ScheduledLocationKey)AS numlocations
FROM    QUOTE_BINDER qb
        JOIN Submission s ON s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
                             AND s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
        JOIN dbo.QB_POLICY_LIMITS qbpl ON qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
                                          AND qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
        JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = s.LOCATION_SKEY
        JOIN dbo.COMPANY co ON co.COMPANY_SKEY = loc.COMPANY_SKEY
        JOIN dbo.CoveragePart cp ON cp.CoveragePartKey = qbpl.CoveragePartKey
        JOIN dbo.CoveragePartLocationXRef cplx ON cplx.QBLIMIT_SKEY = qbpl.QBLIMIT_SKEY
        JOIN dbo.ScheduledLocation sloc ON sloc.ScheduledLocationKey = cplx.ScheduledLocationKey
WHERE   1 = 1
        AND s.DEPARTMENT_NUMBER = 10006
        AND co.COMPANY_SKEY = 809
        AND cp.CoveragePartKey = 1
GROUP BY s.SUB_SUBMISSION_NUMBER ,
        s.SUB_RECORD_NUMBER ,
        s.SUB_INSURED_NAME ,
        s.SUB_EFFECTIVE_DATE,
        loc.INTERNAL_NAME
HAVING  COUNT(sloc.ScheduledLocationKey) > 1
ORDER BY s.SUB_EFFECTIVE_DATE DESC



SELECT * FROM dbo.CoveragePart


SELECT * FROM Company WHERE NAME LIKE '%bass%'


SELECT * FROM Company WHERE NAME LIKE '%souther%'

SELECT * FROM dbo.LOCATION WHERE INTERNAL_NAME LIKE '%tap%'
-- 2336,2337,2338

SELECT  DISTINCT s.SUB_POLICY_NUMBER, s.SUB_EFFECTIVE_DATE, s.SUB_INSURED_NAME
FROM    QUOTE_BINDER qb
		JOIN dbo.QUOTE_BINDER_BINDING_AUTH qbba ON qb.QB_SEQUENCE_NO = qbba.QB_SEQUENCE_NO AND qb.SUB_RECORD_NUMBER = qbba.SUB_RECORD_NUMBER
        JOIN Submission s ON s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
                             AND s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
        JOIN dbo.QB_POLICY_LIMITS qbpl ON qbpl.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
                                          AND qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
        JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = s.LOCATION_SKEY
        JOIN dbo.GLRatingClass grc ON grc.QBLIMIT_SKEY = qbpl.QBLIMIT_SKEY
WHERE 1=1
AND loc.LOCATION_SKEY IN (2336,2337,2338)
AND grc.ModRate = '1.46'
ORDER BY SUB_EFFECTIVE_DATE