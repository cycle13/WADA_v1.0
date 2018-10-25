;Function; regrid precip clim and NGMS clim for every single model to a common grid, so that the Multi-model-mean in the next step can be computed easily.
;Date: 20180305

begin

;=========================
pr_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/pr/"
NGMS_dir_name = "/project/projectdirs/m2840/hongcheq/CMIP5/Post-processing/NGMS/"

WADA_labels = (/"CCSM4",          "CanAM4",      "ACCESS1-3",    "CNRM-CM5",    "NorESM1-M",\
                "IPSL-CM5A-LR",   "HadGEM2-A",    "CMCC-CM",      "MPI-ESM-MR", "ACCESS1-0",\
                "CSIRO-Mk3-6-0",  "IPSL-CM5A-MR","IPSL-CM5B-LR", "MPI-ESM-LR", "MRI-AGCM3-2H",\
                "inmcm4",         "MIROC-ESM",    "MRI-CGCM3",    "MIROC5",    "GFDL-CM3",\
                "GFDL-HIRAM-C360","GFDL-HIRAM-C180"/)

precip_models = (/pr_dir_name+"pr_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CanAM4_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_NorESM1-M_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CMCC-CM_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_inmcm4_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_MIROC5_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.clim.nc",\
                 pr_dir_name+"pr_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.clim.nc"/)

NGMS_models = (/NGMS_dir_name+"NGMS_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CanAM4_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_NorESM1-M_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CMCC-CM_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_inmcm4_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_MIROC5_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.clim.nc",\
                NGMS_dir_name+"NGMS_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.clim.nc"/)

;============== use CCSM4 horizontal grid as the target grid ==
regrid_file = addfile("/project/projectdirs/m2840/hongcheq/regrid/hus_Amon_CCSM4_amip_r1i1p1_197901-201012.nc","r")
newlon = regrid_file->lon
newlat = regrid_file->lat

;============ Regrid preciptation climatology ============
;do i_model = 1,  1 
do i_model = 1, dimsizes(WADA_labels) - 1    ; CCSM4 is the first one, skip.

pr_clim_file = addfile(precip_models(i_model),"r")
pr_clim = pr_clim_file->pr_clim

pr_clim_new = linint2_Wrap(pr_clim&lon,pr_clim&lat,pr_clim,True,newlon,newlat,0)

printVarSummary(pr_clim)
printVarSummary(pr_clim_new)

;--------- write to nc files ------
system("rm -f "+pr_dir_name+"regrid_precipitation_clim_197901-200812."+WADA_labels(i_model)+".nc")
ncdf = addfile(pr_dir_name+"regrid_precipitation_clim_197901-200812."+WADA_labels(i_model)+".nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->pr_clim_regrid = pr_clim_new

delete(pr_clim)
delete(pr_clim_new)
end do ; do i_model

;;============== Regrid NGMS climatology ===========
;do i_model = 1,  1 
do i_model = 1, dimsizes(WADA_labels) - 1    ; CCSM4 is the first one, skip.

NGMS_clim_file = addfile(NGMS_models(i_model),"r")
NGMS_clim = NGMS_clim_file->NGMS

NGMS_clim_new = linint2_Wrap(NGMS_clim&lon,NGMS_clim&lat,NGMS_clim,True,newlon,newlat,0)

printVarSummary(NGMS_clim)
printVarSummary(NGMS_clim_new)

;--------- write to nc files ------
system("rm -f "+NGMS_dir_name+"regrid_NGMS_clim_197901-200812."+WADA_labels(i_model)+".nc")
ncdf = addfile(NGMS_dir_name+"regrid_NGMS_clim_197901-200812."+WADA_labels(i_model)+".nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->NGMS_clim_regrid = NGMS_clim_new

delete(NGMS_clim)
delete(NGMS_clim_new)
end do ; do i_model


end
