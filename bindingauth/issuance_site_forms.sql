SELECT  pipvr.* ,
        pipcp.PIPCommonPolicyDeclarationId
FROM    dbo.PIPCommonPolicyDeclaration pipcp
        JOIN dbo.PIPPolicyValidation pipv ON pipcp.PIPCommonPolicyDeclarationId = pipv.PIPCommonPolicyDeclarationId
        JOIN dbo.PIPValidationRule pipvr ON pipv.PIPValidationCode = pipvr.PIPValidationCode
WHERE   CreatedDate > '3/1/2010'


SELECT * FROM PIPPolicyValidation WHERE PIPCommonPolicyDeclarationId = 19

--INSERT INTO PIPPolicyValidation VALUES (19,1002)
--INSERT INTO PIPPolicyValidation VALUES (19,1003)
--INSERT INTO PIPPolicyValidation VALUES (19,1005)
--INSERT INTO PIPPolicyValidation VALUES (19,1007)
--INSERT INTO PIPPolicyValidation VALUES (19,1060)
--go

SELECT * FROM dbo.PIPValidationRule

SELECT * FROM dbo.RuleBasedDoc WHERE DocNumber LIKE '%909003%'

select distinct rbdsa.Admitted, rbd.*, rbdsr.*
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        join RuleBasedDocScenarioRule rbdsr on rbd.DocId = rbdsr.DocId 
        join RuleBasedDocScenario rbds on rbdsr.ScenarioId = rbds.ScenarioId 
      where 1=1
        and rbd.Department_Number = 10006 
        and rbds.Description = 'Initial Attach'
        and rbdsa.EffectiveDate <= '6/10/2010 12:00:00 AM'
        and (rbdsa.ExpirationDate is null or rbdsa.ExpirationDate > '6/10/2010 12:00:00 AM')
        and rbdsa.Admitted = 'False'


select distinct rbd.*, rbdsr.*
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        join RuleBasedDocScenarioRule rbdsr on rbd.DocId = rbdsr.DocId 
        join RuleBasedDocScenario rbds on rbdsr.ScenarioId = rbds.ScenarioId 
      where 1=1
        and rbd.Department_Number = 10006 
        and rbds.Description = 'Mandatory'
        and rbdsa.EffectiveDate <= '6/1/2010 12:00:00 AM'
        and (rbdsa.ExpirationDate is null or rbdsa.ExpirationDate > '6/1/2010 12:00:00 AM')
        and rbdsa.Admitted = 'False'
        
        
 select distinct rbdsa.*
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        WHERE rbd.DEPARTMENT_NUMBER = 10006
        AND rbdsa.Admitted = 0
        --AND rbd.DocId IN (12623)
        
        
select distinct rbdsa.*
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        WHERE rbd.DEPARTMENT_NUMBER = 10006
        AND rbdsa.Admitted = 1
        
SELECT * FROM dbo.RuleBasedDoc WHERE DocNumber like '%0438%'

select distinct rbd.*, rbdsr.*
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        join RuleBasedDocScenarioRule rbdsr on rbd.DocId = rbdsr.DocId 
        join RuleBasedDocScenario rbds on rbdsr.ScenarioId = rbds.ScenarioId 
      where 1=1
        and rbd.Department_Number = 10006
        and rbds.Description = 'Mandatory'
        and rbdsa.EffectiveDate <= '6/1/2010 12:00:00 AM'
        and (rbdsa.ExpirationDate is null or rbdsa.ExpirationDate > '6/1/2010 12:00:00 AM')
        and rbdsa.Admitted = 'False'
        
select distinct rbdsa.*
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        WHERE rbd.DEPARTMENT_NUMBER = 10006
        AND rbd.DocId IN (12619)
        


