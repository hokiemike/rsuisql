USE [RSUI_PROD]
GO

/****** Object:  StoredProcedure [dbo].[usp_UW_RetrieveTasksWorked]    Script Date: 11/24/2014 08:52:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[usp_UW_RetrieveTasksWorked]
@empRecordNumber int,
@sinceDate datetime

AS

DECLARE @LastNoteTemp TABLE(TaskID int, LastNote text)

DECLARE @taskIDs TABLE(TaskID int NOT NULL)

DECLARE @temp TABLE(TaskID int primary key,
					CurrentStackID int,
					CurrentStepID int,
					CreateDate datetime,
					CompleteDate datetime,
					SuspenseDate datetime,
					IsHighPriority bit,
					DocRefNumber varchar(36),
					VersionTimestamp datetime,
					CurrentStackDescription varchar(255),
					FirstName varchar(60), 
					LastName varchar(60),
					UnderwriterFirstName varchar(60), 
					UnderwriterLastName varchar(60),
					InsuredName varchar(200),
					SubRecordNumber int,
					SubTransmitDate datetime,
					ProblemWatchFlag bit,
					PolicyNbr int,
					PolicySuffix numeric(2,0),
					SubNbr int, 
					EffectiveDate datetime, 
					ExpirationDate datetime,
					SubStatusCode varchar(20), 
					IRFileKey int, 
					CurrentStepDescription varchar(50), 
					LastNote text, 
					SubDeptNbr int, 
					SubProfitCenterKey int,
					SubStatus varchar(60),
					Broker varchar(125),
					SubmissionTimestamp datetime,
					LastModifiedDate datetime,
					CurrentlyAssignToID int,
					PrevSubRecordNumber int,
					PrevIRFileKey int,
					CompanionPolicyGrpNbr int,
					ProducerLocation varchar(60),
					AuditStatus varchar(10),
					AuditRecordTimestamp datetime)
					
INSERT INTO @taskIDs
SELECT DISTINCT t.TaskID as TaskID
FROM TaskHistory th
INNER JOIN Task t ON th.TaskID = t.TaskID
WHERE ((th.AssignedBy = @empRecordNumber AND th.CreateDate >= @sinceDate)
OR (t.SuspensedBy = @empRecordNumber AND t.SuspensedOn >= @sinceDate))

INSERT INTO @temp
SELECT 	t.TaskID as TaskID, 
		t.CurrentTaskType as CurrentStackID, 
		t.CurrentSubType as CurrentStepID, 
		t.CreateDate as CreateDate, 
		t.CompleteDate as CompleteDate, 
		t.SuspenseDate as SuspenseDate, 
		t.IsHighPriority as IsHighPriority, 
		t.DocRefNumber as DocRefNumber, 
		t.VersionTimestamp as VersionTimestamp,
		tt.Description as CurrentStackDescription,
		e.Emp_First_Name as FirstName, 
		e.Emp_Last_Name as LastName, 
        e1.Emp_First_Name as UnderwriterFirstName, 
		e1.Emp_Last_Name as UnderwriterLastName,
        s.Sub_Insured_Name as InsuredName, 
		s.Sub_Record_Number as SubRecordNumber, 
		s.SUB_TRANSMISSION_DATE as SubTransmitDate,
		s.ProblemWatchFlag as ProblemWatchFlag, 		
        s.Sub_Policy_Number as PolicyNbr,
		s.Sub_Policy_Suffix as PolicySuffix,
		s.Sub_Submission_Number as SubNbr, 
		s.Sub_Current_Effective_Date as EffectiveDate, 
		s.Sub_Current_Expiration_Date as ExpirationDate,
		s.Status_Code as SubStatusCode, 
        ir.IRFileKey as IRFileKey,
        tst.Description as CurrentStepDescription, 
		NULL as LastNote, 
        d.Department_Number as SubDeptNbr, 
		d.ProfitCenterKey as SubProfitCenterKey,
        st.Status_Description as SubStatus,
        case
             when p.Last_Name = '' and p.First_Name = '' then ''
             when p.Last_Name = '' then p.First_Name 
             when p.First_Name = '' then p.Last_Name 
			 else p.Last_Name + ', ' + p.First_Name
		end as Broker,
		s.VersionTimestamp as SubmissionTimestamp,
		t.LastModifiedDate as LastModifiedDate,
		t.CurrentlyAssignedTo as CurrentlyAssignToID,
		s.Prior_Sub_Record_Number as PrevSubRecordNumber,
		ir2.IRFileKey as PrevIRFileKey,
		s.CompanionPolicyGroupNbr as CompanionPolicyGrpNbr,
		l.Internal_Name as ProducerLocation,
		ar.AuditStatus,
		ar.VersionTimestamp as AuditRecordTimestamp
FROM Task t
INNER JOIN @taskIDs ids on t.TaskID = ids.TaskID 
LEFT OUTER JOIN Submission s on t.Sub_Record_Number = s.Sub_Record_Number 
LEFT OUTER JOIN Submission s2 on s.Prior_Sub_Record_Number = s2.Sub_Record_Number
LEFT OUTER JOIN IRFile ir on s.Sub_Record_Number = ir.Sub_Record_Number 
LEFT OUTER JOIN IRFile ir2 on s2.Sub_Record_Number = ir2.Sub_Record_Number
LEFT OUTER JOIN TaskType tt on t.CurrentTaskType = tt.TaskTypeID
LEFT OUTER JOIN TaskSubType tst on t.CurrentSubType = tst.TaskSubTypeID
LEFT OUTER JOIN Employee e on t.CurrentlyAssignedTo = e.Emp_Record_Number
LEFT OUTER JOIN Employee e1 on s.Emp_Record_Number = e1.Emp_Record_Number
LEFT OUTER JOIN Departments d on s.Department_Number = d.Department_Number
LEFT OUTER JOIN Status st on s.Status_Code = st.Status_Code
LEFT OUTER JOIN People p on s.People_Skey = p.People_Skey
left outer join location l
	on s.location_Skey = l.Location_Skey
left outer join AuditRecord ar
	on t.Sub_Record_Number = ar.Sub_Record_Number
ORDER BY t.CreateDate

INSERT INTO @LastNoteTemp
SELECT t.TaskID, null
FROM @temp t
--LEFT OUTER JOIN TaskHistory th
--	on t.TaskID = th.TaskID
--WHERE th.TaskSubTypeID = (select max(TaskSubTypeID) from TaskHistory where TaskID = t.TaskID)
	 
UPDATE lnt
SET LastNote = th.Note
FROM @LastNoteTemp lnt
LEFT OUTER JOIN TaskHistory th 
	on lnt.TaskID = th.TaskID
WHERE  th.TaskHistoryID = (select max(TaskHistoryID) from TaskHistory where TaskID = lnt.TaskID and (Note is not null and LTRIM(RTRIM(CAST(Note AS VARCHAR))) <> ''))

UPDATE tmp
SET LastNote = lnt.LastNote
FROM @temp tmp
INNER JOIN @LastNoteTemp lnt
	ON tmp.TaskID = lnt.TaskID
	
SELECT * FROM @temp



GO


