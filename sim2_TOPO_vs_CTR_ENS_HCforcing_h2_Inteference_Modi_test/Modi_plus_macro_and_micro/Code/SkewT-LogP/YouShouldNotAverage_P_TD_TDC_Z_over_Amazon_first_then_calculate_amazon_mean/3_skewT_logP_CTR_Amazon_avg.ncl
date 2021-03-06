load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"
;***********************************************
 begin
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

chunk = 32
num_time = 96

num1 = new(32,integer)
num2 = new(32,integer)

do i_chunk = 0,chunk-1
num1_temp = i_chunk * num_time/chunk
num2_temp = num1_temp + num_time/chunk - 1

num1(i_chunk) = num1_temp
num2(i_chunk) = num2_temp
end do  ; do i_chunk

;-------------
str_time = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
end do

do index = 0,31
;do index = 0,7

;TOPO_dir = prefix + "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_dir = prefix + "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"

;CTR dir is the same as in macro
CTR_dir = prefix + "/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

PS_mean_TOPO = f_TOPO_mean->PS
P0 = 100000.0
PM_mean_TOPO = pres_hybrid_ccm(PS_mean_TOPO,P0,hyam,hybm)
copy_VarCoords(f_TOPO_mean->T,PM_mean_TOPO)
PM_mean_TOPO = PM_mean_TOPO / 100.0;
PM_mean_TOPO@units = "hPa"
printVarSummary(PM_mean_TOPO)

TC_mean_TOPO_K = f_TOPO_mean->T
TC_mean_TOPO = TC_mean_TOPO_K - 273.15
TC_mean_TOPO@units = "Celsius"
copy_VarCoords(f_TOPO_mean->T,TC_mean_TOPO)

Q_mean_TOPO = f_TOPO_mean->Q
RH_mean_TOPO = relhum(TC_mean_TOPO_K,Q_mean_TOPO,PM_mean_TOPO*100.0)
TDC_mean_TOPO = dewtemp_trh(TC_mean_TOPO_K,RH_mean_TOPO) ; result is K
TDC_mean_TOPO = TDC_mean_TOPO - 273.15
TDC_mean_TOPO@units = "Celsius"
copy_VarCoords(f_TOPO_mean->T,TDC_mean_TOPO)

Z_mean_TOPO = f_TOPO_mean->Z3

;---------

PS_mean_CTR = f_CTR_mean->PS
P0 = 100000.0
PM_mean_CTR = pres_hybrid_ccm(PS_mean_CTR,P0,hyam,hybm)
copy_VarCoords(f_CTR_mean->T,PM_mean_CTR)
PM_mean_CTR = PM_mean_CTR / 100.0
PM_mean_CTR@units = "hPa"

TC_mean_CTR_K = f_CTR_mean->T
TC_mean_CTR = TC_mean_CTR_K - 273.15
TC_mean_CTR@units = "Celsius"
copy_VarCoords(f_CTR_mean->T,TC_mean_CTR)

Q_mean_CTR = f_CTR_mean->Q
RH_mean_CTR = relhum(TC_mean_CTR_K,Q_mean_CTR,PM_mean_CTR*100.0)
TDC_mean_CTR = dewtemp_trh(TC_mean_CTR_K,RH_mean_CTR) ; result is K
TDC_mean_CTR = TDC_mean_CTR - 273.15
TDC_mean_CTR@units = "Celsius"
copy_VarCoords(f_CTR_mean->T,TDC_mean_CTR)

Z_mean_CTR = f_CTR_mean->Z3

;------- average over the Amazon -------
Amazon_lon_test1 = (/288.0,309.0/)
Amazon_lat_test1 = (/-10.0,4.0/)

rad    = 4.0*atan(1.0)/180.0
clat   = cos(f_CTR_mean->lat({Amazon_lat_test1(0):Amazon_lat_test1(1)})*rad)

;--------------
PM_mean_CTR_AM = wgt_areaave_Wrap( PM_mean_CTR(:,:,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}), clat, 1.0, 1)
Z_mean_CTR_AM = wgt_areaave_Wrap( Z_mean_CTR(:,:,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}), clat, 1.0, 1)
TC_mean_CTR_AM = wgt_areaave_Wrap( TC_mean_CTR(:,:,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}), clat, 1.0, 1)
TDC_mean_CTR_AM = wgt_areaave_Wrap( TDC_mean_CTR(:,:,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}), clat, 1.0, 1)

PM_mean_TOPO_AM = wgt_areaave_Wrap( PM_mean_TOPO(:,:,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}), clat, 1.0, 1)
Z_mean_TOPO_AM = wgt_areaave_Wrap( Z_mean_TOPO(:,:,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}), clat, 1.0, 1)
TC_mean_TOPO_AM = wgt_areaave_Wrap( TC_mean_TOPO(:,:,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}), clat, 1.0, 1)
TDC_mean_TOPO_AM = wgt_areaave_Wrap( TDC_mean_TOPO(:,:,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}), clat, 1.0, 1)
;------

total_hr = 3
do i_hr = 0,total_hr-1

printVarSummary(PM_mean_CTR_AM)

; --- Read Data; no winds; set to _FillValue------------;
  p_CTR    = PM_mean_CTR_AM(i_hr,:)
  z_CTR    = Z_mean_CTR_AM(i_hr,:)
  tc_CTR   = TC_mean_CTR_AM(i_hr,:)
  tdc_CTR  = TDC_mean_CTR_AM(i_hr,:)
                                ; create BOGUS winds
  wspd = new ( 30, "float", -999.)  ; wspd@_FillValue = -999.
  wdir = new ( 30, "float", -999.)  ; wdir@_FillValue = -999.

  p_TOPO    = PM_mean_TOPO_AM(i_hr,:)
  z_TOPO    = Z_mean_TOPO_AM(i_hr,:)
  tc_TOPO   = TC_mean_TOPO_AM(i_hr,:)
  tdc_TOPO  = TDC_mean_TOPO_AM(i_hr,:)
;*************************
; create plot
;*************************

  wks  = gsn_open_wks ("x11", "./Figures/3_skewt_Amazon_avg_CTR_ihr_"+tostring(index*3+i_hr+1) ) 

; --- Create background skew-T; plot sounding ---------------------

  skewtOpts                 = True
  skewtOpts@DrawColAreaFill = True    ; default is False
  skewtOpts@DrawFahrenheit  = False
  skewtOpts@DrawWind        = False   ; not possible with panel

  skewtOpts@tiMainString    = "CTR, Amazon avg, ihr="+tostring(index*3+i_hr+1) 

  dataOpts   = False        ; no options

;  dataOpts@PrintZ = False
  skewt_bkgd1 = skewT_BackGround(wks, skewtOpts)
  draw (skewt_bkgd1)
  skewt_data = skewT_PlotData(wks, skewt_bkgd1, p_CTR,tc_CTR,tdc_CTR,z_CTR ,wspd,wdir, dataOpts)
  frame(wks)

end do ; do i_hr

end do ; do index


end
