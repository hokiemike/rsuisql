

SELECT c.NAME, loc.INTERNAL_NAME, p.PEOPLE_SKEY, p.LAST_NAME, p.FIRST_NAME,
loc.LOCATION_SKEY, loc.INTERNAL_NAME, c.COMPANY_SKEY, c.NAME, p.EXTERNAL_LOGIN
 FROM dbo.PEOPLE p 
 JOIN dbo.PEOPLE_LOCATION_XREF plx ON p.PEOPLE_SKEY = plx.PEOPLE_SKEY
 JOIN dbo.LOCATION_XREF lxref ON plx.LOCATION_XREF_SKEY = lxref.LOCATION_XREF_SKEY
 JOIN dbo.LOCATION loc ON lxref.LOCATION_SKEY = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY
WHERE 1=1
AND lxref.DEPARTMENT_NUMBER = 10006
AND p.ACTIVE_CODE = 'A'
AND plx.ACTIVE_CODE = 'A'
AND lxref.ACTIVE_CODE = 'A'
AND loc.ACTIVE_CODE = 'A'
ORDER BY c.NAME, loc.INTERNAL_NAME, p.LAST_NAME


SELECT DATEDIFF(second,CreateDate,SentDate) AS completetime, 
DATEDIFF(second,CreateDate,iq.InProcessDate) AS waittime,
iq.CreateDate,
iq.*
 FROM dbo.IssuanceQueue iq
 LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration pcd ON iq.BAPolicyId = pcd.PIPCommonPolicyDeclarationId
 LEFT OUTER JOIN dbo.PIPEndorsement pe ON iq.BAEndorsementId = pe.PIPEndorsementID
 LEFT OUTER JOIN dbo.LOCATION ploc ON pcd.LocationSKey = ploc.LOCATION_SKEY
LEFT OUTER JOIN COMPANY pc ON pc.COMPANY_SKEY = ploc.COMPANY_SKEY
LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration epcd ON pe.PIPCommonPolicyDeclarationId = epcd.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.LOCATION eloc ON epcd.LocationSKey = eloc.LOCATION_SKEY
LEFT OUTER JOIN COMPANY epc ON epc.COMPANY_SKEY = eloc.COMPANY_SKEY
 WHERE 1=1
 --AND CreateDate > '11/3/2011' 
 AND department_number = 10006
 AND ApplicationID = 5 
 AND iq.CreatedBy = 9925
 ORDER BY  iq.CreateDate DESC
 
 SELECT * FROM dbo.PIPPDFInfo WHERE PIPCommonPolicyDeclarationId = 12087
 
 
 SELECT DISTINCT c.Name, loc.INTERNAL_NAME, pcpd.PolicyNumber, iq.* FROM dbo.IssuanceQueue iq
 JOIN dbo.PEOPLE p ON iq.CreatedBy = p.PEOPLE_SKEY
 JOIN dbo.PEOPLE_LOCATION_XREF pxref ON pxref.PEOPLE_SKEY = p.PEOPLE_SKEY
 JOIN dbo.LOCATION_XREF lxref ON lxref.LOCATION_XREF_SKEY = pxref.LOCATION_XREF_SKEY
 LEFT OUTER JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = lxref.LOCATION_SKEY
LEFT OUTER JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY
JOIN dbo.PIPCommonPolicyDeclaration pcpd ON pcpd.PIPCommonPolicyDeclarationId = iq.BAPolicyID
  WHERE ApplicationID = 5 AND StatusId = 4 AND lxref.DEPARTMENT_NUMBER = 10006
  AND NOT EXISTS (SELECT 1 FROM dbo.IssuanceQueue iq2 WHERE iq2.BAPolicyId = iq.BAPolicyId AND iq2.StatusId = 3)
 ORDER BY CreateDate DESC
 
 SELECT * FROM dbo.IssuanceQueue WHERE BAPolicyId = 12087 ORDER BY CreateDate
 
 
