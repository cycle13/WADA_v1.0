;Function: compute precipitation climatology for CMIP5 models (AMIP simulation)
;          compute Bowen ratio climatology for CMIP5 models (AMIP simulation)
;Date: 20180402
;Note: Add wap to it.

begin

hongcheq_dir = "/lustre/DATA/pritchard/hongcheq/CMIP5/pr/"

;========== For precipitation first ============
;=======The data should already be prepared to be on 198201--200812 in 00a_CMIP5_preprocessing_NCO.ncl ======

;===Note: add the year tag in names for easy reference ====

file_names = (/"pr_Amon_CCSM4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_CanAM4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_NorESM1-M_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_CMCC-CM_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_inmcm4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_MIROC5_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "pr_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.ncrcat.nc"/)
;               "pr_Amon_MRI-AGCM3-2S_amip_r1i1p1_198201-200812.ncrcat.nc"/)

file_outputs = (/"pr_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
                 "pr_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)
;                 "pr_Amon_MRI-AGCM3-2S_amip_r1i1p1_198201-200812.clim.nc"/)

;do imodel = dimsizes(file_names)-1,dimsizes(file_names) -1   ; only for the last added file
do imodel = 0,dimsizes(file_names)-1
;======= CCSM4
file_name = file_names(imodel)
file_output = file_outputs(imodel)

pr_file = addfile(hongcheq_dir+file_name,"r")
pr = pr_file->pr
printVarSummary(pr)

pr_clim = dim_avg_n_Wrap(pr,0)
printVarSummary(pr_clim)

pr_mon_clim = clmMonTLL(pr)
printVarSummary(pr_mon_clim)

;======== Write nc files ======
system("rm -f "+hongcheq_dir+file_output)
ncdf = addfile(hongcheq_dir+file_output,"c")
filedimdef(ncdf,"time",-1,True)
ncdf->pr_clim = pr_clim
ncdf->pr_mon_clim = pr_mon_clim

delete(pr)
delete(pr_clim)
delete(pr_mon_clim)
end do ; do imodel

;============== For Bowen ratio next =============
hongcheq_dir1 = "/lustre/DATA/pritchard/hongcheq/CMIP5/hfss/"
hongcheq_dir2 = "/lustre/DATA/pritchard/hongcheq/CMIP5/hfls/"
hongcheq_dir_temp = "/lustre/DATA/pritchard/hongcheq/CMIP5/wap/"

hongcheq_dir3 = "/lustre/DATA/pritchard/hongcheq/CMIP5/BR_processing/"
hongcheq_dir4 = "/lustre/DATA/pritchard/hongcheq/CMIP5/wap_processing/"

file_names1 = (/"hfss_Amon_CCSM4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_CanAM4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_NorESM1-M_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_CMCC-CM_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_inmcm4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_MIROC5_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfss_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.ncrcat.nc"/)
;               "hfss_Amon_MRI-AGCM3-2S_amip_r1i1p1_198201-200812.ncrcat.nc"/)

file_names2 = (/"hfls_Amon_CCSM4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_CanAM4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_NorESM1-M_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_CMCC-CM_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_inmcm4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_MIROC5_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "hfls_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.ncrcat.nc"/)
;               "hfls_Amon_MRI-AGCM3-2S_amip_r1i1p1_198201-200812.ncrcat.nc"/)

file_names3 = (/"wap_Amon_CCSM4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_CanAM4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_NorESM1-M_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_CMCC-CM_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_inmcm4_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_MIROC5_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.ncrcat.nc",\
               "wap_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.ncrcat.nc"/)
;               "wap_Amon_MRI-AGCM3-2S_amip_r1i1p1_198201-200812.ncrcat.nc"/)

file_outputs = (/"BR_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
                 "BR_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)
;                 "BR_Amon_MRI-AGCM3-2S_amip_r1i1p1_198201-200812.clim.nc"/)

file_outputs2 = (/"wap_Amon_CCSM4_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_CanAM4_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_ACCESS1-3_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_CNRM-CM5_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_NorESM1-M_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_IPSL-CM5A-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_CMCC-CM_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_MPI-ESM-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_ACCESS1-0_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_IPSL-CM5A-MR_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_IPSL-CM5B-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_MPI-ESM-LR_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_MRI-AGCM3-2H_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_inmcm4_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_MIROC-ESM_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_MRI-CGCM3_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_MIROC5_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_HadGEM2-A_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_GFDL-CM3_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_GFDL-HIRAM-C360_amip_r1i1p1_198201-200812.clim.nc",\
                 "wap_Amon_GFDL-HIRAM-C180_amip_r1i1p1_198201-200812.clim.nc"/)
;                 "wap_Amon_MRI-AGCM3-2S_amip_r1i1p1_198201-200812.clim.nc"/)
; MRI-AGCM3-2S has the following issue. This model has lat 960 and lon 1920. too memory consuming?
; Note: fatal:NclMalloc Failed:[errno=12]

;do imodel = dimsizes(file_names)-1,dimsizes(file_names)-1 ; only for the later added files
;do imodel = 0,dimsizes(file_names)-1
do imodel = 9,dimsizes(file_names)-1

print(imodel)

file_name1 = file_names1(imodel)
file_name2 = file_names2(imodel)
file_name3 = file_names3(imodel)

file_output = file_outputs(imodel)
file_output2 = file_outputs2(imodel)

hfss_file = addfile(hongcheq_dir1+file_name1,"r")
hfls_file = addfile(hongcheq_dir2+file_name2,"r")
wap_file = addfile(hongcheq_dir_temp+file_name3,"r")

hfss = hfss_file->hfss
hfls = hfls_file->hfls
wap = wap_file->wap

printVarSummary(hfss)
printVarSummary(hfls)
printVarSummary(wap)

;========= Bowen ratio calculated only when abs(latent heat flux)>5 Watts/m2
BR = hfss ; meta data
BR = hfss / where(abs(hfls) .gt. 5, hfls, hfss@_FillValue)
BR@long_name = "Bowen ratio, hfss/hfls, where abs(hfls)>5 watts/m2"
BR@units = "unitless"
printVarSummary(BR)
;

BR_clim = dim_avg_n_Wrap(BR,0)
BR_clim@long_name = "Bowen ratio clim 198201-200812"
printVarSummary(BR_clim)

BR_mon_clim = clmMonTLL(BR)
printVarSummary(BR_mon_clim) 

printVarSummary(wap)

wap_clim = dim_avg_n_Wrap(wap,0)
wap_clim@long_name = "wap clim 198201-200812"
printVarSummary(wap_clim)

wap_mon_clim = clmMonTLLL(wap)
printVarSummary(wap_mon_clim)

;======= Write nc files ======
system("rm -f "+hongcheq_dir3+file_output)
ncdf = addfile(hongcheq_dir3+file_output,"c")
filedimdef(ncdf,"time",-1,True)
ncdf->BR_clim = BR_clim
ncdf->BR_mon_clim = BR_mon_clim


delete(BR)
delete(BR_clim)
delete(hfss)
delete(hfls)
delete(BR_mon_clim)

system("rm -f "+hongcheq_dir4+file_output2)
ncdf2 = addfile(hongcheq_dir4+file_output2,"c")
ncdf2->wap_clim = wap_clim
ncdf2->wap_mon_clim = wap_mon_clim

delete(wap)
delete(wap_clim)
delete(wap_mon_clim)

end do ; do imodel



end
