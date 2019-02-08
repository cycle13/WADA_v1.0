"""
Function:

based on Y-axis vars in
Andes_TEST_vint_forcing.mean_std.avg_day3-7.TOPO00.nc
and X-axis vars in
Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO80.nc
Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO60.nc
Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO40.nc
Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO20.nc
Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO00.nc

plot scatter plots of CTR, TOPO80, TOPO60, TOPO40, TOPO20, TOPO00.
(1) 95% confidence interval as error bars
(2) Subplot 1 with X-axis: CTR-TOPOX, vint_(Cpair*PTTEND);
                    Y-axis: CTR-TOPOX,PRECT(Amazon)
(3) Subplot 2 with X-axis: CTR-TOPOX, vint_(Cpair*PTTEND+Lw*PTEQ);
                    Y-axis; CTR-TOPOX, PRECT(Amazon)

Date:

20181223
"""

import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
#import cartopy
import pandas

dir = '/DFS-L/DATA/pritchard/hongcheq/WADA_CTR_TOPO_ENSEMBLE_post-processing/WADA_CTR_TOPO_Linear_Test_data/'
fil_Y = 'PRECT_Amazon_mean_std_iday3-7_avg.nc'

fil_00 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO00.nc'
fil_20 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO20.nc'
fil_40 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO40.nc'
fil_60 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO60.nc'
fil_80 = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.TOPO80.nc'

# fil_X the sequence should be consistent with fil_Y;
fil_X = [fil_80, fil_60, fil_40, fil_20, fil_00]

ds_Y = xr.open_dataset(dir+fil_Y,decode_times=False)
print(ds_Y)

PRECT_mean = ds_Y['PRECT_mean']
PRECT_std = ds_Y['PRECT_std']
PRECT_CI95 = ds_Y['PRECT_CI95']

#==========read X-axis variables ==========
PTTEND_mean = np.empty((5,1))
PTTEND_std = np.empty((5,1))
PTTEND_CI95 = np.empty((5,1))

PTTEND_PTEQ_mean = np.empty((5,1))
PTTEND_PTEQ_std = np.empty((5,1))
PTTEND_PTEQ_CI95 = np.empty((5,1))

for i_file in range(5):
    ds_X = xr.open_dataset(dir+fil_X[i_file],decode_times=False)
    print(ds_Y)

    # PTTEND term, CTR-TOPO
    PTTEND_mean[i_file] = ds_X['Andes_vint_PTTEND_CTR_TOPO_mean']
    PTTEND_std[i_file] = ds_X['Andes_vint_PTTEND_CTR_TOPO_std']
    PTTEND_CI95[i_file] = ds_X['Andes_vint_PTTEND_CTR_TOPO_CI95']

    PTTEND_PTEQ_mean[i_file] = ds_X['Andes_vint_PTTEND_PTEQ_CTR_TOPO_mean']
    PTTEND_PTEQ_std[i_file] = ds_X['Andes_vint_PTTEND_PTEQ_CTR_TOPO_std']
    PTTEND_PTEQ_CI95[i_file] = ds_X['Andes_vint_PTTEND_PTEQ_CTR_TOPO_CI95']

print(PTTEND_mean)
print(PTTEND_std)
print(PTTEND_CI95)

print(PTTEND_PTEQ_mean)
print(PTTEND_PTEQ_std)
print(PTTEND_PTEQ_CI95)

#====== Plot subplot =======

plt.subplot(2,1,1)
plt.axis([0.0, 260.0, -2.0, -0.0])
plt.errorbar(PTTEND_mean, PRECT_mean, xerr=PTTEND_CI95, yerr=PRECT_CI95, fmt='--o')
plt.title('Vint(Cpair*PTTEND) VS Precip(Amazon)_day3-7, CTR-HEATX')
plt.xlabel('Vint_{Cpair*PTTEND} (Andes), $ W/m^2 $')
plt.ylabel('Precip(Amazon), mm/day')

#text_str = ["TOPO80","TOPO60","TOPO40","TOPO20","TOPO00"]
text_str = ["HEAT20","HEAT40","HEAT60","HEAT80","HEAT100"]

for i_text in range(5):
    plt.text(PTTEND_mean[i_text]*0.95,PRECT_mean[i_text]*0.9,text_str[i_text],
             fontsize=8)

plt.subplot(2,1,2)
plt.axis([0.0, 260.0, -2.0, -0.0])
plt.errorbar(PTTEND_PTEQ_mean, PRECT_mean, xerr=PTTEND_PTEQ_CI95, yerr=PRECT_CI95, fmt='--o')
plt.xlabel('Vint_{Cpair*PTTEND+Lw*PTEQ} (Andes), $ W/m^2 $')
plt.ylabel('Precip(Amazon), mm/day')

for i_text in range(5):
    plt.text(PTTEND_PTEQ_mean[i_text]*0.98,PRECT_mean[i_text]*0.9,text_str[i_text],
             fontsize=8)

plt.subplots_adjust(hspace=.4)

#plt.show()

plt.savefig("../Figures/4_Amazon_precip_response_TOPOX.PTTEND.PTEQ.pdf")
plt.savefig("../Figures/4_Amazon_precip_response_TOPOX.PTTEND.PTEQ.png")







