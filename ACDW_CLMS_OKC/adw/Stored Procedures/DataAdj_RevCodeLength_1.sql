
CREATE PROCEDURE adw.DataAdj_RevCodeLength
AS

    UPDATE [adw].claims_details
    SET revenue_code = TRY_CONVERT( INT, REVENUE_CODE)
    ;
