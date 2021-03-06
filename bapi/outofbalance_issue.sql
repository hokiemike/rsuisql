SELECT * FROM dbo.PIPCommonPolicyDeclaration AS pcpd
WHERE pcpd.PIPCommonPolicyDeclarationId = 175567

SELECT * FROM dbo.LOCATION AS l WHERE LOCATION_SKEY = 55

SELECT * FROM dbo.PIPGLDeclaration AS pd WHERE PIPCommonPolicyDeclarationId = 175567

SELECT SUM(IIF(PrCoPremium<0,0,PrCoPremium) + IIF(OtherPremium < 0,0,OtherPremium))
FROM dbo.PIPGLClassCode AS pcc 
WHERE PIPGLDeclarationID = 155852

SELECT *
FROM dbo.PIPGLClassCode AS pcc WHERE PIPGLDeclarationID = 155852


SELECT * FROM dbo.AUDIT_LOG AS al
WHERE TABLE_NAME = 'PIPCommonPolicyDeclaration'
AND TABLE_KEY LIKE '%175567%' 
ORDER BY AUDIT_DATE DESC, Audit_time DESC

SELECT * FROM dbo.AUDIT_LOG AS al
WHERE TABLE_NAME = 'PIPGLClassCode'
AND SUBSTRING(AFTER_IMAGE,9,8) = '[155852]'
ORDER BY AUDIT_DATE DESC, Audit_time DESC

SELECT * FROM dbo.AUDIT_LOG AS al
WHERE TABLE_NAME = 'PIPGLClassCode'
AND AFTER_IMAGE LIKE '%155852%'
ORDER BY AUDIT_DATE DESC, Audit_time DESC


SELECT * FROM dbo.BAPIRequestLog AS brl
WHERE brl.Path LIKE '%175567%'
ORDER BY LogDate DESC

SELECT * FROM dbo.BAPIRequestLog AS brl
WHERE brl.IdentityName LIKE '%kilpatrick%'
AND brl.LogDate BETWEEN '9/17/2014' AND '9/20/2014'
ORDER BY LogDate DESC

SELECT * FROM dbo.PIPCommonPolicyDeclaration AS pcpd
WHERE pcpd.PolicyNumber = 259305

[312503][155852][1185][6][Additional Insured][1.00][269][-100.00][100.00][-100.00][0][100.00][0][0.00][2]

[312500][155852][378][5][Hotels and Motels - without pools or beaches - less than four stories ][200000.00][268][-100.00][7.29][-100.00][0][1459.00][0][1.00]
[312500][155852][378][5][Hotels and Motels - without pools or beaches - less than four stories ][200000.00][268][-100.00][7.19][-100.00][0][1437.00][0][1.15][1]

[312502][155852][852][6][Dwellings - one-family (lessor�s risk only);][1.00][269][-100.00][51.00][-100.00][0][51.00][0][0.00]
[312502][155852][852][6][Dwellings - one-family (lessor�s risk only);][1.00][269][-100.00][58.65][-100.00][0][59.00][0][0.00][2]



[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 17 2014  3:21PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 17 2014  3:21PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]
[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 19 2014  3:45PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 19 2014  3:45PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]

[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 19 2014  3:45PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 19 2014  3:45PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]
[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 19 2014  3:45PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 19 2014  3:45PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]

[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 19 2014  3:45PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 19 2014  3:45PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]
[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 19 2014  3:45PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 19 2014  3:45PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]

[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 19 2014  3:45PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 19 2014  3:45PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]
[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 19 2014  3:45PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 19 2014  3:45PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]

[175567][][0]                   [][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 19 2014  3:45PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 19 2014  3:45PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]
[175567][][1][Sep 19 2014  3:45PM][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 19 2014  3:45PM][0][3][][0][0][250.00][25.00][2629495][2373418][0][Sep 19 2014  3:45PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]


[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 17 2014 11:55AM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 17 2014 11:55AM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]
[175567][][0][][V][BA][333053][0][1][][JRJ GROUP, LLC][ELK CITY MOTOR LODGE][3045066][Sep 10 2014 12:00AM][Sep 10 2015 12:00AM][][][11503.00][0][2296.00][0][0.00][0][0.00][0][-200.00][][SURPLUS LINES TAX $838.44][POLICY FEE: $175.00][1013.44][MOTEL][Sep 17 2014 12:00AM][2604][55][Sep 17 2014 11:11AM][Sep 17 2014  3:21PM][0][3][][0][0][250.00][25.00][][2373418][0][Sep 17 2014  3:21PM][GRESHAM & ASSOCIATES, LLC][100148703][][OK][0][0][1][][10006][207]