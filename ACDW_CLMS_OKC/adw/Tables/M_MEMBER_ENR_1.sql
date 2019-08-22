﻿CREATE TABLE [adw].[M_MEMBER_ENR] (
    [M_Registration_ID]              VARCHAR (12)  NULL,
    [SUBSCRIBER_ID]                  VARCHAR (50)  NOT NULL,
    [CLIENT_ID]                      VARCHAR (5)   NULL,
    [M_Title]                        VARCHAR (3)   NULL,
    [M_First_Name]                   VARCHAR (50)  NULL,
    [M_Last_Name]                    VARCHAR (50)  NULL,
    [M_Middle_Name]                  VARCHAR (50)  NULL,
    [M_Gender]                       VARCHAR (1)   NULL,
    [M_Date_Of_Birth]                DATETIME      NULL,
    [M_Alternate_Number]             VARCHAR (20)  NULL,
    [M_Mobile_Number]                VARCHAR (20)  NULL,
    [M_Email_Id]                     VARCHAR (50)  NULL,
    [M_Address_Line1_Res]            VARCHAR (150) NULL,
    [M_Address_Line2_Res]            VARCHAR (150) NULL,
    [M_City_Res]                     VARCHAR (50)  NULL,
    [M_State_Res]                    VARCHAR (30)  NULL,
    [M_County_Res]                   VARCHAR (30)  NULL,
    [M_Zip_Code_Res]                 VARCHAR (9)   NULL,
    [M_Address_Line1_Office]         VARCHAR (150) NULL,
    [M_Address_Line2_Office]         VARCHAR (150) NULL,
    [M_City_Office]                  VARCHAR (50)  NULL,
    [M_State_Office]                 VARCHAR (30)  NULL,
    [M_County_Office]                VARCHAR (30)  NULL,
    [M_Zip_Code_Office]              VARCHAR (9)   NULL,
    [M_SSN]                          VARCHAR (15)  NULL,
    [M_Ethinicity]                   VARCHAR (15)  NULL,
    [M_Primary_Address]              TINYINT       NULL,
    [M_Emergency_Contact]            VARCHAR (60)  NULL,
    [M_Emergency_Phone]              VARCHAR (20)  NULL,
    [M_Relationship]                 VARCHAR (2)   NULL,
    [M_Authentication_Key]           VARCHAR (100) NULL,
    [M_Photo_Path]                   VARCHAR (150) NULL,
    [M_Is_Active]                    SMALLINT      NULL,
    [M_Account_Status]               INT           NULL,
    [M_Insured_ID]                   VARCHAR (20)  NULL,
    [M_Patient_Status]               SMALLINT      NULL,
    [M_Ins_Plan_ID]                  INT           NULL,
    [M_Policy_Group]                 VARCHAR (20)  NULL,
    [M_Insurance_Plan]               VARCHAR (50)  NULL,
    [M_Employer]                     VARCHAR (60)  NULL,
    [M_Plan_Start_Dt]                DATETIME      NULL,
    [M_Plan_End_Dt]                  DATETIME      NULL,
    [M_Plan_isActive]                SMALLINT      NULL,
    [M_Insured_First_Name]           VARCHAR (50)  NULL,
    [M_Insured_Last_Name]            VARCHAR (50)  NULL,
    [M_Insured_Middle_Name]          VARCHAR (50)  NULL,
    [M_Insured_Gender]               VARCHAR (1)   NULL,
    [M_Insured_DOB]                  DATETIME      NULL,
    [M_Insured_Telephone]            VARCHAR (20)  NULL,
    [M_Insured_Address]              VARCHAR (150) NULL,
    [M_Insured_City]                 VARCHAR (30)  NULL,
    [M_Insured_State]                VARCHAR (50)  NULL,
    [M_Insured_Zip_Code]             VARCHAR (9)   NULL,
    [M_Insured_Email_Id]             VARCHAR (50)  NULL,
    [M_Other_Health_Plan]            TINYINT       NULL,
    [PRODUCT_ID]                     VARCHAR (50)  NULL,
    [LINE_OF_BUSINESS]               VARCHAR (50)  NULL,
    [PLAN_CODE]                      VARCHAR (50)  NULL,
    [PLAN_DESC]                      VARCHAR (50)  NULL,
    [PLAN_ID]                        VARCHAR (50)  NULL,
    [PRODUCT_CODE]                   VARCHAR (50)  NULL,
    [SUBGRP_ID]                      VARCHAR (50)  NULL,
    [SUBGRP_NAME]                    VARCHAR (150) NULL,
    [MEDICAID_ID]                    VARCHAR (50)  NULL,
    [MEDICARE_ID]                    VARCHAR (50)  NULL,
    [PCP_PRACTICE_TIN]               VARCHAR (50)  NULL,
    [PCP_NPI]                        VARCHAR (50)  NULL,
    [PCP_FIRST_NAME]                 VARCHAR (50)  NULL,
    [PCP_LAST_NAME]                  VARCHAR (50)  NULL,
    [MEMBER_ORG_EFF_DATE]            DATETIME      NULL,
    [MEMBER_CONT_EFF_DATE]           DATETIME      NULL,
    [MEMBER_CUR_EFF_DATE]            DATETIME      NULL,
    [MEMBER_CUR_TERM_DATE]           DATETIME      NULL,
    [AUTO_ASSIGN]                    VARCHAR (50)  NULL,
    [MEMBER_STATUS]                  VARCHAR (50)  NULL,
    [MEMBER_TERM_DATE]               VARCHAR (50)  NULL,
    [CLIENT_ADMIT_RISK_SCORE]        VARCHAR (50)  NULL,
    [CLIENT_RISK_CATEGORY_C]         VARCHAR (50)  NULL,
    [PRIMARY_RISK_FACTOR]            VARCHAR (150) NULL,
    [TOTAL_COSTS_LAST_12_MOS]        VARCHAR (50)  NULL,
    [COUNT_OPEN_CARE_OPPS]           VARCHAR (50)  NULL,
    [INP_COSTS_LAST_12_MOS]          VARCHAR (50)  NULL,
    [ER_COSTS_LAST_12_MOS]           VARCHAR (50)  NULL,
    [OUTP_COSTS_LAST_12_MOS]         VARCHAR (50)  NULL,
    [PHARMACY_COSTS_LAST_12_MOS]     VARCHAR (50)  NULL,
    [PRIMARY_CARE_COSTS_LAST_12_MOS] VARCHAR (50)  NULL,
    [BEHAVIORAL_COSTS_LAST_12_MOS]   VARCHAR (50)  NULL,
    [OTHER_OFFICE_COSTS_LAST_12_MOS] VARCHAR (50)  NULL,
    [INP_ADMITS_LAST_12_MOS]         VARCHAR (50)  NULL,
    [LAST_INP_DISCHARGE]             DATETIME      NULL,
    [ER_VISITS_LAST_12_MOS]          VARCHAR (50)  NULL,
    [LAST_ER_VISIT]                  DATETIME      NULL,
    [LAST_PCP_VISIT]                 DATETIME      NULL,
    [LAST_PCP_PRACTICE_SEEN]         VARCHAR (50)  NULL,
    [LAST_BH_VISIT]                  DATETIME      NULL,
    [LAST_BH_PRACTICE_SEEN]          VARCHAR (50)  NULL,
    [MEMBER_POD]                     VARCHAR (50)  NULL,
    [MEMBER_POD_DESC]                VARCHAR (50)  NULL,
    [CLIENT_UNIQUE_SYSTEM_ID]        VARCHAR (50)  NULL,
    [MBR_YEAR]                       INT           NULL,
    [MBR_MTH]                        INT           NULL,
    [LOAD_DATE]                      VARCHAR (50)  NULL,
    [LOAD_USER]                      VARCHAR (50)  NULL,
    [M_Member_Seq_ID]                BIGINT        IDENTITY (1, 1) NOT NULL,
    PRIMARY KEY CLUSTERED ([M_Member_Seq_ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ndx_M_Member_Enr_Gender]
    ON [adw].[M_MEMBER_ENR]([M_Gender] ASC)
    INCLUDE([SUBSCRIBER_ID]);


GO
CREATE NONCLUSTERED INDEX [Ndx_M_MbrEnr_SubscriberID]
    ON [adw].[M_MEMBER_ENR]([SUBSCRIBER_ID] ASC)
    INCLUDE([M_Date_Of_Birth]);


GO
CREATE NONCLUSTERED INDEX [Ndx_M_Mbr_Enr_Gender]
    ON [adw].[M_MEMBER_ENR]([M_Gender] ASC)
    INCLUDE([SUBSCRIBER_ID], [M_Date_Of_Birth], [MBR_YEAR], [MBR_MTH]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_SUBSCRIBER_ID_M_Date_Of_Birth__M_Gender_CLIENT_ID]
    ON [adw].[M_MEMBER_ENR]([SUBSCRIBER_ID] ASC, [M_Date_Of_Birth] ASC, [M_Gender] ASC, [CLIENT_ID] ASC)
    INCLUDE([M_Member_Seq_ID]);


GO
CREATE STATISTICS [_dta_stat_935674381_9_3_2]
    ON [adw].[M_MEMBER_ENR]([M_Date_Of_Birth], [CLIENT_ID], [SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_935674381_9_2_104_3_8]
    ON [adw].[M_MEMBER_ENR]([M_Date_Of_Birth], [SUBSCRIBER_ID], [M_Member_Seq_ID], [CLIENT_ID], [M_Gender]);


GO
CREATE STATISTICS [_dta_stat_935674381_8_9_3_2]
    ON [adw].[M_MEMBER_ENR]([M_Gender], [M_Date_Of_Birth], [CLIENT_ID], [SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_935674381_8_3_2]
    ON [adw].[M_MEMBER_ENR]([M_Gender], [CLIENT_ID], [SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_935674381_104_9]
    ON [adw].[M_MEMBER_ENR]([M_Member_Seq_ID], [M_Date_Of_Birth]);


GO
CREATE STATISTICS [_dta_stat_935674381_2_104]
    ON [adw].[M_MEMBER_ENR]([SUBSCRIBER_ID], [M_Member_Seq_ID]);


GO
CREATE STATISTICS [_dta_stat_935674381_104_3_8_2]
    ON [adw].[M_MEMBER_ENR]([M_Member_Seq_ID], [CLIENT_ID], [M_Gender], [SUBSCRIBER_ID]);


GO
CREATE STATISTICS [_dta_stat_935674381_3_104_2]
    ON [adw].[M_MEMBER_ENR]([CLIENT_ID], [M_Member_Seq_ID], [SUBSCRIBER_ID]);

