USE [RSUI_PROD]
GO

/****** Object:  View [dbo].[vwPIPDocsByFormType]    Script Date: 10/24/2014 09:47:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[vwPIPDocsByFormType]
AS

SELECT DISTINCT 
    rbd.DocId,
    rbd.DocNumber,
    rbd.Edition,
    rbd.Name,
    rbd.DocTypeId,
    rbdt.Description as DocumentType,
    CASE WHEN st.DocId IS NOT null THEN 'Interline' ELSE rbdst.Description END AS FormType,
    rbd.AllowMultiple,
    rbd.RequiresUserInput,
    rbd.IssuanceOnly,
    rbdsa.Admitted,
    rbd.SystemManaged,
    rbd.EndorsementSystemManaged,
    t.EffDate,
    t.ExpDate
    FROM dbo.RuleBasedDoc rbd 
      JOIN dbo.RuleBasedDocStateApproval rbdsa ON rbdsa.DocId = rbd.DocId
      JOIN dbo.RuleBasedDocType rbdt ON rbd.DocTypeId = rbdt.DocTypeId
      JOIN dbo.RuleBasedDocSubTypeXref rbdsx ON rbdsx.DocId = rbd.DocId
      JOIN dbo.RuleBasedDocSubType rbdst ON rbdsx.SubTypeId = rbdst.SubTypeId
      JOIN
      (
            SELECT rbd2.docId, rbd2.DocNumber AS DocNumber, Min(rbdsa2.EffectiveDate) AS EffDate, MAX(ISNULL(rbdsa2.ExpirationDate, '12/31/9999')) AS ExpDate
            , rbdsa2.Admitted
            FROM dbo.RuleBasedDoc rbd2 
            JOIN dbo.RuleBasedDocStateApproval rbdsa2 ON rbd2.DocId = rbdsa2.DocId
            WHERE 1=1
            AND rbd2.DEPARTMENT_NUMBER = 10006
            GROUP BY rbd2.DocId, DocNumber, rbdsa2.Admitted
            --HAVING MAX(ISNULL(rbdsa2.ExpirationDate, '12/31/9999')) > GETDATE()
      ) t ON rbd.DocId = t.DocId AND rbdsa.Admitted = t.Admitted --AND rbdsa.EffectiveDate = t.EffDate
      LEFT OUTER JOIN
      (
              SELECT DISTINCT rbd.DocId AS DocId
              FROM dbo.RuleBasedDoc rbd
              JOIN dbo.RuleBasedDocSubTypeXref rbdstx ON rbd.DocId = rbdstx.DocId
              JOIN dbo.RuleBasedDocSubType rbdst ON rbdstx.SubTypeId = rbdst.SubTypeId
              WHERE 1=1
              AND rbd.DEPARTMENT_NUMBER = 10006
              AND EXISTS (SELECT 1 FROM dbo.RuleBasedDocSubTypeXref rbdstx2
                                WHERE rbdstx2.SubTypeId = 4002
                                AND rbdstx2.DocId = rbd.DocId)
              AND EXISTS (SELECT 1 FROM dbo.RuleBasedDocSubTypeXref rbdstx3
                                WHERE rbdstx3.SubTypeId = 4003
                                AND rbdstx3.DocId = rbd.DocId)
      ) st ON rbd.DocId = st.DocId
      WHERE 1=1
      AND rbd.DEPARTMENT_NUMBER = 10006





GO


