SELECT * FROM dbo.RuleBasedDocScenario AS rbds WHERE rbds.Department_Number = 10006

SELECT rbdsr.RuleScript, rbdsr.ScenarioRuleId, rbd.* 
FROM dbo.RuleBasedDocScenarioRule AS rbdsr
JOIN dbo.RuleBasedDoc AS rbd ON rbdsr.DocId = rbd.DocId
WHERE rbdsr.ScenarioId = 123

SELECT * FROM dbo.RuleBasedDoc AS rbd
WHERE rbd.Name LIKE '%service of suit%'
AND rbd.DEPARTMENT_NUMBER = 10006


SELECT DISTINCT TOP 1000  [ScenarioRuleId]
      ,a.[DocId]
	  ,b.DocumentType
	  ,b.DocNumber
	  ,b.Edition
	  ,b.Name
      ,[ScenarioId]
      ,[Description]
      ,[RuleScript]
  FROM [DEV3].[dbo].[RuleBasedDocScenarioRule] a 
  JOIN vwBAForms b  ON a.DocId = b.DocId 
  WHERE a.ScenarioId = 103 /* scenario id for Issuance Managed and department 10006*/
    AND 
    AND DocTypeId IN (304, 306) /* Form, Dec Page */


UPDATE RuleBasedDocRatingClassCodeXref SET IsMandatory=0, Comment='Required if TRIA is Accepted.'
WHERE DocID = 16551 AND IsMandatory=1
go

SELECT DISTINCT rbdsr.RuleScript AS quoterule, rbd.* 
FROM dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx
JOIN dbo.RuleBasedDoc AS rbd ON rbd.DocId = rbdrccx.DocID
JOIN dbo.RuleBasedDocScenarioRule AS rbdsr ON rbdsr.DocId = rbd.DocId
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND rbdrccx.IsMandatory = 1
AND rbdsr.ScenarioId = 103
AND rbd.DocId IN (
SELECT rbd.DocId
FROM dbo.RuleBasedDocScenarioRule AS rbdsr
JOIN dbo.RuleBasedDoc AS rbd ON rbdsr.DocId = rbd.DocId
WHERE rbdsr.ScenarioId = 103 )

SELECT DISTINCT rbdsr.RuleScript AS quoterule, rbd.* 
FROM dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx
JOIN dbo.RuleBasedDoc AS rbd ON rbd.DocId = rbdrccx.DocID
JOIN dbo.RuleBasedDocScenarioRule AS rbdsr ON rbdsr.DocId = rbd.DocId
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND rbdrccx.IsMandatory = 1
AND rbdsr.ScenarioId = 103

SELECT DISTINCT rbd.* 
FROM dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx
JOIN dbo.RuleBasedDoc AS rbd ON rbd.DocId = rbdrccx.DocID
--JOIN dbo.RuleBasedDocScenarioRule AS rbdsr ON rbdsr.DocId = rbd.DocId
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND rbdrccx.IsMandatory = 1
--AND rbdsr.ScenarioId = 103

SELECT DISTINCT baf.*
FROM dbo.vwBAForms baf
JOIN dbo.RuleBasedDocRatingClassCodeXref rbdrccx ON baf.DocId = rbdrccx.DocID
JOIN dbo.RatingClassCode rcc ON rbdrccx.RatingClassCodeKey = rcc.RatingClassCodeKey
WHERE 1=1
AND GETDATE() < ISNULL(baf.ExpirationDate,'2099-01-01')
AND Admitted = 0
AND rbdrccx.IsMandatory = 1
AND baf.DocTypeId NOT IN (302,309)
AND baf.DocId NOT IN (
SELECT rbd.DocId
FROM dbo.RuleBasedDocScenarioRule AS rbdsr
JOIN dbo.RuleBasedDoc AS rbd ON rbdsr.DocId = rbd.DocId
WHERE rbdsr.ScenarioId = 103 )

SELECT DISTINCT rcc.*
FROM dbo.vwBAForms baf
JOIN dbo.RuleBasedDocRatingClassCodeXref rbdrccx ON baf.DocId = rbdrccx.DocID
JOIN dbo.RatingClassCode rcc ON rbdrccx.RatingClassCodeKey = rcc.RatingClassCodeKey
WHERE baf.DocId = 13560



