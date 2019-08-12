CREATE TABLE [ast].[OKC_STG_Claims] (
    [Seq_ID]         NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [ICN]            VARCHAR (13) NULL,
    [SAK_RECIP]      NUMERIC (18) NULL,
    [Patient_Status] VARCHAR (10) NULL,
    [Type_Of_Bill]   NUMERIC (18) NULL,
    [Paid_Date]      DATE         NULL,
    [DRG_Code]       VARCHAR (50) NULL,
    [Claim_Type]     VARCHAR (50) NULL,
    [FileName]       VARCHAR (50) NULL,
    [CreatedDate]    DATETIME     NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SKey created by STG Etl', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'OKC_STG_Claims', @level2type = N'COLUMN', @level2name = N'Seq_ID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Claim Number', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'OKC_STG_Claims', @level2type = N'COLUMN', @level2name = N'ICN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'De-Identified Member Id', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'OKC_STG_Claims', @level2type = N'COLUMN', @level2name = N'SAK_RECIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Name of Source File', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'OKC_STG_Claims', @level2type = N'COLUMN', @level2name = N'FileName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date Row Created', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'OKC_STG_Claims', @level2type = N'COLUMN', @level2name = N'CreatedDate';

