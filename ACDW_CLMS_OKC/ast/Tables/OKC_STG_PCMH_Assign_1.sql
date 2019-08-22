CREATE TABLE [ast].[OKC_STG_PCMH_Assign] (
    [Seq_ID]                     NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [Provider_ID]                VARCHAR (50) NULL,
    [SAK_RECIP]                  NUMERIC (18) NULL,
    [Sooner_Care_Program]        VARCHAR (50) NULL,
    [Sooner_Care_Effective_Date] DATE         NULL,
    [Sooner_Care_End_Date]       DATE         NULL,
    [FileName]                   VARCHAR (50) NULL,
    [CreatedDate]                DATETIME     NULL
);

