SELECT * FROM dbo.RuleBasedDoc WHERE DocNumber LIKE '%1010%' AND DEPARTMENT_NUMBER = 10006
SELECT * FROM dbo.RuleBasedDoc WHERE DocNumber LIKE '%1020%' AND DEPARTMENT_NUMBER = 10006
SELECT * FROM dbo.RuleBasedDoc WHERE DocNumber LIKE '%1030%' AND DEPARTMENT_NUMBER = 10006

SELECT * FROM dbo.RuleBasedDocRatingClassCodeXref WHERE DocID IN (12647,12637,12638)

SELECT rcc.RatingClassNumber, rcc.Description, rbd.Name, rccx.IsMandatory
 FROM dbo.RatingClassCode rcc 
JOIN dbo.RuleBasedDocRatingClassCodeXref rccx ON rcc.RatingClassCodeKey = rccx.RatingClassCodeKey
JOIN dbo.RuleBasedDoc rbd ON rbd.DocId = rccx.DocID
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND DocNumber LIKE '%1010%'


SELECT rcc.RatingClassNumber, rcc.Description, rbd.Name, rccx.IsMandatory
 FROM dbo.RatingClassCode rcc 
JOIN dbo.RuleBasedDocRatingClassCodeXref rccx ON rcc.RatingClassCodeKey = rccx.RatingClassCodeKey
JOIN dbo.RuleBasedDoc rbd ON rbd.DocId = rccx.DocID
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND DocNumber LIKE '%1010%'


SELECT * FROM dbo.RuleBasedDocType 
WHERE BindingAuthority = 1

SELECT * FROM dbo.PremiumBasisCode


SELECT * FROM dbo.RuleBasedDoc WHERE DEPARTMENT_NUMBER = 10006 AND Name LIKE '%service of suit%' --12627

--
-- Service of Suit Comment
--
UPDATE dbo.RuleBasedDocRatingClassCodeXref SET Comment = 'Use State specific form if applicable' WHERE DocID = 12627
go

--
-- DELETE all xrefs for 12647,12637,12638
--
DELETE FROM dbo.RuleBasedDocRatingClassCodeXref
WHERE DocID IN (12647,12637,12638)
GO

INSERT INTO dbo.RuleBasedDocRatingClassCodeXref
        ( DocID ,
          RatingClassCodeKey ,
          IsMandatory ,
          Comment
        )
 SELECT 
 12647, 
 rcc.RatingClassCodeKey,
 0,
 null
 FROM dbo.RatingClassCode rcc 
WHERE 1=1
AND rcc.CoveragePartKey = 2
GO

INSERT INTO dbo.RuleBasedDocRatingClassCodeXref
        ( DocID ,
          RatingClassCodeKey ,
          IsMandatory ,
          Comment
        )
 SELECT 
 12637, 
 rcc.RatingClassCodeKey,
 0,
 null
 FROM dbo.RatingClassCode rcc 
WHERE 1=1
AND rcc.CoveragePartKey = 2
GO

INSERT INTO dbo.RuleBasedDocRatingClassCodeXref
        ( DocID ,
          RatingClassCodeKey ,
          IsMandatory ,
          Comment
        )
 SELECT 
 12638, 
 rcc.RatingClassCodeKey,
 0,
 null
 FROM dbo.RatingClassCode rcc 
WHERE 1=1
AND rcc.CoveragePartKey = 2
GO


UPDATE dbo.PremiumBasisCode SET BasisDescription = 'Admissions' WHERE PremiumBasisKey = 3 AND BasisDescription = 'ADM'
GO