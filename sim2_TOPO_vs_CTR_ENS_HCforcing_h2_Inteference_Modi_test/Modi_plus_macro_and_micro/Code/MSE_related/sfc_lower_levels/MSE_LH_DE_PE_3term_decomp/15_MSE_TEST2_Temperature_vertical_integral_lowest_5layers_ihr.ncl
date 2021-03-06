
load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

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

str_time = new(32,string)
;time_label = new(32,string)

do i_str_time = 0,31
str_time(i_str_time) = "time"+tostring(num1(i_str_time))+"-"+tostring(num2(i_str_time))
;time_label(i_str_time) = "time"+str_time(i_str_time)
end do

;do index = 0,31
do index = 0,0

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST."+str_time(index)+".nc"
PS_mean_TOPO_str = "ENS.std.mean.TOPOTEST.MSE.3term."+str_time(index)+".nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro/CTR/"
CTR_mean_str = "ENS.mean.CTR."+str_time(index)+".nc"
PS_mean_CTR_str = "ENS.std.mean.CTR.MSE.3term."+str_time(index)+".nc"

var_str = (/"T"/)

do i_var = 0, dimsizes(var_str) -1

var = var_str(i_var)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_PS_mean_TOPO = addfile(TOPO_dir+PS_mean_TOPO_str,"r")
f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_PS_mean_CTR = addfile(CTR_dir+PS_mean_CTR_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)

printVarSummary(var_mean_TOPO)
printVarSummary(var_mean_CTR)

;========== hybrid coordinate to pressure coordinate ====
;pnew = f_CTR_mean->lev
;pnew@units = "hPa"
;pnew = (/50.0,100.0,200.0,300.0,400.0,500.0,600.0,700.0,800.0,850.0,900.0,950.0,1000.0/)
;P0mb = 1000.0
;printVarSummary(f_TOPO_mean->hyam)
;printVarSummary(f_TOPO_mean->PS)

;hyam = f_TOPO_mean->hyam
;hybm = f_TOPO_mean->hybm
;printVarSummary(var_mean_TOPO)

;var_mean_TOPO_pnew = vinth2p(var_mean_TOPO,hyam,hybm,pnew,f_PS_mean_TOPO->PS_mean,1,P0mb,1,False)
;var_mean_CTR_pnew = vinth2p(var_mean_CTR,hyam,hybm,pnew,f_PS_mean_CTR->PS_mean,1,P0mb,1,False)

;var_mean_TOPO_pnew@_FillValue = 9.969209968386869e+36
;var_mean_CTR_pnew@_FillValue = 9.969209968386869e+36
;var_mean_TOPO_pnew@_FillValue = 9.96921e+36
;var_mean_CTR_pnew@_FillValue = 9.96921e+36
;printVarSummary(var_mean_CTR_pnew)
;printVarSummary(var_mean_TOPO_pnew)

;------------- 
hyai = f_TOPO_mean->hyai
hybi = f_TOPO_mean->hybi

PS_TOPO = f_PS_mean_TOPO->PS_mean
P0 = 100000.0 ; Pa
dph_TOPO = dpres_hybrid_ccm(PS_TOPO,P0,hyai,hybi)
printVarSummary(PS_TOPO)
printVarSummary(dph_TOPO)
;print(f_TOPO_mean->lev)
;print(dph_TOPO(2,:,50,80))

PS_CTR = f_PS_mean_CTR->PS_mean
dph_CTR = dpres_hybrid_ccm(PS_CTR,P0,hyai,hybi)

;----- lowest five layers ------
lowest_lev = 5

var_inte_TOPO = dim_sum_n_Wrap(var_mean_TOPO(:,30-lowest_lev:29,:,:) * dph_TOPO(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_TOPO(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_TOPO,var_inte_TOPO)
printVarSummary(var_inte_TOPO)

var_inte_CTR = dim_sum_n_Wrap(var_mean_CTR(:,30-lowest_lev:29,:,:) * dph_CTR(:,30-lowest_lev:29,:,:), 1)/dim_sum_n(dph_CTR(:,30-lowest_lev:29,:,:),1)
copy_VarCoords(PS_CTR,var_inte_CTR)
printVarSummary(var_inte_CTR)

var_inte_CTR_TOPO = var_inte_CTR ; metadata
var_inte_CTR_TOPO = var_inte_CTR - var_inte_TOPO
printVarSummary(var_inte_CTR_TOPO)

;=============== plot ===========
;total 12 days in the TOPOTEST after branching

;total_days = 12
total_hrs = 3

do i_hr = 0,total_hrs-1
;do i_day = 0,3
 
wks = gsn_open_wks("x11","../Figures/15_Regional_T_TEST22_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
;wks = gsn_open_wks("x11","Global_PTTEND_50-1000hPa_TOPO_vs_CTR_ihr_"+tostring(index*3+i_hr+1))
plot = new(3,graphic)

res = True
res@gsnDraw = False
res@gsnFrame = False

res@cnFillOn = True
res@cnLinesOn = False

;res@gsnAddCyclic = True

res@tiMainString = "ENS(9), ihr="+tostring(index*3+i_hr+1)
res@tiMainFontHeightF = 0.015
res@gsnLeftString = "lowest 5 layers, wgt avg T, CTR"
res@gsnRightString = "Kelvin"

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0

res@cnLevelSelectionMode = "ManualLevels"

res@cnMinLevelValF = 200.0
res@cnMaxLevelValF = 310.0
res@cnLevelSpacingF = 5.

res@gsnLeftString = "TEST,T, wgt avg T, CTR"
plot(0) = gsn_csm_contour_map(wks,var_inte_CTR(i_hr,:,:),res)
res@gsnLeftString = "TEST,T, wgt avg T, TOPO"
plot(1) = gsn_csm_contour_map(wks,var_inte_TOPO(i_hr,:,:),res)

res@cnMinLevelValF = -2.0
res@cnMaxLevelValF = 2.0
res@cnLevelSpacingF = 0.1
;
res@gsnLeftString = "TEST,T, wgt avg T, CTR-TOPO"
plot(2) = gsn_csm_contour_map(wks,var_inte_CTR_TOPO(i_hr,:,:),res)

delete(res@cnMinLevelValF)
delete(res@cnMaxLevelValF)
delete(res@cnLevelSpacingF)

;--------------
resP = True
resP@txString = "Lowest 5 levels, wgt_avg T in CTR, TOPO and CTR-TOPO, ihr="+tostring(index*3+i_hr+1)
gsn_panel(wks, plot, (/1,3/), resP)


end do ; do i_hr

end do; do i_var
end do; do index
end
