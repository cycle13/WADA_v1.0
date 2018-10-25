;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)
;Note: modified 20180913 for Hovmueller

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/Old/"
CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/Old/"

f_TOPO_str = systemfunc("ls "+TOPO_dir+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+CTR_dir+"????-??-??.CTR.nc")

var_str = (/"U","PRECT"/)

members = 180

var_TOPO = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
PS_TOPO = new((/members,12,96,144/),double)
PRECT_TOPO = new((/members,12,96,144/),double)

var_CTR = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
PS_CTR = new((/members,12,96,144/),double)
PRECT_CTR = new((/members,12,96,144/),double)

var_TOPO!0 = "members"
var_TOPO&members = ispan(1,180,1)
PS_TOPO!0 = "members"
PS_TOPO&members = ispan(1,180,1)
PRECT_TOPO!0 = "members"
PRECT_TOPO&members = ispan(1,180,1)

var_CTR!0 = "members"
var_CTR&members = ispan(1,180,1)
PS_CTR!0 = "members"
PS_CTR&members = ispan(1,180,1)
PRECT_CTR!0 = "members"
PRECT_CTR&members = ispan(1,180,1)

do i_file = 0,members -1

f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

var_TOPO(i_file,:,:,:,:) = f_TOPO->$var_str(0)$
PS_TOPO(i_file,:,:,:) = f_TOPO->PS
PRECT_TOPO(i_file,:,:,:) = f_TOPO->PRECT

var_CTR(i_file,:,:,:,:) = f_CTR->$var_str(0)$
PS_CTR(i_file,:,:,:) = f_CTR->PS
PRECT_CTR(i_file,:,:,:) = f_CTR->PRECT

end do ; do i_file 

printVarSummary(var_TOPO)
printVarSummary(PS_TOPO)
printVarSummary(PRECT_TOPO)

printVarSummary(var_CTR)
printVarSummary(PS_CTR)
printVarSummary(PRECT_CTR)

;========== hybrid coordinate to pressure coordinate ====
pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
P0mb = 1000.0

hyam = f_TOPO->hyam
hybm = f_TOPO->hybm

var_TOPO_pnew = vinth2p(var_TOPO,hyam,hybm,pnew,PS_TOPO,1,P0mb,1,False)

var_CTR_pnew = vinth2p(var_CTR,hyam,hybm,pnew,PS_CTR,1,P0mb,1,False)

;=======================

pr_levels = 200.0
lev_temp = pr_levels

var_TOPO_pnew_temp = var_TOPO_pnew(:,:,{lev_temp},:,:)
var_CTR_pnew_temp = var_CTR_pnew(:,:,{lev_temp},:,:)

printVarSummary(var_TOPO_pnew_temp)   ; should be 4 dim (members x time x lat x lon)

;----------- please note that you have to use version newer than ncl6.4.0 to use kolsm2_n without bug ----
prob_var = kolsm2_n(var_TOPO_pnew_temp,var_CTR_pnew_temp,0)   ; calculate statistic along the members dimension
printVarSummary(prob_var)

prob_pr = kolsm2_n(PRECT_TOPO,PRECT_CTR,0)   ; calculate statistic along the members dimension
printVarSummary(prob_pr)

var_mean_TOPO_pnew = dim_avg_n_Wrap(var_TOPO_pnew_temp,0) ; should be (time x lat x lon)
var_mean_CTR_pnew = dim_avg_n_Wrap(var_CTR_pnew_temp,0)  

pr_mean_TOPO = dim_avg_n_Wrap(PRECT_TOPO,0) ; should be (time x lat x lon)
pr_mean_CTR = dim_avg_n_Wrap(PRECT_CTR,0)  

siglvl = 0.1

; Only retain signals of difference between TOPO and CTR with significance.
diff_TOPO_CTR_var = var_mean_TOPO_pnew ; metadata
diff_TOPO_CTR_var = var_mean_TOPO_pnew - var_mean_CTR_pnew

diff_TOPO_CTR_var_sig = var_mean_TOPO_pnew ; metadata
diff_TOPO_CTR_var_sig = where(prob_var .lt. siglvl,var_mean_TOPO_pnew - var_mean_CTR_pnew,diff_TOPO_CTR_var_sig@_FillValue)

