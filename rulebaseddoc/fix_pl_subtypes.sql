SELECT * FROM dbo.RuleBasedDocSubType WHERE Department_Number = 1900


-- list of deletes
SELECT DISTINCT rbd.DocId, rbd.DocNumber, rbd.Name, rbdst.Description, rbdst.SubTypeId, rbdstx.DocSubTypeXrefId
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE rbd.DEPARTMENT_NUMBER = 1900
--AND rbd.DocTypeId = 163 --coverage form
AND rbdst.SubTypeId IN (172,173,174,2006,2008,1910,1911,1912,1913,1914,1915,1916,1917,1918,1923)
ORDER BY rbd.DocId, rbd.DocNumber

SELECT DISTINCT rbd.DocId, rbd.DocNumber, rbd.Name, rbdst.Description, rbdst.SubTypeId, rbdstx.DocSubTypeXrefId
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE rbd.DEPARTMENT_NUMBER = 1900
--AND rbd.DocTypeId = 163 --coverage form
AND rbdst.SubTypeId IN (2004,2006,2008)
ORDER BY rbd.DocId, rbd.DocNumber

SELECT DISTINCT rbd.DocId, rbd.DocNumber, rbd.Name, rbdst.Description, rbdst.SubTypeId, rbdstx.DocSubTypeXrefId
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE rbd.DEPARTMENT_NUMBER = 1900
--AND rbd.DocTypeId = 163 --coverage form
AND rbdst.SubTypeId = 1913
AND NOT EXISTS (SELECT 1 FROM dbo.RuleBasedDoc rbd2
JOIN dbo.RuleBasedDocSubTypeXref rbdstx2 ON rbd2.DocId = rbdstx2.DocId
WHERE rbd2.DocId = rbd.DocId AND rbdstx2.SubTypeId = 1904)
ORDER BY rbd.DocId, rbd.DocNumber

SELECT DISTINCT rbd.DocId, rbd.DocNumber, rbd.Name, rbdst.Description, rbdst.SubTypeId, rbdstx.DocSubTypeXrefId, rbdst.SubTypeId-9 AS ShouldBeSubType
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE rbd.DEPARTMENT_NUMBER = 1900
--AND rbd.DocTypeId = 163 --coverage form
AND rbdst.SubTypeId IN ( 1910,1911,1912,1913,1914,1915,1916,1917,1918 )
AND NOT EXISTS (SELECT 1 FROM dbo.RuleBasedDoc rbd2
JOIN dbo.RuleBasedDocSubTypeXref rbdstx2 ON rbd2.DocId = rbdstx2.DocId
WHERE rbd2.DocId = rbd.DocId AND rbdstx2.SubTypeId = (rbdst.SubTypeId - 9))
ORDER BY rbd.DocId, rbd.DocNumber


SELECT 





SELECT DISTINCT rbd.DocId, rbdst.Description, COUNT(rbdstx.DocSubTypeXrefId)
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE rbd.DEPARTMENT_NUMBER = 1900
AND rbd.DocTypeId = 163 --coverage form
--AND rbdst.SubTypeId NOT IN (1901,1902,1903,1904,1905,1906,1907,1908,1909)
AND rbd.DocId IN (
SELECT DISTINCT rbd.DocId
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE rbd.DEPARTMENT_NUMBER = 1900
AND rbd.DocTypeId = 163 --coverage form
AND rbdst.SubTypeId NOT IN (1901,1902,1903,1904,1905,1906,1907,1908,1909)
)
GROUP BY rbd.DocId, rbdst.Description
ORDER BY rbd.DocId
--HAVING COUNT(rbdstx.DocSubTypeXrefId) > 1

SELECT rbd.DocId, rbdst.Description, COUNT(rbdstx.DocSubTypeXrefId)
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE rbd.DEPARTMENT_NUMBER = 1900
--AND rbd.DocTypeId = 163 --coverage form
AND rbdst.SubTypeId IN (172,173,174,2006,2008,1910,1911,1912,1913,1914,1915,1916,1917,1918,1923)
ORDER BY rbd.DocId, rbd.DocNumber







SELECT * FROM dbo.RuleBasedDocType

