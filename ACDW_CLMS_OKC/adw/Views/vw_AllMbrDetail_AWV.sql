
CREATE VIEW [adw].[vw_AllMbrDetail_AWV]
AS
     SELECT a.*, 
            b.VENDOR_ID, 
            b.SVC_PROV_NPI
     FROM adw.[tvf_get_claims_w_dates]('Well-Care', '', '', '01/01/2001', '01/01/2099') a
          JOIN adw.Claims_Headers b ON a.seq_claim_id = b.seq_claim_id;

