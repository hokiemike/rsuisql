


SELECT TOP 10000 * FROM dbo.BAPIRequestLog AS brl
ORDER BY LogDate DESC

/* AVG Response TIme last 15 minutes */
SELECT AVG(ResponseTime), COUNT(Id) 
FROM dbo.BAPIRequestLog AS brl
WHERE 1=1
AND DATEDIFF(MINUTE,LogDate,GETDATE()) < 15

/* Requests longer than xxx seconds BY DATE */
SELECT *, CAST(t.LongRequests AS NUMERIC)/CAST(t.TotalRequests AS NUMERIC) * 100 AS Pct
FROM(
SELECT CAST(brl.LogDate AS DATE) AS TheDate,
        DATENAME(dw, brl.LogDate) AS TheDateName,
        COUNT(brl.Id) AS TotalRequests,
        SUM(
			CASE
				WHEN brl.ResponseTime > 14000 THEN 1
				ELSE 0
			END
        ) AS LongRequests
FROM dbo.BAPIRequestLog AS brl
WHERE 1=1
--AND brl.ResponseTime > 12000
--AND Path = '~/Policy/Save'
GROUP BY CAST(brl.LogDate AS DATE) ,
        DATENAME(dw, brl.LogDate)
) t
ORDER BY t.TheDate DESC


/* Requests longer than 12 seconds BY DATE */
SELECT *, CAST(t.LongRequests AS NUMERIC)/CAST(t.TotalRequests AS NUMERIC) * 100 AS Pct
FROM(
SELECT CAST(brl.LogDate AS DATE) AS TheDate,
		brl.PATH AS ThePath,
        DATENAME(dw, brl.LogDate) AS TheDateName,
        COUNT(brl.Id) AS TotalRequests,
        SUM(
			CASE
				WHEN brl.ResponseTime > 12000 THEN 1
				ELSE 0
			END
        ) AS LongRequests
FROM dbo.BAPIRequestLog AS brl
WHERE 1=1
--AND brl.ResponseTime > 12000
--AND Path = '~/Policy/Save'
GROUP BY CAST(brl.LogDate AS DATE) ,brl.PATH,
        DATENAME(dw, brl.LogDate)
HAVING SUM(
			CASE
				WHEN brl.ResponseTime > 12000 THEN 1
				ELSE 0
			END
        )  > 5
) t
ORDER BY t.TheDate DESC





/* BAPI Requests longer than 7 seconds */
SELECT TOP 10000 * FROM dbo.BAPIRequestLog AS brl
WHERE 1=1
AND brl.ResponseTime > 12000
ORDER BY LogDate DESC

/* BAPI Requests longer than 30 seconds */
SELECT TOP 10000 * FROM dbo.BAPIRequestLog AS brl
WHERE 1=1
AND brl.ResponseTime > 20000
ORDER BY LogDate DESC

SELECT *
FROM dbo.BAPIRequestLog AS brl
WHERE IdentityName = 'rsuiex\RLugo1'
ORDER BY LogDate DESC

SELECT l.INTERNAL_NAME, * from dbo.PEOPLE AS p
JOIN dbo.PEOPLE_LOCATION_XREF AS plx ON plx.PEOPLE_SKEY = p.PEOPLE_SKEY
JOIN dbo.LOCATION_XREF AS lx ON lx.LOCATION_XREF_SKEY = plx.LOCATION_XREF_SKEY
JOIN dbo.LOCATION AS l ON l.LOCATION_SKEY = lx.LOCATION_SKEY
WHERE 1=1
AND p.EXTERNAL_LOGIN = 'rsuiex\RLugo1'

SELECT DISTINCT IdentityName AS person, COUNT(Id) AS numreqs
FROM dbo.BAPIRequestLog AS brl
WHERE LogDate > '2/28/14'
GROUP BY IdentityName


SELECT CAST(LogDate AS DATE) AS accessdate, COUNT(DISTINCT IdentityName) AS numusers
FROM dbo.BAPIRequestLog AS brl
WHERE 1=1
GROUP BY CAST(LogDate AS DATE)
ORDER BY accessdate desc

/* ALL SAVE REQUESTS - AVG, MIN, MAX */
SELECT  CAST(LogDate AS DATE) AS TheDate ,
        DATENAME(dw, LogDate) ,
        COUNT(Id) AS NumOfRequests ,
        AVG(ResponseTime) AS AvgResponseTime ,
        MIN(ResponseTime) AS MinResponseTime ,
        MAX(ResponseTime) AS MaxResponseTime
