;Function: plot SGH30 plot
;Date: 20190205


begin

path = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/SGH30/USGS-gtopo30_1.9x2.5_remap_c050602.nc"
f = addfile(path,"r")
SGH30 = f->SGH30

printVarSummary(SGH30)

wks = gsn_open_wks ("png","SGH30.png")

res = True
;res@gsnFrame = False
;res@gsnDraw = False

res@tiMainString = "SGH30"

res@cnFillOn = True

res@cnLevelSelectionMode =  "ManualLevels"   
res@cnMinLevelValF       = 100.
res@cnMaxLevelValF       =  200.
res@cnLevelSpacingF      =   100. 
plot = gsn_csm_contour_map(wks, SGH30,res )






end
