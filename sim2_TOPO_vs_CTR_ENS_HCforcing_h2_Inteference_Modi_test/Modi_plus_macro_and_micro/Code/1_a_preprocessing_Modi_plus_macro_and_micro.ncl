;Function: using NCO to preprocess CTR files, and TOPOTEST files.
;Date: 20180708
;Note: modified 20180712 for additional members in 1996 and 2001.
;Note: modified 20180725 for additional 90 members. Now total member = 180.
;Note: modified 20180930 for sim2
;Note: modified 20190521 for new interference

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"
;=========== TOPOTEST ========

in_dir = prefix+"/scratch/hongcheq/NERSC_Cori_WADA_simulation_Interference_Modifications/F_AMIP_CAM5_WADA_TOPO_"
;in_dir = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_TOPO_"
;out_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
out_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"

year1989_str = (/"1989-12-01","1989-12-11","1989-12-21","1989-12-31","1990-01-10","1990-01-20","1990-01-30","1990-02-09","1990-02-19"/)
year1990_str = (/"1990-12-01","1990-12-11","1990-12-21","1990-12-31","1991-01-10","1991-01-20","1991-01-30","1991-02-09","1991-02-19"/)

;------- be aware that a space in the last ---------
var_str = "PRECT,HCforcing,SHFLX,LHFLX,SWCF,LWCF,QRL,QRS,PTTEND,DTCOND,DTV,TTGWORO,U,V,OMEGA,T,Q,Z3,hyam,hybm,PS "

str_new = "_HCforcing_Modi_plus_macro_and_micro"

;do i_ens = 0,8
;
;system("ncrcat -O -D 2 -v "+var_str+in_dir+"1989_sim2_" + year1989_str(i_ens)+str_new+"/atm/hist/*h2*.nc -o "+out_dir+year1989_str(i_ens)+".TOPOTEST.nc")
;
;end do

;CTR has been done in previous _Modi_plus_macro scripts
;===========CTR ===============
; for CTR runs, there is no HCforcing
; TOPO only four days, therefore, no need to join all the files.

var_str = "PRECT,SHFLX,LHFLX,SWCF,LWCF,QRL,QRS,PTTEND,DTCOND,DTV,TTGWORO,U,V,OMEGA,T,Q,Z3,hyam,hybm,PS "

CTR_in_dir_str = "/DFS-L/DATA/pritchard/hongcheq/NERSC_Cori_edison/SCRATCH/archive"
CTR_in_dir1989 = CTR_in_dir_str+"/F_AMIP_CAM5_WADA_CTR_1989_production_sim2/atm/hist/"
CTR_in_dir1990 = CTR_in_dir_str+"/F_AMIP_CAM5_WADA_CTR_1990_production_sim2/atm/hist/"

CTR_out_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"

CTR_in_dir_years = (/CTR_in_dir1989, CTR_in_dir1990/)

year_x_str = (/year1989_str, year1990_str/) ; the second only for dimension matching in the downstream 
;print(year_x_str)

yearx = (/"1989","1990"/)

