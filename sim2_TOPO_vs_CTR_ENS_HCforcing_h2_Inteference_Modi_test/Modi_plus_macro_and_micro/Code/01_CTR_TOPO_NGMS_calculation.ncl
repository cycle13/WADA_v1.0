;Function: Use procedure "Inoue_Back_NGMS_Procedure" to compute the climatology of NGMS of CMIP5 model outputs (AMIP simulation)
;Date: 20180229

load "/global/homes/h/hongcheq/Programming/NCL/WADA/Pilot_test/Inoue_Back_NGMS_Procedure.ncl"
load "/global/homes/h/hongcheq/Programming/NCL_funs_and_procs/funs_and_procs.ncl"

begin

hongcheq_dir = "/project/projectdirs/m2840/hongcheq/CMIP5/"

var_string = (/"hus","ta","zg","ps","ua","va","wap","pr"/)  ; even though in this file, variable pr is not used, it will be used in 02precip_clim_compute.ncl 

;=========== CCSM4
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,0,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CCSM4_amip_r1i1p1_197901-201012.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;;=========== ACCESS1-3

;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,12,371 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_ACCESS1-3_amip_r1i1p1_197801-200812.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc"
;
file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.clim.nc"
;
Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)
;
;;=========== CanAM4
;(1979-1950)*12 = 348; 358+359 = 707
;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,348,707 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CanAM4_amip_r1i1p1_195001-200912.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_CanAM4_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;============ IPSL-CM5A-LR

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,0,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200912.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)
;
;=========== CNRM-CM5

hus_file = hongcheq_dir+"hus/hus_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc"
va_file = hongcheq_dir+"va/va_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;=========== NorESM1-M
;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_NorESM1-M_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc")    ; make sure not including previous NCO-processed NorESM1-M files.
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc"
;
file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_NorESM1-M_amip_r1i1p1_197901-200812.clim.nc"
;
Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)
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

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)
;

;===========CMCC-CM
;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CMCC-CM_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc")    ; make sure not including previous NCO-processed NorESM1-M files.
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_CMCC-CM_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;==========MPI-ESM-MR

hus_file = hongcheq_dir+"hus/hus_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc"
va_file = hongcheq_dir+"va/va_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;;========= ACCESS1-0

hus_file = hongcheq_dir+"hus/hus_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc"
va_file = hongcheq_dir+"va/va_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;======== CSIRO-Mk3-6-0

;var_string_temp = (/"hus","ta","ua","va","wap","zg"/)  ; pr and ps already in 197901-200912.nc
;var_string_temp2 = (/"pr","ps"/) 

;do i_var = 0,dimsizes(var_string_temp) -1
;system("ncrcat -D 2 -v "+var_string_temp(i_var)+" "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200912.ncrcat.nc")
;end do

;-------- Just change the names so that next loop can be done throughout all variables ----
;do i_var = 0,dimsizes(var_string_temp2) - 1
;print(i_var)
;system("cp "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200912.nc "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200912.ncrcat.nc")
;end do

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,0,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200912.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;===============IPSL-CM5A-MR

;var_string_temp = (/"pr","ps"/)  ; hus,ta,ua,va,wap already in 195001-200912.nc
;var_string_temp2 = (/"hus","ta","ua","va","wap","zg"/) 

;do i_var = 0,dimsizes(var_string_temp) -1
;system("ncrcat -D 2 -v "+var_string_temp(i_var)+" "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_195001-200912.ncrcat.nc")
;end do

;-------- Just change the names so that next loop can be done throughout all variables ----
;do i_var = 0,dimsizes(var_string_temp2) - 1
;system("cp "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_195001-200912.nc "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_195001-200912.ncrcat.nc")
;end do

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,348,707 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_195001-200912.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;============ IPSL-CM5B-LR

hus_file = hongcheq_dir+"hus/hus_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc"
va_file = hongcheq_dir+"va/va_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;=========== MPI-ESM-LR

hus_file = hongcheq_dir+"hus/hus_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc"
va_file = hongcheq_dir+"va/va_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;=========== MRI-AGCM3-2H =========

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2H_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;============ inmcm4

;var_string_temp = (/"hus","ta","ua","va","wap","zg"/) 
;var_string_temp2 = (/"pr","ps"/)  ; pr ps already in 197901-200812.nc

;do i_var = 0,dimsizes(var_string_temp) -1
;system("ncrcat -D 2 -v "+var_string_temp(i_var)+" "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_inmcm4_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;-------- Just change the names so that next steps can be consistently done throughout all variables ----
;do i_var = 0,dimsizes(var_string_temp2) - 1
;system("cp "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_inmcm4_amip_r1i1p1_197901-200812.nc "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_inmcm4_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;============= MIROC-ESM
hus_file = hongcheq_dir+"hus/hus_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc"
va_file = hongcheq_dir+"va/va_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;============= MRI-CGCM3

;var_string_temp = (/"hus","ta","ua","va","wap","zg"/) 
;var_string_temp2 = (/"pr","ps"/)  ; pr,ps already in 197901-201012.nc

;do i_var = 0,dimsizes(var_string_temp) -1
;system("ncrcat -D 2 -v "+var_string_temp(i_var)+" "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_197901-201002.ncrcat.nc")
;end do

;-------- Just change the names so that next loop can be done throughout all variables ----
;do i_var = 0,dimsizes(var_string_temp2) - 1
;system("cp "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_197901-201002.nc "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_197901-201002.ncrcat.nc")
;end do

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -d time,0,359 "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_197901-201002.ncrcat.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;======== MIROC5 ========

;var_string_temp = (/"hus","ta","ua","va","wap","zg"/) 
;var_string_temp2 = (/"pr","ps"/)  ; pr,ps already in 197901-200812.nc

;do i_var = 0,dimsizes(var_string_temp) -1
;system("ncrcat -D 2 -v "+var_string_temp(i_var)+" "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_MIROC5_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string_temp(i_var)+"/"+var_string_temp(i_var)+"_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;-------- Just change the names so that next loop can be done throughout all variables ----
;do i_var = 0,dimsizes(var_string_temp2) - 1
;system("cp "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_MIROC5_amip_r1i1p1_197901-200812.nc "+hongcheq_dir+var_string_temp2(i_var)+"/"+var_string_temp2(i_var)+"_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc")
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_MIROC5_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;============= GFDL-CM3

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-CM3_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

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

;file_test = addfile(hongcheq_dir+"hus/hus_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;print(Calendar(file_test->time))

hus_file = hongcheq_dir+"hus/hus_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)

;=========== GFDL-HIRAM-C180

;do i_var = 0,0
;do i_var = 0,dimsizes(var_string) -1
;system("ncrcat -D 2 -v "+var_string(i_var)+" "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C180_amip_r1i1p1_??????-??????.nc -o "+hongcheq_dir+var_string(i_var)+"/"+var_string(i_var)+"_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc")    
;end do
;
;;file_test = addfile(hongcheq_dir+"hus/hus_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc","r")
;;print(Calendar(file_test->time))
;
hus_file = hongcheq_dir+"hus/hus_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc"
ta_file = hongcheq_dir+"ta/ta_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc"
zg_file = hongcheq_dir+"zg/zg_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc"
ps_file = hongcheq_dir+"ps/ps_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc"
ua_file = hongcheq_dir+"ua/ua_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc"
va_file = hongcheq_dir+"va/va_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc"
wap_file = hongcheq_dir+"wap/wap_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc"

file_output = hongcheq_dir+"Post-processing/NGMS/NGMS_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.clim.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)
;






end
