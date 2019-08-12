CREATE TABLE [ast].[OKC_STG_PCMH_Rates] (
    [Provider_ID]              VARCHAR (50) NULL,
    [Seq_ID]                   NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [MH_Rate_Category]         VARCHAR (50) NULL,
    [Payment_Tier_Code]        VARCHAR (50) NULL,
    [Rate_Cell_Age_Group]      VARCHAR (50) NULL,
    [Rate_Cell_Code]           VARCHAR (50) NULL,
    [Rate_Cell_Effective_Date] DATE         NULL,
    [Rate_Cell_End_Date]       DATE         NULL,
    [Rate_Cell_Type]           VARCHAR (50) NULL,
    [fileName]                 VARCHAR (50) NULL,
    [createddate]              DATETIME     NULL
);

