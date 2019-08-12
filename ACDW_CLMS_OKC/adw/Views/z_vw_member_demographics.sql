﻿CREATE VIEW adw.[z_vw_member_demographics]
AS
     SELECT a.URN, 
       a.MBI, 
       a.HICN, 
       a.FirstName, 
       a.LastName, 
       a.Sex, 
       a.DOB, 
       a.DOD, 
       a.CountyName, 
       a.StateName, 
       a.CountyNumber, 
       a.VoluntaryFlag, 
       a.CBFlag, 
       a.CBStepFlag, 
       a.PrevBenFlag, 
       a.HCC1, 
       a.HCC2, 
       a.HCC6, 
       a.HCC8, 
       a.HCC9, 
       a.HCC10, 
       a.HCC11, 
       a.HCC12, 
       a.[HCC17 ], 
       a.[HCC18 ], 
       a.[HCC19 ], 
       a.[HCC21 ], 
       a.[HCC22 ], 
       a.[HCC23 ], 
       a.[HCC27 ], 
       a.[HCC28 ], 
       a.[HCC29 ], 
       a.[HCC33 ], 
       a.[HCC34 ], 
       a.[HCC35 ], 
       a.[HCC39 ], 
       a.[HCC40 ], 
       a.[HCC46 ], 
       a.[HCC47 ], 
       a.[HCC48 ], 
       a.[HCC54 ], 
       a.[HCC55 ], 
       a.[HCC57 ], 
       a.[HCC58 ], 
       a.[HCC70 ], 
       a.[HCC71 ], 
       a.[HCC72 ], 
       a.[HCC73 ], 
       a.[HCC74 ], 
       a.[HCC75 ], 
       a.[HCC76 ], 
       a.[HCC77 ], 
       a.[HCC78 ], 
       a.[HCC79 ], 
       a.[HCC80 ], 
       a.[HCC82 ], 
       a.[HCC83 ], 
       a.[HCC84 ], 
       a.[HCC85 ], 
       a.[HCC86 ], 
       a.[HCC87 ], 
       a.[HCC88 ], 
       a.[HCC96 ], 
       a.[HCC99 ], 
       a.[HCC100 ], 
       a.[HCC103 ], 
       a.[HCC104 ], 
       a.[HCC106 ], 
       a.[HCC107 ], 
       a.[HCC108 ], 
       a.[HCC110 ], 
       a.[HCC111 ], 
       a.[HCC112 ], 
       a.[HCC114 ], 
       a.[HCC115 ], 
       a.[HCC122 ], 
       a.[HCC124 ], 
       a.[HCC134 ], 
       a.[HCC135 ], 
       a.[HCC136 ], 
       a.[HCC137 ], 
       a.[HCC157 ], 
       a.[HCC158 ], 
       a.[HCC161 ], 
       a.[HCC162 ], 
       a.[HCC166 ], 
       a.[HCC167 ], 
       a.[HCC169 ], 
       a.[HCC170 ], 
       a.[HCC173 ], 
       a.[HCC176 ], 
       a.[HCC186 ], 
       a.[HCC188 ], 
       a.[HCC189 ], 
       a.PartDFlag, 
       a.RS_ESRD, 
       a.RS_Disabled, 
       a.RS_AgedDual, 
       a.RS_AgedNonDual, 
       a.Demo_RS_ESRD, 
       a.Demo_RS_Disabled, 
       a.Demo_RS_AgedDual, 
       a.Demo_RS_AgedNonDual, 
       a.ESRD_RS, 
       a.DISABLED_RS, 
       a.DUAL_RS, 
       a.NONDUAL_RS, 
       a.ELIG_TYPE, 
       a.MBR_YEAR, 
       a.MBR_QTR, 
       a.LOAD_DATE, 
       a.LOAD_USER, 
       b.TIN, 
       b.TIN_NAME, 
       b.NPI, 
       b.NPI_NAME
    FROM adw.[vw_active_members] a
	   LEFT JOIN adw.[vw_Mbr_Assigned_TIN_NPI] b ON a.hicn = b.hicn;
