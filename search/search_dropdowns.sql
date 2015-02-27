declare @branch int
set @branch=100
declare @dept int
set @dept=300

SELECT l.LOCATION_SKEY, 
	   l.INTERNAL_NAME  
FROM LOCATION l
JOIN COMPANY co on co.COMPANY_SKEY = l.COMPANY_SKEY
JOIN LOCATION_XREF lxref on lxref.LOCATION_SKEY = l.LOCATION_SKEY
WHERE 1=1
 AND (co.COMPANY_TYPE = 1)
 AND (l.TREATY_FLAG <> 'Y')
 AND ( @branch is null OR lxref.BRANCH_NUMBER = @branch )
 AND ( @dept is null OR lxref.DEPARTMENT_NUMBER = @dept )
ORDER BY l.INTERNAL_NAME ASC
go

declare @branch int
set @branch=100
declare @dept int
set @dept=200

SELECT DISTINCT p.PEOPLE_SKEY,
p.LAST_NAME + ', ' +  p.FIRST_NAME as [DisplayName] 
FROM PEOPLE p
JOIN PEOPLE_LOCATION_XREF plx on plx.PEOPLE_SKEY = p.PEOPLE_SKEY
JOIN LOCATION_XREF lxref on lxref.LOCATION_XREF_SKEY = plx.LOCATION_XREF_SKEY
WHERE 1=1
AND p.PEOPLE_TYPE = 9 
AND ( @branch is null OR lxref.BRANCH_NUMBER = @branch )
AND ( @dept is null OR lxref.DEPARTMENT_NUMBER = @dept )
ORDER BY [DisplayName]  ASC 

SELECT PEOPLE.PEOPLE_SKEY,
PEOPLE.LAST_NAME + ', ' +  PEOPLE.FIRST_NAME as [DisplayName] 
FROM PEOPLE 
WHERE 1=1
AND PEOPLE.PEOPLE_TYPE = 9 
ORDER BY PEOPLE.LAST_NAME ASC, PEOPLE.FIRST_NAME ASC 

	   
