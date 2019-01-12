"""
Function:
    Read files in this dir: /DFS-L/DATA/pritchard/hongcheq/
    WADA_CTR_TOPO_ENSEMBLE_post-processing/
    Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/
    Vertical_growth_of_temperature_anomaly/CloudForcing_SurfaceFluxes/
    To generate a figure of 3x1 for CTR, TOPO, CTR-TOPO respectively.
    For variable CLOUD.
"""
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr
import os

#PCT = 'TOPO00'
#PCT = 'TOPO20'
#PCT = 'TOPO40'
#PCT = 'TOPO60'
PCT = 'TOPO80'


dire = '/scratch/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post\
-processing_h1_tapes_CLOUD/'+PCT+'/'
files = 'CLOUD_avg_box_daily.nc'

Vars = np.zeros((3,8,13))  # [CTR, TOPO, CTR-TOPO] x 8 days x 13 lvl

ds_X = xr.open_dataset(dire+files,decode_times=False)
print(ds_X)

Vars[0,:,:] = ds_X['CLOUD_CTR']
Vars[1,:,:] = ds_X['CLOUD_TOPO']
Vars[2,:,:] = ds_X['CLOUD_CTR_TOPO']

#print(Vars)

#------------plot--------------
x = np.arange(1,9,1)
y = ds_X['lev_p']

print(y)

X, Y = np.meshgrid(x, y)

title_str = ['CTR',PCT,'CTR-'+PCT]

fig, axes = plt.subplots(3, 1, figsize=(9, 9))

cset0 = axes[0].contourf(X, Y, np.transpose(Vars[0,:,:]), cmap='Blues',
                         levels=np.linspace(0.0,0.8,11))
axes[0].set_title(title_str[0])
axes[0].set_ylabel('Level (hPa)')
axes[0].invert_yaxis()
fig.colorbar(cset0,ax=axes[0])

cset1 = axes[1].contourf(X, Y, np.transpose(Vars[1,:,:]), cmap='Blues',
                         levels=np.linspace(0.0,0.8,11))
axes[1].set_title(title_str[1])
axes[1].set_ylabel('Level (hPa)')
axes[1].invert_yaxis()
fig.colorbar(cset1,ax=axes[1])

cset2 = axes[2].contourf(X, Y, np.transpose(Vars[2,:,:]), cmap='RdBu',
                         levels=np.linspace(-0.15,0.15,17))
axes[2].set_title(title_str[2])
axes[2].set_ylabel('Level (hPa)')
axes[2].invert_yaxis()
fig.colorbar(cset2,ax=axes[2])

axes[2].set_xlabel('# days')

plt.subplots_adjust(hspace=.3)
#plt.show()
plt.savefig('../Figures/11_b_'+PCT+'CLOUD_Height_time_daily.pdf')
plt.savefig('../Figures/11_b_'+PCT+'CLOUD_Height_time_daily.png')

# output high, low cloud (>500hPa, or <500hPa) average 3-7 for CTR-TOPOX for
# further usage
# Note that (1) indexing starting from 0 and slide(2,7) does not include the
# last 7.
H_CLOUD_t = ds_X['CLOUD_CTR_TOPO'].sel(lev_p=slice(50,500)).isel(time=slice(2,7))
L_CLOUD_t = ds_X['CLOUD_CTR_TOPO'].sel(lev_p=slice(500,1000)).isel(time=slice(2,7))
print(H_CLOUD_t)
print(L_CLOUD_t)
H_CLOUD = H_CLOUD_t.mean(dim=('time','lev_p'))
L_CLOUD = L_CLOUD_t.mean(dim=('time','lev_p'))
print('-------')
H_CLOUD.name='H_CLOUD'
H_CLOUD.attrs['units'] = 'fraction'
H_CLOUD.attrs['long_name'] = 'hight cloud (500hPa and above) fraction averaged \
from day3-7, CTR-'+PCT

L_CLOUD.name='L_CLOUD'
L_CLOUD.attrs['units'] = 'fraction'
L_CLOUD.attrs['long_name'] = 'low cloud (500hPa and below) fraction averaged \
from day3-7, CTR-'+PCT
print(H_CLOUD)
print(L_CLOUD)
#myds = H_CLOUD.to_dataset()
myds = xr.merge([H_CLOUD, L_CLOUD])
myds.to_netcdf('/gdata/pritchard/hongcheq/WetAndesDryAmazon/Linear_Monotonicity_TEST/H_CLOUD_L_CLOUD_'+PCT+'.nc')
print(myds)


