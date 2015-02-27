alter table RIDefault
drop column org_number
go

alter table RIDefault
drop constraint FK_RIDefault_Departments
go

alter table RIDefault
drop column department_number
go

alter table RIDefault
drop column DefaultEffectiveDate
go

alter table RIDefault
drop constraint FK_RIDefault_LOCATION
go

alter table RIDefault
drop column LOCATION_SKEY
go