FROM    dbo.BAPIRequestLog AS brl
WHERE   1 = 1
        AND Path = '~/Policy/Save'
        --AND brl.ResponseTime > 7000
GROUP BY CAST(LogDate AS DATE) ,
        DATENAME(dw, LogDate)
ORDER BY TheDate DESC

/* SEARCH REQUESTS - AVG, MIN, MAX */
SELECT  CAST(LogDate AS DATE) AS TheDate ,
        DATENAME(dw, LogDate) ,
        COUNT(Id) AS NumRequests ,
        AVG(ResponseTime) AS AvgResponseTime ,
        MIN(ResponseTime) AS MinResponseTime ,
        MAX(ResponseTime) AS MaxResponseTime
FROM    dbo.BAPIRequestLog AS brl
WHERE   1 = 1
        AND Path = '~/Search/Results'
GROUP BY CAST(LogDate AS DATE) ,
        DATENAME(dw, LogDate)
ORDER BY TheDate DESC

/* SAVE REQUESTS - AVG, MIN, MAX */
SELECT  CAST(LogDate AS DATE) AS TheDate ,
        DATENAME(dw, LogDate) ,
        COUNT(Id) AS NumRequests ,
        AVG(ResponseTime) AS AvgResponseTime ,
        MIN(ResponseTime) AS MinResponseTime ,
        MAX(ResponseTime) AS MaxResponseTime
FROM    dbo.BAPIRequestLog AS brl
WHERE   1 = 1
        AND Path = '~/Policy/Save'
GROUP BY CAST(LogDate AS DATE) ,
        DATENAME(dw, LogDate)
ORDER BY TheDate DESC


/* Requests taking longer than 12 seconds */
SELECT  brl.LogDate,
        DATENAME(dw, LogDate) ,
        ResponseTime,
        *
FROM    dbo.BAPIRequestLog AS brl
WHERE   1 = 1
        --AND Path = '~/Policy/Save'
        AND ResponseTime > 12000
ORDER BY brl.LogDate DESC

/* Issuance queue times longer than 90 seconds */
SELECT DATEDIFF(second,CreateDate,SentDate) AS completetime, 
DATEDIFF(second,CreateDate,iq.InProcessDate) AS waittime,
iq.CreateDate,
pc.NAME AS policyco, ploc.INTERNAL_NAME AS policyloc, 
epcd.CreatedDate,
pcd.PolicyNumber, 
epc.NAME AS endorsement_company,
eloc.INTERNAL_NAME AS endorsement_location,
epcd.PolicyNumber AS endorsement_policy,
pe.EndorsementNumber
 FROM dbo.IssuanceQueue iq
 LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration pcd ON iq.BAPolicyId = pcd.PIPCommonPolicyDeclarationId
 LEFT OUTER JOIN dbo.PIPEndorsement pe ON iq.BAEndorsementId = pe.PIPEndorsementID
 LEFT OUTER JOIN dbo.LOCATION ploc ON pcd.LocationSKey = ploc.LOCATION_SKEY
LEFT OUTER JOIN COMPANY pc ON pc.COMPANY_SKEY = ploc.COMPANY_SKEY
LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration epcd ON pe.PIPCommonPolicyDeclarationId = epcd.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.LOCATION eloc ON epcd.LocationSKey = eloc.LOCATION_SKEY
LEFT OUTER JOIN COMPANY epc ON epc.COMPANY_SKEY = eloc.COMPANY_SKEY
 WHERE 1=1
 AND CreateDate > '11/1/2013' 
 AND department_number = 10006
 AND ApplicationID = 5 
 AND DATEDIFF(second,CreateDate,SentDate) > 90
 ORDER BY  CreateDate DESC
 
 /* Issuance queue - long waiters */
