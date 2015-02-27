SELECT pcpd.PIPCommonPolicyDeclarationId AS PolicyId,
		CONVERT(VARCHAR,pcpd.CompanyCode) + 
		CONVERT(VARCHAR,pcpd.PolicySymbol) +
        CONVERT(VARCHAR,pcpd.PolicyNumber) + 
        CONVERT(VARCHAR,pcpd.PolicySuffix) AS PolicyNumber,
       loc.INTERNAL_NAME AS Location,
       pcpd.EffectiveDate AS EffectiveDate,
       loc.COMPANY_SKEY,
       pcpd.InsuredName AS InsuredName,       
       p.LAST_NAME + ', ' + p.FIRST_NAME AS CreatedBy,
       pu.LAST_NAME + ', ' + pu.FIRST_NAME AS Underwriter,
       pcpd.CreatedDate AS CreatedAt,
       pcpd.CreatedByPeopleSKey AS CreatedById,
       pcpd.PDFStatusCode AS PDFStatusCodeId  ,
       pcpd.IssuedDate AS IssuedDate
FROM dbo.PIPCommonPolicyDeclaration pcpd
LEFT OUTER JOIN dbo.LOCATION loc ON pcpd.LocationSKey = LOCATION_SKEY
LEFT OUTER JOIN dbo.PEOPLE p ON p.PEOPLE_SKEY = pcpd.CreatedByPeopleSKey
LEFT OUTER JOIN dbo.PEOPLE pu ON p.PEOPLE_SKEY = pcpd.UnderwriterPeopleSKey
WHERE 1=1
AND pcpd.StatusCode = 0
AND loc.COMPANY_SKEY = 809

