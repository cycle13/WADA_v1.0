'''
Function: overlay the plots of (1) Direct forcing vs Precip(Amazon); and (2)
        Vint_{Cpair*PTTEND+Lw*PTEQ}(Andes) VS Precip(Amazon) in order to show
        the amlification effect of feedbacks on the initial direct forcing over
        the Andes.
Date: 20190109
'''

import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
#import pandas
#import cartopy

dir = '/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/WADA_CTR_TOPO_Linear_Test_data/'
fil_Y = 'PRECT_Amazon_mean_std_iday3-7_avg.nc'

fil_00 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO00.nc'
fil_20 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO20.nc'
fil_40 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO40.nc'
fil_60 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO60.nc'
fil_80 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO80.nc'

fil_D_00 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO00.nc'
fil_D_20 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO20.nc'
fil_D_40 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO40.nc'
fil_D_60 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO60.nc'
fil_D_80 = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.TOPO80.nc'

# fil_X the sequence should be consistent with fil_Y;
fil_X = [fil_80, fil_60, fil_40, fil_20, fil_00]
fil_D_X = [fil_D_80, fil_D_60, fil_D_40, fil_D_20, fil_D_00]

ds_Y = xr.open_dataset(dir+fil_Y,decode_times=False)
print(ds_Y)

PRECT_mean = ds_Y['PRECT_mean']
PRECT_std = ds_Y['PRECT_std']
PRECT_CI95 = ds_Y['PRECT_CI95']

#==========read X-axis variables ==========
DF_mean = np.empty((5,1))
DF_std = np.empty((5,1))
DF_CI95 = np.empty((5,1))

PTTEND_PTEQ_mean = np.empty((5,1))
PTTEND_PTEQ_std = np.empty((5,1))
PTTEND_PTEQ_CI95 = np.empty((5,1))

for i_file in range(5):
    ds_X = xr.open_dataset(dir+fil_X[i_file],decode_times=False)
    ds_D_X = xr.open_dataset(dir+fil_D_X[i_file],decode_times=False)
    print(ds_Y)

    # PTTEND term, CTR-TOPO
    DF_mean[i_file] = ds_D_X['Andes_vint_forcing_CTR_TOPO_mean']
    DF_std[i_file] = ds_D_X['Andes_vint_forcing_CTR_TOPO_std']
    DF_CI95[i_file] = ds_D_X['Andes_vint_forcing_CTR_TOPO_CI95']

    PTTEND_PTEQ_mean[i_file] = ds_X['Andes_vint_PTTEND_PTEQ_CTR_TOPO_mean']
    PTTEND_PTEQ_std[i_file] = ds_X['Andes_vint_PTTEND_PTEQ_CTR_TOPO_std']
    PTTEND_PTEQ_CI95[i_file] = ds_X['Andes_vint_PTTEND_PTEQ_CTR_TOPO_CI95']

print(DF_mean)
print(DF_std)
print(DF_CI95)

print(PTTEND_PTEQ_mean)
print(PTTEND_PTEQ_std)
print(PTTEND_PTEQ_CI95)

#====== Plot subplot =======
plt.figure(figsize=(8,10))

plt.subplot(2,1,1)
plt.axis([0.0, 150.0, -2.0, -0.0])
plt.errorbar(DF_mean, PRECT_mean, xerr=DF_CI95, yerr=PRECT_CI95, fmt='--o',\
             label='Direct Forcing')
plt.title('Amplification effect of direct forcing, CTR-HEATX')
plt.xlabel(' DirectForcing or Vint_{Cpair*PTTEND+Lw*PTEQ} (Andean), $ W/m^2 $')
plt.ylabel('Precip(Amazon)_avg_day3-7, mm/day')

plt.errorbar(PTTEND_PTEQ_mean, PRECT_mean, xerr=PTTEND_PTEQ_CI95, yerr=PRECT_CI95, fmt='--o',\
             label='Cpair*PTTEND+Lw*PTEQ')

#text_str = ["TOPO80","TOPO60","TOPO40","TOPO20","TOPO00"]
text_str = ["HEAT20","HEAT40","HEAT60","HEAT80","HEAT100"]

for i_text in range(5):
    plt.text(DF_mean[i_text]*0.90,PRECT_mean[i_text]*0.9,text_str[i_text],
             fontsize=7)

for i_text in range(5):
    plt.text(PTTEND_PTEQ_mean[i_text]*0.98,PRECT_mean[i_text]*0.9,text_str[i_text],
             fontsize=7)

plt.grid(True)
plt.legend()

plt.subplot(2,1,2)
plt.axis([0.0, 150.0, 0, 150])

plt.errorbar(DF_mean, PTTEND_PTEQ_mean,  yerr=PTTEND_PTEQ_CI95, fmt='--o')
# Add this 1-1 line
plt.errorbar(np.arange(15)*15, np.arange(15)*15, fmt='--', color='k')

plt.xlabel('Vint_DirectForcing (Andes), $ W/m^2 $')
plt.ylabel('Vint_{Cpair*PTTEND+Lw*PTEQ} (Andes), $ W/m^2 $')
plt.title("Total effect of direct forcing")

for i_text in range(5):
    plt.text(DF_mean[i_text]*0.98,PTTEND_PTEQ_mean[i_text]*0.9,text_str[i_text],
             fontsize=7)

plt.subplots_adjust(hspace=.4)
plt.grid(True)

#plt.show()

plt.savefig("../Figures/5_plot_AmplificationEffect_DirectForcing_PTTEND_PTEQ_PrecipAmazon.png")
plt.savefig("../Figures/5_plot_AmplificationEffect_DirectForcing_PTTEND_PTEQ_PrecipAmazon.pdf")


