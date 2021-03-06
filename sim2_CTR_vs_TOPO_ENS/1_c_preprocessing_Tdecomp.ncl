;Function: using NCO to preprocess CTR files, and TOPOTEST files.
;Date: 20180708
;Note: modified 20180712 for additional members in 1996 and 2001.
;Note: modified 20180725 for additional 90 members. Now total member = 180.
;Note: modified 20180930 for sim2
;

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;=========== TOPOTEST ========

in_dir = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_TOPO_"
out_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/TOPO_TEST/"

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
var_str = "TAP,PTTEND,hyam,hybm,PS "

do i_ens = 0,8

system("ncrcat -O -D 2 -v "+var_str+in_dir+"1989_sim2_" + year1989_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1989_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1990_sim2_" + year1990_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1990_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1991_sim2_" + year1991_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1991_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1992_sim2_" + year1992_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1992_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1993_sim2_" + year1993_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1993_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1994_sim2_" + year1994_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1994_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1995_sim2_" + year1995_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1995_str(i_ens)+".TOPOTEST.nc")

system("ncrcat -O -D 2 -v "+var_str+in_dir+"1996_sim2_" + year1996_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1996_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1997_sim2_" + year1997_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1997_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1998_sim2_" + year1998_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1998_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"1999_sim2_" + year1999_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year1999_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2000_sim2_" + year2000_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year2000_str(i_ens)+".TOPOTEST.nc")

system("ncrcat -O -D 2 -v "+var_str+in_dir+"2001_sim2_" + year2001_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year2001_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2002_sim2_" + year2002_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year2002_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2003_sim2_" + year2003_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year2003_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2004_sim2_" + year2004_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year2004_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2005_sim2_" + year2005_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year2005_str(i_ens)+".TOPOTEST.nc")

system("ncrcat -O -D 2 -v "+var_str+in_dir+"2006_sim2_" + year2006_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year2006_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2007_sim2_" + year2007_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year2007_str(i_ens)+".TOPOTEST.nc")
system("ncrcat -O -D 2 -v "+var_str+in_dir+"2008_sim2_" + year2008_str(i_ens)+"/atm/hist/*h2*.nc -o "+out_dir+year2008_str(i_ens)+".TOPOTEST.nc")

end do


;===========CTR ===============

CTR_in_dir1989 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1989_production_sim2/atm/hist/"
CTR_in_dir1990 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1990_production_sim2/atm/hist/"
CTR_in_dir1991 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1991_production_sim2/atm/hist/"
CTR_in_dir1992 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1992_production_sim2/atm/hist/"
CTR_in_dir1993 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1993_production_sim2/atm/hist/"
CTR_in_dir1994 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1994_production_sim2/atm/hist/"
CTR_in_dir1995 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1995_production_sim2/atm/hist/"

CTR_in_dir1996 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1996_production_sim2/atm/hist/"
CTR_in_dir1997 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1997_production_sim2/atm/hist/"
CTR_in_dir1998 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1998_production_sim2/atm/hist/"
CTR_in_dir1999 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1999_production_sim2/atm/hist/"
CTR_in_dir2000 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2000_production_sim2/atm/hist/"

CTR_in_dir2001 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2001_production_sim2/atm/hist/"
CTR_in_dir2002 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2002_production_sim2/atm/hist/"
CTR_in_dir2003 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2003_production_sim2/atm/hist/"
CTR_in_dir2004 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2004_production_sim2/atm/hist/"
CTR_in_dir2005 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2005_production_sim2/atm/hist/"

CTR_in_dir2006 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2006_production_sim2/atm/hist/"
CTR_in_dir2007 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2007_production_sim2/atm/hist/"
CTR_in_dir2008 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_2008_production_sim2/atm/hist/"

CTR_out_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_Tdecom/CTR/"


CTR_in_dir_years = (/CTR_in_dir1989, CTR_in_dir1990, CTR_in_dir1991, CTR_in_dir1992, CTR_in_dir1993, CTR_in_dir1994, CTR_in_dir1995, CTR_in_dir1996, CTR_in_dir1997, CTR_in_dir1998, CTR_in_dir1999, CTR_in_dir2000, CTR_in_dir2001, CTR_in_dir2002, CTR_in_dir2003, CTR_in_dir2004, CTR_in_dir2005, CTR_in_dir2006, CTR_in_dir2007, CTR_in_dir2008/)
;print(CTR_in_dir_years)

year_x_str = (/year1989_str, year1990_str, year1991_str, year1992_str, year1993_str, year1994_str, year1995_str, year1996_str, year1997_str, year1998_str, year1999_str, year2000_str, year2001_str, year2002_str, year2003_str, year2004_str, year2005_str, year2006_str, year2007_str, year2008_str/)
;print(year_x_str)

yearx = (/"1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009"/)

do i_year = 0,19
;do i_year = 0,0
;
system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year)+"-12-0[12345]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,0)+".CTR.t.nc")
;---- move by one hr so that the TOPO files and CTR files have the same time_bnds ----
system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,0)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,0)+".CTR.nc")
system("rm "+CTR_out_dir+year_x_str(i_year,0)+".CTR.t.nc")

system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year)+"-12-1[12345]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,1)+".CTR.t.nc")
system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,1)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,1)+".CTR.nc")
system("rm "+CTR_out_dir+year_x_str(i_year,1)+".CTR.t.nc")

system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year)+"-12-2[12345]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,2)+".CTR.t.nc")
system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,2)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,2)+".CTR.nc")
system("rm "+CTR_out_dir+year_x_str(i_year,2)+".CTR.t.nc")

system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year)+"-12-31-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-01-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-02-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-03-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-04-00000.nc -o "+CTR_out_dir+year_x_str(i_year,3)+".CTR.t.nc")
system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,3)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,3)+".CTR.nc")
system("rm "+CTR_out_dir+year_x_str(i_year,3)+".CTR.t.nc")


system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-1[01234]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,4)+".CTR.t.nc")
system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,4)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,4)+".CTR.nc")
system("rm "+CTR_out_dir+year_x_str(i_year,4)+".CTR.t.nc")

system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-2[01234]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,5)+".CTR.t.nc")
system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,5)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,5)+".CTR.nc")
system("rm "+CTR_out_dir+year_x_str(i_year,5)+".CTR.t.nc")


system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-30-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-31-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-01-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-02-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-03-00000.nc -o "+CTR_out_dir+year_x_str(i_year,6)+".CTR.t.nc")
system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,6)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,6)+".CTR.nc")
system("rm "+CTR_out_dir+year_x_str(i_year,6)+".CTR.t.nc")


system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-09-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-10-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-11-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-12-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-13-00000.nc -o "+CTR_out_dir+year_x_str(i_year,7)+".CTR.t.nc")
system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,7)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,7)+".CTR.nc")
system("rm "+CTR_out_dir+year_x_str(i_year,7)+".CTR.t.nc")

system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-19-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-20-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-21-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-22-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-23-00000.nc -o "+CTR_out_dir+year_x_str(i_year,8)+".CTR.t.nc")
system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,8)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,8)+".CTR.nc")
system("rm "+CTR_out_dir+year_x_str(i_year,8)+".CTR.t.nc")


end do ; do i_year
;

;=========== the relevant mean and std will be calculated by 1_d_preprocessing_Tdecomp.ncl
;;;========== Calculate the mean and std of ensemble in TOPOTEST ======
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
