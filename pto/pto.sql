

SELECT * FROM dbo.EMPLOYEE AS e
WHERE e.EMP_LAST_NAME like '%Starr%'

--5518

SELECT * FROM dbo.OtherTimeReason AS otr
--1,2

SELECT otr.OtherTimeReasonDescription, COUNT(ot.OtherTimeDate)
 FROM dbo.EMPLOYEE AS e
JOIN dbo.Timecard AS t ON e.EMP_RECORD_NUMBER = t.Emp_Record_Number
JOIN dbo.OtherTime AS ot ON ot.TimecardKey = t.TimecardKey
JOIN dbo.OtherTimeReason AS otr ON otr.OtherTimeReasonKey = ot.OtherTimeReasonKey
WHERE 1=1
AND e.EMP_RECORD_NUMBER = 5518
AND ot.OtherTimeDate > '12/31/2012' AND ot.OtherTimeDate < '1/1/2014'
GROUP BY otr.OtherTimeReasonDescription
ORDER BY ot.OtherTimeDate ASC


SELECT e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER, otr.OtherTimeReasonDescription, COUNT(ot.OtherTimeDate)
 FROM dbo.EMPLOYEE AS e
JOIN dbo.Timecard AS t ON e.EMP_RECORD_NUMBER = t.Emp_Record_Number
JOIN dbo.OtherTime AS ot ON ot.TimecardKey = t.TimecardKey
JOIN dbo.OtherTimeReason AS otr ON otr.OtherTimeReasonKey = ot.OtherTimeReasonKey
JOIN dbo.EmployeePTOCoordinatorXref AS epcx ON epcx.Emp_Record_Number = e.EMP_RECORD_NUMBER
WHERE 1=1
AND epcx.Coordinator_Emp_Record_Number = 5300 
AND YEAR(ot.OtherTimeDate) = 2013
AND otr.OtherTimeReasonKey = 2
GROUP BY e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER, otr.OtherTimeReasonDescription
ORDER BY e.EMP_LAST_NAME, EMP_FIRST_NAME




SELECT e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER, otr.OtherTimeReasonDescription, COUNT(ot.OtherTimeDate)
 FROM dbo.EMPLOYEE AS e
JOIN dbo.Timecard AS t ON e.EMP_RECORD_NUMBER = t.Emp_Record_Number
JOIN dbo.OtherTime AS ot ON ot.TimecardKey = t.TimecardKey
JOIN dbo.OtherTimeReason AS otr ON otr.OtherTimeReasonKey = ot.OtherTimeReasonKey
JOIN dbo.EmployeePTOCoordinatorXref AS epcx ON epcx.Emp_Record_Number = e.EMP_RECORD_NUMBER
WHERE 1=1
AND epcx.Coordinator_Emp_Record_Number = 5300 
AND ot.OtherTimeDate > '12/31/2011' AND ot.OtherTimeDate < '1/1/2013'
GROUP BY e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER, otr.OtherTimeReasonDescription
ORDER BY e.EMP_LAST_NAME, EMP_FIRST_NAME


SELECT e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER,  totaldays.totalptodays, COUNT(ot.OtherTimeDate)
 FROM dbo.EMPLOYEE AS e
JOIN dbo.Timecard AS t ON e.EMP_RECORD_NUMBER = t.Emp_Record_Number
JOIN dbo.OtherTime AS ot ON ot.TimecardKey = t.TimecardKey
JOIN dbo.OtherTimeReason AS otr ON otr.OtherTimeReasonKey = ot.OtherTimeReasonKey
JOIN dbo.EmployeePTOCoordinatorXref AS epcx ON epcx.Emp_Record_Number = e.EMP_RECORD_NUMBER
JOIN
(
	SELECT e.EMP_RECORD_NUMBER AS empnbr, COUNT(ot.OtherTimeDate) AS totalptodays
	 FROM dbo.EMPLOYEE AS e
	JOIN dbo.Timecard AS t ON e.EMP_RECORD_NUMBER = t.Emp_Record_Number
	JOIN dbo.OtherTime AS ot ON ot.TimecardKey = t.TimecardKey
	JOIN dbo.OtherTimeReason AS otr ON otr.OtherTimeReasonKey = ot.OtherTimeReasonKey
	JOIN dbo.EmployeePTOCoordinatorXref AS epcx ON epcx.Emp_Record_Number = e.EMP_RECORD_NUMBER
	WHERE 1=1
	AND epcx.Coordinator_Emp_Record_Number = 5300 
	AND ot.OtherTimeDate > '12/31/2010' AND ot.OtherTimeDate < '1/1/2012'
	AND otr.IsPTO = 1
	GROUP BY e.EMP_RECORD_NUMBER
) totaldays ON totaldays.empnbr = e.EMP_RECORD_NUMBER
WHERE 1=1
AND epcx.Coordinator_Emp_Record_Number = 5300 
AND ot.OtherTimeDate > '12/31/2010' AND ot.OtherTimeDate < '1/1/2012'
AND otr.OtherTimeReasonKey = 2
GROUP BY e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER,  totaldays.totalptodays
ORDER BY e.EMP_LAST_NAME, EMP_FIRST_NAME

