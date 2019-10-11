;Function: preprocessing GPCP and FLUXNET-MTE data
;Date: 20180402

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;========= GPCP precipitation extract 1982-2008 climatology ====
gpcp = addfile("/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/precip.mon.mean.nc","r")
precip = gpcp->precip(36:359,:,:)
;print(Calendar(precip&time))
;------------ regrid to CCSM grid ---------

f_model = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/pr/pr_Amon_CCSM4_amip_r1i1p1_197901-201012.nc","r")
newlat = f_model->lat
newlon = f_model->lon

precip_regrid = linint2_Wrap(precip&lon,precip&lat,precip,True,newlon,newlat,0)
printVarSummary(precip_regrid)

;------------------------------------------
pr_clim_GPCP = dim_avg_n_Wrap(precip_regrid,0)
printVarSummary(pr_clim_GPCP)
pr_mon_clim_GPCP = clmMonTLL(precip_regrid)
printVarSummary(pr_mon_clim_GPCP)

;========= output as nc files ====
system("rm -f /lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/GPCP_198201-200812_clim.regrid.288x192.nc")
ncdf = addfile("/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/GPCP_198201-200812_clim.regrid.288x192.nc","c")

filedimdef(ncdf,"time",-1,True)

ncdf->pr_clim_GPCP = pr_clim_GPCP
ncdf->pr_mon_clim_GPCP = pr_mon_clim_GPCP

;======= FLUXNET-MTE Bowen ratio extract 1982-2008 climatology ========

SH = addfile("/lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE_post_processing/FLUXNET-MTE_latent_sensible_heat_flux_1982-2011.regrid.288x192.nc","r")
LH = addfile("/lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE_post_processing/FLUXNET-MTE_latent_sensible_heat_flux_1982-2011.regrid.288x192.nc","r")
MTE_SH = SH->SH_MTE_regrid(0:323,:,:)
MTE_LH = LH->LH_MTE_regrid(0:323,:,:)
;print(Calendar(MTE_SH&time))
;print(Calendar(MTE_LH&time))
;printVarSummary(MTE_SH)
;printVarSummary(MTE_LH)

MTE_SH_clim = dim_avg_n_Wrap(MTE_SH,0)
printVarSummary(MTE_SH_clim)
MTE_SH_mon_clim = clmMonTLL(MTE_SH)
printVarSummary(MTE_SH_mon_clim)

MTE_LH_clim = dim_avg_n_Wrap(MTE_LH,0)
printVarSummary(MTE_LH_clim)
MTE_LH_mon_clim = clmMonTLL(MTE_LH)
printVarSummary(MTE_LH_mon_clim)

MTE_BR_clim = MTE_SH_clim / where(abs(MTE_LH_clim) .gt. 5, MTE_LH_clim,MTE_SH_clim@_FillValue)
MTE_BR_mon_clim = MTE_SH_mon_clim / where(abs(MTE_LH_mon_clim) .gt. 5, MTE_LH_mon_clim,MTE_SH_mon_clim@_FillValue)

copy_VarCoords(MTE_SH_clim,MTE_BR_clim)
copy_VarCoords(MTE_SH_mon_clim,MTE_BR_mon_clim)

printVarSummary(MTE_BR_clim)
printVarSummary(MTE_BR_mon_clim)

;========= output as nc files ====
system("rm -f /lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE_post_processing/FLUXNET-MTE_198201-200812_clim.nc")
ncdf = addfile("/lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE_post_processing/FLUXNET-MTE_198201-200812_clim.nc","c")

filedimdef(ncdf,"time",-1,True)

ncdf->MTE_SH_clim = MTE_SH_clim
ncdf->MTE_SH_mon_clim = MTE_SH_mon_clim

ncdf->MTE_LH_clim = MTE_LH_clim
ncdf->MTE_LH_mon_clim = MTE_LH_mon_clim

ncdf->MTE_BR_clim = MTE_BR_clim
ncdf->MTE_BR_mon_clim = MTE_BR_mon_clim


end
