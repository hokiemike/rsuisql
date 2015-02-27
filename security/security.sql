select * from SecUser where EmpRecordNumber = 5467
select * from SecUser where EmpRecordNumber = 5300

select * from SecGroupUser where SecUserID = 677
select * from SecGroup where SecGroupID IN (7,13,17)
select * from SecRoleUser where SecUserID = 677

select * from SecGroupUser where SecUserID = 502
select * from SecGroup where SecGroupID IN (7,13,17)
select * from SecRoleUser where SecUserID = 502

select sr.*
from SecRoleUser sru 
join SecRole sr on sru.SecRoleID = sr.SecRoleID
and sru.SecUserID = 502

select distinct sgu.SecGroupID, sr.*
from SecGroupRole sgu 
join SecRole sr on sgu.SecRoleID = sr.SecRoleID
and sgu.SecGroupID IN (7,13,17)
