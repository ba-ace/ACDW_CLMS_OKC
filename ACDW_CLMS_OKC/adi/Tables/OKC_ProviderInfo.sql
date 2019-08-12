CREATE TABLE [adi].[OKC_ProviderInfo] (
    [OKC_ProviderInfoKey]  NUMERIC (18)  IDENTITY (1, 1) NOT NULL,
    [Provider_ID]          VARCHAR (50)  NULL,
    [Billing_Provider_NPI] VARCHAR (50)  NULL,
    [Provider_Type]        NUMERIC (20)  NULL,
    [Zip]                  NUMERIC (20)  NULL,
    [Specialty_Primary]    NUMERIC (20)  NULL,
    [Tax_ID]               VARCHAR (50)  NULL,
    [FEIN_SSN_Indicator]   VARCHAR (50)  NULL,
    [start_date]           DATE          NULL,
    [end_date]             DATE          NULL,
    [SrcFileName]          VARCHAR (100) NULL,
    [LoadDate]             DATE          NOT NULL,
    [CreatedDate]          DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            VARCHAR (50)  DEFAULT (suser_sname()) NOT NULL
);

