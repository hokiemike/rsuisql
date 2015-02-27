select * from RuleBasedDoc where DocId = 10


select * from Employee where CONTAINS(*,'phil')

select e.EMP_USER_PROFILE, e.EMP_LAST_NAME, e.EMP_FIRST_NAME, b.BRANCH_DESCRIPTION 
from Employee e
join BRANCHES b on b.BRANCH_NUMBER = e.EMP_BRANCH_NUMBER
where CONTAINS(b.BRANCH_DESCRIPTION,'atlanta') or CONTAINS(e.*,'phil')


select e.EMP_USER_PROFILE, e.EMP_LAST_NAME, e.EMP_FIRST_NAME, b.BRANCH_DESCRIPTION 
from Employee e
join BRANCHES b on b.BRANCH_NUMBER = e.EMP_BRANCH_NUMBER
where CONTAINS(b.BRANCH_DESCRIPTION,'LA') or CONTAINS(e.*,'phil')

select e.EMP_USER_PROFILE, e.EMP_LAST_NAME, e.EMP_FIRST_NAME, b.BRANCH_DESCRIPTION 
from Employee e
join BRANCHES b on b.BRANCH_NUMBER = e.EMP_BRANCH_NUMBER
where CONTAINS(b.*,'FORMSOF(INFLECTIONAL,l.a.)') or CONTAINS(e.*,'phil')

select e.EMP_USER_PROFILE, e.EMP_LAST_NAME, e.EMP_FIRST_NAME, b.BRANCH_DESCRIPTION 
from Employee e
join BRANCHES b on b.BRANCH_NUMBER = e.EMP_BRANCH_NUMBER
where FREETEXT(b.*,'los') or CONTAINS(e.*,'phil')




select * from Employee where CONTAINS(*,'FORMSOF(INFLECTIONAL,abc)')

update Employee set emp_first_name = 'a.b.c.' where EMP_RECORD_NUMBER = 4939

select * from Employee where FREETEXT(*,'atl')

select count(*) from Address


select * from Address where FREETEXT(*,'"Main Street"')

select * from Address where CONTAINS(*,'FORMSOF(INFLECTIONAL,lake)')

select * from Address where CONTAINS(*,'lake')


select * from QUOTE_BINDER where SUB_RECORD_NUMBER = 1142979


----------------------------


select * from DOING_BUSINESS_AS_NAMES where DBA_NAME is null


ALTER TABLE [dbo].[DOING_BUSINESS_AS_NAMES]
     ALTER COLUMN [DBA_NAME]
GO

CREATE CLUSTERED INDEX [idx_dba_name]
    ON [dbo].[DOING_BUSINESS_AS_NAMES]([DBA_NAME])
    WITH FILLFACTOR = 95
GO


CREATE UNIQUE INDEX [rbd_unique_doc_state_admitted]
    ON [dbo].[RuleBasedDocStateApproval]([DocId], [STATE_ABBREVIATION], [Admitted])
GO


ALTER TABLE [dbo].[DOING_BUSINESS_AS_NAMES]
	ADD [DBANameId] int IDENTITY (1,1) NOT NULL
GO

ALTER TABLE [dbo].[DOING_BUSINESS_AS_NAMES]
    DROP CONSTRAINT [PK__DOING_BUSINESS_A__09A971A2]
GO


ALTER TABLE [dbo].[DOING_BUSINESS_AS_NAMES]
    ADD CONSTRAINT [PK_DBANameId]
	PRIMARY KEY ([DBANameId])
GO

select top 11 * from DOING_BUSINESS_AS_NAMES






