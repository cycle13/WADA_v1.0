;Function: compute precipitation climatology for CMIP5 models (AMIP historical simulation)
;Date: 20180219

begin

hongcheq_dir = "/project/projectdirs/m2840/hongcheq/CMIP5/pr/"

;=======The precipitation data should already be prepared to be on 197901--200812 in 01CMIP5_NGMS_calculation.ncl======

;system("ncrcat -D 2 -v pr /project/projectdirs/m2840/hongcheq/CMIP5/pr/pr_Amon_NorESM1-M_amip_r1i1p1*.nc -o /project/projectdirs/m2840/hongcheq/CMIP5/pr/pr_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc")
;system("ncrcat -D 2 -v pr /project/projectdirs/m2840/hongcheq/CMIP5/pr/pr_Amon_HadGEM2-A_amip_r1i1p1*.nc -o /project/projectdirs/m2840/hongcheq/CMIP5/pr/pr_Amon_HadGEM2-A_amip_r1i1p1_197809-200812.ncrcat.nc")

;===Note: make sure that the averaged time are consistent with the time in NGMS calculation
;===Note: add the year tag in names for easy reference ====

file_names = (/"pr_Amon_CCSM4_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_CanAM4_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.nc",\
               "pr_Amon_NorESM1-M_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_CMCC-CM_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.nc",\
               "pr_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.nc",\
               "pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.nc",\
               "pr_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.nc",\
               "pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_inmcm4_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.nc",\
               "pr_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_MIROC5_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.ncrcat.nc",\
               "pr_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.ncrcat.nc"/)

file_outputs = (/"pr_Amon_CCSM4_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_CanAM4_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_ACCESS1-3_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_CNRM-CM5_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_NorESM1-M_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_IPSL-CM5A-LR_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_HadGEM2-A_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_CMCC-CM_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_MPI-ESM-MR_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_ACCESS1-0_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_CSIRO-Mk3-6-0_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_IPSL-CM5A-MR_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_IPSL-CM5B-LR_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_MPI-ESM-LR_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_MRI-AGCM3-2H_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_inmcm4_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_MIROC-ESM_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_MRI-CGCM3_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_MIROC5_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_GFDL-CM3_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_GFDL-HIRAM-C360_amip_r1i1p1_197901-200812.clim.nc",\
                 "pr_Amon_GFDL-HIRAM-C180_amip_r1i1p1_197901-200812.clim.nc"/)


;do imodel = 8,8
do imodel = dimsizes(file_names)-1,dimsizes(file_names)-1
;======= CCSM4
file_name = file_names(imodel)
file_output = file_outputs(imodel)

pr_file = addfile(hongcheq_dir+file_name,"r")
pr = pr_file->pr
printVarSummary(pr)

pr_clim = dim_avg_n_Wrap(pr,0)
printVarSummary(pr_clim)

;======== Write nc files ======
system("rm -f "+hongcheq_dir+file_output)
ncdf = addfile(hongcheq_dir+file_output,"c")
filedimdef(ncdf,"time",-1,True)
ncdf->pr_clim = pr_clim

delete(pr)
delete(pr_clim)
end do ; do imodel

end
