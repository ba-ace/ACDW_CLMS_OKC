CREATE PROCEDURE adw.Load_Pdw_02_ClmsKeyList
AS
     TRUNCATE TABLE ast.pstClmKeyList;

/* create list of clmSkeys: these are all related claims grouped on the cms defined relation criteria 
        and bound under varchar(50) key made from concatenation of all the 4 component parts */

     INSERT INTO ast.pstClmKeyList
     (clmSKey, 
      PRVDR_OSCAR_NUM, 
      BENE_EQTBL_BIC_HICN_NUM, 
      CLM_FROM_DT, 
      CLM_THRU_DT
     )
            SELECT ICN + '.' + CONVERT(VARCHAR(18), s.OKC_ClaimKey) AS clmBigKey, 
                   '' AS ProvID, 
                   '' AS Bene_ID, 
                   '1/1/1900' AS CLM_FROM_DT, 
                   '1/1/1900' AS CLM_THRU_DT
            FROM
            (
                SELECT --top 100  ch.URN, ch.CUR_CLM_UNIQ_ID
                DISTINCT 
                       ICN, 
                       OKC_ClaimKey
                FROM adi.OKC_Claims ch
                     JOIN ast.pstDeDupClmsHdr ddH ON ch.OKC_ClaimKey = ddH.clm_URN
            ) S;
