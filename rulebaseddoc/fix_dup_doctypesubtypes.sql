
--------------------------------------------------------------------------------------------------------------------------------------
--    FIX Dups in RuleBasedDocSubTypeXref and add constraint
--------------------------------------------------------------------------------------------------------------------------------------

--SELECT rbdxr.DocId, rbdxr.SubTypeId, MAX(rbdxr.DocSubTypeXrefId) AS xrefid
--FROM dbo.RuleBasedDocSubTypeXref rbdxr
--JOIN 
--(
--SELECT rbd.DocId AS docid,rbdstx.SubTypeId AS subtype, COUNT(rbdstx.DocSubTypeXrefId) AS xcount
-- FROM dbo.RuleBasedDoc rbd
--JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
--JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
--WHERE 1=1
----AND rbd.DEPARTMENT_NUMBER = 10006
--GROUP BY rbd.DocId,rbdstx.SubTypeId 
--HAVING COUNT(rbdstx.DocSubTypeXrefId) > 1
--) xr ON rbdxr.DocId = xr.docid AND xr.subtype = rbdxr.SubTypeId
--GROUP BY rbdxr.DocId, rbdxr.SubTypeId

DELETE rbdxr2 FROM dbo.RuleBasedDocSubTypeXref rbdxr2
JOIN (
SELECT rbdxr.DocId, rbdxr.SubTypeId, MAX(rbdxr.DocSubTypeXrefId) AS xrefid
FROM dbo.RuleBasedDocSubTypeXref rbdxr
JOIN (
SELECT rbd.DocId AS docid,rbdstx.SubTypeId AS subtype, COUNT(rbdstx.DocSubTypeXrefId) AS xcount
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE 1=1
--AND rbd.DEPARTMENT_NUMBER = 10006
GROUP BY rbd.DocId,rbdstx.SubTypeId 
HAVING COUNT(rbdstx.DocSubTypeXrefId) > 1
) xr ON rbdxr.DocId = xr.docid AND xr.subtype = rbdxr.SubTypeId
GROUP BY rbdxr.DocId, rbdxr.SubTypeId
) tempa ON tempa.xrefid = rbdxr2.DocSubTypeXrefId 
go

DELETE rbdxr2 FROM dbo.RuleBasedDocSubTypeXref rbdxr2
JOIN (
SELECT rbdxr.DocId, rbdxr.SubTypeId, MAX(rbdxr.DocSubTypeXrefId) AS xrefid
FROM dbo.RuleBasedDocSubTypeXref rbdxr
JOIN (
SELECT rbd.DocId AS docid,rbdstx.SubTypeId AS subtype, COUNT(rbdstx.DocSubTypeXrefId) AS xcount
 FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
WHERE 1=1
--AND rbd.DEPARTMENT_NUMBER = 10006
GROUP BY rbd.DocId,rbdstx.SubTypeId 
HAVING COUNT(rbdstx.DocSubTypeXrefId) > 1
) xr ON rbdxr.DocId = xr.docid AND xr.subtype = rbdxr.SubTypeId
GROUP BY rbdxr.DocId, rbdxr.SubTypeId
) tempa ON tempa.xrefid = rbdxr2.DocSubTypeXrefId 
go

-- add constraint to [RuleBasedDocSubTypeXref]
/****** Object:  Index [IX_DocTypeSubType]    Script Date: 03/30/2010 15:31:11 ******/
ALTER TABLE [dbo].[RuleBasedDocSubTypeXref] ADD  CONSTRAINT [IX_DocTypeSubType] UNIQUE NONCLUSTERED 
(
	[DocId] ASC,
	[SubTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_RuleBasedDocSubType_Unique_Desc_Dept]    Script Date: 03/30/2010 16:50:36 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[RuleBasedDocSubType]') AND name = N'IX_RuleBasedDocSubType_Unique_Desc_Dept')
ALTER TABLE [dbo].[RuleBasedDocSubType] DROP CONSTRAINT [IX_RuleBasedDocSubType_Unique_Desc_Dept]
GO


/****** Object:  Index [IX_RuleBasedDocSubType_Unique_Desc_Dept]    Script Date: 03/30/2010 16:50:36 ******/
ALTER TABLE [dbo].[RuleBasedDocSubType] ADD  CONSTRAINT [IX_RuleBasedDocSubType_Unique_Desc_Dept] UNIQUE NONCLUSTERED 
(
	[Department_Number] ASC,
	[Description] ASC,
	[Category] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

--------------------------------------------------------------------------------------------------------------------------------------
--    FIX Dups in RuleBasedDocSubTypeXref and add constraint
-------------------------------------------------------------------------------------------------------------------------------------- 
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
go

/****** Object:  Index [IX_DocTypeSubType_Unique]    Script Date: 03/30/2010 15:34:51 ******/
ALTER TABLE [dbo].[RuleBasedDocSubTypeDocTypeXref] ADD  CONSTRAINT [IX_DocTypeSubType_Unique] UNIQUE NONCLUSTERED 
(
	[DocTypeId] ASC,
	[SubTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


