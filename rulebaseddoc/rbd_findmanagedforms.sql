 select distinct rbd.DocId, rbdsr.RuleScript
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        join RuleBasedDocScenarioRule rbdsr on rbd.DocId = rbdsr.DocId 
        join RuleBasedDocScenario rbds on rbdsr.ScenarioId = rbds.ScenarioId 
        join RuleBasedDocSubTypeXref rbdstx on rbd.DocId = rbdstx.DocId
      where 1=1
        and rbd.Department_Number = 10006 
        and rbds.ScenarioId = (103) --issuance managed
        and rbdsa.State_Abbreviation in ('GA')
        and rbdsa.EffectiveDate <= '7/1/2014'
        and (rbdsa.ExpirationDate is null or rbdsa.ExpirationDate > '7/1/2014')
        and rbdsa.Admitted = 0
        and rbds.Department_Number = 10006 
        and rbdstx.SubTypeId IN (4002,4003,4004,4005,4036)
        
 select distinct rbd.DocId, rbd.DocNumber, rbd.Edition, rbd.Name, 
 rbdt.Description AS DocType, rbdsr.RuleScript, rbdsr.Description
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        join RuleBasedDocScenarioRule rbdsr on rbd.DocId = rbdsr.DocId 
        join RuleBasedDocScenario rbds on rbdsr.ScenarioId = rbds.ScenarioId 
        join RuleBasedDocSubTypeXref rbdstx on rbd.DocId = rbdstx.DocId
        JOIN dbo.RuleBasedDocType AS rbdt ON rbdt.DocTypeId = rbd.DocTypeId
      where 1=1
        and rbd.Department_Number = 10006 
        and rbd.DocTypeId IN (303, 304)
        and rbds.ScenarioId = (103) --issuance managed
        and rbdsa.State_Abbreviation in ('GA')
        and rbdsa.EffectiveDate <= '7/1/2014'
        and (rbdsa.ExpirationDate is null or rbdsa.ExpirationDate > '7/1/2014')
        and rbdsa.Admitted = 0
        and rbds.Department_Number = 10006 
        and rbdstx.SubTypeId IN (4002,4003,4004,4005,4036)

DELETE from dbo.RuleBasedDocScenarioRule WHERE ScenarioId = 123 and docid IN (16085)

select distinct rbd.DocId,
                rbd.DocNumber,
                rbd.Edition,
                rbd.Name,
                rbdt.Description  AS DocType,
                rbdsr.RuleScript,
                rbdsr.Description as RuleDescription
from   RuleBasedDoc rbd
       join RuleBasedDocStateApproval rbdsa
         on rbd.DocId = rbdsa.DocId
       join RuleBasedDocScenarioRule rbdsr
         on rbd.DocId = rbdsr.DocId
       join RuleBasedDocScenario rbds
         on rbdsr.ScenarioId = rbds.ScenarioId
       join RuleBasedDocSubTypeXref rbdstx
         on rbd.DocId = rbdstx.DocId
       JOIN dbo.RuleBasedDocType AS rbdt
         ON rbdt.DocTypeId = rbd.DocTypeId
where  1 = 1
       and rbd.Department_Number = 10006
       and rbd.DocTypeId IN (303, 304)
       and rbds.ScenarioId = (123) --issuance managed
       and rbdsa.State_Abbreviation in ('GA' /* @p0 */)
       and rbdsa.EffectiveDate <= '2014-07-01T00:00:00' /* @p1 */
       and (rbdsa.ExpirationDate is null
             or rbdsa.ExpirationDate > '2014-07-01T00:00:00' /* @p1 */)
       and rbdsa.Admitted = 0
       and rbds.Department_Number = 10006
       and rbdstx.SubTypeId IN (4002 /* @p3 */, 4003 /* @p4 */)

select distinct rbd.*
      from RuleBasedDoc rbd
        join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
        join RuleBasedDocRatingClassCodeXref rccx ON rbdsa.DocId = rccx.DocID
        join dbo.RuleBasedDocSubTypeXref stx ON rbd.DocId = stx.DocId
        LEFT OUTER JOIN RuleBasedDocScenarioRule rbdsr ON rbd.DocId = rbdsr.DocId
      where 1=1
        and rbdsr.ScenarioRuleId IS NULL
        and rbd.DocTypeId IN (303, 304)
        and rbd.Department_Number = 10006 
        and rccx.RatingClassCodeKey IN (1233,1224) --this is actually rating codenumber/subnumber {61226,3} and {68001,1}
        and rbdsa.State_Abbreviation in ('GA')
        and rbdsa.EffectiveDate <= '7/1/2014'
        and (rbdsa.ExpirationDate is null or rbdsa.ExpirationDate > '7/1/2014')
        and rbdsa.Admitted = 0
        and rccx.IsMandatory = 1
        and stx.SubTypeId in (4002,4003) --GL and Property
       
       
