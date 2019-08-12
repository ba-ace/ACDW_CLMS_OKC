CREATE TABLE [ast].[OKC_STG_Eligibility] (
    [Seq_ID]                      NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [SAK_RECIP]                   NUMERIC (18) NULL,
    [Eligibility_Code]            VARCHAR (50) NULL,
    [Eligibility_Effective_Date]  DATE         NULL,
    [Eligibility_End_Date]        DATE         NULL,
    [Aid_Category]                VARCHAR (50) NULL,
    [Aid_Category_Effective_Date] DATE         NULL,
    [Aid_Category_End_Date]       DATE         NULL,
    [fileName]                    VARCHAR (50) NULL,
    [createdDate]                 DATETIME     NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'De-identified member ID', @level0type = N'SCHEMA', @level0name = N'ast', @level1type = N'TABLE', @level1name = N'OKC_STG_Eligibility', @level2type = N'COLUMN', @level2name = N'SAK_RECIP';

