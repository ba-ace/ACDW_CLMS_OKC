CREATE TABLE [adi].[OKC_PcmhRates] (
    [OKC_PcmhRateKey]          NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [Provider_ID]              VARCHAR (50)  NULL,
    [MH_Rate_Category]         VARCHAR (50)  NULL,
    [Payment_Tier_Code]        VARCHAR (50)  NULL,
    [Rate_Cell_Age_Group]      VARCHAR (50)  NULL,
    [Rate_Cell_Code]           VARCHAR (50)  NULL,
    [Rate_Cell_Effective_Date] DATE          NULL,
    [Rate_Cell_End_Date]       DATE          NULL,
    [Rate_Cell_Type]           VARCHAR (50)  NULL,
    [SrcFileName]              VARCHAR (100) NULL,
    [LoadDate]                 DATE          NOT NULL,
    [CreatedDate]              DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL
);

