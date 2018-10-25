;Function: using NCO to preprocess CTR files, and TOPOTEST files.
;Date: 20180708
;Note: modified 20180712 for additional members in 1996 and 2001.
;Note: modified 20180725 for additional 90 members. Now total member = 180.
;Note: modified 201800807 for PTTEND, together with hyam,hybm,PS, which are useful for vinth2p, and others. 

begin

;=========== TOPOTEST ========
in_dir = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_TOPO_"

;out_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
out_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing_PTTEND/TOPO_TEST/"

year1989_str = (/"1989-12-01","1989-12-11","1989-12-21","1989-12-31","1990-01-10","1990-01-20","1990-01-30","1990-02-09","1990-02-19"/)
year1990_str = (/"1990-12-01","1990-12-11","1990-12-21","1990-12-31","1991-01-10","1991-01-20","1991-01-30","1991-02-09","1991-02-19"/)
year1991_str = (/"1991-12-01","1991-12-11","1991-12-21","1991-12-31","1992-01-10","1992-01-20","1992-01-30","1992-02-09","1992-02-19"/)
year1992_str = (/"1992-12-01","1992-12-11","1992-12-21","1992-12-31","1993-01-10","1993-01-20","1993-01-30","1993-02-09","1993-02-19"/)
year1993_str = (/"1993-12-01","1993-12-11","1993-12-21","1993-12-31","1994-01-10","1994-01-20","1994-01-30","1994-02-09","1994-02-19"/)
year1994_str = (/"1994-12-01","1994-12-11","1994-12-21","1994-12-31","1995-01-10","1995-01-20","1995-01-30","1995-02-09","1995-02-19"/)
year1995_str = (/"1995-12-01","1995-12-11","1995-12-21","1995-12-31","1996-01-10","1996-01-20","1996-01-30","1996-02-09","1996-02-19"/)

year1996_str = (/"1996-12-01","1996-12-11","1996-12-21","1996-12-31","1997-01-10","1997-01-20","1997-01-30","1997-02-09","1997-02-19"/)
year1997_str = (/"1997-12-01","1997-12-11","1997-12-21","1997-12-31","1998-01-10","1998-01-20","1998-01-30","1998-02-09","1998-02-19"/)
year1998_str = (/"1998-12-01","1998-12-11","1998-12-21","1998-12-31","1999-01-10","1999-01-20","1999-01-30","1999-02-09","1999-02-19"/)
year1999_str = (/"1999-12-01","1999-12-11","1999-12-21","1999-12-31","2000-01-10","2000-01-20","2000-01-30","2000-02-09","2000-02-19"/)
year2000_str = (/"2000-12-01","2000-12-11","2000-12-21","2000-12-31","2001-01-10","2001-01-20","2001-01-30","2001-02-09","2001-02-19"/)

year2001_str = (/"2001-12-01","2001-12-11","2001-12-21","2001-12-31","2002-01-10","2002-01-20","2002-01-30","2002-02-09","2002-02-19"/)
year2002_str = (/"2002-12-01","2002-12-11","2002-12-21","2002-12-31","2003-01-10","2003-01-20","2003-01-30","2003-02-09","2003-02-19"/)
year2003_str = (/"2003-12-01","2003-12-11","2003-12-21","2003-12-31","2004-01-10","2004-01-20","2004-01-30","2004-02-09","2004-02-19"/)
year2004_str = (/"2004-12-01","2004-12-11","2004-12-21","2004-12-31","2005-01-10","2005-01-20","2005-01-30","2005-02-09","2005-02-19"/)
year2005_str = (/"2005-12-01","2005-12-11","2005-12-21","2005-12-31","2006-01-10","2006-01-20","2006-01-30","2006-02-09","2006-02-19"/) 

year2006_str = (/"2006-12-01","2006-12-11","2006-12-21","2006-12-31","2007-01-10","2007-01-20","2007-01-30","2007-02-09","2007-02-19"/) 
year2007_str = (/"2007-12-01","2007-12-11","2007-12-21","2007-12-31","2008-01-10","2008-01-20","2008-01-30","2008-02-09","2008-02-19"/) 
year2008_str = (/"2008-12-01","2008-12-11","2008-12-21","2008-12-31","2009-01-10","2009-01-20","2009-01-30","2009-02-09","2009-02-19"/) 

