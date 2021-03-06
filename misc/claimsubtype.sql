if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_claims_ClaimSubtype]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[claims] DROP CONSTRAINT FK_claims_ClaimSubtype
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ClaimSubtype]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ClaimSubtype]
GO

CREATE TABLE [dbo].[ClaimSubtype] (
	[ClaimSubtypeKey] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Department] [int] NULL ,
	[Active] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RSAType] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

