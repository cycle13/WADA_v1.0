
load "/export/home/hongcheq/Programming/NCL/Projects/WADA/Inoue_Back_NGMS_Procedure.ncl"
begin

hus_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/hus/hus_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ta_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/ta/ta_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
zg_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/zg/zg_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ps_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/ps/ps_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
ua_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/ua/ua_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
va_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/va/va_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"
wap_file = "/lustre/DATA/pritchard/hongcheq/CMIP5/wap/wap_Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

file_output ="/lustre/DATA/pritchard/hongcheq/WADA/pilot_test/Inoue_Back.NGMS.Amon_CCSM4_amip_r1i1p1_197901-201012.nc"

Inoue_Back_NGMS_Procedure(hus_file,ta_file,zg_file,ps_file,ua_file,va_file,wap_file,file_output)




end
