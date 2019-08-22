
CREATE PROCEDURE adw.Load_Pdw_05_DeDupClmsProcs
AS
     TRUNCATE TABLE ast.pstcPrcDeDupUrns;
     INSERT INTO ast.pstcPrcDeDupUrns(urn)
            SELECT s.OKC_Proc_Key
            FROM
            (
                SELECT c.OKC_Proc_Key, 
                       c.SrcFileName, 
                       ROW_NUMBER() OVER(PARTITION BY c.ICN, 
                                                      c.Procedure_Sequence
                       ORDER BY c.LoadDate DESC, 
                                c.SrcFileName ASC) aDupID
                FROM adi.OKC_ICD9_Procedure c
            ) s
            WHERE s.aDupID = 1;
