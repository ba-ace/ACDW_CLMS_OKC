CREATE TABLE [adi].[OKC_Claims] (
    [OKC_ClaimKey]   NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [ICN]            VARCHAR (13)  NULL,
    [SAK_RECIP]      NUMERIC (18)  NULL,
    [Patient_Status] VARCHAR (10)  NULL,
    [Type_Of_Bill]   NUMERIC (18)  NULL,
    [Paid_Date]      DATE          NULL,
    [DRG_Code]       VARCHAR (50)  NULL,
    [Claim_Type]     VARCHAR (50)  NULL,
    [SrcFileName]    VARCHAR (100) NULL,
    [LoadDate]       DATE          NOT NULL,
    [CreatedDate]    DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([OKC_ClaimKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_adiOkcClaims_ICN]
    ON [adi].[OKC_Claims]([ICN] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Identifying Claim Number', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'OKC_Claims', @level2type = N'COLUMN', @level2name = N'ICN';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'De-Identified Member ID', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'OKC_Claims', @level2type = N'COLUMN', @level2name = N'SAK_RECIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Source File Name', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'OKC_Claims', @level2type = N'COLUMN', @level2name = N'SrcFileName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date row created ', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'OKC_Claims', @level2type = N'COLUMN', @level2name = N'CreatedDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'User who created the row', @level0type = N'SCHEMA', @level0name = N'adi', @level1type = N'TABLE', @level1name = N'OKC_Claims', @level2type = N'COLUMN', @level2name = N'CreatedBy';

