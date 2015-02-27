select s.department_number, e.*
from endorsement e
 join submission s on s.sub_record_number = e.sub_record_number
where ENDORSEMENT_CREATE_DATE > '2006-10-01'
and ENDTYPE_RECORD_NUMBER = 9

select *
from dbo.ENDORSEMENT_TYPE

