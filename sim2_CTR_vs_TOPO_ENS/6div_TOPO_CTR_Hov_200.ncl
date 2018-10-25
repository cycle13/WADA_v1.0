;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)
;Note: modified 20180913 for Hovmueller
;Note: modified 20181002 for sim2_WADA...

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

div_diff_TOPO_CTR = new((/48,13,96,144/),double)
div_diff_TOPO_CTR_sig = new((/48,13,96,144/),double)

PRECT_diff_TOPO_CTR = new((/48,96,144/),double)
PRECT_diff_TOPO_CTR_sig = new((/48,96,144/),double)

str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,7
;do index = 0,0

TOPO_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"

TOPO_div_str = "ENS.std.mean.TOPOTEST.div.time"+str_time(index)+".nc"

CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"

CTR_div_str = "ENS.std.mean.CTR.div.time"+str_time(index)+".nc"

var_str = (/"div","PRECT"/)

do i_var = 0, 1

var = var_str(i_var)

f_div_TOPO = addfile(TOPO_dir+TOPO_div_str,"r")
f_div_CTR = addfile(CTR_dir+CTR_div_str,"r")

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

if (i_var .ne. 1) then

var_mean_TOPO = f_div_TOPO->div_TOPO_mean
var_std_TOPO = f_div_TOPO->div_TOPO_std

var_mean_CTR = f_div_CTR->div_CTR_mean
var_std_CTR = f_div_CTR->div_CTR_std

else   ;  i_var = 1, for PRECT
;dimension different from previous ones
delete(var_mean_TOPO)
delete(var_std_TOPO)
delete(var_mean_CTR)
delete(var_std_CTR)

var_mean_TOPO = f_TOPO_mean->$var$
var_std_TOPO_temp = f_TOPO_std->$var$
var_std_TOPO = var_std_TOPO_temp(0,:,:,:)   ; get rid of the first realization dimension

var_mean_CTR = f_CTR_mean->$var$
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,:,:,:)   ; get rid of the first realization dimension
end if
 
;--------------

if (i_var .ne. 1) then   ; for PRECT, it doesn't have a lev dimension
;========== hybrid coordinate to pressure coordinate ====
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

hyam = f_TOPO_mean->hyam
hybm = f_TOPO_mean->hybm

var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
;printVarSummary(var_mean_TOPO_pnew)
var_std_TOPO_pnew = vinth2p(var_std_TOPO,hyam,hybm,pnew,f_TOPO_mean->PS,1,P0mb,1,False)
;printVarSummary(var_std_TOPO_pnew)

var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;printVarSummary(var_mean_CTR_pnew)
var_std_CTR_pnew = vinth2p(var_std_CTR,hyam,hybm,pnew,f_CTR_mean->PS,1,P0mb,1,False)
;printVarSummary(var_std_CTR_pnew)

else   ; for PRECT
;PRECT is in different dimension from others, delete previous used vars
delete(var_mean_TOPO_pnew)
delete(var_std_TOPO_pnew)
delete(var_mean_CTR_pnew)
delete(var_std_CTR_pnew)

var_mean_TOPO_pnew = var_mean_TOPO
var_std_TOPO_pnew = var_std_TOPO
var_mean_CTR_pnew = var_mean_CTR
var_std_CTR_pnew = var_std_CTR

end if  ; if i_var .ne. 1

siglvl = 0.1
indep_sample = 180
;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO_pnew,var_std_TOPO_pnew^2,indep_sample,var_mean_CTR_pnew,var_std_CTR_pnew^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR = var_mean_TOPO_pnew ; metadata
diff_TOPO_CTR = var_mean_TOPO_pnew - var_mean_CTR_pnew

diff_TOPO_CTR_sig = var_mean_TOPO_pnew ; metadata
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO_pnew - var_mean_CTR_pnew,diff_TOPO_CTR_sig@_FillValue)

printVarSummary(diff_TOPO_CTR)
printVarSummary(diff_TOPO_CTR_sig)

if (i_var .eq. 0) then
   div_diff_TOPO_CTR(index*6:index*6+5,:,:,:) = diff_TOPO_CTR
   div_diff_TOPO_CTR_sig(index*6:index*6+5,:,:,:) = diff_TOPO_CTR_sig
else
   PRECT_diff_TOPO_CTR(index*6:index*6+5,:,:) = diff_TOPO_CTR
   PRECT_diff_TOPO_CTR_sig(index*6:index*6+5,:,:) = diff_TOPO_CTR_sig
end if

delete(prob)
delete(diff_TOPO_CTR)
delete(diff_TOPO_CTR_sig)

end do ; do ivar

