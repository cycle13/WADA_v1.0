"""
Function: reading CTR group of simulation from WADA, calculate correlation
    (1) between Andean precipitation and its east flank sensible heat flux
    (2) between sensible heat flux on east flank and Amazonian precip

"""
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr
import scipy.stats

# Step 1: read files from CTR 1989-2008 DJF
prefix = "/DFS-L/DATA/pritchard/hongcheq/OLD"

years_str = np.arange(1989,2009)

path1 = "/lustre/DATA/pritchard/hongcheq/NERSC_Cori/SCRATCH/\
F_AMIP_CAM5_WADA_CTR_1989_production/atm/hist/"
fileD = "F_AMIP_CAM5_WADA_CTR_1989_production.cam.h0.1989-12.nc"
ds_temp = xr.open_dataset(path1+fileD, decode_times=False)
lat = ds_temp['lat']
lon = ds_temp['lon']
print(lat)
print(lon)

PRECT = xr.DataArray(np.zeros((20, 3, 96, 144)),\
        coords = {'year':years_str,'month':np.arange(1,4),'lat':lat,'lon':lon},\
        dims = ('year','month','lat','lon')) # 20 years x 3 month x 96 lat x 144 lon
SHFLX = xr.DataArray(np.zeros((20, 3, 96, 144)),\
        coords = {'year':years_str,'month':np.arange(1,4),'lat':lat,'lon':lon},\
        dims = ('year','month','lat','lon')) # 20 years x 3 month x 96 lat x 144 lon

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

    PRECT[i_year,0,:,:] = dsD['PRECT'].squeeze('time')
    PRECT[i_year,1,:,:] = dsJ['PRECT'].squeeze('time')
    PRECT[i_year,2,:,:] = dsF['PRECT'].squeeze('time')

    SHFLX[i_year,0,:,:] = dsD['SHFLX'].squeeze('time')
    SHFLX[i_year,1,:,:] = dsJ['SHFLX'].squeeze('time')
    SHFLX[i_year,2,:,:] = dsF['SHFLX'].squeeze('time')

print(PRECT)
print(SHFLX)

# Step 2: calculate Andean mean precip, East flank mean SHFLX, and Amazonian
#           mean precip
f_SGH30 = prefix+"/scratch/hongcheq/SGH30/USGS-gtopo30_1.9x2.5_remap_c050602.nc"
ds_TOPO = xr.open_dataset(f_SGH30, decode_times=False)
SGH30 = ds_TOPO['SGH30']
print(SGH30)

#SGH30m = xr.DataArray(np.zeros((96,144)),coords = {'lat':lat, 'lon':lon},\
#                      dims = ('lat','lon'))
SGH30m = SGH30.sel(lat=slice(-40, 10),lon=slice(270, 300))
PRECTm = PRECT.sel(lat=slice(-40, 10),lon=slice(270, 300))

#print(SGH30m)
#print(PRECTm)

PRECT_Andes = np.where(SGH30m >= 200.0, PRECTm, np.nan) # broadcasting
#print(PRECT_Andes.shape)
#print(type(PRECT_Andes))

PRECT_Andes_mean = np.zeros([20,3])
for i_year in range(PRECT_Andes.shape[0]):
    for i_month in range(PRECT_Andes.shape[1]):
        PRECT_Andes_mean[i_year,i_month] = np.nanmean(PRECT_Andes[i_year,i_month,:,:])

## Next, calculate PRECT_Amazon
Amazon_lon = np.array([288.0,309.0])
Amazon_lat = np.array([-10.0,4.0])

PRECT_Amazon = PRECT.sel(lat=slice(Amazon_lat[0],Amazon_lat[1]), \
                         lon=slice(Amazon_lon[0],Amazon_lon[1]))
#print(PRECT_Amazon)

PRECT_Amazon_mean = np.zeros([20,3])
for i_year in range(PRECT_Amazon.shape[0]):
    for i_month in range(PRECT_Amazon.shape[1]):
        PRECT_Amazon_mean[i_year,i_month] = np.nanmean(PRECT_Amazon[i_year,i_month,:,:])

#print(PRECT_Amazon_mean.shape)
#print(type(PRECT_Amazon_mean))
#print(PRECT_Amazon_mean)
#
# Let's calculate the Andean East Flank SHFLX
EastFlank_lon = np.array([360.0-72.0, 360.0-65.0])
EastFlank_lat = np.array([-10.0, 2.0])

SHFLX_EF = SHFLX.sel(lat=slice(EastFlank_lat[0],EastFlank_lat[1]), \
                    lon=slice(EastFlank_lon[0],EastFlank_lon[1]))

SHFLX_EF_mean = np.zeros([20,3])
for i_year in range(SHFLX_EF.shape[0]):
    for i_month in range(SHFLX_EF.shape[1]):
        SHFLX_EF_mean[i_year,i_month] = np.nanmean(SHFLX_EF[i_year,i_month,:,:])
#
#print(type(SHFLX_EF_mean))
#print(SHFLX_EF_mean.shape)
#print(SHFLX_EF_mean)

# Step 3: calculate correlation between Andean mean precip and its east flank
#         sensible heat flux, and correlation between east flank SHFLX and
#         Amazonian mean precip.

total = PRECT_Amazon_mean.shape[0] * PRECT_Amazon_mean.shape[1]

Andes_EF = scipy.stats.pearsonr(PRECT_Andes_mean.reshape(total,1).squeeze(),\
                                SHFLX_EF_mean.reshape(total,1).squeeze())
Andes_EF_R = Andes_EF[0] # Pearson's r
Andes_EF_P = Andes_EF[1] # p-value

print(type(Andes_EF))
print(Andes_EF)

EF_Amazon = scipy.stats.pearsonr(SHFLX_EF_mean.reshape(total,1).squeeze(),\
                                PRECT_Amazon_mean.reshape(total,1).squeeze())
EF_Amazon_R = EF_Amazon[0] # Pearson's r
EF_Amazon_P = EF_Amazon[1] # p-value

print(type(EF_Amazon))
print(EF_Amazon)












