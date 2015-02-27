

SELECT DISTINCT pgp.Deductible 
FROM dbo.PGInput pgi
JOIN dbo.PGMain pgm ON pgm.PGMainKey = pgi.PGInputItemKey AND pgi.PGInputTypeKey = 1
JOIN dbo.PGProperty pgp ON pgm.PGMainKey = pgp.PGMainKey
WHERE 1=1
AND pgi.CreateDate > '1/1/09'
 AND Deductible IS NOT NULL
 
 
SELECT * FROM dbo.INLAND_MARINE_CLASS
 
SELECT DISTINCT 
pgm.policyNumber, 
co.[NAME], 
loc.INTERNAL_NAME, 
pgp.Deductible,
pgp.WindExcluded,
1 AS HasWindDeductibleAttached
FROM dbo.PGInput pgi
JOIN dbo.PGMain pgm ON pgm.PGMainKey = pgi.PGInputItemKey AND pgi.PGInputTypeKey = 1
JOIN dbo.PGProperty pgp ON pgm.PGMainKey = pgp.PGMainKey
JOIN dbo.LOCATION loc ON pgm.locationNumber = loc.LOCATION_SKEY
JOIN dbo.COMPANY co ON loc.COMPANY_SKEY = co.COMPANY_SKEY
JOIN [PGInputForm] pgif ON pgi.[PGInputKey] = pgif.[PGInputKey]
WHERE 1=1
AND pgi.CreateDate > '01/01/09'
 AND Deductible IS NOT NULL
  --AND pgp.WindExcluded != 1
   AND ( pgif.[Name] LIKE '%CP0321%' OR pgif.[Name] LIKE '%104011%' )
   
SELECT DISTINCT 
pgm.policyNumber, 
co.[NAME], 
loc.INTERNAL_NAME, 
--pgp.Deductible,
--pgp.WindExcluded,
1 AS HasWindDeductibleAttached
FROM dbo.PGInput pgi
JOIN dbo.PGMain pgm ON pgm.PGMainKey = pgi.PGInputItemKey AND pgi.PGInputTypeKey = 1
JOIN dbo.PGProperty pgp ON pgm.PGMainKey = pgp.PGMainKey
JOIN dbo.LocationNumberXref lxref ON pgm.locationNumber = lxref.LocationNumber
JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = lxref.LOCATION_SKEY
JOIN dbo.COMPANY co ON loc.COMPANY_SKEY = co.COMPANY_SKEY
WHERE 1=1
AND pgi.CreateDate > '01/01/08'
 AND co.COMPANY_SKEY = 11
   
 
 
 
SELECT DISTINCT 
pgm.policyNumber, 
co.[NAME], 
loc.INTERNAL_NAME, 
pgp.Deductible,
pgp.WindExcluded,
1 AS HasWindDeductibleAttached
FROM dbo.PGInput pgi
JOIN dbo.PGMain pgm ON pgm.PGMainKey = pgi.PGInputItemKey AND pgi.PGInputTypeKey = 1
JOIN dbo.PGProperty pgp ON pgm.PGMainKey = pgp.PGMainKey
JOIN dbo.LocationNumberXref lxref ON pgm.locationNumber = lxref.LocationNumber
JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = lxref.LOCATION_SKEY
JOIN dbo.COMPANY co ON loc.COMPANY_SKEY = co.COMPANY_SKEY
JOIN [PGInputForm] pgif ON pgi.[PGInputKey] = pgif.[PGInputKey]
WHERE 1=1
AND pgi.CreateDate > '01/01/09'
 AND Deductible IS NOT NULL
  --AND pgp.WindExcluded != 1
   AND ( pgif.[Name] LIKE '%CP0321%' OR pgif.[Name] LIKE '%104011%' )
UNION
SELECT DISTINCT 
pgm.policyNumber, 
co.[NAME], 
loc.INTERNAL_NAME, 
pgp.Deductible,
pgp.WindExcluded,
0 AS HasWindDeductibleAttached
FROM dbo.PGInput pgi
JOIN dbo.PGMain pgm ON pgm.PGMainKey = pgi.PGInputItemKey AND pgi.PGInputTypeKey = 1
JOIN dbo.PGProperty pgp ON pgm.PGMainKey = pgp.PGMainKey
JOIN dbo.LocationNumberXref lxref ON pgm.locationNumber = lxref.LocationNumber
JOIN dbo.LOCATION loc ON loc.LOCATION_SKEY = lxref.LOCATION_SKEY
JOIN dbo.COMPANY co ON loc.COMPANY_SKEY = co.COMPANY_SKEY
JOIN [PGInputForm] pgif ON pgi.[PGInputKey] = pgif.[PGInputKey]
WHERE 1=1
AND pgi.CreateDate > '01/01/09'
 AND Deductible IS NOT NULL
  --AND pgp.WindExcluded != 1
   AND NOT ( pgif.[Name] LIKE '%CP0321%' OR pgif.[Name] LIKE '%104011%' )
ORDER BY co.[NAME], loc.INTERNAL_NAME



SELECT DISTINCT [Name] FROM dbo.PGInputForm
ORDER BY NAME


SELECT * FROM dbo.PGInputType

SELECT * FROM dbo.COMPANY WHERE [NAME] LIKE '%gresham%'

SELECT * FROM dbo.LOCATION WHERE COMPANY_SKEY = 11