;Function: U,V,Z3 difference between TOPOTEST ensemble and CTR ensemble, with significance.
;Date: 20180709
;Note: modified 20180712
;Note: modified 20180718, for ENS(90)
;Note modified 20180725, for ENS(180)
;Note: modified 20180807, for ENS(180), PTTEND
;Note: modified 20190506 for hourly PTTEND

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

;============== ======
f_SGH30 = addfile("/DFS-L/DATA/pritchard/hongcheq/Topography/USGS-gtopo30_1.9x2.5_remap_c050602.nc","r")
SGH30 = f_SGH30->SGH30

SGH30m = SGH30
SGH30m = SGH30@_FillValue
SGH30m({-40:10},{270:300}) = SGH30({-40:10},{270:300})

do ilat = 0,95
   do ilon = 0,143
      if (.not. ismissing(SGH30m(ilat,ilon)) .and. SGH30m(ilat,ilon) .lt. 200.0) then
          SGH30m(ilat,ilon) = SGH30m@_FillValue
      end if
   end do
end do
printVarSummary(SGH30m)

total_times = 96
Andes_mean_CTR = new(total_times,double)
Andes_mean_TOPO = new(total_times,double)
Andes_mean_CTR_TOPO = new(total_times,double)

Amazon_lon_test1 = (/288.0,309.0/)
Amazon_lat_test1 = (/-10.0,4.0/)
Amazon_mean_CTR = new(total_times,double)
Amazon_mean_TOPO = new(total_times,double)
Amazon_mean_CTR_TOPO = new(total_times,double)

var_str = "DSE"

dir_TOPO_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/TOPO_TEST/"
dir_CTR_out = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE/CTR/"

do index = 0,31
;-----read files, (MSE inte already calculated)
;ncdf_TOPO = addfile(dir_TOPO_out+"MSE_DSE_LE.TOPOTEST.L5.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","r")
;ncdf_CTR = addfile(dir_CTR_out+"MSE_DSE_LE.CTR.L5.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","r")
ncdf_TOPO = addfile(dir_TOPO_out+"MSE_DSE_LE.TOPOTEST.L10.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","r")
ncdf_CTR = addfile(dir_CTR_out+"MSE_DSE_LE.CTR.L10.time"+tostring(index*3)+"-"+tostring(index*3+2)+".nc","r")

DSE_CTR_inte = ncdf_CTR->DSE_inte
DSE_TOPO_inte = ncdf_TOPO->DSE_inte
DSE_diff_CTR_TOPO_inte = DSE_CTR_inte
DSE_diff_CTR_TOPO_inte = DSE_CTR_inte - DSE_TOPO_inte

;----------
total_hrs = 3

do i_hr = 0,total_hrs-1
Andes_mean_CTR(index*3+i_hr) = avg(where(.not.ismissing(SGH30m), DSE_CTR_inte(i_hr,:,:), DSE_CTR_inte@_FillValue))
Andes_mean_TOPO(index*3+i_hr) = avg(where(.not.ismissing(SGH30m), DSE_TOPO_inte(i_hr,:,:), DSE_TOPO_inte@_FillValue))
Andes_mean_CTR_TOPO(index*3+i_hr) = avg(where(.not.ismissing(SGH30m), DSE_diff_CTR_TOPO_inte(i_hr,:,:), DSE_diff_CTR_TOPO_inte@_FillValue))

Amazon_mean_CTR(index*3+i_hr) = avg( DSE_CTR_inte(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))
Amazon_mean_TOPO(index*3+i_hr) = avg( DSE_TOPO_inte(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))
Amazon_mean_CTR_TOPO(index*3+i_hr) = avg(DSE_diff_CTR_TOPO_inte(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))


end do ; do i_hr

end do ; do index

Andes_mean_CTR!0 = "time"
Andes_mean_CTR&time = ispan(1,96,1)
Andes_mean_CTR@units = "kJ/kg"
Andes_mean_TOPO!0 = "time"
Andes_mean_TOPO&time = ispan(1,96,1)
Andes_mean_TOPO@units = "kJ/kg"
Andes_mean_CTR_TOPO!0 = "time"
Andes_mean_CTR_TOPO&time = ispan(1,96,1)
Andes_mean_CTR_TOPO@units = "kJ/kg"

Amazon_mean_CTR!0 = "time"
Amazon_mean_CTR&time = ispan(1,96,1)
Amazon_mean_CTR@units = "kJ/kg"
Amazon_mean_TOPO!0 = "time"
Amazon_mean_TOPO&time = ispan(1,96,1)
Amazon_mean_TOPO@units = "kJ/kg"
Amazon_mean_CTR_TOPO!0 = "time"
Amazon_mean_CTR_TOPO&time = ispan(1,96,1)
Amazon_mean_CTR_TOPO@units = "kJ/kg"

;=========== output nc files ========
output_path = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/MSE_decomp_Andes_Amazon/"
;system("rm -f "+output_path+var_str+"L5.nc")
;ncdf = addfile(output_path+var_str+"L5.nc","c")
system("rm -f "+output_path+var_str+"L10.nc")
ncdf = addfile(output_path+var_str+"L10.nc","c")
filedimdef(ncdf, "time", -1, True)
ncdf->Andes_mean_CTR = Andes_mean_CTR
ncdf->Andes_mean_TOPO = Andes_mean_TOPO
ncdf->Andes_mean_CTR_TOPO = Andes_mean_CTR_TOPO

ncdf->Amazon_mean_CTR = Amazon_mean_CTR
ncdf->Amazon_mean_TOPO = Amazon_mean_TOPO
ncdf->Amazon_mean_CTR_TOPO = Amazon_mean_CTR_TOPO

end
