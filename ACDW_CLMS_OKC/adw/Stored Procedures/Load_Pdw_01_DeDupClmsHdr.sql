


/* load set management tables  */

CREATE PROCEDURE adw.Load_Pdw_01_DeDupClmsHdr
AS
    -- Claims Dedup: Use this table to remove any duplicated input rows, they will be duplicated and versioned.. 
    TRUNCATE TABLE ast.[pstDeDupClmsHdr]

    INSERT INTO ast.[pstDeDupClmsHdr](clm_URN)
    SELECT s.OKC_ClaimKey
    FROM (SELECT ch.OKC_ClaimKey--, ICN, SrcFileName
			 , ROW_NUMBER() OVER (PARTITION BY ch.ICN ORDER BY ch.SrcFileName DESC) arn
		  FROM adi.OKC_Claims ch) s
    WHERE s.arn = 1;
