;Function: read TOPO and CTR files, and generate ENS.std.mean.TOPOTEST.div.nc  under this directory:
;          /lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/, 
;          and generate ENS.std.mean.CTR.div.nc under /lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/


begin

dir_TOPO_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_in = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

f_TOPO_str = systemfunc("ls "+dir_TOPO_in+"????-??-??.TOPOTEST.nc")
f_CTR_str = systemfunc("ls "+dir_CTR_in+"????-??-??.CTR.nc")
;print(f_TOPO_str)

members = 180

U_TOPO = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
V_TOPO = new((/members,12,30,96,144/),double) 
U_CTR = new((/members,12,30,96,144/),double)    ;members x 12day x 30lev x 96lat x 144 lon
V_CTR = new((/members,12,30,96,144/),double) 

do i_file = 0, members - 1
;do i_file = 0, 4 - 1
print(i_file)
f_TOPO = addfile(f_TOPO_str(i_file),"r")
f_CTR = addfile(f_CTR_str(i_file),"r")

U_TOPO(i_file,:,:,:,:) = f_TOPO->U
V_TOPO(i_file,:,:,:,:) = f_TOPO->V

U_CTR(i_file,:,:,:,:) = f_CTR->U
V_CTR(i_file,:,:,:,:) = f_CTR->V

end do  ; do i_fiel

div_TOPO = U_TOPO ; metadata
div_TOPO@long_name = "divergence calculated by uv2dv_cfd"
div_TOPO@units = "1/sec"
div_TOPO = uv2dv_cfd(U_TOPO,V_TOPO,f_TOPO->lat,f_TOPO->lon,3)
div_TOPO!0 = "realization"
div_TOPO&realization = ispan(1,180,1)
printVarSummary(div_TOPO)

div_CTR = U_CTR ; metadata
div_CTR@long_name = "divergence calculated by uv2dv_cfd"
div_CTR@units = "1/sec"
div_CTR = uv2dv_cfd(U_CTR,V_CTR,f_CTR->lat,f_CTR->lon,3)
div_CTR!0 = "realization"
div_CTR&realization = ispan(1,180,1)
printVarSummary(div_CTR)

div_TOPO_mean = dim_avg_n_Wrap(div_TOPO,0)
div_TOPO_std = dim_stddev_n_Wrap(div_TOPO,0)
div_CTR_mean = dim_avg_n_Wrap(div_CTR,0)
div_CTR_std = dim_stddev_n_Wrap(div_CTR,0)

printVarSummary(div_TOPO_mean)
printVarSummary(div_TOPO_std)
printVarSummary(div_CTR_mean)
printVarSummary(div_CTR_std)
printVarSummary(div_TOPO)
printVarSummary(div_CTR)

;====================== output to nc files ======
;dir_TOPO_out = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
;dir_CTR_out = "/lustre/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
;dir_TOPO_out = "/gdata/pritchard/hongcheq/WetAndesDryAmazon/Bootstrapping_DATA/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
;dir_CTR_out = "/gdata/pritchard/hongcheq/WetAndesDryAmazon/Bootstrapping_DATA/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"
dir_TOPO_out = "/data21/pritchard/hongcheq/WetAndesDryAmazon/Bootstrapping_DATA/WADA_CTR_TOPO_ENSEMBLE_post-processing/TOPO_TEST/"
dir_CTR_out = "/data21/pritchard/hongcheq/WetAndesDryAmazon/Bootstrapping_DATA/WADA_CTR_TOPO_ENSEMBLE_post-processing/CTR/"

;;--------Simple method
system("rm "+dir_TOPO_out+"ENS.std.mean.TOPOTEST.div.nc")
ncdf_TOPO = addfile(dir_TOPO_out+"ENS.std.mean.TOPOTEST.div.nc","c")
;filedimdef(ncdf_TOPO,"time",-1,True) 
filedimdef(ncdf_TOPO,"realization",-1,True)
ncdf_TOPO->div_TOPO_mean = div_TOPO_mean
ncdf_TOPO->div_TOPO_std = div_TOPO_std
ncdf_TOPO->div_TOPO = div_TOPO ; to use bootstrap in downstream calculation

system("rm "+dir_CTR_out+"ENS.std.mean.CTR.div.nc")
ncdf_CTR = addfile(dir_CTR_out+"ENS.std.mean.CTR.div.nc","c")
;filedimdef(ncdf_CTR,"time",-1,True)
filedimdef(ncdf_CTR,"realization",-1,True)
ncdf_CTR->div_CTR_mean = div_CTR_mean
ncdf_CTR->div_CTR_std = div_CTR_std
ncdf_CTR->div_CTR = div_CTR