select distinct rbd.*
from   RuleBasedDoc rbd
       join RuleBasedDocStateApproval rbdsa
         on rbd.DocId = rbdsa.DocId
       join RuleBasedDocRatingClassCodeXref rccx
         ON rbdsa.DocId = rccx.DocID
       join dbo.RuleBasedDocSubTypeXref stx
         ON rbd.DocId = stx.DocId
       LEFT OUTER JOIN RuleBasedDocScenarioRule rbdsr
         ON rbd.DocId = rbdsr.DocId
where  1 = 1
       and rbdsr.ScenarioRuleId IS NULL
       and rbd.DocTypeId IN (303, 304)
       and rbd.Department_Number = 10006
       and rccx.RatingClassCodeKey IN (4002 /* @p0 */, 4003 /* @p1 */)
       and rbdsa.State_Abbreviation = 'GA' /* @p2 */
       and rbdsa.EffectiveDate <= '2014-07-01' /* @p3 */
       and (rbdsa.ExpirationDate is null
             or rbdsa.ExpirationDate > '2014-07-01' /* @p3 */)
       and rbdsa.Admitted = 012
       and rccx.IsMandatory = 1
       and stx.SubTypeId in (4002 /* @p5 */, 4003 /* @p6 */)       


SELECT * FROM dbo.RuleBasedDocScenario AS rbds

--class codes
SELECT DISTINCT rcc.RatingClassCodeKey, rcc.RatingClassNumber, rcc.RatingClassSubCode, rcc.Description, rcc.PRCO_Included,
 premops.AbbreviatedDescription, prodco.AbbreviatedDescription, propauth.AbbreviatedDescription
FROM dbo.RatingClassCode AS rcc 
LEFT OUTER JOIN dbo.RatingClassCodeAuthIndicator AS premops ON premops.RatingClassCodeAuthIndicatorKey = rcc.PremOpsAuthIndicatorKey
LEFT OUTER JOIN dbo.RatingClassCodeAuthIndicator AS prodco ON prodco.RatingClassCodeAuthIndicatorKey = rcc.ProdCoAuthIndicatorKey
LEFT OUTER JOIN dbo.RatingClassCodeAuthIndicator AS propauth ON propauth.RatingClassCodeAuthIndicatorKey = rcc.PropAuthIndicatorKey
WHERE rcc.IsActive = 1 AND rcc.CoveragePartKey = 2
ORDER BY rcc.RatingClassNumber

INSERT INTO [RuleBasedDocScenario]
           ([Description]
           ,[Department_Number])
     VALUES
           ('Quote Managed',10006)
GO


ALTER TABLE BuildingCoverageCode ADD LookupValue VARCHAR(50)
GO

ALTER TABLE BuildingCoverageCode ADD LookupCode VARCHAR(8)
GO


SELECT * FROM dbo.RuleBasedDocScenario AS rbds WHERE Department_Number = 10006

SELECT * FROM dbo.RuleBasedDocScenarioRule AS rbds WHERE ScenarioId = 123

SELECT * FROM dbo.RuleBasedDocSubType AS rbdst
WHERE Department_Number = 10006


SELECT * FROM dbo.BuildingCoverageCode AS bcc

SELECT * FROM dbo.PIPLookupCategory AS plc


SELECT * FROM dbo.PIPLookupItem AS pli WHERE pli.PIPLookupCategoryId = 16 --im coverages

SELECT * FROM dbo.PIPLookupItem AS pli WHERE pli.PIPLookupCategoryId = 34 --valuation basis

SELECT * FROM dbo.PIPLookupCategory AS plc

SELECT * FROM dbo.INLAND_MARINE_CLASS AS imc WHERE IsCoverage = 1

SELECT * FROM dbo.CauseOfLossCode AS colc

SELECT * FROM dbo.BuildingCoverageCode AS bcc

SELECT * FROM dbo.RuleBasedDocScenario AS rbds WHERE Description = 'Quote Managed'

