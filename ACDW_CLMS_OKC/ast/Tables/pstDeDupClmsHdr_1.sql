CREATE TABLE [ast].[pstDeDupClmsHdr] (
    [clm_URN]     INT           NOT NULL,
    [CreatedDate] DATETIME2 (7) CONSTRAINT [df_astPstDeDupClmsHdr_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   VARCHAR (20)  CONSTRAINT [df_astPstDeDupClmsHdr_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    PRIMARY KEY CLUSTERED ([clm_URN] ASC)
);

