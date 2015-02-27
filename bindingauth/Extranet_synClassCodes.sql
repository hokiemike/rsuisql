

/****** Object:  StoredProcedure [dbo].[usp_Extranet_SyncClassCodes]    Script Date: 08/28/2014 09:50:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[usp_Extranet_SyncClassCodes]

AS

SET NOCOUNT ON

SELECT 
		DISTINCT rcc.IsActive,
				rcc.PRCO_Included,
				prodco.AbbreviatedDescription AS ProdCoDescription,
				rcc.Description,
				rcc.RatingClassSubCode,
				rcc.RatingClassCodeKey,
				rcc.RatingClassNumber, 
				pbc.BasisDescription,
				premops.AbbreviatedDescription AS PremOpsDescription,
				propauth.AbbreviatedDescription AS PropAuthDescription,
				rbdrccx.IsMandatory,
				rbdrccx.Comment,
				baforms.DocId, 
				baforms.DocNumber, 
				baforms.Edition, 
				baforms.Name, 
				baforms.EffDate as EffectiveDate, 
				baforms.FormType AS FormType,
				baforms.DocumentType AS DocType 
FROM vwBAManualForms baforms
JOIN dbo.RuleBasedDocRatingClassCodeXref AS rbdrccx ON rbdrccx.DocID = baforms.DocId
JOIN dbo.RatingClassCode AS rcc ON rcc.RatingClassCodeKey = rbdrccx.RatingClassCodeKey
LEFT OUTER JOIN dbo.PremiumBasisCode pbc ON rcc.PremiumBasisKey = pbc.PremiumBasisKey
LEFT OUTER JOIN dbo.RatingClassCodeAuthIndicator premops ON rcc.PremOpsAuthIndicatorKey = premops.RatingClassCodeAuthIndicatorKey
LEFT OUTER JOIN dbo.RatingClassCodeAuthIndicator prodco ON rcc.ProdCoAuthIndicatorKey = prodco.RatingClassCodeAuthIndicatorKey
LEFT OUTER JOIN dbo.RatingClassCodeAuthIndicator propauth ON rcc.PropAuthIndicatorKey = propauth.RatingClassCodeAuthIndicatorKey
--LEFT OUTER JOIN dbo.RuleBasedDocStateApproval rbdsa ON rbdsa.DocId = baforms.DocId
LEFT OUTER JOIN dbo.RuleBasedDocSubTypeXref rbdsax ON baforms.DocId = rbdsax.DocId
WHERE 1=1
AND rcc.CoveragePartKey != 5
AND (baforms.Admitted IS NULL OR baforms.Admitted = 0)
--AND rcc.RatingClassNumber = 45450
AND baforms.EffDate <= GETDATE()  
AND (baforms.ExpDate IS NULL OR baforms.ExpDate >= GETDATE())
AND baforms.SubTypeId IN (4002,4003,4004)

GO


