select top 100 * from UWNetLog 
where Exception like '%Stale%'

select * from UWNetLog 
where 1=1
--and Message like '%modified%'
and Date > '10/16/2008'

select * from UWNetLog 
where 1=1
and Message like '%stale%tasks%'
and Date > '9/01/2008'
order by Date

select * from UWNetLog 
where 1=1
and Message like '%stale%tasks%'
and Date > '9/01/2008'
order by Date

select * from UWNetLog 
where 1=1
and Message like '%grid%rowstyle%'
and Date > '10/01/2008'
order by Date

select HostName, count(id) 
from UWNetLog 
where 1=1
--and Message like '%grid%rowstyle%'
and Date > '10/30/2008'
group by HostName
order by count(id) desc

select HostName, count(id) 
from UWNetLog 
where 1=1
--and Message like '%grid%rowstyle%'
and Logger not like '%.CacheFactory%'
and Date > '10/30/2008'
group by HostName
order by count(id) desc



select * 
from UWNetLog 
where 1=1
--and Message like '%grid%rowstyle%'
and Logger not like '%.CacheFactory%'
and Message not like '%Outlook contact%'
and Date > '11/3/2008'
order by Date desc


