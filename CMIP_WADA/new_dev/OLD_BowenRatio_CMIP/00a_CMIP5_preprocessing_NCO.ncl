;Function: preprocessing CMIP5 precipitation, sensible heat and latent heat files into 1982-2008 years (FLUXNET-MTE temporal span).
;Date: 20180329
;Note: 20191010, add OMEGA

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

hongcheq_dir = "/lustre/DATA/pritchard/hongcheq/CMIP5/"

var_string = (/"pr","hfss","hfls","wap","hus"/)

;=========== CCSM4
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CCSM4_amip_r1i1p1_197901-201012.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CCSM4_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_CCSM4_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;;=========== ACCESS1-3

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,48,371 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_ACCESS1-3_amip_r1i1p1_197801-200812.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;
;;=========== CanAM4
;(1979-1950)*12 = 348; 358+359 = 707
;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,384,707 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CanAM4_amip_r1i1p1_195001-200912.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CanAM4_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_CanAM4_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;============ IPSL-CM5A-LR

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200912.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;
;=========== CNRM-CM5

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))


;=========== NorESM1-M
;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_NorESM1-M_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc")    ; make sure not including previous NCO-processed NorESM1-M files.
;end do
;
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_NorESM1-M_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_NorESM1-M_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;;
;=========================================
;=========== HadGEM2-A =======
;======= Note: issues with ESGF, no hfls files for this model for now. 20180329
;======= Note: 20180412, ESGF issue solved, you have hfls files for this model now.
;;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_HadGEM2-A_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_HadGEM2-A_amip_r1i1p1_197809-200812.ncrcat.nc")   
;end do
;
;;;;======== Only 198201--200812 =====
;;;;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,40,363 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_HadGEM2-A_amip_r1i1p1_197809-200812.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"hfls/hfls_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;;;------------ HadGEM2-A -----------
;;;;got the hfls file from Chris T, pre-processing it first
;;system("ncrcat -D 2 -d time,36,359 /lustre/DATA/pritchard/hongcheq/CMIP5/From_Chris/HadGEM2-A_amip_r1i1p1_mo_EBudgetMonthly.nc /lustre/DATA/pritchard/hongcheq/CMIP5/hfls/hfls_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.temp193.nc")
;;
;;;============ lon contains 193 values? hfss contains only 192 values ========
;;Had_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/hfls/hfls_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.temp193.nc","r")
;;hfls_lon_192 = Had_file->hfls(:,:,0:191)
;;
;;system("rm -f /lustre/DATA/pritchard/hongcheq/CMIP5/hfls/hfls_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.nc")
;;ncdf = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/hfls/hfls_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.nc","c")
;;filedimdef(ncdf,"time",-1,True)
;;ncdf->hfls = hfls_lon_192
;;

;===========CMCC-CM
;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CMCC-CM_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc")    ; make sure not including previous NCO-processed NorESM1-M files.
;end do
;
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CMCC-CM_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_CMCC-CM_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))
;
;==========MPI-ESM-MR

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;;========= ACCESS1-0

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;======== CSIRO-Mk3-6-0

;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200912.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;===============IPSL-CM5A-MR

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_195001-200912.ncrcat.nc")
;end do
;;
;;==================
;
;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,384,707 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_195001-200912.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))
;
;============ IPSL-CM5B-LR

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;=========== MPI-ESM-LR

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;=========== MRI-AGCM3-2H =========

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2H_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do
;
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;============ inmcm4

;do i_var = 0,dimsizes(var_string) - 1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_inmcm4_amip_r1i1p1_197901-200812.nc "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_inmcm4_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_inmcm4_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;============= MIROC-ESM

;do i_var = 0,dimsizes(var_string) - 1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;============= MRI-CGCM3

;;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_197901-201002.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;======== MIROC5 ========

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MIROC5_amip_r1i1p1_197901-200812.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MIROC5_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"pr/pr_Amon_MIROC5_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))


;============= GFDL-CM3
;Note due to issues in ESGF, no hfls for this model now
;Note 20180412 issues solved, you have hfls files now.
;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-CM3_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do
;
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;;
;file_test = addfile(hongcheq_dir+"hfls/hfls_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;exit
;;-------------- Get the hfls file from Chris T, processing here ---
;system("ncrcat -D 2 -d time,36,359 /lustre/DATA/pritchard/hongcheq/CMIP5/From_Chris/GFDL-CM3_amip_r1i1p1_mo_EBudgetMonthly.nc /lustre/DATA/pritchard/hongcheq/CMIP5/hfls/hfls_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.ncrcat.nc")

;file_test = addfile(hongcheq_dir+"hfls/hfls_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;
;;=========== GISS-E2-R
;;;;!!!Note: For this model, hus,pr,ps,ta,wap have lat=90, but for ua,va,zg, lat=89???=====
;;;;   Note: just put this model aside for now.
;;;;==========================
;;do i_var = 0,0
;;do i_var = 0,dimsizes(var_string) -1
;;system("ncrcat -D 2 -d time,336,695 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GISS-E2-R_amip_r1i1p1_195101-201012.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc")
;;end do
;
;;file_test = addfile(hongcheq_dir+"hus/hus_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;;print(Calendar(file_test->time))
;
;;hus_file = hongcheq_dir+"hus/hus_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;;ta_file = hongcheq_dir+"ta/ta_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;;zg_file = hongcheq_dir+"zg/zg_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;;ps_file = hongcheq_dir+"ps/ps_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;;ua_file = hongcheq_dir+"ua/ua_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;;va_file = hongcheq_dir+"va/va_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;;wap_file = hongcheq_dir+"wap/wap_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;
;;file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.clim.nc"
;
;;Error from the following line 
;;""
;;Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)
;
;=========== GFDL-HIRAM-C360
;Due to issues in ESGF, not hfls for this model yet
;Note: 20180412 issues solved, you have the hfls files now.

;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C360_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do
;
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"hfls/hfls_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))
;
;exit

;=========== GFDL-HIRAM-C180
;Due to issues in ESGF, no hfls file for this model yet
;Note: 20180412, issues have been solved, you have the hfls files now
;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C180_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do
;;
;;
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"hfls/hfls_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;exit
;

;; put this model aside for now.
;;--- MRI-AGCM3-2S -----
;
;;do i_var = 0,0
;;do i_var = 0,dimsizes(var_string) -1
;;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2S_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2S_amip_r1i1p1_197901-200812.ncrcat.nc")    
;;end do
;;
;;do i_var = 0,dimsizes(var_string) -1
;;system("ncrcat -D 2 -d time,36,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2S_amip_r1i1p1_197901-200812.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2S_amip_r1i1p1_198201-200812.ncrcat.nc")
;;end do
;;
;;file_test = addfile(hongcheq_dir+"hfls/hfls_Amon_MRI-AGCM3-2S_amip_r1i1p1_198201-200812.ncrcat.nc","r")
;;print(Calendar(file_test->time))

;;; MRI-AGCM3-2S has the following issue in 00b_CMIP5_precip_Bowen_ratio_clim_compute.ncl. This model has lat 960 and lon 1920. too memory consuming?
; Note: fatal:NclMalloc Failed:[errno=12]








end
