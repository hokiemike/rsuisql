SELECT * FROM dbo.RuleBasedDocScenarioRule
SELECT * FROM dbo.RuleBasedDocScenario
SELECT * FROM dbo.RuleBasedDocSubType WHERE Department_Number = 10006


SET IDENTITY_INSERT RuleBasedDocScenario ON
INSERT INTO dbo.RuleBasedDocScenario
        (  ScenarioId,Description, Department_Number )
VALUES  ( 12,
		  'Initial Attach', -- Description - varchar(120)
          10006  -- Department_Number - int
          )
SET IDENTITY_INSERT RuleBasedDocScenario OFF
GO



DELETE FROM dbo.RuleBasedDocScenarioRule WHERE ScenarioId IN (12)
GO

--all
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12599 , 12 ,'attach to all' ,'0 < 1')
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12593 , 12 , 'attach to all' , '0 < 1' )  --jacket
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12595 , 12 , 'attach to all' , '0 < 1' )  --min earned prem
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12619 , 12 , 'attach to all' , '0 < 1' )  --terrorism
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12627 , 12 , 'attach to all' , '0 < 1' )  --service of suit
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12603 , 12 , 'attach to all' , '0 < 1' )  --common policy conditions
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12632 , 12 , 'attach to all' , '0 < 1' )  --nuclear


        
--gl 
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12351 , 12 , 'attach for GL' , 'ctx.HasSelectedCoverage(4002)' )  --dec   
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12459 , 12 , 'attach for GL' , 'ctx.HasSelectedCoverage(4002)' )  --basis of premium (GL)
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12348 , 12 , 'attach for GL' , 'ctx.HasSelectedCoverage(4002)' )  --comml gl cov form (GL)

--pl
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12633 , 12 , 'attach for PL' , 'ctx.HasSelectedCoverage(4004)' )  --pl dec
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12635 , 12 , 'attach for PL' , 'ctx.HasSelectedCoverage(4004)' )  --pl coverage form

--im
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12572 , 12 , 'attach for IM' , 'ctx.HasSelectedCoverage(4005)' )  --im dec
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12563 , 12 , 'attach for IM' , 'ctx.HasSelectedCoverage(4005)' )  --im conditions

--liquor
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12604 , 12 , 'attach for Liquor' , 'ctx.HasSelectedCoverage(4006)' )  --liquor dec
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12586 , 12 , 'attach for Liquor' , 'ctx.HasSelectedCoverage(4006)' )  --liquor cov form

--property
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12653 , 12 , 'attach for Property' , 'ctx.HasSelectedCoverage(4003)' )  --prop conditions
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12640 , 12 , 'attach for Property' , 'ctx.HasSelectedCoverage(4003)' )  --prop dec
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 12650 , 12 , 'attach for Property' , 'ctx.HasSelectedCoverage(4003)' )  --bldg and pers prop cov form
INSERT INTO dbo.RuleBasedDocScenarioRule VALUES  ( 13586 , 12 , 'attach for Property' , 'ctx.HasSelectedCoverage(4003)' )  --total or constructive loss



GO          


SELECT * FROM dbo.RuleBasedDoc WHERE DEPARTMENT_NUMBER = 10006 AND Name LIKE '%total%'

--DELETE FROM dbo.RuleBasedDocScenario WHERE ScenarioId = 9



