select *
from DOING_BUSINESS_AS_NAMES


-- 
-- BEGIN script to add identity to DOING_BUSINESS_AS_NAMES; MAKE SEQUENCES ZERO BASED
-- 

CREATE TABLE [dbo].[TEMP_DOING_BUSINESS_AS_NAMES] ( 
    [SUB_RECORD_NUMBER]	domain_integer NOT NULL,
    [DBA_SEQUENCE_NO]  	domain_integer NOT NULL,
    [DBA_NAME]         	varchar(200) NULL,
    [VersionTimestamp] 	datetime NOT NULL DEFAULT (1 / 1 / 1900),
    CONSTRAINT [PK__TEMP_DOING_BUSINESS_AS_NAME] PRIMARY KEY([DBA_SEQUENCE_NO],[SUB_RECORD_NUMBER])
)
GO

insert into TEMP_DOING_BUSINESS_AS_NAMES
select *
from DOING_BUSINESS_AS_NAMES 
GO

DROP TABLE DOING_BUSINESS_AS_NAMES
go

CREATE TABLE [dbo].[DOING_BUSINESS_AS_NAMES] (
    [DBANameKey]       	int IDENTITY(1,1) NOT NULL, 
    [SUB_RECORD_NUMBER]	domain_integer NOT NULL,
    [DBA_SEQUENCE_NO]  	domain_integer NOT NULL,
    [DBA_NAME]         	varchar(200) NULL,
    [VersionTimestamp] 	datetime NOT NULL DEFAULT (1 / 1 / 1900),
    CONSTRAINT [PK_DOING_BUSINESS_AS_NAME] PRIMARY KEY([DBANameKey])
)
GO

ALTER TABLE [dbo].[DOING_BUSINESS_AS_NAMES]
    ADD CONSTRAINT [FK_DOING_BUSINESS_AS_NAMES_SUBMISSION]
	FOREIGN KEY([SUB_RECORD_NUMBER])
	REFERENCES [dbo].[SUBMISSION]([SUB_RECORD_NUMBER])
	ON DELETE NO ACTION 
	ON UPDATE NO ACTION 
GO

insert into DOING_BUSINESS_AS_NAMES
select *
from TEMP_DOING_BUSINESS_AS_NAMES 
GO

update DOING_BUSINESS_AS_NAMES set DBA_SEQUENCE_NO = (DBA_SEQUENCE_NO - 1)
go

drop table TEMP_DOING_BUSINESS_AS_NAMES
go

-- 
-- END script to add identity to DOING_BUSINESS_AS_NAMES; MAKE SEQUENCES ZERO BASED
-- 

select * from DOING_BUSINESS_AS_NAMES where DBA_SEQUENCE_NO = 0


update DOING_BUSINESS_AS_NAMES set DBA_SEQUENCE_NO = (DBA_SEQUENCE_NO - 1)
go

select top 500 * from DOING_BUSINESS_AS_NAMES

