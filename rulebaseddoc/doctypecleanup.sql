-- 
-- Find all active docs in one subtype but not another
--	
SELECT DISTINCT rbd.DocId, rbd.DocNumber, rbd.Edition, rbdt.Description, rbd.Name,rbdt.Description,
stuff((select ',' + CAST(t2.Description as varchar(20))
     from dbo.RuleBasedDocSubTypeXref t1
     JOIN RuleBasedDocSubType t2 on t1.SubTypeId = t2.SubTypeId
     WHERE t1.DocId = rbd.DocId
     for xml path('')),1,1,'') SubTypes
FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
JOIN dbo.RuleBasedDocStateApproval AS rbdsa ON rbdsa.DocId = rbd.DocId
JOIN dbo.RuleBasedDocType AS rbdt ON rbdt.DocTypeId = rbd.DocTypeId
WHERE 1=1
--AND rbd.DEPARTMENT_NUMBER = 1900
AND rbdsa.EffectiveDate <= GETDATE() 
	AND (rbdsa.ExpirationDate IS NULL OR rbdsa.ExpirationDate >= GETDATE())
AND rbdst.SubTypeId IN (2013) -- PL Cov - Medical Professional
AND NOT EXISTS (SELECT 1 FROM RuleBasedDocSubTypeXref rbdstx2 WHERE rbdstx2.DocId = rbd.DocId 
               and rbdstx2.SubTypeId = 1902) --Medical Professional
               
               
               
-- find all doc types for active PL docs
SELECT DISTINCT rbdt.DocTypeId, rbdt.Description
FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
JOIN dbo.RuleBasedDocStateApproval AS rbdsa ON rbdsa.DocId = rbd.DocId
JOIN dbo.RuleBasedDocType AS rbdt ON rbdt.DocTypeId = rbd.DocTypeId
WHERE 1=1
AND rbdsa.EffectiveDate <= GETDATE() 
	AND (rbdsa.ExpirationDate IS NULL OR rbdsa.ExpirationDate >= GETDATE())
AND rbd.DEPARTMENT_NUMBER = 1900
ORDER BY rbdt.DocTypeId

-- find all sub types for active PL docs with doc counts
SELECT DISTINCT rbdst.Description, rbdst.SubTypeId, rbdst.SurrogateKey, COUNT(DISTINCT rbd.DocId) AS numberofdocs
FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
JOIN dbo.RuleBasedDocStateApproval AS rbdsa ON rbdsa.DocId = rbd.DocId
JOIN dbo.RuleBasedDocType AS rbdt ON rbdt.DocTypeId = rbd.DocTypeId
WHERE 1=1
AND rbdsa.EffectiveDate <= GETDATE() 
	AND (rbdsa.ExpirationDate IS NULL OR rbdsa.ExpirationDate >= GETDATE())
AND rbd.DEPARTMENT_NUMBER = 1900
GROUP BY rbdst.Description, rbdst.SubTypeId, rbdst.SurrogateKey
ORDER BY rbdst.SubTypeId

-- find all sub types for active PL docs with doc counts
SELECT DISTINCT rbdst.Description, rbdst.SubTypeId, rbdst.SurrogateKey, COUNT(DISTINCT rbd.DocId) AS numberofdocs
FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
JOIN dbo.RuleBasedDocStateApproval AS rbdsa ON rbdsa.DocId = rbd.DocId
JOIN dbo.RuleBasedDocType AS rbdt ON rbdt.DocTypeId = rbd.DocTypeId
WHERE 1=1
AND rbdsa.EffectiveDate <= GETDATE() 
	AND (rbdsa.ExpirationDate IS NULL OR rbdsa.ExpirationDate >= GETDATE())
AND rbd.DEPARTMENT_NUMBER = 1900
GROUP BY rbdst.Description, rbdst.SubTypeId, rbdst.SurrogateKey
ORDER BY rbdst.SubTypeId

--
-- find all active docs in a certain subtype
--
SELECT DISTINCT rbd.DocId, rbd.DocNumber, rbd.Edition, rbdt.Description, rbd.Name,rbdt.Description,
stuff((select ',' + CAST(t2.Description as varchar(20))
     from dbo.RuleBasedDocSubTypeXref t1
     JOIN RuleBasedDocSubType t2 on t1.SubTypeId = t2.SubTypeId
     WHERE t1.DocId = rbd.DocId
     for xml path('')),1,1,'') SubTypes
FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
JOIN dbo.RuleBasedDocStateApproval AS rbdsa ON rbdsa.DocId = rbd.DocId
JOIN dbo.RuleBasedDocType AS rbdt ON rbdt.DocTypeId = rbd.DocTypeId
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 1900
AND rbdsa.EffectiveDate <= GETDATE() 
	AND (rbdsa.ExpirationDate IS NULL OR rbdsa.ExpirationDate >= GETDATE())
AND rbdst.SubTypeId IN (1906) -- PL Cov - Medical Professional

--
-- any BA doctypes being assigned non-BA subtypes
--
SELECT rbdstdtx.SubTypeDocTypeXrefId, rbdt.DocTypeId, rbdt.Description, rbdst.SubTypeId, rbdst.Description, rbdst.Department_Number
FROM dbo.RuleBasedDocType AS rbdt
JOIN dbo.RuleBasedDocSubTypeDocTypeXref AS rbdstdtx ON rbdstdtx.DocTypeId = rbdt.DocTypeId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstdtx.SubTypeId = rbdst.SubTypeId
WHERE 1=1
AND rbdst.DEPARTMENT_NUMBER != 10006 
AND rbdt.BindingAuthority = 1
ORDER BY rbdstdtx.SubTypeDocTypeXrefId



--
-- which doctype/subtype combinations have no docs assigned
--
SELECT st.Department_Number, st.SubTypeId, st.Description, st.Category, dt.DocTypeId, dt.Description
FROM dbo.RuleBasedDocSubTypeDocTypeXref stdtx
JOIN dbo.RuleBasedDocSubType st ON stdtx.SubTypeId = st.SubTypeId
JOIN dbo.RuleBasedDocType dt ON stdtx.DocTypeId = dt.DocTypeId
LEFT JOIN (
	SELECT DISTINCT stx.SubTypeId, d.DocTypeId, d.DEPARTMENT_NUMBER
	FROM dbo.RuleBasedDoc d
	JOIN dbo.RuleBasedDocSubTypeXref stx ON d.DocId = stx.DocId
	JOIN dbo.RuleBasedDocType dt ON d.DocTypeId = dt.DocTypeId
	JOIN dbo.RuleBasedDocStateApproval AS rbdsa ON rbdsa.DocId = d.DocId
	WHERE 1=1--d.DEPARTMENT_NUMBER = 1900
	AND rbdsa.EffectiveDate <= GETDATE() 
	AND (rbdsa.ExpirationDate IS NULL OR rbdsa.ExpirationDate >= GETDATE())
	) UsedDTST ON stdtx.DocTypeId = UsedDTST.DocTypeId AND stdtx.SubTypeId = UsedDTST.SubTypeId  and UsedDTST.DEPARTMENT_NUMBER = st.Department_Number
WHERE 1=1
--AND st.Department_Number = 200
AND UsedDTST.DocTypeId IS NULL
AND UsedDTST.SubTypeId IS NULL
ORDER BY 1,2,3


SELECT st.Department_Number, st.SubTypeId, st.Description, st.Category
FROM dbo.RuleBasedDocSubType st 
LEFT JOIN (
	SELECT DISTINCT stx.SubTypeId, d.DocTypeId, d.DEPARTMENT_NUMBER
	FROM dbo.RuleBasedDoc d
	JOIN dbo.RuleBasedDocSubTypeXref stx ON d.DocId = stx.DocId
	JOIN dbo.RuleBasedDocType dt ON d.DocTypeId = dt.DocTypeId
	JOIN dbo.RuleBasedDocStateApproval AS rbdsa ON rbdsa.DocId = d.DocId
	WHERE 1=1--d.DEPARTMENT_NUMBER = 1900
	--AND rbdsa.EffectiveDate <= GETDATE() 
	--AND (rbdsa.ExpirationDate IS NULL OR rbdsa.ExpirationDate >= GETDATE())
	) UsedDTST ON st.SubTypeId = UsedDTST.SubTypeId 
WHERE 1=1
AND UsedDTST.DocTypeId IS NULL
AND UsedDTST.SubTypeId IS NULL
ORDER BY 1,2,3
