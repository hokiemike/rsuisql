SELECT TOP 100 * FROM dbo.BARatingAPILog AS bral ORDER BY bral.Date DESC

SELECT c.NAME,  l.INTERNAL_NAME, ISNULL(t.mcnt,0)
 FROM RSUIPDBN02.RSUI_PROD.dbo.LOCATION l
 JOIN RSUIPDBN02.RSUI_PROD.dbo.COMPANY AS c ON c.COMPANY_SKEY = l.COMPANY_SKEY
 JOIN RSUIPDBN02.RSUI_PROD.dbo.LOCATION_XREF AS lx ON l.LOCATION_SKEY = lx.LOCATION_SKEY
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


SELECT MgaGuid AS mguid, CAST(bral.Date AS DATE) AS accessdate, COUNT(ID) AS mcnt
	 FROM dbo.BARatingAPILog AS bral
	  WHERE 1=1
	 AND Action = 'GetRates'
	 GROUP BY MgaGuid,CAST(bral.Date AS DATE)
	 ORDER BY accessdate DESC
	 
SELECT CAST(bral.Date AS DATE) AS accessdate, DATENAME(dw, bral.Date), COUNT(ID) AS mcnt
	 FROM dbo.BARatingAPILog AS bral
	  WHERE 1=1
	 AND Action = 'GetRates'
	 --AND DATE > '2013-09-23'
	 GROUP BY CAST(bral.Date AS DATE), DATENAME(dw, bral.Date)
	 ORDER BY accessdate DESC
	 

	 
