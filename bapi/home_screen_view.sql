USE [RSMSMIRROR]
GO

/****** Object:  View [dbo].[vwPIPPolicyAndEndorsementView]    Script Date: 01/20/2014 14:09:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--search / grid view
ALTER VIEW [dbo].[vwPIPPolicyAndEndorsementView]
AS
/* BA policies which are in the PIP tables and do not have endorsements */ 
SELECT DISTINCT
        pcpd.PIPCommonPolicyDeclarationId AS PolicyId ,
        pcpd.CompanyCode
        + pcpd.PolicySymbol
        + REPLACE(STR(pcpd.PolicyNumber, 6),
                  ' ', '0') + ' '
        + REPLACE(STR(pcpd.PolicySuffix, 2),
                  ' ', '0') AS PolicyNumber ,
        'Type' = CASE WHEN pcpd.ReadOnlyCopy = 0 /*this is used because when we endorse we are creating a policy that is readonly and we want it to appear as a docucorp policy*/
                      THEN 'Policy'
                      ELSE 'DocuCorp'
                 END ,
        pcpd.LocationSKey ,
        loc.INTERNAL_NAME AS Location ,
        pcpd.EffectiveDate AS EffectiveDate ,
        pcpd.InsuredName AS InsuredName ,
        p.LAST_NAME + ', ' + p.FIRST_NAME AS CreatedBy ,
        pu.LAST_NAME + ', '
        + pu.FIRST_NAME AS Underwriter ,
        pcpd.CreatedDate AS CreatedAt ,
        pcpd.CreatedByPeopleSKey AS CreatedById ,
        pcpd.StatusCode AS StatusCode ,
        pcpd.IssuedDate AS IssuedDate ,
        'Company_Skey' = CASE
                          WHEN pcpd.LocationSKey IS NOT NULL
                          THEN loc.COMPANY_SKEY
                          ELSE lc.COMPANY_SKEY
                         END ,
        pcpd.CreatedByPeopleSKey AS PeopleSkey ,
        pcpd.UnderwriterPeopleSKey ,
        NULL AS EndorsementId ,
        NULL AS EndorsementTypeId,
        loc.IsELANY ,
        'SubRecordNumber' = CASE
                          WHEN pcpd.ReadOnlyCopy = 0 /*this is used because when we endorse we are creating a policy that is readonly and we want it to appear as a docucorp policy*/
                          THEN NULL
                          ELSE pcpd.SUB_RECORD_NUMBER
                          END,
		pcpd.DepartmentNumber,
		pcpd.ProgramKey,
		ISNULL(a.AddressLine1,'') + ' ' + ISNULL(a.AddressLine2,'') + '  '+ISNULL(a.City,'') + ', ' + ISNULL(a.STATE_ABBREVIATION,'') + ' ' + ISNULL(a.ZipCode,'') AS Address		
FROM    dbo.PIPCommonPolicyDeclaration pcpd WITH (NOLOCK)
		LEFT OUTER JOIN PIPEndorsement pe ON pe.PIPCommonPolicyDeclarationId = pcpd.PIPCommonPolicyDeclarationId 
		LEFT OUTER JOIN dbo.Address AS a ON pcpd.InsuredAddressKey = a.AddressKey
        LEFT OUTER JOIN dbo.LOCATION loc ON pcpd.LocationSKey = LOCATION_SKEY
        LEFT OUTER JOIN dbo.PEOPLE p ON p.PEOPLE_SKEY = pcpd.CreatedByPeopleSKey
        LEFT OUTER JOIN dbo.PEOPLE_LOCATION pl ON p.PEOPLE_SKEY = pl.PEOPLE_SKEY
        LEFT OUTER JOIN dbo.PEOPLE pu ON pu.PEOPLE_SKEY = pcpd.UnderwriterPeopleSKey
        LEFT OUTER JOIN dbo.LOCATION lc ON pl.LOCATION_SKEY = lc.LOCATION_SKEY

UNION ALL
/* BA policies and endorsements from PIP table for policies with endorsements */
SELECT DISTINCT
        pcpd.PIPCommonPolicyDeclarationId AS PolicyId ,
        pcpd.CompanyCode
        + pcpd.PolicySymbol
        + REPLACE(STR(pcpd.PolicyNumber, 6),
                  ' ', '0') + ' '
        + REPLACE(STR(pcpd.PolicySuffix, 2),
                  ' ', '0') AS PolicyNumber ,
        'End '
        + CASE WHEN e.EndorsementNumber = 0
               THEN '- TBD'
               ELSE LTRIM(RTRIM(STR(e.EndorsementNumber)))
                    + ' - '
                    + pet.Abbreviation
          END AS Type ,
        pcpd.LocationSKey ,
        loc.INTERNAL_NAME AS Location ,
        e.EffectiveDate AS EffectiveDate ,
        pcpd.InsuredName AS InsuredName ,
        p.LAST_NAME + ', ' + p.FIRST_NAME AS CreatedBy ,
        pu.LAST_NAME + ', '
        + pu.FIRST_NAME AS Underwriter ,
        e.CreatedDate AS CreatedAt ,
        'CreatedById' = CASE
                          WHEN e.CreatedByPeopleSKey IS NOT NULL
                          THEN e.CreatedByPeopleSKey
                          ELSE pcpd.CreatedByPeopleSKey
                        END ,
        e.StatusCode AS StatusCode ,
        e.IssuedDate AS IssuedDate ,
        loc.COMPANY_SKEY AS Company_Skey ,
        'PeopleSkey' = CASE
                          WHEN e.CreatedByPeopleSKey IS NOT NULL
                          THEN e.CreatedByPeopleSKey
                          ELSE pcpd.CreatedByPeopleSKey
                       END ,
        pcpd.UnderwriterPeopleSKey ,
        e.PIPEndorsementId AS EndorsementId ,
        e.PIPEndorsementTypeID,
        loc.IsELANY ,
        NULL AS SubRecordNumber,
		pcpd.DepartmentNumber,
		pcpd.ProgramKey,
		ISNULL(a.AddressLine1,'') + ' ' + ISNULL(a.AddressLine2,'') + '  '+ISNULL(a.City,'') + ', ' + ISNULL(a.STATE_ABBREVIATION,'') + ' ' + ISNULL(a.ZipCode,'') AS Address
FROM    PIPEndorsement e WITH (NOLOCK)
        JOIN dbo.PIPCommonPolicyDeclaration pcpd ON pcpd.PIPCommonPolicyDeclarationId = e.PIPCommonPolicyDeclarationId
        LEFT OUTER JOIN PIPEndorsementType pet ON e.PIPEndorsementTypeID = pet.PIPEndorsementTypeID
        LEFT OUTER JOIN dbo.Address AS a ON pcpd.InsuredAddressKey = a.AddressKey
        LEFT OUTER JOIN dbo.LOCATION loc ON pcpd.LocationSKey = LOCATION_SKEY
        LEFT OUTER JOIN dbo.PEOPLE p ON p.PEOPLE_SKEY = e.CreatedByPeopleSKey
        LEFT OUTER JOIN dbo.PEOPLE pu ON pu.PEOPLE_SKEY = pcpd.UnderwriterPeopleSKey


GO


