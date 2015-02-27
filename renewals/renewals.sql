select distinct datepart(month, s.SUB_EFFECTIVE_DATE) as m, datepart(year, s.SUB_EFFECTIVE_DATE) as y
from RENEWAL_LOG rl
join SUBMISSION s on rl.NEW_SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
where datepart(month, rl.LOG_CREATION_DATE) = 11
  and datepart(year, rl.LOG_CREATION_DATE) = 2008
order by y, m

select datepart(month,max( s.SUB_EFFECTIVE_DATE )), datepart(year,max( s.SUB_EFFECTIVE_DATE ))
from RENEWAL_LOG rl
join SUBMISSION s on rl.NEW_SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
where 1=1
  and datepart(month, rl.LOG_CREATION_DATE) = 11
  and datepart(year, rl.LOG_CREATION_DATE) = 2008

order by y, m

select rl.LOG_CREATION_DATE, rl.*
from RENEWAL_LOG rl
join SUBMISSION s on rl.NEW_SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
where 1=1
  and datepart(month, rl.LOG_CREATION_DATE) = 11
  and datepart(year, rl.LOG_CREATION_DATE) = 2008
  and datepart(day, rl.LOG_CREATION_DATE) NOT IN ( 15, 21 )


select rl.LOG_CREATION_DATE, rl.*
from RENEWAL_LOG rl
join SUBMISSION s on rl.NEW_SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
where 1=1
  and datepart(month, rl.LOG_CREATION_DATE) = 10
  and datepart(year, rl.LOG_CREATION_DATE) = 2008
  --and isnull(rl.LOG_MODIFIED_DATE,'1/1/1999') != isnull(LOG_CREATION_DATE,'1/1/1999')
  and ABS(DATEDIFF(minute,rl.LOG_MODIFIED_DATE,rl.LOG_CREATION_DATE)) > 30






select *
from RENEWAL_LOG rl
join SUBMISSION s on rl.NEW_SUB_RECORD_NUMBER = s.SUB_RECORD_NUMBER
where datepart(month, rl.LOG_CREATION_DATE) = 11
  and datepart(year, rl.LOG_CREATION_DATE) = 2008
  and s.SUB_EFFECTIVE_DATE < '11-1-2008'
