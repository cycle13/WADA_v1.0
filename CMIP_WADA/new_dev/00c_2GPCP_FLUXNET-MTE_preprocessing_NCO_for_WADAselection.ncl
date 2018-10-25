;Function: preprocessing GPCP and FLUXNET-MTE data
;Date: 20180402

;Note: WADAselection

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

;========= GPCP precipitation extract 1982-2008 climatology ====
gpcp = addfile("/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/precip.mon.mean.nc","r")
precip_temp = gpcp->precip(131:361,:,:)   ; 198912-200902

;make sure the Dec is the from the following year
precip_D = precip_temp(0:230:12,:,:) ; Dec
precip_J = precip_temp(1:230:12,:,:) ; Jan
precip_F = precip_temp(2:230:12,:,:) ; Feb

print(Calendar(precip_D&time))
print(Calendar(precip_J&time))
print(Calendar(precip_F&time))

precip = precip_D(0,:,:) ; metadata
precip = (dim_avg_n(precip_D,0) + dim_avg_n(precip_J,0) + dim_avg_n(precip_F,0) ) / 3.0
precip@long_name = "DJF mean, 1989-2008, (1989 Dec -- 1990 Jan, Feb, etc. until 2008 Dec-2009Jan,Feb)"
printVarSummary(precip)

;------------ regrid to CESM CTR grid ---------

f_model = addfile("/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/F_AMIP_CAM5_WADA_CTR_1989_production/atm/hist/F_AMIP_CAM5_WADA_CTR_1989_production.cam.h1.1989-11-21-00000.nc","r")

newlat = f_model->lat
newlon = f_model->lon

precip_regrid = linint2_Wrap(precip&lon,precip&lat,precip,True,newlon,newlat,0)
printVarSummary(precip_regrid)

;========= output as nc files ====
system("rm -f /lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/GPCP_1989-2008_DJFmean.regrid.144x96.nc")
ncdf = addfile("/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/GPCP_1989-2008_DJFmean.regrid.144x96.nc","c")

filedimdef(ncdf,"time",-1,True)

ncdf->pr_clim_GPCP = precip_regrid


end
