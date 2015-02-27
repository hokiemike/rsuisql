
SELECT * FROM dbo.RuleBasedDoc rbd1
JOIN dbo.RuleBasedDoc rbd2 ON 
(rbd1.DocNumber = rbd2.DocNumber AND rbd1.DEPARTMENT_NUMBER = rbd2.DEPARTMENT_NUMBER AND rbd1.Edition = rbd2.Edition)
WHERE 1=1
AND rbd1.DocNumber IS NOT NULL 
AND rbd1.DocNumber != ' '
AND rbd1.DocId != rbd2.DocId

SELECT * FROM dbo.RuleBasedDoc rbd
JOIN dbo.RuleBasedDocStateApproval rbdsa ON rbd.DocId = rbdsa.DocId
WHERE rbd.name LIKE '%bar%'
AND rbdsa.EffectiveDate <= '5/6/2010'

SELECT * FROM dbo.RuleBasedDocStateApproval
WHERE DocId IN (13721, 12330)


SELECT * FROM dbo.RuleBasedDoc WHERE Name LIKE '%bar%'
SELECT * FROM dbo.RuleBasedDocSubTypeXref WHERE docid IN (13720,13721)

SELECT * FROM dbo.RuleBasedDocSubType WHERE Department_Number = 10006


SELECT  DocNumber, Edition, DEPARTMENT_NUMBER, DocTypeId,  COUNT(DocId)
 FROM dbo.RuleBasedDoc
WHERE 1=1
AND DEPARTMENT_NUMBER = 10006
GROUP BY DocNumber, Edition, DEPARTMENT_NUMBER, DocTypeId
HAVING COUNT(DocId) > 1

SELECT * FROM dbo.RuleBasedDocType