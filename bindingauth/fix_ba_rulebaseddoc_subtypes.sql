

-- update subtypedoctypexref rows pointing to the other depts codes
UPDATE dbo.RuleBasedDocSubTypeDocTypeXref SET DocTypeId = 304 WHERE DocTypeId = 26 AND SubTypeId IN (4002,4003,4004,4005,4006,4007)
UPDATE dbo.RuleBasedDocSubTypeDocTypeXref SET DocTypeId = 305 WHERE DocTypeId = 29 AND SubTypeId IN (4002,4003,4004,4005,4006,4007)
UPDATE dbo.RuleBasedDocSubTypeDocTypeXref SET DocTypeId = 306 WHERE DocTypeId = 220 AND SubTypeId IN (4002,4003,4004,4005,4006,4007)
UPDATE dbo.RuleBasedDocSubTypeDocTypeXref SET DocTypeId = 307 WHERE DocTypeId = 224 AND SubTypeId IN (4002,4003,4004,4005,4006,4007)
go

--remove all subtypedoctypexref rows for superflous codes
DELETE x FROM RuleBasedDocSubTypeDocTypeXref x 
--SELECT x.* FROM RuleBasedDocSubTypeDocTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE 1=1
AND Department_Number = 10006 
AND x.DocTypeId IN (SELECT DISTINCT DocTypeId FROM dbo.RuleBasedDocType WHERE BindingAuthority = 0)
go

--change doc type to state form instead of using stateform subtypes
UPDATE dbo.RuleBasedDoc SET DocTypeId = 303
WHERE DocID IN (SELECT DISTINCT x.DocId FROM dbo.RuleBasedDocSubTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE st.Department_Number = 10006 AND st.SubTypeId = 4007) --state form 
go

--remove xrefs to state form subtype to doctypes
DELETE x FROM RuleBasedDocSubTypeDocTypeXref x 
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE 1=1
AND Department_Number = 10006 
AND x.SubTypeId = 4007
go

--insert the correct xrefs for bindauth subtypes
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4002, 301)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4003, 301)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4004, 301)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4005, 301)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4006, 301)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4002, 302)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4003, 302)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4004, 302)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4005, 302)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4006, 302)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4002, 303)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4003, 303)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4004, 303)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4005, 303)
INSERT INTO dbo.RuleBasedDocSubTypeDocTypeXref ( SubTypeId, DocTypeId ) VALUES  ( 4006, 303)
go


--SELECT DISTINCT docid FROM dbo.RuleBasedDocSubTypeXref x
--JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
--WHERE st.Department_Number = 10006
--AND st.SubTypeId = 4001


--anything set to 4001 insert rows to point to every subtype
INSERT INTO dbo.RuleBasedDocSubTypeXref ( DocId, SubTypeId )
SELECT DISTINCT docid, 4002 FROM dbo.RuleBasedDocSubTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE st.Department_Number = 10006 AND st.SubTypeId = 4001

INSERT INTO dbo.RuleBasedDocSubTypeXref ( DocId, SubTypeId )
SELECT DISTINCT docid, 4003 FROM dbo.RuleBasedDocSubTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE st.Department_Number = 10006 AND st.SubTypeId = 4001

INSERT INTO dbo.RuleBasedDocSubTypeXref ( DocId, SubTypeId )
SELECT DISTINCT docid, 4004 FROM dbo.RuleBasedDocSubTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE st.Department_Number = 10006 AND st.SubTypeId = 4001

INSERT INTO dbo.RuleBasedDocSubTypeXref ( DocId, SubTypeId )
SELECT DISTINCT docid, 4005 FROM dbo.RuleBasedDocSubTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE st.Department_Number = 10006 AND st.SubTypeId = 4001

INSERT INTO dbo.RuleBasedDocSubTypeXref ( DocId, SubTypeId )
SELECT DISTINCT docid, 4006 FROM dbo.RuleBasedDocSubTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE st.Department_Number = 10006 AND st.SubTypeId = 4001

INSERT INTO dbo.RuleBasedDocSubTypeXref ( DocId, SubTypeId )
SELECT DISTINCT docid, 4007 FROM dbo.RuleBasedDocSubTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE st.Department_Number = 10006 AND st.SubTypeId = 4001
go

--remove all doc xref rows pointing to 4001
DELETE x FROM dbo.RuleBasedDocSubTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE st.Department_Number = 10006 AND st.SubTypeId = 4001 
go
--remove all doc xref rows pointing to 4007
DELETE x FROM dbo.RuleBasedDocSubTypeXref x
JOIN dbo.RuleBasedDocSubType st ON x.SubTypeId = st.SubTypeId
WHERE st.Department_Number = 10006 AND st.SubTypeId = 4007 
go
  


--delete 4001 subtype
DELETE FROM dbo.RuleBasedDocSubType WHERE SubTypeId = 4001
go

--delete 4007 subtype
DELETE FROM dbo.RuleBasedDocSubType WHERE SubTypeId = 4007
go