diff_TOPO_CTR_pr = pr_mean_TOPO ; metadata
diff_TOPO_CTR_pr = pr_mean_TOPO - pr_mean_CTR

diff_TOPO_CTR_pr_sig = pr_mean_TOPO ; metadata
diff_TOPO_CTR_pr_sig = where(prob_pr .lt. siglvl,pr_mean_TOPO - pr_mean_CTR, diff_TOPO_CTR_pr_sig@_FillValue)

delete(var_TOPO)
delete(var_CTR)
delete(PRECT_TOPO)
delete(PRECT_CTR)

delete(var_TOPO_pnew)
delete(var_CTR_pnew)
delete(var_TOPO_pnew_temp)
delete(var_CTR_pnew_temp)

delete(var_mean_TOPO_pnew)
delete(var_mean_CTR_pnew)
delete(pr_mean_TOPO)
delete(pr_mean_CTR)

diff_TOPO_CTR_var&time = ispan(1,12,1)
diff_TOPO_CTR_var_sig&time = ispan(1,12,1)

diff_TOPO_CTR_pr&time = ispan(1,12,1)
diff_TOPO_CTR_pr_sig&time = ispan(1,12,1)

diff_TOPO_CTR_pr = diff_TOPO_CTR_pr * 8.64e7
diff_TOPO_CTR_pr_sig = diff_TOPO_CTR_pr_sig * 8.64e7
diff_TOPO_CTR_pr@units = "mm/day"
diff_TOPO_CTR_pr_sig@units = "mm/day"

;
printVarSummary(diff_TOPO_CTR_var)
printVarSummary(diff_TOPO_CTR_var_sig)
printVarSummary(diff_TOPO_CTR_pr)
printVarSummary(diff_TOPO_CTR_pr_sig)

;=============================================================================
;=============== average over lat (-5,5) in preparation for Hovmueler=========
;total_days = 11
total_days = 6

lat_c1 = -5.0
lat_c2 = 5.0
lon_c1 = 260.0 
lon_c2 = 320.0

var_diff_TOPO_CTR_hov = dim_avg_n_Wrap(diff_TOPO_CTR_var(0:total_days,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
var_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(diff_TOPO_CTR_var_sig(0:total_days,{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

PRECT_diff_TOPO_CTR_hov = dim_avg_n_Wrap(diff_TOPO_CTR_pr(0:total_days,{lat_c1:lat_c2},{lon_c1:lon_c2}),1)   ; avg over lat
PRECT_diff_TOPO_CTR_hov_sig = dim_avg_n_Wrap(diff_TOPO_CTR_pr_sig(0:total_days,{lat_c1:lat_c2},{lon_c1:lon_c2}),1) ; avg over lat

printVarSummary(var_diff_TOPO_CTR_hov)
printVarSummary(var_diff_TOPO_CTR_hov_sig)

printVarSummary(PRECT_diff_TOPO_CTR_hov)
printVarSummary(PRECT_diff_TOPO_CTR_hov_sig)

;================ plot ===========

wks = gsn_open_wks("png","K-S_test_Hov_Regional_"+var_str(0)+"_TOPO_vs_CTR_"+sprintf("%4.1f",pr_levels)+"hPa")
wks_sig = gsn_open_wks("png","Sig_K-S_test_Hov_Regional_"+var_str(0)+"_TOPO_vs_CTR_"+sprintf("%4.1f",pr_levels)+"hPa")

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = True
res@cnLineLabelsOn = False
res@cnFillOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -2.0
res@cnMaxLevelValF = 13.0
res@cnLevelSpacingF = 0.25
res@gsnContourNegLineDashPattern = 1
res@gsnContourZeroLineThicknessF = 2.

plot_var = gsn_csm_hov(wks,var_diff_TOPO_CTR_hov,res)

res@gsnCenterString = "siglvl=0.1"
plot_var_sig = gsn_csm_hov(wks_sig,var_diff_TOPO_CTR_hov_sig,res)

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
res@gsnRightString = "U(m/sec),"+sprintf("%4.1f",pr_levels) + "hPa"
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
