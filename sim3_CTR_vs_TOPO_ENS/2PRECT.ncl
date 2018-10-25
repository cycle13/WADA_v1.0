;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF
;Note: modified on 20181001 

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin

str_time = (/"0-5","6-11","12-17","18-23","24-29","30-35","36-41","42-47"/)

do index = 0,7

TOPO_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
TOPO_mean_str = "ENS.mean.TOPOTEST.time"+str_time(index)+".nc"
TOPO_std_str = "ENS.std.TOPOTEST.time"+str_time(index)+".nc"

CTR_dir = "/scratch/hongcheq/sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_mean_str = "ENS.mean.CTR.time"+str_time(index)+".nc"
CTR_std_str = "ENS.std.CTR.time"+str_time(index)+".nc"

var = (/"PRECT"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)
var_std_TOPO_temp = f_TOPO_std->$var$
;printVarSummary(var_std_TOPO_temp)
var_std_TOPO = var_std_TOPO_temp(0,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_TOPO)

var_mean_CTR = f_CTR_mean->$var$
;printVarSummary(var_mean_CTR)
var_std_CTR_temp = f_CTR_std->$var$
var_std_CTR = var_std_CTR_temp(0,:,:,:)   ; get rid of the first realization dimension
;printVarSummary(var_std_CTR)

siglvl = 0.1
indep_sample = 180

;========= 180 samples within each ensemble, branched every 10 days, independend number of samples ~ 180
prob = ttest(var_mean_TOPO,var_std_TOPO^2,indep_sample,var_mean_CTR,var_std_CTR^2,indep_sample,True,False)
;printVarSummary(prob)

; Only retain signals of difference between TOPO and CTR with significance.
;
;===Note: In your previous analysis on daily output, TOPO and CTR time dimention matches well because in the 1_a_preprocessing, the processing of CTR files were using ncrcat connnect all together first, then use ncrcat again to tease out the slice of the same time  dimension as in TOPOTEST.
;=====   In this new 1 hr output, you used ncrcat to combine 4 day of files for CTR without combining all ~ 3month CTR data together, without using ncrcat (together with print(Calendar(X&time))), therefore, the CTR lag TOPO time dimension by 1 hr. You checked time_bnds to conclude this conclusion==== 
diff_TOPO_CTR = var_mean_TOPO ; metadata
diff_TOPO_CTR = var_mean_TOPO - var_mean_CTR

diff_TOPO_CTR_sig = var_mean_TOPO ; metadata
diff_TOPO_CTR_sig = where(prob .lt. siglvl,var_mean_TOPO - var_mean_CTR,diff_TOPO_CTR@_FillValue)

diff_TOPO_CTR = diff_TOPO_CTR * 8.64e7 ; m/sec to mm/day
diff_TOPO_CTR_sig = diff_TOPO_CTR_sig * 8.64e7 ; m/sec to mm/day
diff_TOPO_CTR@units = "mm/day"
diff_TOPO_CTR_sig@units = "mm/day"

printVarSummary(diff_TOPO_CTR)
printVarSummary(diff_TOPO_CTR_sig)

var_mean_CTR = var_mean_CTR * 8.64e7
var_mean_CTR@units = "mm/day"

;================ plot ===========
;total 96 hr in the TOPOTEST after branching
;total_hr = 96
total_hr = 6

do i_hr = 0,total_hr-1
;do i_hr = 0,1
 
wks = gsn_open_wks("png","2_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(index*6+i_hr+1))
wks_sig = gsn_open_wks("png","2_Sig_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(index*6+i_hr+1))
wks_CTR = gsn_open_wks("png","2_CTR_Regional_"+var+"_TOPO_vs_CTR_ihr_"+tostring(index*6+i_hr+1))

gsn_reverse_colormap(wks)    ; blue color indicate positive precip changes
gsn_reverse_colormap(wks_sig)    ; blue color indicate positive precip changes
gsn_reverse_colormap(wks_CTR)    ; blue color indicate positive precip changes

res = True
;res@gsnDraw = False
;res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = var+", TOPO - CTR, ENS(180), ihr="+tostring(index*6+i_hr+1)
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -4.0
res@cnMaxLevelValF = 4.0
res@cnLevelSpacingF = 0.5

res@mpMaxLatF = 60.0
res@mpMinLatF = -60.0
res@mpMaxLonF = 350.0
res@mpMinLonF = 230.0
;
res@gsnLeftString = var

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR(i_hr,:,:),res)
plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_sig(i_hr,:,:),res)


res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 20.0
res@cnLevelSpacingF = 1.0

res@cnFillPalette = "MPL_Blues"

res@tiMainString = var+", CTR, ENS(180), ihr="+tostring(index*6+i_hr+1)

plot_CTR = gsn_csm_contour_map_ce(wks_CTR,var_mean_CTR(i_hr,:,:),res)

delete(res@cnFillPalette)

end do


end do ; do index

end
