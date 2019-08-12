
CREATE PROCEDURE adw.DataAdj_DrgCode
AS -- does this remove leading zeros?
    UPDATE adw.[Claims_Headers]        
		  SET DRG_CODE = SUBSTRING(DRG_CODE, 2,4) 
    WHERE not drg_code IS NULL
	   and TRY_CONVERT(int, DRG_CODE) is not null
    ;

