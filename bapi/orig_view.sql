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
/* this part for the Policys */ 
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

FROM    dbo.PIPCommonPolicyDeclaration pcpd
		LEFT OUTER JOIN dbo.Address AS a ON pcpd.InsuredAddressKey = a.AddressKey
        LEFT OUTER JOIN dbo.LOCATION loc ON pcpd.LocationSKey = LOCATION_SKEY
        LEFT OUTER JOIN dbo.PEOPLE p ON p.PEOPLE_SKEY = pcpd.CreatedByPeopleSKey
        LEFT OUTER JOIN dbo.PEOPLE_LOCATION pl ON p.PEOPLE_SKEY = pl.PEOPLE_SKEY
        LEFT OUTER JOIN dbo.PEOPLE pu ON pu.PEOPLE_SKEY = pcpd.UnderwriterPeopleSKey
        LEFT OUTER JOIN dbo.LOCATION lc ON pl.LOCATION_SKEY = lc.LOCATION_SKEY 
     
UNION
/* this part for the Endorsements */
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

FROM    dbo.PIPCommonPolicyDeclaration pcpd
		LEFT OUTER JOIN dbo.Address AS a ON pcpd.InsuredAddressKey = a.AddressKey
        JOIN PIPEndorsement e ON pcpd.PIPCommonPolicyDeclarationId = e.PIPCommonPolicyDeclarationId
        LEFT OUTER JOIN PIPEndorsementType pet ON e.PIPEndorsementTypeID = pet.PIPEndorsementTypeID
        LEFT OUTER JOIN dbo.LOCATION loc ON pcpd.LocationSKey = LOCATION_SKEY
        LEFT OUTER JOIN dbo.PEOPLE p ON p.PEOPLE_SKEY = e.CreatedByPeopleSKey
        LEFT OUTER JOIN dbo.PEOPLE pu ON pu.PEOPLE_SKEY = pcpd.UnderwriterPeopleSKey
UNION
SELECT DISTINCT
        pcpd.PIPCommonPolicyDeclarationId AS PolicyId ,
        LTRIM(RTRIM(ic.COMPANY_CODE))
        + LTRIM(RTRIM(ps.POLICY_CODE))
        + REPLACE(STR(s.SUB_POLICY_NUMBER,
                      6), ' ', '0') + ' '
        + REPLACE(STR(s.SUB_POLICY_SUFFIX,
                      2), ' ', '0') AS PolicyNumber ,
        'DocuCorp' AS TYPE ,
        s.LOCATION_SKEY ,
        loc.INTERNAL_NAME AS Location ,
        s.SUB_EFFECTIVE_DATE AS EffectiveDate ,
        s.SUB_INSURED_NAME ,
        '' AS CreatedBy ,
        p.LAST_NAME + ', ' + p.FIRST_NAME AS Underwriter ,
        s.CreateDate AS CreatedAt ,
        NULL AS CreatedById ,
        'StatusCode' = CASE
                          WHEN s.SUB_CANCELLATION_DATE IS NOT NULL
                          THEN 2
                          ELSE 1
                       END ,
        s.IssuedDate AS IssuedDate ,
        loc.COMPANY_SKEY AS Company_Skey ,
        NULL PeopleSkey ,
        s.PEOPLE_SKEY AS UnderwriterPeopleSKey ,
        NULL AS EndorsementId ,
        NULL AS EndorsementTypeId,
        loc.IsELANY ,
        s.SUB_RECORD_NUMBER AS SubRecordNumber,
        10006,  --PG Records are all BA
		207,     -- PG Records are all the standard BA Program
		'' -- no address for PG
FROM    dbo.SUBMISSION AS s
        LEFT OUTER JOIN dbo.LOCATION loc ON s.LOCATION_SKEY = loc.LOCATION_SKEY
        LEFT OUTER JOIN dbo.PEOPLE p ON p.PEOPLE_SKEY = s.PEOPLE_SKEY
        LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration
        AS pcpd ON s.SUB_RECORD_NUMBER = pcpd.SUB_RECORD_NUMBER
        LEFT OUTER JOIN dbo.INSURANCE_COMPANIES
        AS ic ON s.COMPANY_RECORD_NUMBER = ic.COMPANY_RECORD_NUMBER
        LEFT OUTER JOIN dbo.POLICY_SYMBOL
        AS ps ON s.SUB_POLICY_SYMBOL = ps.SYMBOL_SKEY
