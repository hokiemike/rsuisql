select idg.IRFileKey, e.EMP_LAST_NAME, e.EMP_FIRST_NAME, * 
from Task t
join EMPLOYEE e on e.EMP_RECORD_NUMBER = t.CurrentlyAssignedTo
join IRDocumentGroup idg on idg.ReferenceNumber = t.DocRefNUmber
 where  DocRefNUmber is not null 
and Sub_Record_Number is null and CompleteDate is null

select * from IRDocumentGroup where ReferenceNumber = '04dc999d-478d-44a8-bd5e-4a7b01'

select * from Task where CreatedBy = 5515 and CreateDate > '2008-05-05'

select * from Employee where EMP_LAST_NAME like '%wahl%'



