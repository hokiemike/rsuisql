SELECT TOP 100 CAST(REPLACE(Request,'encoding="utf-8"','encoding="utf-16"' AS XML)
  FROM dbo.BARatingAPILog AS bral
WHERE 1=1
AND Action = 'GetRates' 
ORDER BY date DESC

SELECT TOP 100 CAST(REPLACE(Request,'encoding="utf-8"','encoding="utf-16"') AS XML)
  FROM dbo.BARatingAPILog AS bral
WHERE 1=1
AND Action = 'GetRates' 
ORDER BY date DESC

SELECT TOP 100 REPLACE(Request,'encoding="utf-8"','encoding="utf-16"') AS XML
  FROM dbo.BARatingAPILog AS bral
WHERE 1=1
AND Action = 'GetRates' 
ORDER BY date DESC

SELECT TOP 100 CAST(CAST(REPLACE(Request,'encoding="utf-8"','encoding="utf-16"') AS NTEXT) AS XML) 
  FROM dbo.BARatingAPILog AS bral
WHERE 1=1
AND Action = 'GetRates' 
ORDER BY date DESC



--inner

SELECT DISTINCT CAST(CAST(REPLACE(Request,'encoding="utf-8"','encoding="utf-16"') AS NTEXT) AS XML)
	  .value('(//AddressLine1)[1]','nvarchar(300)') AS maddr1,
	bral.APIUser AS musr,
	bral.MgaGuid AS mguid
FROM dbo.BARatingAPILog AS bral
WHERE 1=1
AND Action = 'GetRates'

SELECT DISTINCT CAST(CAST(REPLACE(Request,'encoding="utf-8"','encoding="utf-16"') AS NTEXT) AS XML)
	  .value('(//AddressLine1)[1]','nvarchar(300)') AS maddr1,
	bral.APIUser AS musr,
	bral.MgaGuid AS mguid
FROM dbo.BARatingAPILog AS bral
WHERE 1=1
AND Action = 'GetRates'

SELECT c.NAME,  l.INTERNAL_NAME, COUNT(t.maddr1)
 FROM RSUI_PROD.dbo.LOCATION l
 JOIN RSUI_PROD.dbo.COMPANY AS c ON c.COMPANY_SKEY = l.COMPANY_SKEY
 JOIN RSUI_PROD.dbo.LOCATION_XREF AS lx ON l.LOCATION_SKEY = lx.LOCATION_SKEY
 LEFT OUTER JOIN 
 (
	 SELECT DISTINCT CAST(CAST(REPLACE(Request,'encoding="utf-8"','encoding="utf-16"') AS NTEXT) AS XML)
	  .value('(//AddressLine1)[1]','nvarchar(300)') AS maddr1,
	bral.APIUser AS musr,
	bral.MgaGuid AS mguid
		FROM dbo.BARatingAPILog AS bral
		WHERE 1=1
		AND Action = 'GetRates'
 ) t ON t.mguid = l.MGAIdentifier
 WHERE 1=1
 AND lx.DEPARTMENT_NUMBER = 10006
GROUP BY c.NAME,  l.INTERNAL_NAME
ORDER BY c.NAME, l.INTERNAL_NAME DESC





SELECT TOP 100 Request
  FROM dbo.BARatingAPILog AS bral
WHERE 1=1
AND Action = 'GetRates' 
ORDER BY date DESC


SELECT MgaGuid, l.internal_name, COUNT(ID)
 FROM dbo.BARatingAPILog AS bral
 JOIN RSUI_PROD.dbo.LOCATION AS l ON l.MGAIdentifier = bral.MgaGuid
 JOIN RSUI_PROD.dbo.COMPANY AS c ON c.COMPANY_SKEY = l.COMPANY_SKEY
 WHERE 1=1
 AND Action = 'GetRates'
 GROUP BY MgaGuid, l.internal_name
ORDER BY COUNT(ID) DESC


SELECT c.NAME,  l.INTERNAL_NAME, ISNULL(t.mcnt,0)
 FROM RSUI_PROD.dbo.LOCATION l
 JOIN RSUI_PROD.dbo.COMPANY AS c ON c.COMPANY_SKEY = l.COMPANY_SKEY
 JOIN RSUI_PROD.dbo.LOCATION_XREF AS lx ON l.LOCATION_SKEY = lx.LOCATION_SKEY
 LEFT OUTER JOIN 
 (
	 SELECT MgaGuid AS mguid, COUNT(ID) AS mcnt
	 FROM dbo.BARatingAPILog AS bral
	  WHERE 1=1
	 AND Action = 'GetRates'
	 GROUP BY MgaGuid
 ) t ON t.mguid = l.MGAIdentifier
 WHERE 1=1
 AND lx.DEPARTMENT_NUMBER = 10006
ORDER BY c.NAME, l.INTERNAL_NAME DESC


SELECT c.NAME,  COUNT(ID)
 FROM dbo.BARatingAPILog AS bral
 JOIN RSUI_PROD.dbo.LOCATION AS l ON l.MGAIdentifier = bral.MgaGuid
 JOIN RSUI_PROD.dbo.COMPANY AS c ON c.COMPANY_SKEY = l.COMPANY_SKEY
 WHERE 1=1
 AND Action = 'GetRates'
 GROUP BY c.NAME
ORDER BY COUNT(ID) DESC


SELECT c.NAME,  l.INTERNAL_NAME, COUNT(ID)
 FROM RSUI_PROD.dbo.LOCATION l
 LEFT OUTER JOIN dbo.BARatingAPILog AS bral ON  bral.MgaGuid = l.MGAIdentifier
 LEFT OUTER JOIN RSUI_PROD.dbo.COMPANY AS c ON c.COMPANY_SKEY = l.COMPANY_SKEY
 WHERE 1=1
 AND Action = 'GetRates'
 GROUP BY c.NAME, l.INTERNAL_NAME
ORDER BY c.NAME, l.INTERNAL_NAME DESC

Bass Underwriters  