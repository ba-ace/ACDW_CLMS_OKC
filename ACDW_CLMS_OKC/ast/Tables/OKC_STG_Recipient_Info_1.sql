CREATE TABLE [ast].[OKC_STG_Recipient_Info] (
    [Seq_ID]                          NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [SAK_RECIP]                       NUMERIC (18) NULL,
    [Date_of_Birth]                   DATE         NULL,
    [Gender]                          VARCHAR (5)  NULL,
    [Zip]                             NUMERIC (10) NULL,
    [Race_Code]                       VARCHAR (5)  NULL,
    [Ethnic_Code]                     VARCHAR (5)  NULL,
    [Tribal_Verification_Description] VARCHAR (77) NULL,
    [Valid_ID_Indicator]              VARCHAR (2)  NULL,
    [FileName]                        VARCHAR (50) NULL,
    [CreatedDate]                     DATETIME     NULL
);

