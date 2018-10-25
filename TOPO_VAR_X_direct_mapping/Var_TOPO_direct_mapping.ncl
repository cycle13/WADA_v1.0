;Function: Have a test run to output HCftem(:ncol,:pver) = ptend%s(:ncol,:pver)/cpair as HCDEEP. 
;          The ultimate purpose is to see if this variable can be reconstruct from other variables already in the output field in your previous 180 member runs. If yes, you can save some time not redoing the ENS(180)
;Date: 20180917


begin

dir = "/DFS-L/DATA/pritchard/hongcheq/TOPO_debug/"
;fil = "F_AMIP_CAM5_WADA_TOPO_1996_test1_1996-12-01_TEST2.cam.h1.1996-12-02-00000-12-13-00000.ncrcat.nc"
fil = "F_AMIP_CAM5_WADA_TOPO_1996_test1_1996-12-01_TEST2.cam.h1.1996-12-02-21600-12-13-21600.ncrcat.nc"

f = addfile(dir+fil,"r")

PCT = 1.0   ; The test run is CTR

HCDEEP = f->HCDEEP
HCDEEP = HCDEEP * PCT  
printVarSummary(HCDEEP)

ZMDT = f->ZMDT
printVarSummary(ZMDT)

EVAPTZM = f->EVAPTZM
printVarSummary(EVAPTZM)

ZMMTT = f->ZMMTT
printVarSummary(ZMMTT)

HCDEEP_diff1 = HCDEEP ;
HCDEEP_diff1 = HCDEEP - ZMDT
printVarSummary(HCDEEP_diff1) 

HCDEEP_diff2 = HCDEEP ;
HCDEEP_diff2 = HCDEEP - (EVAPTZM + ZMDT)
printVarSummary(HCDEEP_diff2) 

HCDEEP_diff3 = HCDEEP ; 
HCDEEP_diff3 = HCDEEP - (EVAPTZM + ZMDT + ZMMTT)
;=============
lev_x = 500.0

do i_day = 0,11

wks0 = gsn_open_wks("png","HCDEEP_"+i_day)
wks1 = gsn_open_wks("png","HCDEEP_diff1_"+i_day)
wks2 = gsn_open_wks("png","HCDEEP_diff2_"+i_day)
wks3 = gsn_open_wks("png","HCDEEP_diff3_"+i_day)

res = True

res@gsnDraw = True
res@gsnFrame = True
res@cnLinesOn = True
res@cnFillOn = True
res@cnLinesOn = False

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 3.0e-4
res@cnLevelSpacingF = 1.0e-5

res@tiMainString = "PTTENDsHC, lev = "+sprintf("%5.2f",lev_x)+"i_time="+i_day

plot0 = gsn_csm_contour_map(wks0,HCDEEP(i_day,{lev_x},:,:),res)

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -0.5e-5
res@cnMaxLevelValF = 0.5e-5
res@cnLevelSpacingF = 0.5e-6

res@tiMainString = "PTTENDsHC - ZMDT, lev = "+sprintf("%5.2f",lev_x)+"i_time="+i_day
plot1 = gsn_csm_contour_map(wks1,HCDEEP_diff1(i_day,{lev_x},:,:),res)

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -0.5e-5
res@cnMaxLevelValF = 0.5e-5
res@cnLevelSpacingF = 0.5e-6

res@tiMainString = "PTTENDsHC - (ZMDT+EVAPTZM), lev = "+sprintf("%5.2f",lev_x)+"i_time="+i_day
plot2 = gsn_csm_contour_map(wks2,HCDEEP_diff2(i_day,{lev_x},:,:),res)

res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = -0.5e-5
res@cnMaxLevelValF = 0.5e-5
res@cnLevelSpacingF = 0.5e-6

res@tiMainString = "PTTENDsHC - (ZMDT+EVAPTZM+ZMMTT), lev = "+sprintf("%5.2f",lev_x)+"i_time="+i_day
plot3 = gsn_csm_contour_map(wks3,HCDEEP_diff3(i_day,{lev_x},:,:),res)


end do ; do i_day

end
