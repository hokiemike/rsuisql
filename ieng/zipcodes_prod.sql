

SELECT zcd.ZipCode, COUNT(DISTINCT zccd.City)
 FROM dbo.ZipCodeData AS zcd
JOIN dbo.ZipCodeCityData AS zccd ON zcd.ZipCode = zccd.ZipCode
WHERE 1=1
AND zcd.StateCode = 'FL'
AND zcd.ZipCode = 33014
GROUP BY zcd.ZipCode

SELECT * FROM dbo.ZipCodeCountyData AS zccd WHERE zccd.ZipCode = 33014