WHERE   1 = 1
        AND s.DEPARTMENT_NUMBER = 10006
        AND pcpd.SUB_RECORD_NUMBER IS NULL
        AND s.QB_SEQUENCE_NO > 0
        AND s.SUB_CURRENT_EXPIRATION_DATE > DATEADD(YEAR,
                          -3, GETDATE())
/*AND s.PRIOR_SUB_RECORD_NUMBER IS NULL*/
UNION
SELECT DISTINCT
        pcpd.PIPCommonPolicyDeclarationId AS PolicyId ,
        LTRIM(RTRIM(ic.COMPANY_CODE))
        + LTRIM(RTRIM(ps.POLICY_CODE))
        + REPLACE(STR(s.SUB_POLICY_NUMBER,
                      6), ' ', '0') + ' '
        + REPLACE(STR(s.SUB_POLICY_SUFFIX,
                      2), ' ', '0') AS PolicyNumber ,
        'DocuCorpEnd '
        + LTRIM(RTRIM(STR(e.ENDORSEMENT_NUMBER))) AS TYPE ,
        s.LOCATION_SKEY ,
        loc.INTERNAL_NAME AS Location ,
        e.ENDORSEMENT_EFFECTIVE_DATE AS EffectiveDate ,
        s.SUB_INSURED_NAME ,
        '' AS CreatedBy ,
        p.LAST_NAME + ', ' + p.FIRST_NAME AS Underwriter ,
        e.ENDORSEMENT_CREATE_DATE AS CreatedAt ,
        NULL AS CreatedById ,
        2 AS StatusCode ,
        s.IssuedDate AS IssuedDate ,
        loc.COMPANY_SKEY AS Company_Skey ,
        NULL PeopleSkey ,
        s.PEOPLE_SKEY AS UnderwriterPeopleSKey ,
        e.ENDORSEMENT_SKEY AS EndorsementId ,
        NULL AS EndorsementTypeId, --old policies will not have reporting endorsements
        loc.IsELANY ,
        s.SUB_RECORD_NUMBER AS SubRecordNumber,
		10006,  --PG Records are all BA
		207,     -- PG Records are all the standard BA Program
		'' -- no address for PG

FROM    dbo.ENDORSEMENT AS e
        JOIN dbo.SUBMISSION AS s ON e.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
        LEFT OUTER JOIN dbo.LOCATION loc ON s.LOCATION_SKEY = loc.LOCATION_SKEY
        LEFT OUTER JOIN dbo.PEOPLE p ON p.PEOPLE_SKEY = s.PEOPLE_SKEY
        LEFT OUTER JOIN dbo.PIPCommonPolicyDeclaration
        AS pcpd ON s.SUB_RECORD_NUMBER = pcpd.SUB_RECORD_NUMBER
        LEFT OUTER JOIN dbo.INSURANCE_COMPANIES
        AS ic ON s.COMPANY_RECORD_NUMBER = ic.COMPANY_RECORD_NUMBER
        LEFT OUTER JOIN dbo.POLICY_SYMBOL
        AS ps ON s.SUB_POLICY_SYMBOL = ps.SYMBOL_SKEY
        LEFT OUTER JOIN dbo.PIPEndorsement pe ON e.ENDORSEMENT_SKEY = pe.ENDORSEMENT_SKEY
WHERE   1 = 1
        AND s.DEPARTMENT_NUMBER = 10006
        AND pe.ENDORSEMENT_SKEY IS NULL
        AND s.QB_SEQUENCE_NO > 0
        AND s.SUB_CURRENT_EXPIRATION_DATE > DATEADD(YEAR,
                          -3, GETDATE())


GO


