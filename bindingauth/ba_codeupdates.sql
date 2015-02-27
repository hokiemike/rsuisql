


--
-- (2) remove GL docs from codes where GL is prohibited
--
DELETE rrcx
FROM dbo.RuleBasedDocRatingClassCodeXref rrcx
JOIN  dbo.RatingClassCode rcc ON rrcx.RatingClassCodeKey = rcc.RatingClassCodeKey
WHERE 1=1
AND docid IN (12459, 12348, 12351, 12540, 12541, 13578)
AND rcc.PremOpsAuthIndicatorKey = 2 AND rcc.ProdCoAuthIndicatorKey = 2
GO

--
-- (3) remove prop docs from codes where property is prohibited
--
DELETE rrcx 
FROM dbo.RuleBasedDocRatingClassCodeXref rrcx
JOIN  dbo.RatingClassCode rcc ON rrcx.RatingClassCodeKey = rcc.RatingClassCodeKey
WHERE 1=1
AND docid IN (12650, 12640, 12653)
AND rcc.PropAuthIndicatorKey = 2
GO

--
--  (4) insert row for doc CG 2104 (12378) into xref for every code that allows premises but prohibits proudcts
--
INSERT INTO dbo.RuleBasedDocRatingClassCodeXref
        ( DocID ,
          RatingClassCodeKey ,
          IsMandatory ,
          Comment
        )
SELECT 12378, RatingClassCodeKey, 1, null  
FROM dbo.RatingClassCode 
WHERE PremOpsAuthIndicatorKey != 2 AND ProdCoAuthIndicatorKey = 2
GO

--
-- (5) insert row for doc CG 404012 (13586) into xref for every code that allows property
--
INSERT INTO dbo.RuleBasedDocRatingClassCodeXref
        ( DocID ,
          RatingClassCodeKey ,
          IsMandatory ,
          Comment
        )
SELECT 13586,RatingClassCodeKey, 1, null 
FROM dbo.RatingClassCode WHERE PropAuthIndicatorKey != 2
GO


--SELECT * FROM dbo.RatingClassCode WHERE PremOpsAuthIndicatorKey != 2 AND ProdCoAuthIndicatorKey = 2

--SELECT * FROM dbo.RatingClassCode WHERE PropAuthIndicatorKey !=2

--SELECT * FROM dbo.RatingClassCodeAuthIndicator

--SELECT * FROM dbo.RuleBasedDocScenarioRule WHERE RuleScript LIKE '%hasinlandmarine2%'