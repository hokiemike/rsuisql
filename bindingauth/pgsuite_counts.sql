select count (distinct pgi.PGInputKey)
from PGInput pgi
join PGTransaction pt on pt.PGInputKey = pgi.PGInputKey
and ModifiedDate >= '5/7/2009'


--
-- number of successes (2 transactions, where most current is SUCCESS)
--
select count(pgi.PGInputKey)
from PGInput pgi
join PGTransaction pgt on pgt.PGInputKey = pgi.PGInputKey and pgt.IsCurrent = 1
where 1=1
and 2 = (
    select count(*) 
        from PGTransaction pt2  
        where pt2.PGInputKey = pgi.PGInputKey )
and pgt.PGTransactionTypeKey = 2
and dbo.udf_rpt_StripTimeFromDate(pgi.CreateDate) = '5/7/2009'

--
-- number of storeds (1 transaction, most current is stored)
--
select count(pgi.PGInputKey)
from PGInput pgi
join PGTransaction pgt on pgt.PGInputKey = pgi.PGInputKey and pgt.IsCurrent = 1
where 1=1
and 1 = (
    select count(*) 
        from PGTransaction pt2  
        where pt2.PGInputKey = pgi.PGInputKey )
and pgt.PGTransactionTypeKey = 6
and dbo.udf_rpt_StripTimeFromDate(pgi.CreateDate) = '5/7/2009'

--
-- total 
--
select count(pgi.PGInputKey)
from PGInput pgi
where 1=1
and dbo.udf_rpt_StripTimeFromDate(pgi.CreateDate) = '5/7/2009'




declare @RETURN_VALUE datetime
set @RETURN_VALUE = '2005-01-01 12:00:00 AM'
declare @InDate datetime
set @InDate = '2005-01-01 12:00:00 AM'
EXECUTE @RETURN_VALUE = [dbo].[udf_rpt_StripTimeFromDate] @InDate 
print '@RETURN_VALUE: ' + @RETURN_VALUE
print '@InDate: ' + @InDate
GO


select * from PGTransactionType