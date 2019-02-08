"""
Function: reading CTR group of simulation from WADA, calculate correlation
    (1) between Andean precipitation and its east flank sensible heat flux
    (2) between sensible heat flux on east flank and Amazonian precip

"""
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr


# Step 1: read files from CTR 1989-2008 DJF
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

years_str = np.arange(1989,2009)

PRECT = xr.DataAarray(np.zeros(20, 3, 96, 144), coords = {'':, '':} ) # 20 years x 3 month x 96 lat x 144 lon

for i_year in range(len(years_str)):
    print(i_year)

    year_num = i_year+1989
    path1 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/\
F_AMIP_CAM5_WADA_CTR_"+str(year_num)+"_production/atm/hist/"
    fileD = "F_AMIP_CAM5_WADA_CTR_"+str(year_num)+"_production.cam.h0."+str(year_num)+"-12.nc"
    fileJ = "F_AMIP_CAM5_WADA_CTR_"+str(year_num)+"_production.cam.h0."+str(year_num+1)+"-01.nc"
    fileF = "F_AMIP_CAM5_WADA_CTR_"+str(year_num)+"_production.cam.h0."+str(year_num+1)+"-02.nc"

    dsD = xr.open_dataset(path1+fileD, decode_times=False)
    dsJ = xr.open_dataset(path1+fileJ, decode_times=False)
    dsF = xr.open_dataset(path1+fileF, decode_times=False)
    PRECT[i_year,0,:,:] = dsD['PRECT']
    PRECT[i_year,1,:,:] = dsJ['PRECT']
    PRECT[i_year,2,:,:] = dsF['PRECT']
print(PRECT)
exit()



# Step 2: calculate Andean mean precip, East flank mean SHFLX, and Amazonian
#           mean precip
f_SGH30 = prefix+"/scratch/hongcheq/SGH30/USGS-gtopo30_1.9x2.5_remap_c050602.nc"
ds_TOPO = xr.open_dataset(f_SGH30, decode_times=False)
SGH30 = ds_TOPO['SGH30']
print(SGH30)






# Step 3: calculate correlation between Andean mean precip and its east flank
#         sensible heat flux, and correlation between east flank SHFLX and
#         Amazonian mean precip.
















