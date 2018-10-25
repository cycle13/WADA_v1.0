;Function: After "04_a_Regridding_to_common_horizontal_grid.ncl", 
;         save Single Model minus Multi-model-mean(MMM) and MMM itself for precipitation and NGMS.

begin

;=========================
pr_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/pr/"
NGMS_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/Post-processing/NGMS/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M",\
                "IPSL-CM5A-LR",   "HadGEM2-A",    "CMCC-CM",      "MPI-ESM-MR", "ACCESS1-0",\
                "CSIRO-Mk3-6-0",  "IPSL-CM5A-MR","IPSL-CM5B-LR", "MPI-ESM-LR", "MRI-AGCM3-2H",\
                "inmcm4",         "MIROC-ESM",    "MRI-CGCM3",    "MIROC5",    "GFDL-CM3",\
                "GFDL-HIRAM-C360","GFDL-HIRAM-C180"/)

;================== Regridding has been done by "04_a_Regridding_to_common_horizontal_grid.ncl"
;==================  all models to CCSM4 model horizontal grid before calculating the multi-model-mean(MMM) and model minus MMM =====
CCSM4_pr_clim_file = addfile(pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc","r")
pr_clim_ave = CCSM4_pr_clim_file->pr_clim
pr_clim_minus_MMM = CCSM4_pr_clim_file->pr_clim ; metadata

printVarSummary(pr_clim_ave)
printVarSummary(pr_clim_minus_MMM)

do i_model = 1, dimsizes(WADA_labels)-1  ; skip CCSM
pr_clim_temp_file = addfile(pr_dir_name+"regrid_precipitation_clim_197901-200812."+WADA_labels(i_model)+".nc","r")
pr_clim_temp = pr_clim_temp_file->pr_clim_regrid

pr_clim_ave = pr_clim_ave + pr_clim_temp
delete(pr_clim_temp_file)
delete(pr_clim_temp)
end do ; do i_model
pr_clim_ave = pr_clim_ave / dimsizes(WADA_labels)
pr_clim_ave@long_name = "Multi-Model-Mean of precip clim, 197901-200812"
printVarSummary(pr_clim_ave)

;------------- output pr_clim_ave  as nc files -
system("rm -f "+pr_dir_name+"Multi-Model-Mean_regrid_pr_clim_197901-200812.nc")
ncdf = addfile(pr_dir_name+"Multi-Model-Mean_regrid_pr_clim_197901-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->pr_MMM = pr_clim_ave
;------------
;------------------------- Calculate Single model - Model Multi-model-mean -----------

do i_model = 0, dimsizes(WADA_labels)-1
if (i_model .eq. 0) then
pr_clim_temp_file = addfile(pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc","r")
pr_clim_temp = pr_clim_temp_file->pr_clim
else
pr_clim_temp_file = addfile(pr_dir_name+"regrid_precipitation_clim_197901-200812."+WADA_labels(i_model)+".nc","r")
pr_clim_temp = pr_clim_temp_file->pr_clim_regrid
end if

pr_clim_minus_MMM = pr_clim_temp  -  pr_clim_ave
copy_VarCoords(pr_clim_ave,pr_clim_minus_MMM)
pr_clim_minus_MMM@long_name = "precip clim minus Multi-model-mean, AMIP, 197901-200812"
;----------------- output as nc files -------
system("rm -f "+pr_dir_name+WADA_labels(i_model)+"_minus_Multi-Model-Mean_regrid_pr_clim_197901-200812.nc")
ncdf = addfile(pr_dir_name+WADA_labels(i_model)+"_minus_Multi-Model-Mean_regrid_pr_clim_197901-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->pr_clim_minus_MMM = pr_clim_minus_MMM

delete(pr_clim_temp_file)
delete(pr_clim_temp)
delete(pr_clim_minus_MMM)
delete(ncdf)
end do ; do i_model

;================================= Calculate Multi-model-mean for NGMS =========
;================================  and save it to nc files =====================
CCSM4_NGMS_clim_file = addfile(NGMS_dir_name+"NGMS_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc","r")
NGMS_clim_ave = CCSM4_NGMS_clim_file->NGMS
NGMS_clim_minus_MMM = CCSM4_NGMS_clim_file->NGMS ; metadata

printVarSummary(NGMS_clim_ave)
printVarSummary(NGMS_clim_minus_MMM)

do i_model = 1, dimsizes(WADA_labels)-1  ; skip CCSM
NGMS_clim_temp_file = addfile(NGMS_dir_name+"regrid_NGMS_clim_197901-200812."+WADA_labels(i_model)+".nc","r")
NGMS_clim_temp = NGMS_clim_temp_file->NGMS_clim_regrid

NGMS_clim_ave = NGMS_clim_ave + NGMS_clim_temp
delete(NGMS_clim_temp_file)
delete(NGMS_clim_temp)
end do ; do i_model
NGMS_clim_ave = NGMS_clim_ave / dimsizes(WADA_labels)
NGMS_clim_ave@long_name = "Multi-Model-Mean of NGMS clim, 197901-200812"
printVarSummary(NGMS_clim_ave)

;------------- output NGMS_clim_ave  as nc files -
system("rm -f "+NGMS_dir_name+"Multi-Model-Mean_regrid_NGMS_clim_197901-200812.nc")
ncdf = addfile(NGMS_dir_name+"Multi-Model-Mean_regrid_NGMS_clim_197901-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->NGMS_MMM = NGMS_clim_ave
;------------
;------------------------- Calculate Single model - Model Multi-model-mean -----------

do i_model = 0, dimsizes(WADA_labels)-1
if (i_model .eq. 0) then
NGMS_clim_temp_file = addfile(NGMS_dir_name+"NGMS_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc","r")
NGMS_clim_temp = NGMS_clim_temp_file->NGMS
else
NGMS_clim_temp_file = addfile(NGMS_dir_name+"regrid_NGMS_clim_197901-200812."+WADA_labels(i_model)+".nc","r")
NGMS_clim_temp = NGMS_clim_temp_file->NGMS_clim_regrid
end if

NGMS_clim_minus_MMM = NGMS_clim_temp  -  NGMS_clim_ave
copy_VarCoords(NGMS_clim_ave,NGMS_clim_minus_MMM)
NGMS_clim_minus_MMM@long_name = "NGMS clim minus Multi-model-mean, AMIP, 197901-200812"
;----------------- output as nc files -------
system("rm -f "+NGMS_dir_name+WADA_labels(i_model)+"_minus_Multi-Model-Mean_regrid_NGMS_clim_197901-200812.nc")
ncdf = addfile(NGMS_dir_name+WADA_labels(i_model)+"_minus_Multi-Model-Mean_regrid_NGMS_clim_197901-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->NGMS_clim_minus_MMM = NGMS_clim_minus_MMM

delete(NGMS_clim_temp_file)
delete(NGMS_clim_temp)
delete(NGMS_clim_minus_MMM)
delete(ncdf)
end do ; do i_model


end
