;Function: based on TOPOTEST (100% shutting down latent heat when SGH30 > threshold, or 0% remaining), 20% remaining, 40%, 60%, 80%, 100% remaining (CTR is 100%) ;
;          check if Amazonian precip response to the TOPO inteference is roughtly linear.
;Date: 20180830
;Date: modified 20181127

begin

;================================
undef("add_y_errorbar")
procedure add_y_errorbar(wks, plot, x[*]:numeric,y[*]:numeric, yerror[*]:numeric, res)
local dimz, xpoints, ypoints, gsres, i
begin
  gsres = res
  dimz  = dimsizes(y)

  xpoints = (/x, x/)
  ypoints = (/ y-yerror, y+yerror/)
  do i=0, dimz(0)-1
     plot@$tostring("y_errorbar"+i)$ = gsn_add_polyline(wks, plot, xpoints(:,i), ypoints(:,i), gsres )
  end do
end

;================================

;---------------Keep consistent with previous polygons ---------
;------On your DOE poster, Amazon box is used to be (51W-72W, 10S-4N)
Amazon_lon1 = 288.0
Amazon_lon2 = 309.0
Amazon_lat1 = -10.0
Amazon_lat2 = 4.0

;========= Cycle of day 1, day 2, day 3 , ..., day 12 =====================

;========= Cyle of 0% (TOPOTEST), 20%, 40%, 60%, 80%, 100%(CTR) ===========
prec_mean_PCT = new(6,double)   ; # of  Percentage
prec_std_PCT = new(6,double)

;part of TOPOTEST80 still on Cori, to be added here
dir_str = (/"/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/",\
            "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPOTEST80/",\
            "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPOTEST60/",\
            "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPOTEST40/",\
            "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPOTEST20/",\
            "/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPOTEST00/"/)

fil_str = (/"????-??-??.PRECT.CTR.nc","*.PRECT.TOPOTEST80.nc","*.PRECT.TOPOTEST60.nc","*.PRECT.TOPOTEST40.nc","*.PRECT.TOPOTEST20.nc","????-??-??.PRECT.TOPOTEST00.nc"/)
;fil_str = (/"????-??-??.PRECT.CTR.nc","*.PRECT.TOPOTEST80.nc","*.PRECT.TOPOTEST60.nc","*.PRECT.TOPOTEST40.nc","*.PRECT.TOPOTEST20.nc","????-??-??.TOPOTEST.nc"/)
;fil_str = (/"*CTR.nc","*.PRECT.TOPOTEST80.nc","*.PRECT.TOPOTEST60.nc","*.PRECT.TOPOTEST40.nc","*.PRECT.TOPOTEST20.nc","????-??-??.TOPOTEST.nc"/)

prec_CTR = new(180,double)  ; 
prec = new(180,double)

do i_PCT = 0, 5
;do i_PCT = 0, 4

;========= Step 1: Calculate each ensemble member TOPO-CTR for prec(Amazon) and save it as prec(iday,i_member) in 12x180 =====

dir = dir_str(i_PCT) 

fili = systemfunc("cd "+dir+" ; ls "+fil_str(i_PCT))

;do i_member = 0, 18
do i_member = 0, dimsizes(fili) -1

f = addfile(dir+fili(i_member),"r")
;-------average from day 3 to day 7
temp = dim_avg_n_Wrap(f->PRECT(2:6,:,:),0)

lat = f->lat
lat_Amazon = lat({Amazon_lat1:Amazon_lat2})
;print(lat_Amazon)

rad  = 4.0*atan(1.0)/180.0

clat = cos(lat_Amazon*rad)

;printVarSummary(temp(:,{Amazon_lat1:Amazon_lat2},{Amazon_lon1:Amazon_lon2}))
if (i_PCT .eq. 0)
prec_CTR(i_member) = wgt_areaave_Wrap(temp({Amazon_lat1:Amazon_lat2},{Amazon_lon1:Amazon_lon2}), clat, 1.0, 0)
end if

prec(i_member) = wgt_areaave_Wrap(temp({Amazon_lat1:Amazon_lat2},{Amazon_lon1:Amazon_lon2}), clat, 1.0, 0)

end do ; i_member

;=========== CTR - TOPO_X, it will be zero for i_PCT = 0 because both are CTR ======
;prec = prec-prec_CTR
prec = prec_CTR-prec   ; 

printVarSummary(prec)
prec = prec*8.64e7
prec@units = "mm/day"

;========= Step 2: Calculate the mean and std of prec(i_member) as prec_mean, prec_std ========
prec_mean = dim_avg_Wrap(prec)
prec_std = dim_stddev_Wrap(prec)
printVarSummary(prec_mean)
printVarSummary(prec_std)

