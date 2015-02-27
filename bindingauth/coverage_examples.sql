

--
-- List all Bass policies and show coverages (use this to find policies with the coverage you want to see)
--
SELECT DISTINCT pcp.PolicyNumber,  pcp.InsuredName, pcp.EffectiveDate, loc.INTERNAL_NAME, 
ppd.PIPPropertyDeclarationID, pggl.PIPGLDeclarationID, ppld.PIPPLDeclarationID, plld.PIPLLDeclarationID, pimd.PIPIMDeclarationID
 FROM dbo.QUOTE_BINDER_BINDING_AUTH qbba 
JOIN dbo.QUOTE_BINDER qb ON qbba.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
JOIN dbo.SUBMISSION s ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER AND qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
JOIN dbo.QB_POLICY_LIMITS qbpl ON s.QB_SEQUENCE_NO = qbpl.QB_SEQUENCE_NO AND s.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
JOIN dbo.PIPCommonPolicyDeclaration pcp ON s.SUB_RECORD_NUMBER = pcp.SUB_RECORD_NUMBER
LEFT OUTER JOIN dbo.PIPPropertyDeclaration ppd ON ppd.PIPCommonPolicyDeclarationId = pcp.PIPCommonPolicyDeclarationID
LEFT OUTER JOIN dbo.PIPGLDeclaration pggl ON pggl.PIPCommonPolicyDeclarationId = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPLLDeclaration plld ON plld.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPIMDeclaration pimd ON pimd.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPPLDeclaration ppld ON ppld.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
JOIN dbo.LOCATION loc ON pcp.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY 
WHERE 1=1
AND s.DEPARTMENT_NUMBER = 10006
AND c.COMPANY_SKEY = 809
AND pcp.IssuedDate IS NOT NULL
AND pcp.ReadOnlyCopy != 1


--
-- 
-- Show QB_POLICY_LIMITS FOR A GIVEN BA POLICY NUMBER
--
SELECT DISTINCT pcp.PolicyNumber,  s.SUB_RECORD_NUMBER, pcp.InsuredName, pcc.COVERAGE_DESCRIPTION, qbpl.*
 FROM dbo.QUOTE_BINDER_BINDING_AUTH qbba 
JOIN dbo.QUOTE_BINDER qb ON qbba.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
JOIN dbo.SUBMISSION s ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER AND qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
JOIN dbo.QB_POLICY_LIMITS qbpl ON s.QB_SEQUENCE_NO = qbpl.QB_SEQUENCE_NO AND s.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
JOIN dbo.PIPCommonPolicyDeclaration pcp ON s.SUB_RECORD_NUMBER = pcp.SUB_RECORD_NUMBER
JOIN dbo.POLICY_COVERAGE pc ON pc.POLCOV_SKEY = qbpl.POLCOV_SKEY
JOIN dbo.POLICY_COVERAGE_CODES pcc ON pcc.COVERAGE_SKEY = pc.COVERAGE_SKEY
LEFT OUTER JOIN dbo.PIPPropertyDeclaration ppd ON ppd.PIPCommonPolicyDeclarationId = pcp.PIPCommonPolicyDeclarationID
LEFT OUTER JOIN dbo.PIPGLDeclaration pggl ON pggl.PIPCommonPolicyDeclarationId = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPLLDeclaration plld ON plld.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPIMDeclaration pimd ON pimd.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPPLDeclaration ppld ON ppld.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
JOIN dbo.LOCATION loc ON pcp.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY 
WHERE 1=1
AND s.DEPARTMENT_NUMBER = 10006
AND c.COMPANY_SKEY = 809
AND pcp.PolicyNumber = 132646


--
-- Bass Policies - count of IM coverages
--
SELECT DISTINCT pcp.PolicyNumber,  COUNT(DISTINCT pimd.PIPIMDeclarationID)
 FROM dbo.QUOTE_BINDER_BINDING_AUTH qbba 
JOIN dbo.QUOTE_BINDER qb ON qbba.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
JOIN dbo.SUBMISSION s ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER AND qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
JOIN dbo.QB_POLICY_LIMITS qbpl ON s.QB_SEQUENCE_NO = qbpl.QB_SEQUENCE_NO AND s.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
JOIN dbo.PIPCommonPolicyDeclaration pcp ON s.SUB_RECORD_NUMBER = pcp.SUB_RECORD_NUMBER
LEFT OUTER JOIN dbo.PIPPropertyDeclaration ppd ON ppd.PIPCommonPolicyDeclarationId = pcp.PIPCommonPolicyDeclarationID
LEFT OUTER JOIN dbo.PIPGLDeclaration pggl ON pggl.PIPCommonPolicyDeclarationId = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPLLDeclaration plld ON plld.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPIMDeclaration pimd ON pimd.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPPLDeclaration ppld ON ppld.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
JOIN dbo.LOCATION loc ON pcp.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY 
WHERE 1=1
AND s.DEPARTMENT_NUMBER = 10006
AND c.COMPANY_SKEY = 809
AND pcp.IssuedDate IS NOT NULL
AND pcp.ReadOnlyCopy != 1
GROUP BY pcp.PolicyNumber
HAVING COUNT(pimd.PIPIMDeclarationID) > 1


--
-- Example of how multiple IM coverages in PIP are stored on QBPL (they are aggregated to one row)
--
SELECT DISTINCT pcp.PolicyNumber,  s.SUB_RECORD_NUMBER, pcp.InsuredName, pcc.COVERAGE_DESCRIPTION,  qbpl.*
 FROM dbo.QUOTE_BINDER_BINDING_AUTH qbba 
JOIN dbo.QUOTE_BINDER qb ON qbba.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO AND qbba.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
JOIN dbo.SUBMISSION s ON qb.SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER AND qb.QB_SEQUENCE_NO = s.QB_SEQUENCE_NO
JOIN dbo.QB_POLICY_LIMITS qbpl ON s.QB_SEQUENCE_NO = qbpl.QB_SEQUENCE_NO AND s.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
JOIN dbo.PIPCommonPolicyDeclaration pcp ON s.SUB_RECORD_NUMBER = pcp.SUB_RECORD_NUMBER
JOIN dbo.POLICY_COVERAGE pc ON pc.POLCOV_SKEY = qbpl.POLCOV_SKEY
JOIN dbo.POLICY_COVERAGE_CODES pcc ON pcc.COVERAGE_SKEY = pc.COVERAGE_SKEY
LEFT OUTER JOIN dbo.PIPPropertyDeclaration ppd ON ppd.PIPCommonPolicyDeclarationId = pcp.PIPCommonPolicyDeclarationID
LEFT OUTER JOIN dbo.PIPGLDeclaration pggl ON pggl.PIPCommonPolicyDeclarationId = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPLLDeclaration plld ON plld.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPIMDeclaration pimd ON pimd.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
LEFT OUTER JOIN dbo.PIPPLDeclaration ppld ON ppld.PIPCommonPolicyDeclarationID = pcp.PIPCommonPolicyDeclarationId
JOIN dbo.LOCATION loc ON pcp.LocationSKey = loc.LOCATION_SKEY
JOIN COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY 
WHERE 1=1
AND s.DEPARTMENT_NUMBER = 10006
AND c.COMPANY_SKEY = 809
AND pcp.PolicyNumber = 144286