
CREATE PROCEDURE adw.Load_Pdw_04_DeDupClmsLns
AS
     TRUNCATE TABLE ast.pstcLnsDeDupUrns;
     INSERT INTO ast.pstcLnsDeDupUrns(URN)
            SELECT s.OKC_ServicesKey
            FROM
            (
                SELECT cl.OKC_ServicesKey, 
                       cl.SrcFileName, 
                       cl.LoadDate, 
                       ROW_NUMBER() OVER(PARTITION BY cl.ICN, 
                                                      cl.DETAIL_NUMBER
                       ORDER BY cl.loadDate DESC, 
                                cl.SrcFileName ASC) arn
                FROM adi.OKC_Services cl
            ) s
            WHERE s.arn = 1;