;--------- check the histogram to see if it's roughtly normal distribution ------
;--------- to facilitate the downstream confidence interval calculation ----


wks_hist = gsn_open_wks("png","../Figures/Normal_distribution_inspection_i_day_PCT_"+tostring(i_PCT))
res_hist = True
res_hist@gsnMaximize = True
res_hist@tiMainString = "CTR-TOPO, PRECT, i_PCT="+i_PCT

res_hist@gsnHistogramBinIntervals = fspan(0.0,3.0,30)

 plot_hist = gsn_histogram(wks_hist,prec,res_hist)


;========== Step 3: save as addional variable prec_mean_PCT(i_pct), prec_std_PCT(i_pct) =========
prec_mean_PCT(i_PCT) = prec_mean
prec_std_PCT(i_PCT) = prec_std

;========= End of the cyle of 0% (TOPOTEST), 20%, 40%, 60%, 80%, 100%(CTR) ===========
end do ; do i_PCT

;prec_mean_PCT = prec_mean_PCT*8.64e7
;prec_mean_PCT@units = "mm/day"
;prec_std_PCT = prec_std_PCT*8.64e7
;prec_std_PCT@units = "mm/day"

printVarSummary(prec_mean_PCT)
printVarSummary(prec_std_PCT)

;=========== Step 4: plot the Prec(Amazon) vs % of latent heating retained for iday ==========


;x = (/1,3,4,5,6/)   
;x = (/2.0,3.0,4.0,5.0/)     ; x-axis starts with (0,0), representing CTR-CTR point, therefore x=1, representing 80% should be a placeholder
x = (/1.0,2.0,3.0,4.0,5.0/)
;x = (/1.0,2.0,3.0,4.0/)

;x_str = (/"60%","40%","20%","00%"/)
x_str = (/"80%","60%","40%","20%","00%"/)

y = prec_mean_PCT(1:5)   ; prec_mean_PCT(0) always zero since its CTR-CTR, skip the first CTR-CTR case
std = prec_std_PCT(1:5)

;-----------

n_total = 180
t_c = abs(cdft_t(0.025,n_total - 1))    ; t_{alpha/2} (n-1) value 
CI95 = std/sqrt(n_total) * t_c   ; assuming normal distribution

wks  = gsn_open_wks("x11","../Figures/TOPOTEST_95CI_Linear_TEST_iday_3-7_avg")   
  
   res  = True                   
   res@gsnDraw             = False
   res@gsnFrame            = False

   res@xyMarkLineModes     = "Markers"
   res@xyMarker            = 9
   res@xyMarkerSizeF       = 0.02                        ; default 0.01
   res@xyMarkerThicknessF  = 2.0                         ; default 1.00

   res@trYMaxF             = 0.0  
   res@trYMinF             = -2.4   
   res@trXMinF             = 0.0
   res@trXMaxF             = 5.5
  
   res@tiMainString = "Prec(Amazon) response to CondenHeat(Andes), avg of day 3-7"
   res@gsnRightString = "mm/day"
   res@gsnCenterString = "95% confidence interval"
   res@tiXAxisString = "% of LH retained"
   res@tiYAxisString = "PRECT(Amazon), CTR-TOPOX" 
   
   res@tmXBMode = "Explicit"
   res@tmXBValues      = x
   res@tmXBLabels      = x_str
   res@tmXBLabelFontHeightF = 0.015
 
   plot                    = gsn_csm_xy (wks,x,y,res)

   gsresy = True
   gsresy@gsLineColor      = "blue"                       ; add y error bars
   gsresy@gsLineThicknessF = 4.0
   add_y_errorbar(wks, plot, x, y, CI95, gsresy)

   draw(plot)
   frame(wks)

;============ output nc files to make the next step easier =======
system("rm "+"/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/WADA_CTR_TOPO_Linear_Test_data/PRECT_Amazon_mean_std_iday3-7_avg.nc")
ncdf = addfile("/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/WADA_CTR_TOPO_Linear_Test_data/PRECT_Amazon_mean_std_iday3-7_avg.nc" ,"c")

;save y as vintPTTEND_mean
;save std as a referece
;save CI95 as CI95 for plotting

name_str =  "PRECT(Amazon), CTR-TOPOX, X=80%,60%,40%,20%,00%, (X=100% means CTR)"

y@long_name = name_str+", mean"
y@units = "mm/day"

std@long_name = name_str+", std"
std@units = "mm/day"

CI95@long_name = name_str+", 95% Confidence Interval"
CI95@units = "mm/day"

ncdf->PRECT_mean = y
ncdf->PRECT_std = std
ncdf->PRECT_CI95 = CI95




end