SELECT DISTINCT rbdsr.RuleScript AS quoterule
, b.EffectiveDate
, b.ExpirationDate
, rbd.* 
FROM dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx
JOIN dbo.RuleBasedDoc AS rbd ON rbd.DocId = rbdrccx.DocID
JOIN dbo.RuleBasedDocScenarioRule AS rbdsr ON rbdsr.DocId = rbd.DocId
LEFT OUTER JOIN vwBAForms b ON rbd.DocId = b.DocId
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND rbdrccx.IsMandatory = 1
AND rbdsr.ScenarioId = 103
AND b.ExpirationDate > '2015-01-09' -- only need active ones
AND rbd.DocId NOT IN (
SELECT rbd.DocId
FROM dbo.RuleBasedDocScenarioRule AS rbdsr
JOIN dbo.RuleBasedDoc AS rbd ON rbdsr.DocId = rbd.DocId
WHERE rbdsr.ScenarioId = 123 )
ORDER BY rbd.DocNumber

--
-- issuance managed
--
SELECT DISTINCT rbdsr.RuleScript AS quoterule, rbd.* 
FROM dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx
JOIN dbo.RuleBasedDoc AS rbd ON rbd.DocId = rbdrccx.DocID
JOIN dbo.RuleBasedDocScenarioRule AS rbdsr ON rbdsr.DocId = rbd.DocId
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND rbdrccx.IsMandatory = 1
AND rbdsr.ScenarioId = 123
AND rbd.DocId IN (
SELECT rbd.DocId
FROM dbo.RuleBasedDocScenarioRule AS rbdsr
JOIN dbo.RuleBasedDoc AS rbd ON rbdsr.DocId = rbd.DocId
WHERE rbdsr.ScenarioId = 123 )


SELECT DISTINCT rbdsr.RuleScript AS quoterule, rbd.* 
FROM dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx
JOIN dbo.RuleBasedDoc AS rbd ON rbd.DocId = rbdrccx.DocID
JOIN dbo.RuleBasedDocScenarioRule AS rbdsr ON rbdsr.DocId = rbd.DocId
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND rbdrccx.IsMandatory = 1
AND rbdsr.ScenarioId = 103
AND rbd.DocId IN (
SELECT rbd.DocId
FROM dbo.RuleBasedDocScenarioRule AS rbdsr
JOIN dbo.RuleBasedDoc AS rbd ON rbdsr.DocId = rbd.DocId
WHERE rbdsr.ScenarioId = 103 )





SELECT DISTINCT rbd.* 
FROM dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx
JOIN dbo.RuleBasedDoc AS rbd ON rbd.DocId = rbdrccx.DocID
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND rbdrccx.IsMandatory = 1


SELECT DISTINCT rcc2.* 
FROM dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx
JOIN dbo.RuleBasedDoc AS rbd ON rbd.DocId = rbdrccx.DocID
JOIN dbo.RatingClassCode AS rcc2 ON rcc2.RatingClassCodeKey = rbdrccx.RatingClassCodeKey
WHERE 1=1
AND rbd.DEPARTMENT_NUMBER = 10006
AND rbdrccx.IsMandatory = 1
AND rbd.DocId = 13322



select distinct  rbd.DocId as DocId, rbd.DocNumber as DocNumber, 
                  rbd.Edition As Edition, rbd.Name as Name, 
                  rbdt.Description AS DocType,rccx.IsMandatory
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        join RuleBasedDocRatingClassCodeXref rccx ON rbdsa.DocId = rccx.DocID
        join dbo.RuleBasedDocSubTypeXref stx ON rbd.DocId = stx.DocId
        LEFT OUTER JOIN RuleBasedDocScenarioRule rbdsr ON rbd.DocId = rbdsr.DocId
        JOIN dbo.RuleBasedDocType AS rbdt ON rbdt.DocTypeId = rbd.DocTypeId
        JOIN dbo.RatingClassCode AS rcc ON rcc.RatingClassCodeKey = rccx.RatingClassCodeKey
      where 1=1
        and rbd.DocTypeId IN (303, 304)
        and rbd.Department_Number = 10006 
        AND rcc.RatingClassNumber = 60010
        and rbdsa.State_Abbreviation = 'GA'
        and rbdsa.EffectiveDate <= '7/2/2014' 
        and (rbdsa.ExpirationDate is null or rbdsa.ExpirationDate > '7/2/2014')
        and rbdsa.Admitted = 0
        and stx.SubTypeId in (4002,4003)

