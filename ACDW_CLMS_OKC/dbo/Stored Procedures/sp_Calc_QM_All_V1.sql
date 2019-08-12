
create PROCEDURE [dbo].[sp_Calc_QM_All_V1]
AS 
    -- 2 params Measurement year, and client Key
	EXEC sp_19_Calc_QM_ABA	  2019,'7' ;
	EXEC sp_19_Calc_QM_ART 	  2019,'7' ;
	EXEC sp_19_Calc_QM_AWC 	  2019,'7' ;
	EXEC sp_19_Calc_QM_BCS	  2019,'7' ;
	EXEC sp_19_Calc_QM_CBP	  2019,'7' ;
	EXEC sp_19_Calc_QM_CCS	  2019,'7' ;
	EXEC sp_19_Calc_QM_CDC_0	  2019,'7' ;
	EXEC sp_19_Calc_QM_CDC_7_9 2019,'7' ;
	EXEC sp_19_Calc_QM_CDC_BP  2019,'7' ;
	EXEC sp_19_Calc_QM_CDC_E	  2019,'7' ;
	EXEC sp_19_Calc_QM_CDC_HB  2019,'7' ;
	EXEC sp_19_Calc_QM_CDC_N	  2019,'7' ;
	EXEC sp_19_Calc_QM_COA	  2019,'7' ;
	EXEC sp_19_Calc_QM_COL	  2019,'7' ;
	EXEC sp_19_Calc_QM_FUH	  2019,'7' ;
	EXEC sp_19_Calc_QM_PCE	  2019,'7' ;
	EXEC sp_19_Calc_QM_SPD	  2019,'7' ;
	EXEC sp_19_Calc_QM_SPR	  2019,'7' ;
	EXEC sp_19_Calc_QM_W15	  2019,'7' ;
	EXEC sp_19_Calc_QM_W36	  2019,'7' ;
	EXEC sp_19_Calc_QM_WCC	  2019,'7' ;


	-- max qm history and load into cl
	TRUNCATE TABLE adw.QM_ResultByMember_CL;    

     INSERT INTO [adw].[QM_ResultByMember_CL]
           ([ClientMemberKey]
           ,[QmMsrId]
           ,[QmCntCat]
           ,[QMDate]
           ,[CreateDate]
           ,[CreateBy])
    SELECT h.ClientMemberKey, 
           h.QmMsrId, 
           h.QmCntCat, 
           h.QMDate, 
           h.CreateDate, 
           h.CreateBy
    FROM adw.QM_ResultByMember_History h
    WHERE h.QMDate = CONVERT(DATE, GETDATE(), 101);


	