SELECT DATEDIFF(second,CreateDate,SentDate) AS completetime, 
DATEDIFF(second,CreateDate,iq.InProcessDate) AS waittime,
iq.CreateDate,
DATENAME(dw, iq.CreateDate),
pc.NAME AS policyco, ploc.INTERNAL_NAME AS policyloc, 
epcd.CreatedDate,
pcd.PolicyNumber, 
epc.NAME AS endorsement_company,
eloc.INTERNAL_NAME AS endorsement_location,
epcd.PolicyNumber AS endorsement_policy,
pe.EndorsementNumber
 FROM dbo.IssuanceQueue iq
 LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration pcd ON iq.BAPolicyId = pcd.PIPCommonPolicyDeclarationId
 LEFT OUTER JOIN dbo.PIPEndorsement pe ON iq.BAEndorsementId = pe.PIPEndorsementID
 LEFT OUTER JOIN dbo.LOCATION ploc ON pcd.LocationSKey = ploc.LOCATION_SKEY
LEFT OUTER JOIN COMPANY pc ON pc.COMPANY_SKEY = ploc.COMPANY_SKEY
LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration epcd ON pe.PIPCommonPolicyDeclarationId = epcd.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.LOCATION eloc ON epcd.LocationSKey = eloc.LOCATION_SKEY
LEFT OUTER JOIN COMPANY epc ON epc.COMPANY_SKEY = eloc.COMPANY_SKEY
 WHERE 1=1
 AND CreateDate > '11/1/2013' 
 AND department_number = 10006
 AND ApplicationID = 5 
 AND DATEDIFF(second,CreateDate,iq.InProcessDate) > 30
 ORDER BY  CreateDate DESC
 
  
  SELECT CAST(iq.CreateDate AS DATE) AS createdate,
  AVG(DATEDIFF(second,CreateDate,SentDate)) as avgcompletetime, 
 AVG(DATEDIFF(second,CreateDate,iq.InProcessDate)) AS avgwaittime,
 COUNT(iq.QueueId) numberofrequests
  FROM dbo.IssuanceQueue iq
  LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration pcd ON iq.BAPolicyId = pcd.PIPCommonPolicyDeclarationId
  LEFT OUTER JOIN dbo.PIPEndorsement pe ON iq.BAEndorsementId = pe.PIPEndorsementID
  LEFT OUTER JOIN dbo.LOCATION ploc ON pcd.LocationSKey = ploc.LOCATION_SKEY
 LEFT OUTER JOIN COMPANY pc ON pc.COMPANY_SKEY = ploc.COMPANY_SKEY
 LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration epcd ON pe.PIPCommonPolicyDeclarationId = epcd.PIPCommonPolicyDeclarationId
 LEFT OUTER JOIN dbo.LOCATION eloc ON epcd.LocationSKey = eloc.LOCATION_SKEY
 LEFT OUTER JOIN COMPANY epc ON epc.COMPANY_SKEY = eloc.COMPANY_SKEY
  WHERE 1=1
  AND CAST(CreateDate AS Date) > '9/1/2013' 
  AND department_number = 10006
  AND ApplicationID = 5
  AND epcd.PolicyNumber is not NULL
  --AND DATEDIFF(second,CreateDate,iq.InProcessDate) > 30
  GROUP BY CAST(iq.CreateDate AS DATE)
  ORDER BY createdate desc


SELECT TOP 1000 * FROM dbo.BAPIRequestLog AS brl
WHERE brl.IdentityName LIKE '%dracul%'
AND ResponseTime > 8000
ORDER BY LogDate DESC 

SELECT TOP 1000 * FROM dbo.BAPIRequestLog AS brl
WHERE brl.IdentityName LIKE '%dlugo1%'
AND ResponseTime > 20000
ORDER BY LogDate DESC 

SELECT * FROM dbo.PIPCommonPolicyDeclaration AS pcpd WHERE pcpd.PIPCommonPolicyDeclarationId = 121291

SELECT TOP 1000 * FROM dbo.BAPIRequestLog AS brl
WHERE brl.IdentityName LIKE '%tselzer%'
AND ResponseTime > 20000
ORDER BY LogDate DESC 

SELECT distinct loc.INTERNAL_NAME, p.* FROM People p
JOIN dbo.PEOPLE_LOCATION_XREF AS plx ON plx.PEOPLE_SKEY = p.PEOPLE_SKEY
JOIN dbo.LOCATION_XREF AS lx ON lx.LOCATION_XREF_SKEY = plx.LOCATION_XREF_SKEY
JOIN Location loc ON loc.LOCATION_SKEY = lx.LOCATION_SKEY
WHERE LAST_NAME LIKE '%selzer%'
SELECT * from Location WHERE 
