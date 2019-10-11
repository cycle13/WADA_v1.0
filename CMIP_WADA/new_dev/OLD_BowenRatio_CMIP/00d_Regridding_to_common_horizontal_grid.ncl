;Function; regrid precip clim and Bowen ratio for every single model to a common grid, so that the Multi-model-mean in the next step can be computed easily.
;Date: 20180402

begin

;=========================
pr_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/pr/"
BR_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/BR_processing/"
wap_dir_name = "/lustre/DATA/pritchard/hongcheq/CMIP5/wap_processing/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M",\
                "IPSL-CM5A-LR",     "CMCC-CM",      "MPI-ESM-MR", "ACCESS1-0",\
                "CSIRO-Mk3-6-0",  "IPSL-CM5A-MR","IPSL-CM5B-LR", "MPI-ESM-LR", "MRI-AGCM3-2H",\
                "inmcm4",         "MIROC-ESM",    "MRI-CGCM3",    "MIROC5", "HadGEM2-A", "GFDL-CM3", "GFDL-HIRAM-C360","GFDL-HIRAM-C180"/)

precip_models = (/pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)

BR_models = (/BR_dir_name+"BR_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
                BR_dir_name+"BR_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)

wap_models = (/wap_dir_name+"wap_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
                wap_dir_name+"wap_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)

;============== use CCSM4 horizontal grid as the target grid ==
regrid_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/pr/pr_Amon_CCSM4_amip_r1i1p1_197901-201012.nc","r")
newlon = regrid_file->lon
newlat = regrid_file->lat

;============ Regrid preciptation climatology ============
;do i_model = dimsizes(WADA_labels) -1 , dimsizes(WADA_labels) -1 ; only update the last model 
do i_model = 1, dimsizes(WADA_labels) - 1    ; CCSM4 is the first one, skip.

pr_clim_file = addfile(precip_models(i_model),"r")
pr_clim = pr_clim_file->pr_clim
pr_mon_clim = pr_clim_file->pr_mon_clim

pr_clim_new = linint2_Wrap(pr_clim&lon,pr_clim&lat,pr_clim,True,newlon,newlat,0)
pr_mon_clim_new = linint2_Wrap(pr_mon_clim&lon,pr_mon_clim&lat,pr_mon_clim,True,newlon,newlat,0)

printVarSummary(pr_clim)
printVarSummary(pr_clim_new)
printVarSummary(pr_mon_clim)
printVarSummary(pr_mon_clim_new)

;--------- write to nc files ------
system("rm -f "+pr_dir_name+"regrid_precipitation_clim_198201-200812."+WADA_labels(i_model)+".nc")
ncdf = addfile(pr_dir_name+"regrid_precipitation_clim_198201-200812."+WADA_labels(i_model)+".nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->pr_clim_regrid = pr_clim_new
ncdf->pr_mon_clim_regrid = pr_mon_clim_new

delete(pr_clim)
delete(pr_clim_new)
delete(pr_mon_clim)
delete(pr_mon_clim_new)

end do ; do i_model

;;============== Regrid BR climatology ===========
;do i_model = dimsizes(WADA_labels)-1 , dimsizes(WADA_labels) -1 
do i_model = 1, dimsizes(WADA_labels) - 1    ; CCSM4 is the first one, skip.

BR_clim_file = addfile(BR_models(i_model),"r")
BR_clim = BR_clim_file->BR_clim
BR_mon_clim = BR_clim_file->BR_mon_clim

BR_clim_new = linint2_Wrap(BR_clim&lon,BR_clim&lat,BR_clim,True,newlon,newlat,0)
BR_mon_clim_new = linint2_Wrap(BR_mon_clim&lon,BR_mon_clim&lat,BR_mon_clim,True,newlon,newlat,0)

printVarSummary(BR_clim)
printVarSummary(BR_clim_new)
printVarSummary(BR_mon_clim_new)

;--------- write to nc files ------
system("rm -f "+BR_dir_name+"regrid_BR_clim_198201-200812."+WADA_labels(i_model)+".nc")
ncdf = addfile(BR_dir_name+"regrid_BR_clim_198201-200812."+WADA_labels(i_model)+".nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->BR_clim_regrid = BR_clim_new
ncdf->BR_mon_clim_regrid = BR_mon_clim_new

delete(BR_clim)
delete(BR_clim_new)
delete(BR_mon_clim)
delete(BR_mon_clim_new)

end do ; do i_model

;;============== Regrid wap climatology ===========
;do i_model = dimsizes(WADA_labels)-1 , dimsizes(WADA_labels) -1 
do i_model = 1, dimsizes(WADA_labels) - 1    ; CCSM4 is the first one, skip.

wap_clim_file = addfile(wap_models(i_model),"r")
wap_clim = wap_clim_file->wap_clim
wap_mon_clim = wap_clim_file->wap_mon_clim

wap_clim_new = linint2_Wrap(wap_clim&lon,wap_clim&lat,wap_clim,True,newlon,newlat,0)
wap_mon_clim_new = linint2_Wrap(wap_mon_clim&lon,wap_mon_clim&lat,wap_mon_clim,True,newlon,newlat,0)

printVarSummary(wap_clim)
printVarSummary(wap_clim_new)
printVarSummary(wap_mon_clim_new)

;--------- write to nc files ------
system("rm -f "+wap_dir_name+"regrid_wap_clim_198201-200812."+WADA_labels(i_model)+".nc")
ncdf = addfile(wap_dir_name+"regrid_wap_clim_198201-200812."+WADA_labels(i_model)+".nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->wap_clim_regrid = wap_clim_new
ncdf->wap_mon_clim_regrid = wap_mon_clim_new

delete(wap_clim)
delete(wap_clim_new)
delete(wap_mon_clim)
delete(wap_mon_clim_new)

end do ; do i_model


end
