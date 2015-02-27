select * from UWNetLog 
where 1=1
 and DATEDIFF(day, Date, getdate()) < 1
 and Message not like '%RemoveTempFiles%'
 and Message not like '%Cannot access a disposed%'
 and Exception not like '%System.Windows.Forms.AxHost.OleInterfaces.AttemptStopEvents%'
order by Date Desc

go



select * from UWNetLog 
where 1=1
 and DATEDIFF(day, Date, getdate()) < 1
 and HostName like '%drake%'
order by Date Desc
go


select * from UWNetLog 
where 1=1
 --and DATEDIFF(day, Date, getdate()) < 1
-- and HostName like '%drake%'
--and Message like '%deadlock%'
and Date > '2008-10-22'
order by Date Desc
go