delete(var_mean_TOPO)
delete(var_std_TOPO)

delete(var_mean_CTR)
delete(var_std_CTR)

delete(var_mean_TOPO_pnew)
delete(var_std_TOPO_pnew)

delete(var_mean_CTR_pnew) 
delete(var_std_CTR_pnew)


end do ; do index

;printVarSummary(div_diff_TOPO_CTR)
;printVarSummary(div_diff_TOPO_CTR_sig)

;printVarSummary(PRECT_diff_TOPO_CTR)
;printVarSummary(PRECT_diff_TOPO_CTR_sig)
;
;========================

div_diff_TOPO_CTR&time = ispan(1,48,1)
div_diff_TOPO_CTR_sig&time = ispan(1,48,1)
PRECT_diff_TOPO_CTR&time = ispan(1,48,1)
PRECT_diff_TOPO_CTR_sig&time = ispan(1,48,1)

PRECT_diff_TOPO_CTR = PRECT_diff_TOPO_CTR * 8.64e7
PRECT_diff_TOPO_CTR_sig = PRECT_diff_TOPO_CTR_sig * 8.64e7
PRECT_diff_TOPO_CTR@units = "mm/day"
PRECT_diff_TOPO_CTR_sig@units = "mm/day"
;
printVarSummary(div_diff_TOPO_CTR)
printVarSummary(div_diff_TOPO_CTR_sig)
printVarSummary(PRECT_diff_TOPO_CTR)
printVarSummary(PRECT_diff_TOPO_CTR_sig)

;=============== average over lat (-5,5) in preparation for Hovmueler=========
;total_days = 11
total_hrs = 48

pr_levels = 200.0

lat_c1 = -5.0
lat_c2 = 5.0

lon_c1 = 260.0 
lon_c2 = 320.0

div_diff_TOPO_CTR_hov = dim_avg_n_Wrap(div_diff_TOPO_CTR(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
div_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(div_diff_TOPO_CTR_sig(0:total_hrs-1,{pr_levels},{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

PRECT_diff_TOPO_CTR_hov = dim_avg_n_Wrap(PRECT_diff_TOPO_CTR(0:total_hrs-1,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
PRECT_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(PRECT_diff_TOPO_CTR_sig(0:total_hrs-1,{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

printVarSummary(div_diff_TOPO_CTR_hov)
printVarSummary(div_diff_TOPO_CTR_hov_sig)

printVarSummary(PRECT_diff_TOPO_CTR_hov)
printVarSummary(PRECT_diff_TOPO_CTR_hov_sig)

;================ plot ===========

wks = gsn_open_wks("png","6_Hov_Regional_div_TOPO_vs_CTR_"+sprintf("%4.1f",pr_levels)+"hPa")
wks_sig = gsn_open_wks("png","6_Sig_Hov_Regional_div_TOPO_vs_CTR_"+sprintf("%4.1f",pr_levels)+"hPa")

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

;----------
X_diff_TOPO_CTR_hov = div_diff_TOPO_CTR_hov
X_diff_TOPO_CTR_hov_sig = div_diff_TOPO_CTR_hov_sig

res@cnLevelSelectionMode = "ManualLevels"

res@cnMinLevelValF = -8.0e-6
res@cnMaxLevelValF = 5.0e-6
res@cnLevelSpacingF = 0.5e-6

res@gsnContourNegLineDashPattern = 1
res@gsnContourZeroLineThicknessF = 2.
res@gsnRightString = "div(1/sec),"+sprintf("%4.1f",pr_levels) + "hPa"
;----------

plot_var = gsn_csm_hov(wks,X_diff_TOPO_CTR_hov,res)

res@gsnCenterString = "siglvl=0.1"
plot_var_sig = gsn_csm_hov(wks_sig,X_diff_TOPO_CTR_hov_sig,res)

;---------
delete(res@gsnCenterString)

res@cnFillOn = True
res@cnLineLabelsOn = False
res@cnLinesOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -6.0
res@cnMaxLevelValF = 6.0
res@cnLevelSpacingF = 0.25

res@tiMainString = "TOPO - CTR, ENS(180)"
res@gsnLeftString = "PRECT(mm/day)"
gsn_reverse_colormap(wks)

plot_P = gsn_csm_hov(wks,PRECT_diff_TOPO_CTR_hov,res)

gsn_reverse_colormap(wks_sig)
plot_P_sig = gsn_csm_hov(wks_sig,PRECT_diff_TOPO_CTR_hov_sig,res)

overlay(plot_P,plot_var)
draw(plot_P)
frame(wks)

overlay(plot_P_sig,plot_var_sig)
draw(plot_P_sig)
frame(wks_sig)



end
