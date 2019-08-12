CREATE TABLE [ast].[OKC_STG_ICD9_Procedure] (
    [Seq_ID]              NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [ICN]                 VARCHAR (50) NULL,
    [ICD_Version]         NUMERIC (18) NULL,
    [SAK_RECIP]           NUMERIC (18) NULL,
    [ICD9_Procedure_Code] VARCHAR (50) NULL,
    [Procedure_Sequence]  NUMERIC (18) NULL,
    [fileName]            VARCHAR (50) NULL,
    [createdDate]         DATETIME     NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'De Identified Member Id', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'OKC_STG_ICD9_Procedure', @level2type = N'COLUMN', @level2name = N'SAK_RECIP';

