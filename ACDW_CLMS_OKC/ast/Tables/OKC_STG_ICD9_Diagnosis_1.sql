CREATE TABLE [ast].[OKC_STG_ICD9_Diagnosis] (
    [Seq_ID]              NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [ICN]                 VARCHAR (50) NULL,
    [Diagnosis_Sequence]  VARCHAR (8)  NULL,
    [SAK_RECIP]           NUMERIC (18) NULL,
    [ICD9_Diagnosis_Code] VARCHAR (50) NULL,
    [ICD_Version]         NUMERIC (18) NULL,
    [fileName]            VARCHAR (50) NULL,
    [createdDate]         DATETIME     NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'De-identified member ID', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'OKC_STG_ICD9_Diagnosis', @level2type = N'COLUMN', @level2name = N'SAK_RECIP';

