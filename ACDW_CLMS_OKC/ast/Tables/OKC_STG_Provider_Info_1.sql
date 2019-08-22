CREATE TABLE [ast].[OKC_STG_Provider_Info] (
    [Seq_ID]               NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [Provider_ID]          VARCHAR (50) NULL,
    [Billing_Provider_NPI] VARCHAR (50) NULL,
    [Provider_Type]        NUMERIC (20) NULL,
    [Zip]                  NUMERIC (20) NULL,
    [Specialty_Primary]    NUMERIC (20) NULL,
    [Tax_ID]               VARCHAR (50) NULL,
    [FEIN_SSN_Indicator]   VARCHAR (50) NULL,
    [start_date]           DATE         NULL,
    [end_date]             DATE         NULL,
    [fileName]             VARCHAR (50) NULL,
    [createddate]          DATETIME     NULL
);

