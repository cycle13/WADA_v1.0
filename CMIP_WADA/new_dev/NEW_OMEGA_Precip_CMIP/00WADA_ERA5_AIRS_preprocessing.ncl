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

;----------- read specific humidity from AIRS file -------
AIRS = addfile("/lustre/DATA/pritchard/hongcheq/AIRS/hus_mon_AIRS-2-0_BE_gn_200209-201105.nc","r")
AIRS_hus = AIRS->hus(4:75,{50000},:,:) ; from 2003 Jan - 2008 Dec
printVarSummary(AIRS_hus)


;--------- step 2: to climatology --------
r_new_clim = dim_avg_n_Wrap(r_new,0)
q_new_clim = dim_avg_n_Wrap(q_new,0)
w_new_clim = dim_avg_n_Wrap(w_new,0)

printVarSummary(r_new_clim)
printVarSummary(q_new_clim)
printVarSummary(w_new_clim)

;--------- AIRS specific humidity ------
AIRS_hus_mon_clim = clmMonTLL(AIRS_hus)
printVarSummary(AIRS_hus_mon_clim)
AIRS_hus_DJF = AIRS_hus_mon_clim(0,:,:) ; metadata
AIRS_hus_DJF = (AIRS_hus_mon_clim(0,:,:) + AIRS_hus_mon_clim(1,:,:) + AIRS_hus_mon_clim(11,:,:) )/3.0
printVarSummary(AIRS_hus_DJF)
; "AIRS 2003-2008 DJF climatology"

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

AIRS_hus_regrid = linint2_Wrap(AIRS_hus_DJF&lon,AIRS_hus_DJF&lat,AIRS_hus_DJF,True,newlon,newlat,0)
printVarSummary(AIRS_hus_regrid)
;------------- step 4 -------------------
;------------- output to nc files ------
system("rm -f /DFS-L/DATA/pritchard/hongcheq/ERA5/ERA5.AIRS.r_q_w.500hPa.regrid.nc")
ncdf = addfile("/DFS-L/DATA/pritchard/hongcheq/ERA5/ERA5.AIRS.r_q_w.500hPa.regrid.nc","c")

filedimdef(ncdf,"time",-1,True)
ncdf->r_regrid = r_regrid
ncdf->q_regrid = q_regrid
ncdf->w_regrid = w_regrid

ncdf->AIRS_hus_regrid = AIRS_hus_regrid



end
