;
;load

begin
;---------- step 1: ERA5, from short to float 
dir = "/DFS-L/DATA/pritchard/hongcheq/ERA5/"
fil = "ERA5.monthly.RelativeHumidity.SpecificHumidity.VerticalVelocity.1979-2008.500hPa.DJF.nc"

ERA5_file = addfile(dir+fil,"r")   
; ------ 1979 - 2008, DJF only, skip the 1979, 1980, 1981, to make consistent with CMIP
r = short2flt(ERA5_file->r(9:,:,:))
q = short2flt(ERA5_file->q(9:,:,:))
w = short2flt(ERA5_file->w(9:,:,:))

;---- 
r_new = r(:,::-1,:)
q_new = q(:,::-1,:)
w_new = w(:,::-1,:)

printVarSummary(r)
printVarSummary(q)
printVarSummary(w)

;---------- step 2: to climatology --------
r_new_clim = dim_avg_n_Wrap(r_new,0)
q_new_clim = dim_avg_n_Wrap(q_new,0)
w_new_clim = dim_avg_n_Wrap(w_new,0)

printVarSummary(r_new_clim)
printVarSummary(q_new_clim)
printVarSummary(w_new_clim)

;------- step 3: ERA5, regrid to grid structures other CMIP models use

;============== use CCSM4 horizontal grid as the target grid ==
regrid_file = addfile("/lustre/DATA/pritchard/hongcheq/CMIP5/pr/pr_Amon_CCSM4_amip_r1i1p1_197901-201012.nc","r")
newlon = regrid_file->lon
newlat = regrid_file->lat

r_regrid = linint2_Wrap(r_new_clim&longitude,r_new_clim&latitude,r_new_clim,True,newlon,newlat,0)
q_regrid = linint2_Wrap(q_new_clim&longitude,q_new_clim&latitude,q_new_clim,True,newlon,newlat,0)
w_regrid = linint2_Wrap(w_new_clim&longitude,w_new_clim&latitude,w_new_clim,True,newlon,newlat,0)

printVarSummary(r_regrid)
printVarSummary(q_regrid)
printVarSummary(w_regrid)

;------------- output to nc files ------
system("rm -f /DFS-L/DATA/pritchard/hongcheq/ERA5/ERA5.r_q_w.500hPa.regrid.nc")
ncdf = addfile("/DFS-L/DATA/pritchard/hongcheq/ERA5/ERA5.r_q_w.500hPa.regrid.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->r_regrid = r_regrid
ncdf->q_regrid = q_regrid
ncdf->w_regrid = w_regrid




end
