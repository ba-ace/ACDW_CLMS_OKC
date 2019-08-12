﻿
CREATE PROCEDURE [adw].[QM_MASTER]
AS
     IF OBJECT_ID('tmp_QM_MSR_CNT') IS NULL
         BEGIN
             CREATE TABLE [dbo].[tmp_QM_MSR_CNT]
             ([MeasureName]   VARCHAR(20) NULL, 
              [cnt_den]       INT NULL, 
              [cnt_num]       INT NULL, 
              [cnt_exc]       INT NULL, 
              [ExecutionDate] DATETIME NULL, 
              [cnt_DenVisits] INT NULL, 
              [cnt_NumVisits] INT NULL
             );
		   
     END;
     EXEC adw.[SP_QM_ABA];
     EXEC adw.[SP_QM_ART];
     EXEC adw.[SP_QM_AWC];
     EXEC adw.[SP_QM_BCS];
     EXEC adw.[SP_QM_CCS];
     EXEC adw.[SP_QM_CDC_8];
     EXEC adw.[SP_QM_CDC_9];
     EXEC adw.[SP_QM_CDC_BP];
     EXEC adw.[SP_QM_CDC_E];
     EXEC adw.[SP_QM_CDC_HB];
     EXEC adw.[SP_QM_CDC_N];
     EXEC adw.[SP_QM_COL];
     EXEC adw.[SP_QM_PCE_B];
     EXEC adw.[SP_QM_PCE_S];
     EXEC adw.[SP_QM_SPR];
     EXEC adw.[SP_QM_WC0];
     EXEC adw.[SP_QM_WC1];
     EXEC adw.[SP_QM_WC2];
     EXEC adw.[SP_QM_WC3];
     EXEC adw.[SP_QM_WC4];
     EXEC adw.[SP_QM_WC5];
     EXEC adw.[SP_QM_WC6];
     EXEC adw.[SP_QM_WC36];

     /* CDC 7 is currently not being run due to development */

     --EXEC [SP_QM_CDC_7]
     -- run this set of aggregates.
     -- REMOVED PER Si: exec dbo.sp_QM_Aggr_LoadAll;
     -- Collect results and write to QMResultByMbr
     EXEC sp_collect_QmResultByMbr;
