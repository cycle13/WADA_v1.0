;Function: Preprocessing FLUXNET-MET data
;Date: 20180402

begin

;================FLUXNET-MTE=========================

f_SH = addfile("/lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE/2017613193931EnsembleHcor_May12.1982.2011.nc","r")
f_LH = addfile("/lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE/20176131936542_EnsembleLEcor_May12.nc","r")

SH_MTE = f_SH->EnsembleHcor_May12
LH_MTE = f_LH->EnsembleLEcor_May12
printVarSummary(SH_MTE)
printVarSummary(LH_MTE)

SH_MTE = SH_MTE(:,::-1,:)
LH_MTE = LH_MTE(:,::-1,:)

printVarSummary(SH_MTE)
printVarSummary(LH_MTE)

SH_MTE_flip = lonFlip(SH_MTE)
LH_MTE_flip = lonFlip(LH_MTE)

printVarSummary(SH_MTE_flip)
printVarSummary(LH_MTE_flip)

;================ Regrid FLUXNET-MET to model grid =============

f_model = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/pr/pr_Amon_CCSM4_amip_r1i1p1_197901-201012.nc","r")
newlat = f_model->lat
newlon = f_model->lon

SH_MTE_regrid = linint2_Wrap(SH_MTE_flip&longitude,SH_MTE_flip&latitude,SH_MTE_flip,True,newlon,newlat,0)

LH_MTE_regrid = linint2_Wrap(LH_MTE_flip&longitude,LH_MTE_flip&latitude,LH_MTE_flip,True,newlon,newlat,0)

printVarSummary(SH_MTE_regrid)
printVarSummary(LH_MTE_regrid)

;========== convert from MegaJoules/day/m2  to watts/m2 ============
;=========== by *10^6/24/3600 ===================================

SH_MTE_regrid = SH_MTE_regrid *10^6 / (24.0*3600.0)
SH_MTE_regrid@units = "W/m2"
LH_MTE_regrid = LH_MTE_regrid * 10^6 / (24.0*3600.0)
LH_MTE_regrid@units = "W/m2"

printVarSummary(SH_MTE_regrid)
printVarSummary(LH_MTE_regrid)

;===============Out put FLUXNET-MTE data to nc files=============================================
system("rm /lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE_post_processing/FLUXNET-MTE_latent_sensible_heat_flux_1982-2011.regrid.288x192.nc")
ncdf = addfile("/lustre/DATA/pritchard/hongcheq/ET_datasets/FLUXNET_MTE_post_processing/FLUXNET-MTE_latent_sensible_heat_flux_1982-2011.regrid.288x192.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->SH_MTE_regrid = SH_MTE_regrid
ncdf->LH_MTE_regrid = LH_MTE_regrid



end
