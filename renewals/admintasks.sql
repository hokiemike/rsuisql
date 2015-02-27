select * from TaskType where ProfitCenterKey = 11
delete from TaskType where TaskTypeID in (54,55)

insert into TaskType values ('New Mail',11)
insert into TaskType values ('New Business',11)
go

select * from tasksubtype

select * from ProfitCenter

insert into TaskSubType values (52,'New Mail',1)
insert into TaskSubType values (53,'New Business',1)
go


update TaskSubType set Description = 'Clearance' where TaskSubTypeId = 506
go

