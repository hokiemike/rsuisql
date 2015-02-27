select distinct co.COMPANY_TYPE, co.REINS_TYPE 
from Location l 
 join LOCATION_XREF lx on lx.LOCATION_SKEY = l.LOCATION_SKEY
 join COMPANY co on co.COMPANY_SKEY = l.COMPANY_SKEY 
 where 1=1 
  and  lx.DEPARTMENT_NUMBER = 200
  and  lx.BRANCH_NUMBER = 100 


select * from REFERENCE_TYPE where CATEGORY_SKEY = 6 --reins types
select * from REFERENCE_TYPE where CATEGORY_SKEY = 1 --company types
select * from REFERENCE_CATEGORY

--
-- QUERY IN  REINSURANCE MODUILES  THAT PULLS BACK FAC REINSURERS
--
declare @branch int
set @branch=100
declare @dept int
set @dept=300
declare @effdate datetime
set @effdate='2006-01-10'


-- FAC REINSURERS (COMPANY_TYPE = 2, RI_TYPE 24)
--select distinct l.* 
select distinct co.COMPANY_TYPE
from Location l 
 left outer join LOCATION_XREF lx on lx.LOCATION_SKEY = l.LOCATION_SKEY
 left outer join Company co on co.COMPANY_SKEY = l.COMPANY_SKEY
 where 1=1
 and co.REINS_TYPE = 24 
and lx.DEPARTMENT_NUMBER = 200 
and lx.BRANCH_NUMBER = 100 
-- ( l.EXPIRATION_DATE >= @effdate or l.EXPIRATION_DATE is null) and
-- ( l.EFFECTIVE_DATE <= @effdate ) 
order by l.INTERNAL_NAME 
go


-- FAC INTERMEDIARIES (COMPANY_TYPE = 3, RI_TYPE = 23)
select distinct l.* 
from Location l 
 left outer join LOCATION_XREF lx on lx.LOCATION_SKEY = l.LOCATION_SKEY
 left outer join Company co on co.COMPANY_SKEY = l.COMPANY_SKEY
 where 1=1
 and co.REINS_TYPE = 23 
 and co.COMPANY_TYPE = 3
 and l.TREATY_FLAG != 'Y'
 and lx.DEPARTMENT_NUMBER = 200 
 and lx.BRANCH_NUMBER = 100 
-- ( l.EXPIRATION_DATE >= @effdate or l.EXPIRATION_DATE is null) and
-- ( l.EFFECTIVE_DATE <= @effdate ) 
order by l.INTERNAL_NAME 
go

-- FAC DIRECT MARKETS (COMPANY_TYPE = 3, RI_TYPE = 22)
select distinct l.* 
from Location l 
 left outer join LOCATION_XREF lx on lx.LOCATION_SKEY = l.LOCATION_SKEY
 left outer join Company co on co.COMPANY_SKEY = l.COMPANY_SKEY
 where 1=1
 and co.REINS_TYPE = 22
 and co.COMPANY_TYPE = 3
 and l.TREATY_FLAG != 'Y'
 and lx.DEPARTMENT_NUMBER = 200 
 and lx.BRANCH_NUMBER = 100 
-- ( l.EXPIRATION_DATE >= @effdate or l.EXPIRATION_DATE is null) and
-- ( l.EFFECTIVE_DATE <= @effdate ) 
order by l.INTERNAL_NAME 
go
