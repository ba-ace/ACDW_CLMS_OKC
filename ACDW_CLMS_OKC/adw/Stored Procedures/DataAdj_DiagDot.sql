CREATE PROCEDURE adw.DataAdj_DiagDot
AS 
    UPDATE adw.Claims_Diags
        SET diagCode = h.value_code
    FROM adw.Claims_Diags d
        JOIN (SELECT VALUE_CODE, REPLACE(VALUE_CODE, '.', '') noDot
			 FROM lst.LIST_HEDIS_CODE lh
			 WHERE lh.VALUE_CODE_SYSTEM IN('ICD9CM', 'ICD10CM')
			 ) h ON d.diagCode = h.noDot;
