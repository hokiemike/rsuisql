SELECT DISTINCT mcc.RatingType FROM dbo.Mst_ClassCodes AS mcc


SELECT * FROM dbo.Mst_ClassCodes AS mcc
WHERE mcc.RatingType = 'Company'
AND mcc.CompanyOperations = 'Included'

SELECT * FROM dbo.Mst_ClassCodes AS mcc
WHERE mcc.RatingType = 'ISO'
AND mcc.CompanyOperations = 'Included'

SELECT mcc.ClassCode, mcc.Description, mcc.Subcode, mcc.IsRatingTypeBoth, mcc.PremisesOperations,
mcc.CompanyOperations, meb.ExposureDescription,mcc.IsAdditionalQuestions 
 FROM dbo.Mst_ClassCodes AS mcc
 JOIN dbo.Mst_ExposureBase AS meb ON mcc.ExposureBaseID = meb.ExposureBaseID
WHERE mcc.RatingType = 'ISO'
AND mcc.CompanyOperations = 'Authorized'

SELECT mcc.ClassCode, mcc.Description, mcc.Subcode, mcc.IsRatingTypeBoth, mcc.PremisesOperations,
mcc.CompanyOperations, meb.ExposureDescription,mcc.IsAdditionalQuestions 
 FROM dbo.Mst_ClassCodes AS mcc
 JOIN dbo.Mst_ExposureBase AS meb ON mcc.ExposureBaseID = meb.ExposureBaseID
WHERE mcc.RatingType = 'Company'
AND mcc.CompanyOperations = 'Included'

-- copmany rated ONLY; products rated separately
SELECT mcc.ClassCode, mcc.Description, mcc.Subcode, mcc.IsRatingTypeBoth, mcc.PremisesOperations,
mcc.CompanyOperations, meb.ExposureDescription,mcc.IsAdditionalQuestions 
 FROM dbo.Mst_ClassCodes AS mcc
 JOIN dbo.Mst_ExposureBase AS meb ON mcc.ExposureBaseID = meb.ExposureBaseID
WHERE mcc.RatingType = 'Company'
AND mcc.IsRatingTypeBoth = 0
AND mcc.CompanyOperations = 'Authorized'


SELECT mcc.ClassCode, mcc.Description, mcc.Subcode, mcc.RatingType, mcc.IsRatingTypeBoth, mcc.PremisesOperations,
mcc.CompanyOperations, meb.ExposureDescription,mcc.IsAdditionalQuestions
 FROM dbo.Mst_ClassCodes AS mcc
 JOIN dbo.Mst_ExposureBase AS meb ON mcc.ExposureBaseID = meb.ExposureBaseID
WHERE mcc.RatingType = 'Company'
AND mcc.IsRatingTypeBoth = 0
AND mcc.CompanyOperations = 'Authorized'

SELECT * FROM dbo.Mst_ClassCodes AS mcc WHERE mcc.ClassCode = 10115


SELECT tcm.* FROM dbo.Trn_ClassificationMapping AS tcm
JOIN dbo.Mst_ClassCodes AS mcc ON tcm.ClassCodeID = mcc.ClassCodeID
WHERE mcc.ClassCode = 63218

SELECT tcm.* FROM dbo.Trn_ClassificationMapping AS tcm
JOIN dbo.Mst_ClassCodes AS mcc ON tcm.ClassCodeID = mcc.ClassCodeID
WHERE tcm.ClassificationCode = 1

SELECT mcc.ClassCode, mcc.DESCRIPTION, COUNT(tcm.ClassificationMapID)
 FROM dbo.Trn_ClassificationMapping AS tcm
JOIN dbo.Mst_ClassCodes AS mcc ON tcm.ClassCodeID = mcc.ClassCodeID
WHERE 1=1
AND tcm.IsActive = 1
GROUP BY mcc.ClassCode, mcc.DESCRIPTION
HAVING COUNT(tcm.ClassificationMapID) > 2

SELECT * FROM tc


SELECT meb.ExposureBaseType, mcc.*, meb.* FROM dbo.Mst_ClassCodes AS mcc
JOIN dbo.Mst_ExposureBase AS meb ON mcc.ExposureBaseID = meb.ExposureBaseID
WHERE mcc.Description LIKE '%beauty%'