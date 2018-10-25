;Function: After "01_a_Regridding_to_common_horizontal_grid.ncl ", 
;         save Single Model minus Multi-model-mean(MMM) and MMM itself for hfss.

begin

;=========================
pr_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/pr/"
hfss_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/hfss/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M",\
                "IPSL-CM5A-LR",   "HadGEM2-A",    "CMCC-CM",      "MPI-ESM-MR", "ACCESS1-0",\
                "CSIRO-Mk3-6-0",  "IPSL-CM5A-MR","IPSL-CM5B-LR", "MPI-ESM-LR", "MRI-AGCM3-2H",\
                "inmcm4",         "MIROC-ESM",    "MRI-CGCM3",    "MIROC5",    "GFDL-CM3",\
                "GFDL-HIRAM-C360","GFDL-HIRAM-C180"/)

;================== Regridding has been done by "01_a_Regridding_to_common_horizontal_grid.ncl"
;==================  all models to CCSM4 model horizontal grid before calculating the multi-model-mean(MMM) and model minus MMM =====

;================================= Calculate Multi-model-mean for hfss =========
;================================  and save it to nc files =====================
CCSM4_hfss_clim_file = addfile(hfss_dir_name+"hfss_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc","r")
hfss_clim_ave = CCSM4_hfss_clim_file->hfss_clim
hfss_clim_minus_MMM = CCSM4_hfss_clim_file->hfss_clim ; metadata

printVarSummary(hfss_clim_ave)
printVarSummary(hfss_clim_minus_MMM)

do i_model = 1, dimsizes(WADA_labels)-1  ; skip CCSM
hfss_clim_temp_file = addfile(hfss_dir_name+"regrid_hfss_clim_197901-200812."+WADA_labels(i_model)+".nc","r")
hfss_clim_temp = hfss_clim_temp_file->hfss_clim_regrid

hfss_clim_ave = hfss_clim_ave + hfss_clim_temp
delete(hfss_clim_temp_file)
delete(hfss_clim_temp)
end do ; do i_model
hfss_clim_ave = hfss_clim_ave / dimsizes(WADA_labels)
hfss_clim_ave@long_name = "Multi-Model-Mean of hfss clim, 197901-200812"
printVarSummary(hfss_clim_ave)

;------------- output hfss_clim_ave  as nc files -
system("rm -f "+hfss_dir_name+"Multi-Model-Mean_regrid_hfss_clim_197901-200812.nc")
ncdf = addfile(hfss_dir_name+"Multi-Model-Mean_regrid_hfss_clim_197901-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->hfss_MMM = hfss_clim_ave
;------------
;------------------------- Calculate Single model - Model Multi-model-mean -----------

do i_model = 0, dimsizes(WADA_labels)-1
if (i_model .eq. 0) then
hfss_clim_temp_file = addfile(hfss_dir_name+"hfss_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc","r")
hfss_clim_temp = hfss_clim_temp_file->hfss_clim
else
hfss_clim_temp_file = addfile(hfss_dir_name+"regrid_hfss_clim_197901-200812."+WADA_labels(i_model)+".nc","r")
hfss_clim_temp = hfss_clim_temp_file->hfss_clim_regrid
end if

hfss_clim_minus_MMM = hfss_clim_temp  -  hfss_clim_ave
copy_VarCoords(hfss_clim_ave,hfss_clim_minus_MMM)
hfss_clim_minus_MMM@long_name = "hfss clim minus Multi-model-mean, AMIP, 197901-200812"
;----------------- output as nc files -------
system("rm -f "+hfss_dir_name+WADA_labels(i_model)+"_minus_Multi-Model-Mean_regrid_hfss_clim_197901-200812.nc")
ncdf = addfile(hfss_dir_name+WADA_labels(i_model)+"_minus_Multi-Model-Mean_regrid_hfss_clim_197901-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->hfss_clim_minus_MMM = hfss_clim_minus_MMM

delete(hfss_clim_temp_file)
delete(hfss_clim_temp)
delete(hfss_clim_minus_MMM)
delete(ncdf)
end do ; do i_model


end