SELECT e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER,  totaldays.totalptodays, COUNT(DISTINCT ot.OtherTimeDate)
 FROM dbo.EMPLOYEE AS e
JOIN dbo.Timecard AS t ON e.EMP_RECORD_NUMBER = t.Emp_Record_Number
JOIN dbo.OtherTime AS ot ON ot.TimecardKey = t.TimecardKey
JOIN dbo.OtherTimeReason AS otr ON otr.OtherTimeReasonKey = ot.OtherTimeReasonKey
JOIN dbo.EmployeePTOCoordinatorXref AS epcx ON epcx.Emp_Record_Number = e.EMP_RECORD_NUMBER
JOIN
(
	SELECT e.EMP_RECORD_NUMBER AS empnbr, COUNT(DISTINCT ot.OtherTimeDate) AS totalptodays
	 FROM dbo.EMPLOYEE AS e
	JOIN dbo.Timecard AS t ON e.EMP_RECORD_NUMBER = t.Emp_Record_Number
	JOIN dbo.OtherTime AS ot ON ot.TimecardKey = t.TimecardKey
	JOIN dbo.OtherTimeReason AS otr ON otr.OtherTimeReasonKey = ot.OtherTimeReasonKey
	JOIN dbo.EmployeePTOCoordinatorXref AS epcx ON epcx.Emp_Record_Number = e.EMP_RECORD_NUMBER
	WHERE 1=1
	AND epcx.Coordinator_Emp_Record_Number = 5300 
	AND ot.OtherTimeDate > '12/31/2010' AND ot.OtherTimeDate < '1/1/2012'
	AND otr.IsPTO = 1
	GROUP BY e.EMP_RECORD_NUMBER
) totaldays ON totaldays.empnbr = e.EMP_RECORD_NUMBER
WHERE 1=1
AND epcx.Coordinator_Emp_Record_Number = 5300 
AND ot.OtherTimeDate > '12/31/2010' AND ot.OtherTimeDate < '1/1/2012'
AND otr.OtherTimeReasonKey = 2
GROUP BY e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER,  totaldays.totalptodays
ORDER BY e.EMP_LAST_NAME, EMP_FIRST_NAME



SELECT e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER, ot.OtherTimeDate, DATENAME(weekday,ot.OtherTimeDate)
 FROM dbo.EMPLOYEE AS e
JOIN dbo.Timecard AS t ON e.EMP_RECORD_NUMBER = t.Emp_Record_Number
JOIN dbo.OtherTime AS ot ON ot.TimecardKey = t.TimecardKey
JOIN dbo.OtherTimeReason AS otr ON otr.OtherTimeReasonKey = ot.OtherTimeReasonKey
JOIN dbo.EmployeePTOCoordinatorXref AS epcx ON epcx.Emp_Record_Number = e.EMP_RECORD_NUMBER
WHERE 1=1
--AND epcx.Coordinator_Emp_Record_Number = 5300 
AND ot.OtherTimeDate > '12/31/2010' AND ot.OtherTimeDate < '1/1/2014'
AND otr.OtherTimeReasonKey = 2
AND e.EMP_RECORD_NUMBER = 5518
--GROUP BY e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER
ORDER BY ot.OtherTimeDate DESC

SELECT e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER, DATENAME(weekday,ot.OtherTimeDate), COUNT(DISTINCT ot.OtherTimeDate)
 FROM dbo.EMPLOYEE AS e
JOIN dbo.Timecard AS t ON e.EMP_RECORD_NUMBER = t.Emp_Record_Number
JOIN dbo.OtherTime AS ot ON ot.TimecardKey = t.TimecardKey
JOIN dbo.OtherTimeReason AS otr ON otr.OtherTimeReasonKey = ot.OtherTimeReasonKey
JOIN dbo.EmployeePTOCoordinatorXref AS epcx ON epcx.Emp_Record_Number = e.EMP_RECORD_NUMBER
WHERE 1=1
--AND epcx.Coordinator_Emp_Record_Number = 5300 
AND ot.OtherTimeDate > '12/31/2011' AND ot.OtherTimeDate < '1/1/2013'
AND otr.OtherTimeReasonKey = 2
AND e.EMP_RECORD_NUMBER = 5518
GROUP BY e.EMP_LAST_NAME, EMP_FIRST_NAME, e.EMP_RECORD_NUMBER, DATENAME(weekday,ot.OtherTimeDate)
ORDER BY ot.OtherTimeDate DESC

SELECT * FROM Employee e
WHERE 