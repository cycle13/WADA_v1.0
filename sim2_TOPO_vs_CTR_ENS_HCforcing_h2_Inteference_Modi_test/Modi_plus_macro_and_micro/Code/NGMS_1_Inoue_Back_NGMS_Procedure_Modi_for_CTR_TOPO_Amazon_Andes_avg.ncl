;Function: After NGMS_1_Inoue_Back_NGMS_Procedure_Modi_for_CTR.ncl, and NGMS_1_Inoue_Back_NGMS_Procedure_Modi_for_TOPO.ncl
;to calculate Amazon, Andes average values of NGMS, numerator, denominator, numerator_horizontal, and numerator_vertical
;Date: 20190712

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

var_str = (/"NGMS","Numerator","Denominator","inte_numerator_hori","inte_numerator_vert"/)

do i_var = 0, dimsizes(var_str) -1
var = var_str(i_var)

do index = 0,31

TOPO_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/TOPO_TEST/"
TOPO_str = "ENS.mean.TOPOTEST."+str_time(index)+".NGMS.nc"

CTR_dir = prefix+"/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_Modi_plus_macro_and_micro/CTR/"
CTR_str = "ENS.mean.CTR."+str_time(index)+".NGMS.nc"

f_TOPO = addfile(TOPO_dir+TOPO_str,"r")
f_CTR = addfile(CTR_dir+CTR_str,"r")

var_TOPO = f_TOPO->$var$
var_CTR = f_CTR->$var$

var_diff_CTR_TOPO = var_CTR ; metadata
var_diff_CTR_TOPO = var_CTR - var_TOPO

total_hrs = 3

do i_hr = 0,total_hrs-1

Andes_mean_CTR(index*3+i_hr) = avg(where(.not.ismissing(SGH30m), var_CTR(i_hr,:,:), var_CTR@_FillValue))
Andes_mean_TOPO(index*3+i_hr) = avg(where(.not.ismissing(SGH30m), var_TOPO(i_hr,:,:), var_TOPO@_FillValue))
Andes_mean_CTR_TOPO(index*3+i_hr) = avg(where(.not.ismissing(SGH30m), var_diff_CTR_TOPO(i_hr,:,:), var_diff_CTR_TOPO@_FillValue))

Amazon_mean_CTR(index*3+i_hr) = avg( var_CTR(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))
Amazon_mean_TOPO(index*3+i_hr) = avg( var_TOPO(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))
Amazon_mean_CTR_TOPO(index*3+i_hr) = avg(var_diff_CTR_TOPO(i_hr,{Amazon_lat_test1(0):Amazon_lat_test1(1)},{Amazon_lon_test1(0):Amazon_lon_test1(1)}))

end do ; do i_hr

end do ; do index

Andes_mean_CTR!0 = "time"
Andes_mean_CTR&time = ispan(1,96,1)
Andes_mean_CTR@units = var_CTR@units
Andes_mean_TOPO!0 = "time"
Andes_mean_TOPO&time = ispan(1,96,1)
Andes_mean_TOPO@units =  var_TOPO@units
Andes_mean_CTR_TOPO!0 = "time"
Andes_mean_CTR_TOPO&time = ispan(1,96,1)
Andes_mean_CTR_TOPO@units = var_CTR@units

Amazon_mean_CTR!0 = "time"
Amazon_mean_CTR&time = ispan(1,96,1)
Amazon_mean_CTR@units = var_CTR@units
Amazon_mean_TOPO!0 = "time"
Amazon_mean_TOPO&time = ispan(1,96,1)
Amazon_mean_TOPO@units = var_CTR@units
Amazon_mean_CTR_TOPO!0 = "time"
Amazon_mean_CTR_TOPO&time = ispan(1,96,1)
Amazon_mean_CTR_TOPO@units = var_CTR@units

;=========== output nc files ========
output_path = "/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/NGMS/"
system("rm -f "+output_path+var_str(i_var)+".nc")
ncdf = addfile(output_path+var_str(i_var)+".nc","c")
filedimdef(ncdf, "time", -1, True)
ncdf->Andes_mean_CTR = Andes_mean_CTR
ncdf->Andes_mean_TOPO = Andes_mean_TOPO
ncdf->Andes_mean_CTR_TOPO = Andes_mean_CTR_TOPO

ncdf->Amazon_mean_CTR = Amazon_mean_CTR
ncdf->Amazon_mean_TOPO = Amazon_mean_TOPO
ncdf->Amazon_mean_CTR_TOPO = Amazon_mean_CTR_TOPO

end do ; do i_var

end
