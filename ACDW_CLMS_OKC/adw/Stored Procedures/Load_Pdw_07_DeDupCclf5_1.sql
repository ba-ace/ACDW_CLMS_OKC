CREATE PROCEDURE [adw].[Load_Pdw_07_DeDupCclf5]
AS    
    -- there is no analgous set to  cclf 5 in the OKC input set
    TRUNCATE TABLE ast.pstcDeDupClms_Cclf5;

    INSERT INTO ast.pstcDeDupClms_Cclf5 (urn)
    SELECT *
    FROM (SELECT NULL s) s
    --WHERE s.arn = 1
