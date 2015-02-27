SELECT * FROM dbo.LossCost AS lc 
WHERE classcode = '60035'
AND lc.OtherPara = 'Prem'
AND Territory = 501 AND StateCode = 'AL'

SELECT * FROM dbo.LossCost AS lc 
WHERE classcode = '60035'
AND lc.OtherPara = 'Prem'
--AND Territory = 501 
AND StateCode = 'GA'


SELECT StateCode, ClassCode, COUNT(DISTINCT Territory) 
 FROM dbo.LossCost AS lc 
WHERE classcode = '60035'
AND lc.OtherPara = 'Prem'
--AND Territory = 501 AND StateCode = 'AL'
GROUP BY StateCode, ClassCode
HAVING COUNT(DISTINCT Territory) = 1