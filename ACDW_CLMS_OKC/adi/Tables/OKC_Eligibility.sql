CREATE TABLE [adi].[OKC_Eligibility] (
    [OKC_ELigiblityKey]           NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [SAK_RECIP]                   NUMERIC (18)  NULL,
    [Eligibility_Code]            VARCHAR (50)  NULL,
    [Eligibility_Effective_Date]  DATE          NULL,
    [Eligibility_End_Date]        DATE          NULL,
    [Aid_Category]                VARCHAR (50)  NULL,
    [Aid_Category_Effective_Date] DATE          NULL,
    [Aid_Category_End_Date]       DATE          NULL,
    [SrcFileName]                 VARCHAR (100) NULL,
    [LoadDate]                    DATE          NOT NULL,
    [CreatedDate]                 DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                   VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL
);

