
CREATE PROCEDURE adw.Load_Pdw_03_LatestEffectiveClmsHeader
AS
     TRUNCATE TABLE ast.pstLatestEffectiveClmsHdr;
     INSERT INTO ast.pstLatestEffectiveClmsHdr
     (clmSKey, 
      clmHdrURN
     )
            SELECT src.clmSKey, 
                   src.OKC_ClaimKey
            FROM
            (
                SELECT csk.clmSKey, 
                       ch.OKC_ClaimKey, 
                       ROW_NUMBER() OVER(PARTITION BY csk.clmSKey
                       ORDER BY ch.OKC_ClaimKey) LastEffective
                FROM ast.pstClmKeyList csk
                     JOIN adi.OKC_Claims ch ON csk.clmSKey = ICN + '.' + CONVERT(VARCHAR(18), ch.OKC_ClaimKey)
                     JOIN ast.pstDeDupClmsHdr ddH ON ch.OKC_ClaimKey = ddH.clm_URN
            ) src
            WHERE src.LastEffective = 1;