;------- be aware that a space in the last ---------
;------- Note that you tried to add PTTEND in previous layout, but maxmemory issue always occurred.-----
;var_str = "PRECT,FLUT,U,V,OMEGA,T,Q,Z3,hyam,hybm,PS "
var_str = "PTTEND,hyam,hybm,PS "
var_name = "PTTEND"  ; You need to add similar indicators for other vaviables later

;do i_ens = 0,8
;
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1989_test1_" + year1989_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1989_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1990_test1_" + year1990_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1990_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1991_test1_" + year1991_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1991_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1992_test1_" + year1992_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1992_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1993_test1_" + year1993_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1993_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1994_test1_" + year1994_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1994_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1995_test1_" + year1995_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1995_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1996_test1_" + year1996_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1996_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1997_test1_" + year1997_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1997_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1998_test1_" + year1998_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1998_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1999_test1_" + year1999_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year1999_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"2000_test1_" + year2000_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year2000_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"2001_test1_" + year2001_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year2001_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"2002_test1_" + year2002_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year2002_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"2003_test1_" + year2003_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year2003_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"2004_test1_" + year2004_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year2004_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"2005_test1_" + year2005_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year2005_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"2006_test1_" + year2006_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year2006_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"2007_test1_" + year2007_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year2007_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"2008_test1_" + year2008_str(i_ens)+"/atm/hist/*h1*.nc -o "+out_dir+year2008_str(i_ens)+"."+var_name+".TOPOTEST.nc")
;
;end do

;============CTR ===============
CTR_in_dir1989 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1989_production/atm/hist/"
CTR_in_dir1990 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1990_production/atm/hist/"
CTR_in_dir1991 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1991_production/atm/hist/"
CTR_in_dir1992 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1992_production/atm/hist/"
CTR_in_dir1993 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1993_production/atm/hist/"
CTR_in_dir1994 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1994_production/atm/hist/"
CTR_in_dir1995 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1995_production/atm/hist/"

CTR_in_dir1996 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1996_production/atm/hist/"
CTR_in_dir1997 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1997_production/atm/hist/"
CTR_in_dir1998 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1998_production/atm/hist/"
CTR_in_dir1999 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1999_production/atm/hist/"
CTR_in_dir2000 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2000_production/atm/hist/"

CTR_in_dir2001 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2001_production/atm/hist/"
CTR_in_dir2002 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2002_production/atm/hist/"
CTR_in_dir2003 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2003_production/atm/hist/"
CTR_in_dir2004 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2004_production/atm/hist/"
CTR_in_dir2005 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2005_production/atm/hist/"

CTR_in_dir2006 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2006_production/atm/hist/"
CTR_in_dir2007 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2007_production/atm/hist/"
CTR_in_dir2008 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2008_production/atm/hist/"

;CTR_out_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_out_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing_PTTEND/CTR/"

;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1989+"*h1*.nc -o "+CTR_in_dir1989+"F_AMIP_CAM5_WADA_CTR_1989_production.cam.1989-11-21-00000--1990-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1990+"*h1*.nc -o "+CTR_in_dir1990+"F_AMIP_CAM5_WADA_CTR_1990_production.cam.1990-11-21-00000--1991-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1991+"*h1*.nc -o "+CTR_in_dir1991+"F_AMIP_CAM5_WADA_CTR_1991_production.cam.1991-11-21-00000--1992-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1992+"*h1*.nc -o "+CTR_in_dir1992+"F_AMIP_CAM5_WADA_CTR_1992_production.cam.1992-11-21-00000--1993-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1993+"*h1*.nc -o "+CTR_in_dir1993+"F_AMIP_CAM5_WADA_CTR_1993_production.cam.1993-11-21-00000--1994-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1994+"*h1*.nc -o "+CTR_in_dir1994+"F_AMIP_CAM5_WADA_CTR_1994_production.cam.1994-11-21-00000--1995-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1995+"*h1*.nc -o "+CTR_in_dir1995+"F_AMIP_CAM5_WADA_CTR_1995_production.cam.1995-11-21-00000--1996-03-12-00000."+var_name+".ncrcat.nc")
;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1996+"*h1*.nc -o "+CTR_in_dir1996+"F_AMIP_CAM5_WADA_CTR_1996_production.cam.1996-11-21-00000--1997-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1997+"*h1*.nc -o "+CTR_in_dir1997+"F_AMIP_CAM5_WADA_CTR_1997_production.cam.1997-11-21-00000--1998-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1998+"*h1*.nc -o "+CTR_in_dir1998+"F_AMIP_CAM5_WADA_CTR_1998_production.cam.1998-11-21-00000--1999-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir1999+"*h1*.nc -o "+CTR_in_dir1999+"F_AMIP_CAM5_WADA_CTR_1999_production.cam.1999-11-21-00000--2000-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir2000+"*h1*.nc -o "+CTR_in_dir2000+"F_AMIP_CAM5_WADA_CTR_2000_production.cam.2000-11-21-00000--2001-03-12-00000."+var_name+".ncrcat.nc")
;
;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir2001+"*h1*.nc -o "+CTR_in_dir2001+"F_AMIP_CAM5_WADA_CTR_2001_production.cam.2001-11-21-00000--2002-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir2002+"*h1*.nc -o "+CTR_in_dir2002+"F_AMIP_CAM5_WADA_CTR_2002_production.cam.2002-11-21-00000--2003-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir2003+"*h1*.nc -o "+CTR_in_dir2003+"F_AMIP_CAM5_WADA_CTR_2003_production.cam.2003-11-21-00000--2004-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir2004+"*h1*.nc -o "+CTR_in_dir2004+"F_AMIP_CAM5_WADA_CTR_2004_production.cam.2004-11-21-00000--2005-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir2005+"*h1*.nc -o "+CTR_in_dir2005+"F_AMIP_CAM5_WADA_CTR_2005_production.cam.2005-11-21-00000--2006-03-12-00000."+var_name+".ncrcat.nc")
;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir2006+"*h1*.nc -o "+CTR_in_dir2006+"F_AMIP_CAM5_WADA_CTR_2006_production.cam.2006-11-21-00000--2007-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir2007+"*h1*.nc -o "+CTR_in_dir2007+"F_AMIP_CAM5_WADA_CTR_2007_production.cam.2007-11-21-00000--2008-03-12-00000."+var_name+".ncrcat.nc")
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir2008+"*h1*.nc -o "+CTR_in_dir2008+"F_AMIP_CAM5_WADA_CTR_2008_production.cam.2008-11-21-00000--2009-03-12-00000."+var_name+".ncrcat.nc")

count_start = (/"11","21","31","41","51","61","71","81","91"/)
count_end = (/"22","32","42","52","62","72","82","92","102"/)


;do i_count = 0,8
;;;;do i_count = 0,0
;;
;;============ year 1989--1995
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1989+"F_AMIP_CAM5_WADA_CTR_1989_production.cam.1989-11-21-00000--1990-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1989_str(i_count)+"."+var_name+".CTR.nc")
;;
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1990+"F_AMIP_CAM5_WADA_CTR_1990_production.cam.1990-11-21-00000--1991-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1990_str(i_count)+"."+var_name+".CTR.nc")
;;
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1991+"F_AMIP_CAM5_WADA_CTR_1991_production.cam.1991-11-21-00000--1992-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1991_str(i_count)+"."+var_name+".CTR.nc")
;;
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1992+"F_AMIP_CAM5_WADA_CTR_1992_production.cam.1992-11-21-00000--1993-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1992_str(i_count)+"."+var_name+".CTR.nc")
;;
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1993+"F_AMIP_CAM5_WADA_CTR_1993_production.cam.1993-11-21-00000--1994-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1993_str(i_count)+"."+var_name+".CTR.nc")
;;
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1994+"F_AMIP_CAM5_WADA_CTR_1994_production.cam.1994-11-21-00000--1995-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1994_str(i_count)+"."+var_name+".CTR.nc")
;;
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1995+"F_AMIP_CAM5_WADA_CTR_1995_production.cam.1995-11-21-00000--1996-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1995_str(i_count)+"."+var_name+".CTR.nc")
;
;;
;;;======== year 1996
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1996+"F_AMIP_CAM5_WADA_CTR_1996_production.cam.1996-11-21-00000--1997-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1996_str(i_count)+"."+var_name+".CTR.nc")
;;
;;;======== year 1997
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1997+"F_AMIP_CAM5_WADA_CTR_1997_production.cam.1997-11-21-00000--1998-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1997_str(i_count)+"."+var_name+".CTR.nc")
;;
;;;======== year 1998
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1998+"F_AMIP_CAM5_WADA_CTR_1998_production.cam.1998-11-21-00000--1999-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1998_str(i_count)+"."+var_name+".CTR.nc")
;;
;;;======== year 1999
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir1999+"F_AMIP_CAM5_WADA_CTR_1999_production.cam.1999-11-21-00000--2000-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year1999_str(i_count)+"."+var_name+".CTR.nc")
;;
;;;======== year 2000
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir2000+"F_AMIP_CAM5_WADA_CTR_2000_production.cam.2000-11-21-00000--2001-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year2000_str(i_count)+"."+var_name+".CTR.nc")
;;
;;;======== year 2001
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir2001+"F_AMIP_CAM5_WADA_CTR_2001_production.cam.2001-11-21-00000--2002-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year2001_str(i_count)+"."+var_name+".CTR.nc")
;;
;;;======== year 2002
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir2002+"F_AMIP_CAM5_WADA_CTR_2002_production.cam.2002-11-21-00000--2003-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year2002_str(i_count)+"."+var_name+".CTR.nc")
;;
;;;======== year 2003
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir2003+"F_AMIP_CAM5_WADA_CTR_2003_production.cam.2003-11-21-00000--2004-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year2003_str(i_count)+"."+var_name+".CTR.nc")
;;
;;;======== year 2004
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir2004+"F_AMIP_CAM5_WADA_CTR_2004_production.cam.2004-11-21-00000--2005-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year2004_str(i_count)+"."+var_name+".CTR.nc")
;;
;;;======= year 2005
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir2005+"F_AMIP_CAM5_WADA_CTR_2005_production.cam.2005-11-21-00000--2006-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year2005_str(i_count)+"."+var_name+".CTR.nc")
;;
;
;;====== year 2006--2008
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir2006+"F_AMIP_CAM5_WADA_CTR_2006_production.cam.2006-11-21-00000--2007-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year2006_str(i_count)+"."+var_name+".CTR.nc")
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir2007+"F_AMIP_CAM5_WADA_CTR_2007_production.cam.2007-11-21-00000--2008-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year2007_str(i_count)+"."+var_name+".CTR.nc")
;system("ncrcat -O -D 2 -d time,"+count_start(i_count)+","+count_end(i_count)+" -v "+var_str+CTR_in_dir2008+"F_AMIP_CAM5_WADA_CTR_2008_production.cam.2008-11-21-00000--2009-03-12-00000."+var_name+".ncrcat.nc -o "+CTR_out_dir+year2008_str(i_count)+"."+var_name+".CTR.nc")
;
;end do
;;

;;========== Calculate the mean and std of ensemble in TOPOTEST ======
;;-----combine different members into a single file
;system("ncecat -u realization "+out_dir+"*.nc -o "+out_dir+"ENS.TOPOTEST.nc")
;
;;-----calculate the ensemble mean along the realization dimension
;system("ncwa -O -a realization "+out_dir+"ENS.TOPOTEST.nc "+out_dir+"ENS.mean.TOPOTEST.nc")
;
;;-----Calculate Anomaly -
;system("ncbo -O "+out_dir+"ENS.TOPOTEST.nc "+out_dir+"ENS.mean.TOPOTEST.nc "+out_dir+"ENS.anom.TOPOTEST.nc")
;
;;------Calculate the standard deviation along realization dimension-
;system("ncra -O -y rmssdn "+out_dir+"ENS.anom.TOPOTEST.nc "+out_dir+"ENS.std.TOPOTEST.nc")
;
;;========== Calculate the mean and std of ensemble in CTR ======
;;-----combine different members into a single file
;system("ncecat -u realization "+CTR_out_dir+"*.nc -o "+CTR_out_dir+"ENS.CTR.nc")
;;-----calculate the ensemble mean along the realization dimension
;system("ncwa -O -a realization "+CTR_out_dir+"ENS.CTR.nc "+CTR_out_dir+"ENS.mean.CTR.nc")
;;-----Calculate Anomaly -
;system("ncbo -O "+CTR_out_dir+"ENS.CTR.nc "+CTR_out_dir+"ENS.mean.CTR.nc "+CTR_out_dir+"ENS.anom.CTR.nc")
;;------Calculate the standard deviation along realization dimension-
;system("ncra -O -y rmssdn "+CTR_out_dir+"ENS.anom.CTR.nc "+CTR_out_dir+"ENS.std.CTR.nc")











end
