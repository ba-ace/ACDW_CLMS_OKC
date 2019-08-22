CREATE TABLE [adi].[OKC_ICD9_Procedure] (
    [OKC_Proc_Key]        NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [ICN]                 VARCHAR (50)  NULL,
    [ICD_Version]         NUMERIC (18)  NULL,
    [SAK_RECIP]           NUMERIC (18)  NULL,
    [ICD9_Procedure_Code] VARCHAR (50)  NULL,
    [Procedure_Sequence]  NUMERIC (18)  NULL,
    [SrcFileName]         VARCHAR (100) NULL,
    [LoadDate]            DATE          NOT NULL,
    [CreatedDate]         DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL
);

