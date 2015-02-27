UPDATE dbo.RuleBasedDocRatingClassCodeXref
SET IsMandatory = 0, Comment = 'This form is mandatory if not using state-specific version'
WHERE DocId = 12627
AND IsMandatory = 1 AND Comment IS NOT NULL
go

UPDATE dbo.RuleBasedDocRatingClassCodeXref
SET IsMandatory = 0, Comment = 'This form is mandatory if not using state-specific version'
WHERE DocId = 12603
AND IsMandatory = 1 AND Comment IS NOT NULL
go

--SELECT * FROM dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx WHERE DocID IN ( 12627, 12603) AND IsMandatory = 0