;;;------------- method two
;ntim  = dimsizes(div_TOPO&time)                 ; get dimension sizes  
;nlev  = dimsizes(div_TOPO&lev)                                               
;nlat  = dimsizes(div_TOPO&lat)  
;nlon  = dimsizes(div_TOPO&lon)      
;
;diro_TOPO = dir_TOPO_out                     ; Output directory
;filo_TOPO = "ENS.std.mean.TOPOTEST.div.nc"             ; Output file
;system("rm " + diro_TOPO + filo_TOPO)    ; remove if exists
;fout  = addfile (diro_TOPO + filo_TOPO, "c")  ; open output file
;
;setfileoption(fout,"DefineMode",True)
;
;fAtt               = True            ; assign file attributes
;fAtt@title         = "NCL Efficient Approach to netCDF Creation"  
;fAtt@source_file   =  "original-file.nc"
;fAtt@Conventions   = "None"   
;fAtt@creation_date = systemfunc ("date")        
;fileattdef( fout, fAtt )            ; copy file attributes    
;
;dimNames = (/"realization","time", "lat", "lon", "lev"/)  
;;dimSizes = (/180, -1   ,  nlat,  nlon, nlev /) 
;;dimUnlim = (/ False, True , False, False, False/)   
;dimSizes = (/180, ntim,  nlat,  nlon, nlev /) 
;dimUnlim = (/ False, False, False, False, False/)   
;filedimdef(fout,dimNames,dimSizes,dimUnlim)
;
;filevardef(fout, "realization" ,typeof(div_TOPO&realization),getvardims(div_TOPO&realization)) 
;filevardef(fout, "time" ,typeof(div_TOPO&time),getvardims(div_TOPO&time)) 
;filevardef(fout, "lev"  ,typeof(div_TOPO&lev),getvardims(div_TOPO&lev) )                           
;filevardef(fout, "lat"  ,typeof(div_TOPO&lat),getvardims(div_TOPO&lat))                          
;filevardef(fout, "lon"  ,typeof(div_TOPO&lon),getvardims(div_TOPO&lon))                          
;filevardef(fout, "div_TOPO_mean"    ,typeof(div_TOPO_mean)  ,getvardims(div_TOPO_mean))    
;filevardef(fout, "div_TOPO_std"   ,typeof(div_TOPO_std) ,getvardims(div_TOPO_std))          
;filevardef(fout, "div_TOPO",typeof(div_TOPO),getvardims(div_TOPO))
;;filevardef(fout, "div_CTR_mean"    ,typeof(div_CTR_mean)  ,getvardims(div_CTR_mean))    
;;filevardef(fout, "div_CTR_std"   ,typeof(div_CTR_std) ,getvardims(div_CTR_std))          
;;filevardef(fout, "div_CTR",typeof(div_CTR),getvardims(div_CTR))
;
;filevarattdef(fout,"realization",div_TOPO&realization)                           ; copy  attributes
;filevarattdef(fout,"time" ,div_TOPO&time)                    ; copy time attributes
;filevarattdef(fout,"lev"  ,div_TOPO&lev)                     ; copy lev attributes
;filevarattdef(fout,"lat"  ,div_TOPO&lat)                     ; copy lat attributes
;filevarattdef(fout,"lon"  ,div_TOPO&lon)                     ; copy lon attributes
;filevarattdef(fout,"div_TOPO_mean"   ,div_TOPO_mean)                      ; copy  attributes
;filevarattdef(fout,"div_TOPO_std",div_TOPO_std)
;filevarattdef(fout,"div_TOPO",div_TOPO)
;;filevarattdef(fout,"div_CTR_mean"   ,div_CTR_mean)                      ; copy  attributes
;;filevarattdef(fout,"div_CTR_std",div_CTR_std)
;;filevarattdef(fout,"div_CTR",div_CTR)
;setfileoption(fout,"DefineMode",False)
;
;fout->realization = (/div_TOPO&realization/)
;fout->time   = (/div_TOPO&time/)     
;fout->lev    = (/div_TOPO&lev/)
;fout->lat    = (/div_TOPO&lat/)
;fout->lon    = (/div_TOPO&lon/) 
;fout->div_TOPO_mean      = (/div_TOPO_mean/)
;fout->div_TOPO_std      = (/div_TOPO_std/)
;fout->div_TOPO  = (/div_TOPO/)
;;fout->div_CTR_mean      = (/div_CTR_mean/)
;;fout->div_CTR_std      = (/div_CTR_std/)
;;fout->div_CTR  = (/div_CTR/)


end
