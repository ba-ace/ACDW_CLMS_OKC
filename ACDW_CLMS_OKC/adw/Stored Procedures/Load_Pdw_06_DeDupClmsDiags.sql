CREATE PROCEDURE adw.Load_Pdw_06_DeDupClmsDiags
AS
     TRUNCATE TABLE [ast].[pstcDgDeDupUrns];
     INSERT INTO ast.pstcDgDeDupUrns(urn)
            SELECT s.OKC_DiagnosisKey
            FROM
            (
                SELECT c.OKC_DiagnosisKey, 
                       c.SrcFileName, 
                       ROW_NUMBER() OVER(PARTITION BY c.ICN, 
                                                      c.Diagnosis_Sequence
                       ORDER BY c.LoadDate DESC, 
                                c.SrcFileName DESC) aDupID
                FROM adi.OKC_ICD9_Diagnosis c
            ) s
            WHERE s.aDupID = 1;
