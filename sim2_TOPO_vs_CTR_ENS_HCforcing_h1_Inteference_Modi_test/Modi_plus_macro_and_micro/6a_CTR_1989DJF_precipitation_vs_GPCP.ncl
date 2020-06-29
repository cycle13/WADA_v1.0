;To calculate the WADA 1989 CTR simulation, the Andean and Amazon rainfall biases relative to GPCPv2.3

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
f_model = addfile("/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/WADA_simulation/1989_CTR/F_AMIP_CAM5_WADA_CTR_1989_production_sim2.cam.h0.1989-12_1990-01_1990-02.ncrcat.nc","r")
f_gpcp = addfile("/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/precip.mon.mean.GPCPv2.3.new.nc","r")

PRECT = f_model->PRECT
PRECT = PRECT * 86400.0 * 1000.0 ; from meter/sec to mm/day
PRECT@units = "mm/day"
printVarSummary(PRECT)
PRECT_DJFmean = dim_avg_n_Wrap(PRECT,0)
printVarSummary(PRECT_DJFmean)

precip_gpcp = f_gpcp->precip
precip_gpcp_1989DJF = precip_gpcp(131:133,:,:)
printVarSummary(precip_gpcp_1989DJF)
print(Calendar(precip_gpcp_1989DJF&time))

;--------- regrid GPCP to model grid -----
  newlat = PRECT_DJFmean
  newlon = fspan(0.,355.,72)
  newlat@units = "degrees_north"
  newlon@units = "degrees_east"

  precip_gpcp_regrid = linint2_Wrap(precip_gpcp_1989DJF&lon,precip_gpcp_1989DJF&lat,precip_gpcp_1989DJF,True,PRECT_DJFmean&lon,PRECT_DJFmean&lat,0)
 
 printVarSummary(precip_gpcp_regrid)

precip_gpcp_regrid_mean = dim_avg_n_Wrap(precip_gpcp_regrid,0)
printVarSummary(precip_gpcp_regrid_mean)

;------- Andean rainfall mean and bias ------------
;-------- Use SGH30 -----  
f_SGH30 = addfile("/DFS-L/DATA/pritchard/hongcheq/Topography/USGS-gtopo30_1.9x2.5_remap_c050602.nc","r")
SGH30 = f_SGH30->SGH30

SGH30m = SGH30
SGH30m = SGH30@_FillValue
SGH30m({-40:10},{270:300}) = SGH30({-40:10},{270:300})

do ilat = 0,95
   do ilon = 0,143
      if (.not. ismissing(SGH30m(ilat,ilon)) .and. SGH30m(ilat,ilon) .lt. 200.0) then
          SGH30m(ilat,ilon) = SGH30m@_FillValue
      end if
   end do
end do
printVarSummary(SGH30m)


;-------- Amazonian rainfall mean and bias ---------

Amazon_lon_test1 = (/288.0,309.0/)
Amazon_lat_test1 = (/-10.0,4.0/)

;calculate Amazon mean precip, and Andean mean precip 
rad = 4.0*atan(1.0)/180.0
clat = cos(f_model->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad)

Andes_model = avg(where(.not.ismissing(SGH30m), PRECT_DJFmean, PRECT_DJFmean@_FillValue))
Andes_gpcp = avg(where(.not.ismissing(SGH30m), precip_gpcp_regrid_mean, precip_gpcp_regrid_mean@_FillValue)) 
Amazon_model = wgt_areaave_Wrap( PRECT_DJFmean({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1 )

Amazon_gpcp = wgt_areaave_Wrap( precip_gpcp_regrid_mean({Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}),clat,1.0,1)


Andes_model@long_name = "Andean mean rainfall of 1989 DJF in CTR simulations"
Amazon_model@long_name = "Amazon mean rainfall of 1989 DJF in CTR simulations"

Andes_bias = Andes_model - Andes_gpcp
Andes_bias@long_name = "Bias of the Andean rainfall of 1989 DJF in CTR simulation, relative to GPCPv2.3 "

Amazon_bias = Amazon_model - Amazon_gpcp
Amazon_bias@long_name = "Bias of the Amazonian rainfall of 1989 DJF in CTR simulation, relative to GPCPv2.3 "

Andes_model@units = "mm/day"
Amazon_model@units = "mm/day"
Andes_bias@units = "mm/day"
Amazon_bias@units = "mm/day"

;printVarSummary(Andes_model)
print(Andes_model)
;printVarSummary(Amazon_model)
print(Amazon_model)

;printVarSummary(Andes_bias)
print(Andes_bias)
;printVarSummary(Amazon_bias)
print(Amazon_bias)

;--------- save at nc files -----
system("rm /lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/WADA_simulation/1989_CTR/Andes_Amazon_rainfall_mean_bias.nc") 
ncdf = addfile("/lustre/DATA/pritchard/hongcheq/GPCP/mon/v2.3/WADA_simulation/1989_CTR/Andes_Amazon_rainfall_mean_bias.nc" ,"c")

filedimdef(ncdf,"time",-1,True) 

ncdf->Andes_model  = Andes_model
ncdf->Andes_bias  = Andes_bias
ncdf->Amazon_model  = Amazon_model
ncdf->Amazon_bias  = Amazon_bias


end
