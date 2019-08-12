CREATE TABLE [adw].[Claims_Member] (
    [SUBSCRIBER_ID]         VARCHAR (50) NOT NULL,
    [IsActiveMember]        TINYINT      CONSTRAINT [DF_ClaimsMember_IsActive] DEFAULT ((0)) NOT NULL,
    [DOB]                   VARCHAR (50) NULL,
    [MEMB_LAST_NAME]        VARCHAR (50) NULL,
    [MEMB_MIDDLE_INITIAL]   VARCHAR (50) NULL,
    [MEMB_FIRST_NAME]       VARCHAR (50) NULL,
    [MEDICAID_NO]           VARCHAR (50) NULL,
    [MEDICARE_NO]           VARCHAR (50) NULL,
    [GENDER]                VARCHAR (5)  NULL,
    [MEMB_ZIP]              VARCHAR (50) NULL,
    [COMPANY_CODE]          VARCHAR (50) NULL,
    [LINE_OF_BUSINESS_DESC] VARCHAR (50) NULL,
    [LoadDate]              DATETIME     NOT NULL,
    [CreatedDate]           DATETIME     DEFAULT (sysdatetime()) NOT NULL,
    [CreatedBy]             VARCHAR (50) DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]       DATETIME     DEFAULT (sysdatetime()) NOT NULL,
    [LastUpdatedBy]         VARCHAR (50) DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [PK_Claims_Member] PRIMARY KEY CLUSTERED ([SUBSCRIBER_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NdxClmsMmbr_LOB]
    ON [adw].[Claims_Member]([LINE_OF_BUSINESS_DESC] ASC)
    INCLUDE([SUBSCRIBER_ID], [DOB], [MEMB_LAST_NAME], [MEMB_MIDDLE_INITIAL], [MEDICAID_NO], [MEDICARE_NO], [GENDER], [MEMB_ZIP], [COMPANY_CODE]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsMmbr_LOB]
    ON [adw].[Claims_Member]([LINE_OF_BUSINESS_DESC] ASC)
    INCLUDE([SUBSCRIBER_ID], [DOB], [MEMB_LAST_NAME], [MEMB_MIDDLE_INITIAL], [MEDICAID_NO], [MEDICARE_NO], [GENDER], [MEMB_ZIP], [COMPANY_CODE]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsMbrs_IsActive]
    ON [adw].[Claims_Member]([IsActiveMember] ASC)
    INCLUDE([SUBSCRIBER_ID], [DOB]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsMbrs_Gender]
    ON [adw].[Claims_Member]([IsActiveMember] ASC, [GENDER] ASC)
    INCLUDE([SUBSCRIBER_ID], [DOB]);


GO
CREATE NONCLUSTERED INDEX [Ndx_ClmsMbrs_SubscriberId]
    ON [adw].[Claims_Member]([SUBSCRIBER_ID] ASC)
    INCLUDE([DOB]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Member_19_933578364__K1_K10]
    ON [adw].[Claims_Member]([SUBSCRIBER_ID] ASC, [MEMB_ZIP] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_Claims_Member_19_933578364__K1]
    ON [adw].[Claims_Member]([SUBSCRIBER_ID] ASC);


GO


CREATE TRIGGER adw.Claims_Member_AfterUpdate
ON adw.Claims_Member
AFTER UPDATE 
AS
   UPDATE adw.Claims_Member
   SET LastUpdatedDate = SYSDATETIME()
	, LastUpdatedBy = SYSTEM_USER
   FROM Inserted i
   WHERE adw.Claims_Member.Subscriber_ID = i.Subscriber_ID;
