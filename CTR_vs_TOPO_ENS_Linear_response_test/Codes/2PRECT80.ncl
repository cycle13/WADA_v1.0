;Function: PRECT difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified on 20180712 with 36 members.
;Note: modified on 201880718 with 90 members. 1996-2005 DJF
;Note: modified on 20180725 with 180 members. 1989-2008 DJF

load "/export/home/hongcheq/Programming/NCL/funs_and_procs/funs_and_procs.ncl"

begin
PCT = "80"
TOPO_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing_PRECT/TOPOTEST"+PCT+"/"
TOPO_mean_str = "ENS.mean.TOPOTEST"+PCT+".nc"
TOPO_std_str = "ENS.std.TOPOTEST"+PCT+".nc"

;CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
CTR_dir = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/Old/"
CTR_mean_str = "ENS.mean.CTR.nc"
CTR_std_str = "ENS.std.CTR.nc"

var = (/"PRECT"/)

f_TOPO_mean = addfile(TOPO_dir+TOPO_mean_str,"r")
f_TOPO_std = addfile(TOPO_dir+TOPO_std_str,"r")

f_CTR_mean = addfile(CTR_dir+CTR_mean_str,"r")
f_CTR_std = addfile(CTR_dir+CTR_std_str,"r")

var_mean_TOPO = f_TOPO_mean->$var$
;printVarSummary(var_mean_TOPO)
var_std_TOPO_temp = f_TOPO_std->$var$
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

;================ plot ===========
;total 12 days in the TOPOTEST after branching
;total_days = 12
total_days = 10

;---------------To add polygons ---------
Amazon_lon1 = 290.0
Amazon_lon2 = 308.0
Amazon_lat1 = -10.0
Amazon_lat2 = 4.0
 xpts_Amazon = (/Amazon_lon1,Amazon_lon2,Amazon_lon2,Amazon_lon1,Amazon_lon1/)
 ypts_Amazon = (/Amazon_lat1,Amazon_lat1,Amazon_lat2,Amazon_lat2,Amazon_lat1/)

dum_Amazon = new(4*total_days,graphic)
dum_Amazon_sig = new(4*total_days,graphic)

;----------------------

do i_day = 0,total_days-1
;do i_day = 0,1
 
wks = gsn_open_wks("png","Regional_"+var+"_TOPO"+PCT+"_vs_CTR_iday_"+tostring(i_day+1))
;wks = gsn_open_wks("png","Global_"+var+"_TOPO"+PCT+"_vs_CTR_iday_"+tostring(i_day+1))
wks_sig = gsn_open_wks("png","Sig_Regional_"+var+"_TOPO"+PCT+"_vs_CTR_iday_"+tostring(i_day+1))
;wks_sig = gsn_open_wks("png","Sig_Global_"+var+"_TOPO"+PCT+"_vs_CTR_iday_"+tostring(i_day+1))

gsn_reverse_colormap(wks)    ; blue color indicate positive precip changes
gsn_reverse_colormap(wks_sig)    ; blue color indicate positive precip changes

res = True
res@gsnDraw = False
res@gsnFrame = False
res@cnLinesOn = False
res@cnLineLabelsOn = False
res@cnFillOn = True

res@tiMainString = var+", TOPO"+PCT+" - CTR, ENS(180), iday="+tostring(i_day+1)
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

plot = gsn_csm_contour_map_ce(wks,diff_TOPO_CTR(i_day,:,:),res)
plot_sig = gsn_csm_contour_map_ce(wks_sig,diff_TOPO_CTR_sig(i_day,:,:),res)

;----------- Add polygons ---------

; add the box
respoly                  = True                      ; polyline mods desired
respoly@gsLineColor      = "red"                     ; color of lines
respoly@gsLineThicknessF = 2.0                       ; thickness of lines

do i = 0 , 3
  dum_Amazon(i+i_day*4)=gsn_add_polyline(wks,plot,xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),respoly)
  dum_Amazon_sig(i+i_day*4)=gsn_add_polyline(wks_sig,plot_sig,xpts_Amazon(i:i+1),ypts_Amazon(i:i+1),respoly)
end do

draw(plot)
draw(plot_sig)
frame(wks)
frame(wks_sig)

end do

;======== Note: that sampling frequency is every 10 days per member through DJF, DJF mean all first 10 days for the ENS ===
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 12.0
res@cnLevelSpacingF = 0.4

res@tiMainString = var+", CTR ENS(180), DJF clim"
res@gsnRightString = "mm/day"

wks_clim = gsn_open_wks("png","Clim_Regional_"+var+"_CTR")
;wks_clim = gsn_open_wks("png","Clim_Global_"+var+"_CTR")

gsn_reverse_colormap(wks_clim)    ; blue color indicate positive precip changes

plot_clim = gsn_csm_contour_map_ce(wks_clim,8.64e7*dim_avg_n_Wrap(var_mean_CTR(0:9,:,:),0),res)


end
