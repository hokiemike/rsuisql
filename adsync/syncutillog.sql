SELECT sud.* 
FROM dbo.SyncUtilityDetail AS sud
--JOIN dbo.SyncUtilityJob AS suj ON sud.Id = suj.Id
WHERE sud.Status = 'Delete'


SELECT DISTINCT suj.*, suc.* 
FROM dbo.SyncUtilityDetail AS sud
JOIN dbo.SyncUtilityContract AS suc ON suc.Id = sud.ContractId
JOIN dbo.SyncUtilityJob AS suj ON suj.Id = suc.JobId
WHERE sud.Status = 'Delete'
AND suc.Starttime > '6/13/2013'
AND suc.Name LIKE '%wirt%'
ORDER BY suc.Starttime

SELECT DISTINCT suj.*, suc.*, sud.* 
FROM dbo.SyncUtilityDetail AS sud
JOIN dbo.SyncUtilityContract AS suc ON suc.Id = sud.ContractId
JOIN dbo.SyncUtilityJob AS suj ON suj.Id = suc.JobId
WHERE sud.Status = 'Update'
AND suc.Starttime > '6/13/2013'
ORDER BY suc.Starttime

SELECT DISTINCT  sud.* 
FROM dbo.SyncUtilityDetail AS sud
JOIN dbo.SyncUtilityContract AS suc ON suc.Id = sud.ContractId
JOIN dbo.SyncUtilityJob AS suj ON suj.Id = suc.JobId
WHERE sud.Status = 'Update'
AND suc.Starttime > '6/13/2013'
ORDER BY sud.ContractId


AND suc.Name LIKE '%Hicks%'
WHERE sud.Log LIKE '%alleg%'

SELECT * FROM dbo.SyncUtilityContract AS suc
