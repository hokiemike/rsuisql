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
AND rcc.PropAuthIndicatorKey != 2
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
AND rcc.PropAuthIndicatorKey != 2
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
AND rcc.PropAuthIndicatorKey != 2
GO


UPDATE dbo.PremiumBasisCode SET BasisDescription = 'Admissions' WHERE PremiumBasisKey = 3 AND BasisDescription = 'ADM'
GO