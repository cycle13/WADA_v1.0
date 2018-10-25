;Function: Use procedure "Inoue_Back_NGMS_Procedure" to compute the climatology of NGMS of CMIP5 model outputs (AMIP simulation)
;Date: 20180229

load "/global/homes/h/hongcheq/Programming/NCL/WADA/Pilot_test/Inoue_Back_NGMS_Procedure.ncl"
load "/global/homes/h/hongcheq/Programming/NCL_funs_and_procs/funs_and_procs.ncl"

begin

hongcheq_dir = "/project/projectdirs/m2840/hongcheq/CMIP5/"

var_string = (/"hfss"/)

;=========== CCSM4
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,0,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CCSM4_amip_r1i1p1_197901-201012.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)

;file_output = hongcheq_dir+"hfss/hfss_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc"

;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;;=========== ACCESS1-3

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,12,371 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_ACCESS1-3_amip_r1i1p1_197801-200812.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)

;file_output = hongcheq_dir+"hfss/hfss_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.clim.nc"

;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim
;
;;=========== CanAM4
;(1979-1950)*12 = 348; 358+359 = 707
;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,348,707 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CanAM4_amip_r1i1p1_195001-200912.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_CanAM4_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;============ IPSL-CM5A-LR

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,0,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200912.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim
;
;=========== CNRM-CM5

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)

;file_output = hongcheq_dir+"hfss/hfss_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.clim.nc"

;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;=========== NorESM1-M
;====================

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_NorESM1-M_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc")    ; make sure not including previous NCO-processed NorESM1-M files.
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)

;file_output = hongcheq_dir+"hfss/hfss_Amon_NorESM1-M_amip_r1i1p1_197901-200812.clim.nc"

;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim
;;
;=========================================
;=========== HadGEM2-A =======
;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_HadGEM2-A_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_HadGEM2-A_amip_r1i1p1_197809-200812.ncrcat.nc")    ; make sure not including previous NCO-processed NorESM1-M files.
;end do

;======== Only 197901--200812 =====
;;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,4,363 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_HadGEM2-A_amip_r1i1p1_197809-200812.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;===========CMCC-CM
;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CMCC-CM_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc")    ; make sure not including previous NCO-processed NorESM1-M files.
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)

;file_output = hongcheq_dir+"hfss/hfss_Amon_CMCC-CM_amip_r1i1p1_197901-200812.clim.nc"

;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim


;==========MPI-ESM-MR

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim


;;========= ACCESS1-0

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;======== CSIRO-Mk3-6-0


;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,0,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200912.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)

;file_output = hongcheq_dir+"hfss/hfss_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.clim.nc"

;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;===============IPSL-CM5A-MR


;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_195001-200912.ncrcat.nc")
;end do

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,348,707 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_195001-200912.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;============ IPSL-CM5B-LR

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim
;
;=========== MPI-ESM-LR

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;;
;file_output = hongcheq_dir+"hfss/hfss_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.clim.nc"
;;
;;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;=========== MRI-AGCM3-2H =========

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2H_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do

;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;============ inmcm4

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_inmcm4_amip_r1i1p1_197901-200812.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_inmcm4_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim
;
;============= MIROC-ESM

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim 

;============= MRI-CGCM3

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,0,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_197901-201002.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do
;
;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))
;

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;======== MIROC5 ========

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_MIROC5_amip_r1i1p1_197901-200812.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_MIROC5_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;============= GFDL-CM3

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-CM3_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do
;
;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))
;
;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;=========== GISS-E2-R
;;;!!!Note: For this model, hus,pr,ps,ta,wap have lat=90, but for ua,va,zg, lat=89???=====
;;;   Note: just put this model aside for now.
;;;==========================
;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,336,695 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GISS-E2-R_amip_r1i1p1_195101-201012.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;hus_file = hongcheq_dir+"hus/hus_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;ta_file = hongcheq_dir+"ta/ta_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;zg_file = hongcheq_dir+"zg/zg_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;ps_file = hongcheq_dir+"ps/ps_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;ua_file = hongcheq_dir+"ua/ua_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;va_file = hongcheq_dir+"va/va_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"
;wap_file = hongcheq_dir+"wap/wap_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.ncrcat.nc"

;file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_GISS-E2-R_amip_r1i1p1_197901-200812.clim.nc"

;Error from the following line 
;""
;Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;=========== GFDL-HIRAM-C360

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C360_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do
;
;file_test = addfile(hongcheq_dir+"hus/hus_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim

;=========== GFDL-HIRAM-C180

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C180_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do
;
;file_test = addfile(hongcheq_dir+"hfss/hfss_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))
;
;f_hfss = addfile(hongcheq_dir+"hfss/hfss_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;hfss = f_hfss->hfss
;hfss_clim = dim_avg_n_Wrap(hfss,0)
;printVarSummary(hfss_clim)
;
;file_output = hongcheq_dir+"hfss/hfss_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.clim.nc"
;
;;;-------- write climatology of sensible heat flux to nc files ======
;system("rm -f "+file_output)
;ncdf = addfile(file_output,"c")
;filedimdef(ncdf,"time",-1,True)
;ncdf->hfss_clim = hfss_clim
;;
;





end