;;do i_year = 10,19
;do i_year = 0,0
;;;;do i_year = 0,0
;;;;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year)+"-12-0[12345]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,0)+".CTR.t.nc")
;;;---- move by one hr so that the TOPO files and CTR files have the same time_bnds ----
;system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,0)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,0)+".CTR.nc")
;system("rm "+CTR_out_dir+year_x_str(i_year,0)+".CTR.t.nc")
;;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year)+"-12-1[12345]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,1)+".CTR.t.nc")
;system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,1)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,1)+".CTR.nc")
;system("rm "+CTR_out_dir+year_x_str(i_year,1)+".CTR.t.nc")
;;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year)+"-12-2[12345]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,2)+".CTR.t.nc")
;system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,2)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,2)+".CTR.nc")
;system("rm "+CTR_out_dir+year_x_str(i_year,2)+".CTR.t.nc")
;;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year)+"-12-31-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-01-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-02-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-03-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-04-00000.nc -o "+CTR_out_dir+year_x_str(i_year,3)+".CTR.t.nc")
;system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,3)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,3)+".CTR.nc")
;system("rm "+CTR_out_dir+year_x_str(i_year,3)+".CTR.t.nc")
;;
;;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-1[01234]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,4)+".CTR.t.nc")
;system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,4)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,4)+".CTR.nc")
;system("rm "+CTR_out_dir+year_x_str(i_year,4)+".CTR.t.nc")
;;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-2[01234]-00000.nc -o "+CTR_out_dir+year_x_str(i_year,5)+".CTR.t.nc")
;system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,5)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,5)+".CTR.nc")
;system("rm "+CTR_out_dir+year_x_str(i_year,5)+".CTR.t.nc")
;;
;;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-30-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-01-31-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-01-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-02-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-03-00000.nc -o "+CTR_out_dir+year_x_str(i_year,6)+".CTR.t.nc")
;system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,6)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,6)+".CTR.nc")
;system("rm "+CTR_out_dir+year_x_str(i_year,6)+".CTR.t.nc")
;;
;;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-09-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-10-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-11-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-12-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-13-00000.nc -o "+CTR_out_dir+year_x_str(i_year,7)+".CTR.t.nc")
;system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,7)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,7)+".CTR.nc")
;system("rm "+CTR_out_dir+year_x_str(i_year,7)+".CTR.t.nc")
;;
;system("ncrcat -O -D 2 -v "+var_str+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-19-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-20-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-21-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-22-00000.nc "+CTR_in_dir_years(i_year)+"F_AMIP_CAM5_WADA_CTR_"+yearx(i_year)+"_production_sim2.cam.h2."+yearx(i_year+1)+"-02-23-00000.nc -o "+CTR_out_dir+year_x_str(i_year,8)+".CTR.t.nc")
;system("ncrcat -O -D 2 -d time,1,96 -v "+var_str+CTR_out_dir+year_x_str(i_year,8)+".CTR.t.nc -o "+CTR_out_dir+year_x_str(i_year,8)+".CTR.nc")
;system("rm "+CTR_out_dir+year_x_str(i_year,8)+".CTR.t.nc")
;
;
;end do ; do i_year
;;;
;;
;
;;;========== Calculate the mean and std of ensemble in TOPOTEST ======

;-----combine different members into a single file
;system("ncecat -u realization "+out_dir+"*.nc -o "+out_dir+"ENS.TOPOTEST.nc")
;------- to cut the ENS.TOPOTEST.nc into smaller chunks to avoid the memory problem ----
;-------- to avoid the memory issue -------------
num_time = 96
chunk = 32

;do i_chunk = 0,chunk-1
;num1 = i_chunk * num_time/chunk
;num2 = num1 + num_time/chunk - 1
;;note only ncl 6.5.0 or newer verion has this function
;pid = subprocess("ncrcat -D 2 -d time,"+tostring(num1)+","+tostring(num2)+" "+out_dir+"ENS.TOPOTEST.nc -o "+out_dir+"ENS.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc")
;end do
;
;numFinished = 0
;do while(numFinished.lt.chunk) 
;  pid = subprocess_wait(-1, True)
;  numFinished = numFinished + 1
;end do

;;-----calculate the ensemble mean along the realization dimension
;;;do i_chunk = 0,chunk-1
;do i_chunk = 0,chunk-1
;num1 = i_chunk * num_time/chunk
;num2 = num1 + num_time/chunk - 1
;;note only ncl 6.5.0 or newer verion has this function
;;pid = subprocess("ncwa -O -a realization "+out_dir+"ENS.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc "+out_dir+"ENS.mean.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc")
;system("ncwa -O -a realization "+out_dir+"ENS.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc "+out_dir+"ENS.mean.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc")
;end do
;;
;;;numFinished = 0
;;;do while(numFinished.lt.chunk) 
;;  pid = subprocess_wait(-1, True)
;;  numFinished = numFinished + 1
;;end do

;;;---- Calculate Anomaly -
;do i_chunk = 0,chunk-1
;num1 = i_chunk * num_time/chunk
;num2 = num1 + num_time/chunk - 1
;;;note only ncl 6.5.0 or newer verion has this function
;pid = subprocess("ncbo -O "+out_dir+"ENS.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc "+out_dir+"ENS.mean.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc "+out_dir+"ENS.anom.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc")
;end do
;
;numFinished = 0
;do while(numFinished.lt.chunk) 
;  pid = subprocess_wait(-1, True)
;  numFinished = numFinished + 1
;end do

;;------Calculate the standard deviation along realization dimension-
do i_chunk = 0,chunk-1
num1 = i_chunk * num_time/chunk
num2 = num1 + num_time/chunk - 1
;;note only ncl 6.5.0 or newer verion has this function
pid = subprocess("ncra -O -y rmssdn "+out_dir+"ENS.anom.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc "+out_dir+"ENS.std.TOPOTEST.time"+tostring(num1)+"-"+tostring(num2)+".nc")
end do

numFinished = 0
do while(numFinished.lt.chunk) 
  pid = subprocess_wait(-1, True)
  numFinished = numFinished + 1
end do
exit

;===============
;========== Calculate the mean and std of ensemble in CTR ======
;-----combine different members into a single file
;system("ncecat -u realization "+CTR_out_dir+"*.nc -o "+CTR_out_dir+"ENS.CTR.nc")
;------- to cut the ENS.TOPOTEST.nc into smaller chunks to avoid the memory problem ----

;do i_chunk = 0,chunk-1
;num1 = i_chunk * num_time/chunk
;num2 = num1 + num_time/chunk - 1
;;note only ncl 6.5.0 or newer verion has this function
;pid = subprocess("ncrcat -D 2 -d time,"+tostring(num1)+","+tostring(num2)+" "+CTR_out_dir+"ENS.CTR.nc -o "+CTR_out_dir+"ENS.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc")
;
;end do
;
;numFinished = 0
;do while(numFinished.lt.chunk) 
;  pid = subprocess_wait(-1, True)
;  numFinished = numFinished + 1
;end do

;;-----calculate the ensemble mean along the realization dimension

;do i_chunk = 0,chunk-1
;num1 = i_chunk * num_time/chunk
;num2 = num1 + num_time/chunk - 1
;;note only ncl 6.5.0 or newer verion has this function
;;pid = subprocess("ncwa -O -a realization "+CTR_out_dir+"ENS.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc "+CTR_out_dir+"ENS.mean.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc")
;system("ncwa -O -a realization "+CTR_out_dir+"ENS.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc "+CTR_out_dir+"ENS.mean.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc")
;
;end do

;;numFinished = 0
;;do while(numFinished.lt.chunk) 
;;  pid = subprocess_wait(-1, True)
;;  numFinished = numFinished + 1
;;end do
;;
;
;;;-----Calculate Anomaly -
;do i_chunk = 0,chunk-1
;num1 = i_chunk * num_time/chunk
;num2 = num1 + num_time/chunk - 1
;;note only ncl 6.5.0 or newer verion has this function
;pid = subprocess("ncbo -O "+CTR_out_dir+"ENS.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc "+CTR_out_dir+"ENS.mean.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc "+CTR_out_dir+"ENS.anom.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc")
;
;end do
;
;numFinished = 0
;do while(numFinished.lt.chunk) 
;  pid = subprocess_wait(-1, True)
;  numFinished = numFinished + 1
;end do
;;;------Calculate the standard deviation along realization dimension-
;
;do i_chunk = 0,chunk-1
;num1 = i_chunk * num_time/chunk
;num2 = num1 + num_time/chunk - 1
;;note only ncl 6.5.0 or newer verion has this function
;pid = subprocess("ncra -O -y rmssdn "+CTR_out_dir+"ENS.anom.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc "+CTR_out_dir+"ENS.std.CTR.time"+tostring(num1)+"-"+tostring(num2)+".nc")
;end do
;
;numFinished = 0
;do while(numFinished.lt.chunk) 
;  pid = subprocess_wait(-1, True)
;  numFinished = numFinished + 1
;end do
;
;;system("ncra -O -y rmssdn "+CTR_out_dir+"ENS.anom.CTR.time90-95.nc "+CTR_out_dir+"ENS.std.CTR.time90-95.nc")


end
