"""
Function:

based on X-axis vars in
Andes_TEST_vint_forcing.mean_std.avg_day3-7.TOPO00.nc
and Y-axis vars in
Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO00.nc
Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO20.nc
Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO40.nc
Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO60.nc
Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO80.nc

plot scatter plots of CTR, TOPO80, TOPO60, TOPO40, TOPO20, TOPO00.
(1) 95% confidence interval as error bars
(2) Subplot 1 with X-axis: CTR-TOPOX, DirectForcing; Y-axis: CTR-TOPOX,PRECT(Amazon)
(3) Subplot 2 with X-axis: CTR-TOPOX, EffectiveForcing; Y-axis; CTR-TOPOX, PRECT(Amazon)

Date:

20181203
"""
import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
#import cartopy
import pandas

dir = '/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/WADA_CTR_TOPO_Linear_Test_data/'
fil_X = 'PRECT_Amazon_mean_std_iday3-7_avg.nc'

fil_00 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO00.nc'
fil_20 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO20.nc'
fil_40 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO40.nc'
fil_60 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO60.nc'
#fil_80 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO80.nc'

# fil_Y the sequence should be consistent with fil_X;
#fil_Y = [fil_80, fil_60, fil_40, fil_20, fil_00]
fil_Y = [fil_60, fil_40, fil_20, fil_00]

ds_X = xr.open_dataset(dir+fil_X,decode_times=False)
print(ds_X)

PRECT_mean = ds_X['PRECT_mean']
PRECT_std = ds_X['PRECT_std']
PRECT_CI95 = ds_X['PRECT_CI95']

#==========read Y-axis variables ==========
DF_mean = np.empty((4,1))
DF_std = np.empty((4,1))
DF_CI95 = np.empty((4,1))

EF_mean = np.empty((4,1))
EF_std = np.empty((4,1))
EF_CI95 = np.empty((4,1))

for i_file in range(4):
    ds_Y = xr.open_dataset(dir+fil_Y[i_file],decode_times=False)
    print(ds_Y)

    # DirectForcing, CTR-TOPO
    DF_mean[i_file] = ds_Y['Andes_vint_forcing_CTR_TOPO_mean']
    DF_std[i_file] = ds_Y['Andes_vint_forcing_CTR_TOPO_std']
    DF_CI95[i_file] = ds_Y['Andes_vint_forcing_CTR_TOPO_CI95']

    EF_mean[i_file] = ds_Y['Andes_EF_mean']
    EF_std[i_file] = ds_Y['Andes_EF_std']
    EF_CI95[i_file] = ds_Y['Andes_EF_CI95']

print(DF_mean)
print(DF_std)
print(DF_CI95)

print(EF_mean)
print(EF_std)
print(EF_CI95)

#====== Plot subplot =======

plt.subplot(2,1,1)
plt.axis([50.0, 240.0, -2.0, -0.6])
plt.errorbar(DF_mean, PRECT_mean, xerr=DF_CI95, yerr=PRECT_CI95, fmt='--o')
plt.title('Forcing w/o adjustment VS Precip(Amazon)_day3-7, CTR-TOPOX')
plt.xlabel('Direct Forcing(Andes), $ W/m^2 $')
plt.ylabel('Precip(Amazon), mm/day')

#text_str = ["TOPO80","TOPO60","TOPO40","TOPO20","TOPO00"]
text_str = ["TOPO60","TOPO40","TOPO20","TOPO00"]

for i_text in range(4):
    plt.text(DF_mean[i_text]*0.95,PRECT_mean[i_text]*0.9,text_str[i_text],
             fontsize=8)

plt.subplot(2,1,2)
plt.axis([50.0, 240.0, -2.0, -0.6])
plt.errorbar(EF_mean, PRECT_mean, xerr=EF_CI95, yerr=PRECT_CI95, fmt='--o')
plt.xlabel('Effective Forcing(Andes), $ W/m^2 $')
plt.ylabel('Precip(Amazon), mm/day')

for i_text in range(4):
    plt.text(EF_mean[i_text]*0.98,PRECT_mean[i_text]*0.9,text_str[i_text],
             fontsize=8)

plt.subplots_adjust(hspace=.4)

#plt.show()

plt.savefig("../Figures/Amazon_precip_response_TOPOX.pdf")
plt.savefig("../Figures/Amazon_precip_response_TOPOX.png")







