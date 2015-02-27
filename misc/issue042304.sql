select *
from ClaimSuffix
where ClaimSuffixKey IN ( 57286, 57287)


select c.*, cp.Department
from Claims c
 join ClaimPolicy cp on cp.ClaimPOlicyKey = c.ClaimPOlicyKey
where c.ClaimKey IN (50829, 50830)

select *
from ClaimPOlicy
where ClaimPOlicyKey = 19075


select *
from ClaimType
where org_number = 1

select *
from ClaimSubtype
where org_number = 1
 and Description = 'Silica'



--
-- GIVE TO STEVE RE: Molini's issue
--
--update ClaimSuffix
set ClaimTypeKey = 6 -- OBIEV, org1
where ClaimSuffixKey = 57286

--update ClaimSuffix
set ClaimTypeKey = 6 -- OBIEV, org1
where ClaimSuffixKey = 57287

--update Claims
set ClaimSubTypeKey = 145 --Silica, for org1 and dept 100
where ClaimKey = 50829

--update Claims
set ClaimSubTypeKey = 145 --Silica, for org1 and dept 100
where ClaimKey = 50830


