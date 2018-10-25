;Function: After "00d_Regridding_to_common_horizontal_grid.ncl", 
;         save Single Model minus OBS (GPCP for precip, and FLUXNET-MTE for Bowen ratio) and Multi-Model-Mean for precipitation and Bowen Ratio.

begin

;=========================
pr_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/pr/"
BR_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/BR_processing/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M",\
                "IPSL-CM5A-LR",      "CMCC-CM",      "MPI-ESM-MR", "ACCESS1-0",\
                "CSIRO-Mk3-6-0",  "IPSL-CM5A-MR","IPSL-CM5B-LR", "MPI-ESM-LR", "MRI-AGCM3-2H",\
                "inmcm4",         "MIROC-ESM",    "MRI-CGCM3",    "MIROC5", "HadGEM2-A","GFDL-CM3", "GFDL-HIRAM-C360", "GFDL-HIRAM-C180"/)

;================== Regridding has been done by "00d_Regridding_to_common_horizontal_grid.ncl"
;==================  all models to CCSM4 model horizontal grid before calculating the multi-model-mean(MMM) and model minus MMM =====
CCSM4_pr_clim_file = addfile(pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc","r")
pr_clim_ave = CCSM4_pr_clim_file->pr_clim
;pr_clim_minus_MMM = CCSM4_pr_clim_file->pr_clim ; metadata

pr_mon_clim_ave = CCSM4_pr_clim_file->pr_mon_clim ; metadata
;pr_mon_clim_minus_MMM = CCSM4_pr_clim_file->pr_mon_clim ; metadata

printVarSummary(pr_clim_ave)
;printVarSummary(pr_clim_minus_MMM)
printVarSummary(pr_mon_clim_ave)
;printVarSummary(pr_mon_clim_minus_MMM)

do i_model = 1, dimsizes(WADA_labels)-1  ; skip CCSM
pr_clim_temp_file = addfile(pr_dir_name+"regrid_precipitation_clim_198201-200812."+WADA_labels(i_model)+".nc","r")
pr_clim_temp = pr_clim_temp_file->pr_clim_regrid
pr_mon_clim_temp = pr_clim_temp_file->pr_mon_clim_regrid

pr_clim_ave = pr_clim_ave + pr_clim_temp
pr_mon_clim_ave = pr_mon_clim_ave + pr_mon_clim_temp

delete(pr_clim_temp_file)
delete(pr_clim_temp)
delete(pr_mon_clim_temp)

end do ; do i_model
pr_clim_ave = pr_clim_ave / dimsizes(WADA_labels)
pr_clim_ave@long_name = "Multi-Model-Mean of precip clim, 198201-200812"
printVarSummary(pr_clim_ave)

pr_mon_clim_ave = pr_mon_clim_ave / dimsizes(WADA_labels)
pr_mon_clim_ave@long_name = "Multi-Model-Mean of precip monthly clim, 198201-200812"
printVarSummary(pr_mon_clim_ave)

;------------- output pr_clim_ave and pr_mon_clim_ave as nc files -
system("rm -f "+pr_dir_name+"Multi-Model-Mean_regrid_pr_clim_198201-200812.nc")
ncdf = addfile(pr_dir_name+"Multi-Model-Mean_regrid_pr_clim_198201-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->pr_MMM = pr_clim_ave
ncdf->pr_mon_MMM = pr_mon_clim_ave

;------------------------- Calculate Single model precip - GPCP regridded-----------
;------------ regridded precip from GPCP ------
 f_GPCP_regrid = addfile("/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/GPCP_198201-200812_clim.regrid.288x192.nc","r")
 precip_regrid_GPCP = f_GPCP_regrid->pr_clim_GPCP

precip_regrid_GPCP = precip_regrid_GPCP / 86400.0 ; 
precip_regrid_GPCP@units = "kg m-2 s-1"

do i_model = 0, dimsizes(WADA_labels)-1
if (i_model .eq. 0) then
pr_clim_temp_file = addfile(pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc","r")
pr_clim_temp = pr_clim_temp_file->pr_clim
else
pr_clim_temp_file = addfile(pr_dir_name+"regrid_precipitation_clim_198201-200812."+WADA_labels(i_model)+".nc","r")
pr_clim_temp = pr_clim_temp_file->pr_clim_regrid
end if

pr_clim_minus_GPCP = pr_clim_temp  -  precip_regrid_GPCP
copy_VarCoords(pr_clim_ave,pr_clim_minus_GPCP)
pr_clim_minus_GPCP@long_name = "precip clim minus regridded GPCP, AMIP, 198201-200812"
;----------------- output as nc files -------
system("rm -f "+pr_dir_name+WADA_labels(i_model)+"_minus_regridded_GPCP_pr_clim_198201-200812.nc")
ncdf = addfile(pr_dir_name+WADA_labels(i_model)+"_minus_regridded_GPCP_pr_clim_198201-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->pr_clim_minus_GPCP = pr_clim_minus_GPCP

delete(pr_clim_temp_file)
delete(pr_clim_temp)
delete(pr_clim_minus_GPCP)
delete(ncdf)
end do ; do i_model

;================================= Calculate Multi-model-mean for BR =========
;================================  and save it to nc files =====================
CCSM4_BR_clim_file = addfile(BR_dir_name+"BR_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc","r")
BR_clim_ave = CCSM4_BR_clim_file->BR_clim
BR_clim_minus_MMM = CCSM4_BR_clim_file->BR_clim ; metadata

printVarSummary(BR_clim_ave)
printVarSummary(BR_clim_minus_MMM)

do i_model = 1, dimsizes(WADA_labels)-1  ; skip CCSM
BR_clim_temp_file = addfile(BR_dir_name+"regrid_BR_clim_198201-200812."+WADA_labels(i_model)+".nc","r")
BR_clim_temp = BR_clim_temp_file->BR_clim_regrid

BR_clim_ave = BR_clim_ave + BR_clim_temp
delete(BR_clim_temp_file)
delete(BR_clim_temp)
end do ; do i_model
BR_clim_ave = BR_clim_ave / dimsizes(WADA_labels)
BR_clim_ave@long_name = "Multi-Model-Mean of BR clim, 198201-200812"
printVarSummary(BR_clim_ave)

;------------- output BR_clim_ave  as nc files -
system("rm -f "+BR_dir_name+"Multi-Model-Mean_regrid_BR_clim_198201-200812.nc")
ncdf = addfile(BR_dir_name+"Multi-Model-Mean_regrid_BR_clim_198201-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->BR_MMM = BR_clim_ave
;------------
;------------------------- Calculate Single model BR  - regridded BR from FLUXNET-MTE -----------
;--------- regridded Bowen ratio from FLUXNET-MTE -------- 
f_BR_MTE = addfile("/lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE_post_processing/FLUXNET-MTE_198201-200812_clim.nc","r")
MTE_BR_clim = f_BR_MTE->MTE_BR_clim

do i_model = 0, dimsizes(WADA_labels)-1
if (i_model .eq. 0) then
BR_clim_temp_file = addfile(BR_dir_name+"BR_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc","r")
BR_clim_temp = BR_clim_temp_file->BR_clim
else
BR_clim_temp_file = addfile(BR_dir_name+"regrid_BR_clim_198201-200812."+WADA_labels(i_model)+".nc","r")
BR_clim_temp = BR_clim_temp_file->BR_clim_regrid
end if

BR_clim_minus_MTE = BR_clim_temp  -  MTE_BR_clim
copy_VarCoords(BR_clim_ave,BR_clim_minus_MTE)
BR_clim_minus_MTE@long_name = "BR clim minus Bowen ratio derived from FLUXNET-MTE, AMIP, 198201-200812"
;----------------- output as nc files -------
system("rm -f "+BR_dir_name+WADA_labels(i_model)+"_minus_regridded_FLUXNET-MTE_BR_clim_198201-200812.nc")
ncdf = addfile(BR_dir_name+WADA_labels(i_model)+"_minus_regridded_FLUXNET-MTE_BR_clim_198201-200812.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->BR_clim_minus_MTE = BR_clim_minus_MTE

delete(BR_clim_temp_file)
delete(BR_clim_temp)
delete(BR_clim_minus_MTE)
delete(ncdf)
end do ; do i_model


end
