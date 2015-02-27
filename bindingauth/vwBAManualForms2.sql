

DROP VIEW [vwBAForms]

/****** Object:  View [dbo].[vwPIPDocsByFormType]    Script Date: 10/28/2014 11:07:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vwBAForms]
AS

SELECT DISTINCT 
    rbd.DocId,
    rbd.DocNumber,
    rbd.Edition,
    rbd.Name,
    rbd.DocTypeId,
    rbdt.Description as DocumentType,
    ( CASE
		WHEN (select COUNT(rbdstx2.DocSubTypeXrefId)
				FROM dbo.RuleBasedDocSubTypeXref rbdstx2
				JOIN dbo.RuleBasedDocSubType rbdst2 ON rbdst2.SubTypeId = rbdstx2.SubTypeId
				WHERE rbdstx2.SubTypeId IN (4002,4003)
				AND rbdstx2.DocId = rbd.DocId) > 1 
			THEN 'Interline'
		WHEN ( select COUNT(rbdstx2.DocSubTypeXrefId)
				FROM dbo.RuleBasedDocSubTypeXref rbdstx2
				WHERE rbdstx2.SubTypeId IN (4002,4004,4005,4006,4036)
				AND rbdstx2.DocId = rbd.DocId) > 1				 
			THEN 'GL'
		WHEN ( select COUNT(rbdstx2.DocSubTypeXrefId)
				FROM dbo.RuleBasedDocSubTypeXref rbdstx2
				WHERE rbdstx2.SubTypeId IN (4004,4005,4006,4036)
				AND rbdstx2.DocId = rbd.DocId) > 1				 
			THEN 'GL'
		ELSE
			'Undetermined'
		END
	 ) AS FormType,
    rbd.AllowMultiple,
    rbd.RequiresUserInput,
    rbd.IssuanceOnly,
    rbdsa.Admitted,
    rbd.SystemManaged,
    rbd.EndorsementSystemManaged,
    t.EffDate AS EffectiveDate,
    t.ExpDate AS ExpirationDate
    FROM dbo.RuleBasedDoc rbd 
      JOIN dbo.RuleBasedDocStateApproval rbdsa ON rbdsa.DocId = rbd.DocId
      JOIN dbo.RuleBasedDocType rbdt ON rbd.DocTypeId = rbdt.DocTypeId
      JOIN
      (
            SELECT rbd2.docId, rbd2.DocNumber AS DocNumber, Min(rbdsa2.EffectiveDate) AS EffDate, MAX(ISNULL(rbdsa2.ExpirationDate, '12/31/9999')) AS ExpDate
            , rbdsa2.Admitted
            FROM dbo.RuleBasedDoc rbd2 
            JOIN dbo.RuleBasedDocStateApproval rbdsa2 ON rbd2.DocId = rbdsa2.DocId
            WHERE 1=1
            AND rbd2.DEPARTMENT_NUMBER = 10006
            GROUP BY rbd2.DocId, DocNumber, rbdsa2.Admitted
      ) t ON rbd.DocId = t.DocId AND rbdsa.Admitted = t.Admitted --AND rbdsa.EffectiveDate = t.EffDate
      WHERE 1=1
      AND rbd.DEPARTMENT_NUMBER = 10006






GO


