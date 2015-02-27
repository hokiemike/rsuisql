

--SELECT * FROM dbo.RuleBasedDocSubType WHERE Department_Number = 300

--SELECT * FROM dbo.RuleBasedDocSubTypeXref rbdxr WHERE SubTypeId IN (301,302,303,304)

--SELECT * FROM dbo.RuleBasedDocSubTypeXref rbdxr WHERE SubTypeId IN (196,197,198,199)

--
-- Update cross reference to not use the duplicate subtypes
--
UPDATE dbo.RuleBasedDocSubTypeXref
SET SubTypeId = 301
WHERE SubTypeId IN (196)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 302
WHERE SubTypeId IN (197)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 303
WHERE SubTypeId IN (198)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 304
WHERE SubTypeId IN (199)
go



--
-- find duplicates
--
--SELECT rbd.DocId,rbdstx.SubTypeId, COUNT(rbdstx.DocSubTypeXrefId)
-- FROM dbo.RuleBasedDoc rbd
--JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
--JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
--WHERE rbd.DEPARTMENT_NUMBER = 300
--GROUP BY rbd.DocId,rbdstx.SubTypeId 
--HAVING COUNT(rbdstx.DocSubTypeXrefId) > 1
--ORDER BY rbd.DocId,rbdstx.SubTypeId


--
-- delete dup subtypes xrefs
--
BEGIN TRANSACTION
DELETE rbdxr2 FROM dbo.RuleBasedDocSubTypeXref rbdxr2
JOIN (
SELECT rbdxr.DocId, rbdxr.SubTypeId, MAX(rbdxr.DocSubTypeXrefId) AS xrefid
FROM dbo.RuleBasedDocSubTypeXref rbdxr
JOIN (
SELECT rbd.DocId AS docid,rbdstx.SubTypeId AS subtype, COUNT(rbdstx.DocSubTypeXrefId) AS xcount
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE rbd.DEPARTMENT_NUMBER = 300
GROUP BY rbd.DocId,rbdstx.SubTypeId 
HAVING COUNT(rbdstx.DocSubTypeXrefId) > 1
) xr ON rbdxr.DocId = xr.docid AND xr.subtype = rbdxr.SubTypeId
GROUP BY rbdxr.DocId, rbdxr.SubTypeId
) tempa ON tempa.xrefid = rbdxr2.DocSubTypeXrefId 

COMMIT TRANSACTION
go


-- Update cross reference to not use the duplicate subtypes
--
UPDATE dbo.RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 301
WHERE SubTypeId IN (196)
go

UPDATE dbo.RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 302
WHERE SubTypeId IN (197)
go

UPDATE dbo.RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 303
WHERE SubTypeId IN (198)
go

UPDATE dbo.RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 304
WHERE SubTypeId IN (199)
go



--
-- find duplicates in doctype-to-subtype xref
--
--SELECT rbdstx.DocTypeId, rbdstx.SubTypeId, COUNT(rbdstx.SubTypeDocTypeXrefId)
--FROM dbo.RuleBasedDocSubTypeDocTypeXref rbdstx
--JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
--WHERE 1=1
--GROUP BY rbdstx.DocTypeId,rbdstx.SubTypeId 
--HAVING COUNT(rbdstx.SubTypeDocTypeXrefId) > 1
--ORDER BY rbdstx.DocTypeId,rbdstx.SubTypeId


--
-- delete dup subtypes-to-doctype xrefs
--
--BEGIN TRANSACTION
--DELETE rbdxr2 FROM dbo.RuleBasedDocSubTypeDocTypeXref rbdxr2
--JOIN (
--SELECT rbdxr.DocTypeId, rbdxr.SubTypeId, MAX(rbdxr.SubTypeDocTypeXrefId) AS xrefid
--FROM dbo.RuleBasedDocSubTypeDocTypeXref rbdxr
--JOIN (
--SELECT rbdstx.DocTypeId AS idocid, rbdstx.SubTypeId AS isubtype, COUNT(rbdstx.SubTypeDocTypeXrefId) AS icount
--FROM dbo.RuleBasedDocSubTypeDocTypeXref rbdstx
--JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
--WHERE 1=1
--GROUP BY rbdstx.DocTypeId,rbdstx.SubTypeId 
--HAVING COUNT(rbdstx.SubTypeDocTypeXrefId) > 1
--) xr ON rbdxr.DocTypeId = xr.idocid AND xr.isubtype = rbdxr.SubTypeId
--GROUP BY rbdxr.DocTypeId, rbdxr.SubTypeId
--) tempa ON tempa.xrefid = rbdxr2.SubTypeDocTypeXrefId 

--COMMIT TRANSACTION
--go



--delete duplicate subtypes
DELETE FROM dbo.RuleBasedDocSubType
WHERE SubTypeId IN (196,197,198,199)
GO

--
-- PROPERTY
--
UPDATE dbo.RuleBasedDocSubTypeXref 
SET SubTypeId = 2009 
WHERE SubTypeId IN (2010,2011,2012,2015)
GO

UPDATE dbo.RuleBasedDocSubTypeDocTypeXref 
SET SubTypeId = 2009 
WHERE SubTypeId IN (2010,2011,2012,2015)
GO

DELETE FROM dbo.RuleBasedDocSubType WHERE SubTypeId IN (2010,2011,2012,2015)

--
-- CASUALTY
--
UPDATE dbo.RuleBasedDocSubTypeXref 
SET SubTypeId = 2000 
WHERE SubTypeId IN (2002)
GO

UPDATE dbo.RuleBasedDocSubTypeXref 
SET SubTypeId = 2001 
WHERE SubTypeId IN (2003)
GO


UPDATE dbo.RuleBasedDocSubTypeDocTypeXref 
SET SubTypeId = 2000 
WHERE SubTypeId IN (2002)
GO

UPDATE dbo.RuleBasedDocSubTypeDocTypeXref 
SET SubTypeId = 2001 
WHERE SubTypeId IN (2003)
GO


DELETE FROM dbo.RuleBasedDocSubType WHERE SubTypeId IN (2002,2003)