--
-- Find all BAPI IDs that are out of sync
--
-- (MIRROR VERSION)
--
SELECT 'rsuiex\' + e.samAccountName AS ADName, p.EXTERNAL_LOGIN, p.PEOPLE_SKEY, e.department, e.mail, p.EMAIL_ADDRESS_1, c.NAME, loc.LOCATION_SKEY, loc.INTERNAL_NAME
from ExtranetUsers e 
left outer join RSUITSTDB.RSMSMIRROR.dbo.PEOPLE p on e.employeeID = p.people_skey
JOIN RSUITSTDB.RSMSMIRROR.dbo.PEOPLE_LOCATION_XREF plx ON p.PEOPLE_SKEY = plx.PEOPLE_SKEY
 JOIN RSUITSTDB.RSMSMIRROR.dbo.LOCATION_XREF lxref ON plx.LOCATION_XREF_SKEY = lxref.LOCATION_XREF_SKEY
 JOIN RSUITSTDB.RSMSMIRROR.dbo.LOCATION loc ON lxref.LOCATION_SKEY = loc.LOCATION_SKEY
JOIN RSUITSTDB.RSMSMIRROR.dbo.COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY
WHERE 1=1
and e.employeeID is not null
  and e.employeeID <> ''
  and e.division not in ('Delete','RSC','Pebble')
  and e.samaccountname not in ('bapi1','bapi2')
  and p.active_code  <> 'I'
  AND lxref.DEPARTMENT_NUMBER = 10006
  AND 'rsuiex\' + e.samAccountName != p.EXTERNAL_LOGIN
  
--check for someone
SELECT * 
FROM dbo.ExtranetUsers AS eu 
WHERE eu.samAccountName LIKE '%Liu%'
  
  
--
-- Update all BAPI ids that are out of sync
--
-- (MIRROR VERSION)
--    
update RSUITSTDB.RSMSMIRROR.dbo.PEOPLE
set external_login = 'rsuiex\' + e.samAccountName 
from ExtranetUsers e 
left outer join RSUITSTDB.RSMSMIRROR.dbo.PEOPLE p2 on e.employeeID = p2.people_skey 
where 1=1
  AND p2.PEOPLE_SKEY IN
  (
	SELECT DISTINCT p.PEOPLE_SKEY
		from ExtranetUsers e 
		left outer join RSUITSTDB.RSMSMIRROR.dbo.PEOPLE p on e.employeeID = p.people_skey
		JOIN RSUITSTDB.RSMSMIRROR.dbo.PEOPLE_LOCATION_XREF plx ON p.PEOPLE_SKEY = plx.PEOPLE_SKEY
		 JOIN RSUITSTDB.RSMSMIRROR.dbo.LOCATION_XREF lxref ON plx.LOCATION_XREF_SKEY = lxref.LOCATION_XREF_SKEY
		 JOIN RSUITSTDB.RSMSMIRROR.dbo.LOCATION loc ON lxref.LOCATION_SKEY = loc.LOCATION_SKEY
		JOIN RSUITSTDB.RSMSMIRROR.dbo.COMPANY c ON loc.COMPANY_SKEY = c.COMPANY_SKEY
		WHERE 1=1
		and e.employeeID is not null
		  and e.employeeID <> ''
		  and e.division not in ('Delete','RSC','Pebble')
		  and e.samaccountname not in ('bapi1','bapi2')
		  and p.active_code  <> 'I'
		  AND lxref.DEPARTMENT_NUMBER = 10006
		  AND 'rsuiex\' + e.samAccountName != p.EXTERNAL_LOGIN
  )
  GO

  
  