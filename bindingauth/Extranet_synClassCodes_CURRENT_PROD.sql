USE [RSUI_PROD]
GO

/****** Object:  StoredProcedure [dbo].[usp_Extranet_SyncClassCodes]    Script Date: 10/28/2014 10:23:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[usp_Extranet_SyncClassCodes]

AS

SET NOCOUNT ON

SELECT DISTINCT rcc.IsActive,
				rcc.PRCO_Included,
				prodco.AbbreviatedDescription AS ProdCoDescription,
				rcc.Description,
				rcc.RatingClassSubCode,
				rcc.RatingClassCodeKey,
				rcc.RatingClassNumber, 
				pbc.BasisDescription,
				premops.AbbreviatedDescription AS PremOpsDescription,
				propauth.AbbreviatedDescription AS PropAuthDescription,
				rccx.IsMandatory,
				rccx.Comment,
				rbd.DocId, 
				rbd.DocNumber, 
				rbd.Edition, 
				rbd.Name, 
				rbd.EffectiveDate,
				CASE WHEN st.DocId IS NOT null THEN 'Interline' 
					 ELSE rbdst.Description 
				END AS FormType,
				rbdt.Description AS DocType 
FROM dbo.RatingClassCode rcc
Left OUTER JOIN dbo.RuleBasedDocRatingClassCodeXref rccx ON rcc.RatingClassCodeKey = rccx.RatingClassCodeKey
--LEFT OUTER JOIN dbo.RuleBasedDoc rbd ON rccx.DocID = rbd.DocId
LEFT OUTER JOIN(
      SELECT rb.DocId AS DocId, rb.DocNumber AS DocNumber, 
      rb.Edition AS Edition, 
      rb.Name AS Name, 
      rb.Department_Number AS Department_Number,
      rb.DocTypeId AS DocTypeId,
      MAX(rbdsa.EffectiveDate) AS EffectiveDate
      FROM dbo.RuleBasedDoc rb 
      JOIN dbo.RuleBasedDocStateApproval rbdsa ON rbdsa.DocId = rb.DocId
      JOIN
      (
            SELECT rbd2.DocNumber AS DocNumber, MAX(rbdsa2.EffectiveDate) AS EffDate
            FROM dbo.RuleBasedDoc rbd2 
            JOIN dbo.RuleBasedDocStateApproval rbdsa2 ON rbd2.DocId = rbdsa2.DocId
            WHERE DEPARTMENT_NUMBER = 10006
            AND rbdsa2.Admitted = 0
            GROUP BY DocNumber
      ) t ON rb.DocNumber = t.DocNumber AND rbdsa.EffectiveDate = t.EffDate
      WHERE 1=1
      AND rb.DEPARTMENT_NUMBER = 10006
      AND rbdsa.Admitted = 0
      GROUP BY rb.DocId, rb.DocNumber, rb.Edition, rb.Name, rb.Department_Number, rb.DocTypeId
) rbd ON rccx.DocID = rbd.DocId
LEFT OUTER JOIN
(
      SELECT rbd.DocId AS DocId,COUNT(*) AS cnt
      FROM dbo.RuleBasedDoc rbd
      JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
      JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
      WHERE 1=1
      AND rbd.DEPARTMENT_NUMBER = 10006
      AND rbd.Docid IN ( SELECT rbd2.DocId FROM dbo.RuleBasedDoc rbd2 
                  JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
                  JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
                  WHERE rbdstx.SubTypeId IN (4002, 4003)
            )
      GROUP BY rbd.DocId 
      HAVING COUNT(*) > 1
) st ON rbd.DocId = st.DocId
LEFT OUTER JOIN dbo.PremiumBasisCode pbc ON rcc.PremiumBasisKey = pbc.PremiumBasisKey
LEFT OUTER JOIN dbo.RatingClassCodeAuthIndicator premops ON rcc.PremOpsAuthIndicatorKey = premops.RatingClassCodeAuthIndicatorKey
LEFT OUTER JOIN dbo.RatingClassCodeAuthIndicator prodco ON rcc.ProdCoAuthIndicatorKey = prodco.RatingClassCodeAuthIndicatorKey
LEFT OUTER JOIN dbo.RatingClassCodeAuthIndicator propauth ON rcc.PropAuthIndicatorKey = propauth.RatingClassCodeAuthIndicatorKey
LEFT OUTER JOIN dbo.RuleBasedDocStateApproval rbdsa ON rbdsa.DocId = rbd.DocId
LEFT OUTER JOIN dbo.RuleBasedDocSubTypeXref rbdsax ON rbd.DocId = rbdsax.DocId
LEFT OUTER JOIN dbo.RuleBasedDocSubType rbdst ON rbdsax.SubTypeId = rbdst.SubTypeId
LEFT OUTER JOIN dbo.RuleBasedDocType AS rbdt ON rbd.DocTypeId = rbdt.DocTypeId
WHERE 1=1
AND (rbd.DEPARTMENT_NUMBER is null OR rbd.DEPARTMENT_NUMBER = 10006)
AND rcc.CoveragePartKey != 5
AND (rbdsa.Admitted IS NULL OR rbdsa.Admitted = 0)
AND (rbdsa.STATE_ABBREVIATION IS NULL OR rbdsa.STATE_ABBREVIATION = 'GA')
ORDER BY rcc.RatingClassNumber, rbd.DocNumber, DocType





GO


