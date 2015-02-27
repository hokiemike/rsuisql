

-- ===========================================
-- PL
-- ===========================================
--
-- Update cross reference to not use the duplicate subtypes
--
UPDATE dbo.RuleBasedDocSubTypeXref
SET SubTypeId = 1901
WHERE SubTypeId IN (1910)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 1902
WHERE SubTypeId IN (1911)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 1903
WHERE SubTypeId IN (1912)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 1904
WHERE SubTypeId IN (1913,174)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 1905
WHERE SubTypeId IN (173,1914)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 1906
WHERE SubTypeId IN (1915,172)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 1907
WHERE SubTypeId IN (1916)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 1908
WHERE SubTypeId IN (1917)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 1909
WHERE SubTypeId IN (1918)
go

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 2004
WHERE SubTypeId IN (2006,2008)
go


--
-- find duplicates
--
--SELECT rbd.DocId,rbdstx.SubTypeId, COUNT(rbdstx.DocSubTypeXrefId)
-- FROM dbo.RuleBasedDoc rbd
--JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
--JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
--WHERE rbd.DEPARTMENT_NUMBER = 1900
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
WHERE rbd.DEPARTMENT_NUMBER = 1900
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
SET SubTypeId = 1901
WHERE SubTypeId IN (1910)
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 1902
WHERE SubTypeId IN (1911)
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 1903
WHERE SubTypeId IN (1912)
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 1904
WHERE SubTypeId IN (1913,174)
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 1905
WHERE SubTypeId IN (173,1914)
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 1906
WHERE SubTypeId IN (1915,172)
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 1907
WHERE SubTypeId IN (1916)
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 1908
WHERE SubTypeId IN (1917)
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 1909
WHERE SubTypeId IN (1918)
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 2004
WHERE SubTypeId IN (2006,2008)
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
BEGIN TRANSACTION
DELETE rbdxr2 FROM dbo.RuleBasedDocSubTypeDocTypeXref rbdxr2
JOIN (
SELECT rbdxr.DocTypeId, rbdxr.SubTypeId, MAX(rbdxr.SubTypeDocTypeXrefId) AS xrefid
FROM dbo.RuleBasedDocSubTypeDocTypeXref rbdxr
JOIN (
SELECT rbdstx.DocTypeId AS idocid, rbdstx.SubTypeId AS isubtype, COUNT(rbdstx.SubTypeDocTypeXrefId) AS icount
FROM dbo.RuleBasedDocSubTypeDocTypeXref rbdstx
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE 1=1
GROUP BY rbdstx.DocTypeId,rbdstx.SubTypeId 
HAVING COUNT(rbdstx.SubTypeDocTypeXrefId) > 1
) xr ON rbdxr.DocTypeId = xr.idocid AND xr.isubtype = rbdxr.SubTypeId
GROUP BY rbdxr.DocTypeId, rbdxr.SubTypeId
) tempa ON tempa.xrefid = rbdxr2.SubTypeDocTypeXrefId 

COMMIT TRANSACTION
go

--
-- misc cleanup
--

UPDATE RuleBasedDocSubTypeXref
SET SubTypeId = 1901
WHERE SubTypeId = 1928
AND DocID IN (12129,12130,12131)
go

DELETE FROM RuleBasedDocSubTypeXref
WHERE DocId = 2 AND SubTypeId = 1928
go

DELETE FROM dbo.RuleBasedDocSubTypeDocTypeXref WHERE SubTypeId = 1928 AND DocTypeId = 29
go

UPDATE RuleBasedDocSubTypeDocTypeXref
SET SubTypeId = 1901
WHERE SubTypeId = 1928
AND DocTypeId IN (201)
go
--delete duplicate subtypes
DELETE FROM dbo.RuleBasedDocSubType
WHERE SubTypeId IN (172,173,174,2006,2008,1910,1911,1912,1913,1914,1915,1916,1917,1918,1928)
go
--SELECT * FROM dbo.RuleBasedDocSubTypeDocTypeXref WHERE SubTypeId IN (172,173,174,2006,2008,1910,1911,1912,1913,1914,1915,1916,1917,1918,1928)
--SELECT * FROM dbo.RuleBasedDocSubType
--SELECT * FROM dbo.RuleBasedDocSubTypeDocTypeXref WHERE SubTypeId IN (172,173,174,2006,2008,1910,1911,1912,1913,1914,1915,1916,1917,1918)
--SELECT * FROM dbo.RuleBasedDocSubTypeXref WHERE SubTypeId IN (172,173,174,2006,2008,1910,1911,1912,1913,1914,1915,1916,1917,1918)





-- =====================================================
-- DO
-- =====================================================

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

-- ===========================================
-- PROPERTY
-- ===========================================
UPDATE dbo.RuleBasedDocSubTypeXref 
SET SubTypeId = 2009 
WHERE SubTypeId IN (2010,2011,2012,2015)
GO

UPDATE dbo.RuleBasedDocSubTypeDocTypeXref 
SET SubTypeId = 2009 
WHERE SubTypeId IN (2010,2011,2012,2015)
GO

DELETE FROM dbo.RuleBasedDocSubType WHERE SubTypeId IN (2010,2011,2012,2015)
go

-- =============================================
-- CASUALTY
-- ===============================================
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
go

-- ===================================================================
--  CONSTRAINT TO KEEP THIS CRAP FROM HAPPENING AGAIN
-- ====================================================================

/*
   Tuesday, March 02, 201012:31:43 PM
   User: sa
   Server: RSUIDEVDB
   Database: DEV3
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.RuleBasedDocSubType ADD CONSTRAINT
	IX_RuleBasedDocSubType_Unique_Desc_Dept UNIQUE NONCLUSTERED 
	(
	Department_Number,
	Description
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT