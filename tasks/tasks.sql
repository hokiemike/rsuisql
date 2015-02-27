select stat.STATUS_NAME, s.EMP_RECORD_NUMBER, e.EMP_LAST_NAME, sus.*
from SUSPENSE sus 
join SUBMISSION s on s.SUB_RECORD_NUMBER = sus.SUB_RECORD_NUMBER
join SUSPENSE_STATUS stat on stat.STATUS_SKEY = sus.SUSPENSE_STATUS
join EMPLOYEE e on e.EMP_RECORD_NUMBER = s.EMP_RECORD_NUMBER
where 1=1
 and s.DEPARTMENT_NUMBER = 300
 and s.STATUS_CODE = 'Q'
 and s.CreateDate > '5/1/2007'
 --and sus.SUSPENSE_COMMENT like '%premium ind%'



--
-- INSERT SAMPLE TASKS BASED ON SUSPENSE ITEMS 
--
INSERT INTO TASK
select  3,
        s.SUB_RECORD_NUMBER,
        s.EMP_RECORD_NUMBER,
        5300,
        null, --completed by
        'Test task for entered for ' + convert(varchar,s.SUB_INSURED_NAME),
        sus.SUSPENSE_DATE, --createdate
        null, --completeDate
        null, --SuspenseDate
        0, --IsHighPriority
        null --docid
from SUSPENSE sus 
join SUBMISSION s on s.SUB_RECORD_NUMBER = sus.SUB_RECORD_NUMBER
join SUSPENSE_STATUS stat on stat.STATUS_SKEY = sus.SUSPENSE_STATUS
join EMPLOYEE e on e.EMP_RECORD_NUMBER = s.EMP_RECORD_NUMBER
where 1=1
 and s.DEPARTMENT_NUMBER = 300
 and s.STATUS_CODE = 'Q'
 and s.CreateDate > '1/1/2007'
 --and sus.SUSPENSE_COMMENT like '%premium ind%'
--and sus.SUSPENSE_COMMENT not like '%renew%'

--
-- INSERT SAMPLE TASKHISTORY FOR INSERTED TASKS ITEMS 
--
INSERT INTO TaskHistory
select 9,TaskID,t.AssignedTo,5300,'A sample note.  John is cool.',t.CreateDate
from Task t
where t.CreatedBy = 5300

select *
from Task t
where t.CreatedBy = 5300

select * from TaskSubType where TaskTypeID = 3

select * from TaskHistory

select * from SUSPENSE_STATUS

INSERT INTO Task

INSERT INTO [Task]([TaskID], [TaskTypeID], [Sub_Record_Number], [AssignedTo], [CreatedBy], [CompletedBy], [Description], [CreateDate], [CompleteDate], [SuspenseDate], [IsHighPriority], [DocID])
  VALUES(4, 4, 1197239, 5201, 5452, NULL, 'Renewal of: NHP624432 00 Foster Avenue Apartment Corporation', '20071213 15:02:55.0', NULL, NULL, 1, NULL)
GO

select * from Task

select * from TaskType

select * from Task

-- renewal histories
select th.* 
from TaskHistory th
 join Task t on t.TaskID = th.TaskID 
where 1=1
 and t.TaskTypeID = 4


select *
from TaskHistory
where 1=1


select * from SecUser 

select * 
from TaskSubType
where TaskTypeID = 4


select * 
from TaskType
where 1=1
 and Department_Number = 300
