'''
Function: using output files under /DFS-L/DATA/pritchard/hongcheq/OLD/scratch
/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Raymond/
Raymond_numerator.nc (this file is produced by 1_a_Raymond_Numerator_diabatic_term.ncl)

plot time series of 3 variables
DH_Amazon_mean_CTR  / NGMS_Andes_mean_CTR
DH_Amazon_mean_TOPO / NGMS_Andes_mean_TOPO
DH_Amazon_mean_CTR_TOPO / NGMS_Amazon_mean_CTR_TOPO

Then for CTR, TOPO, and CTR-TOPO.

Date: 2019/07/29
'''

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt

data_path1 = '/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/\
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/Raymond/'
file_names1 = ['Raymond_numerator']

data_path2 = '/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/\
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/NGMS/'
file_names2 = ['NGMS']

var_names1 = ['DH']

data_vars = np.zeros((1,96)) # 1 vars x 95 hours

cases = ['CTR', 'TOPO', 'CTR_TOPO']

for i_case in range(len(cases)):
    ds1 = xr.open_dataset(data_path1+file_names1[0]+'.nc', decode_times=False)
    ds2 = xr.open_dataset(data_path2+file_names2[0]+'.nc', decode_times=False)
    DH_temp = ds1[var_names1[0]+'_Amazon_mean_'+cases[i_case]]
    NGMS_temp = ds2['Amazon_mean_'+cases[i_case]]
    print(DH_temp)
    print(NGMS_temp)
    for j in range(96):
        data_vars[0,j] = DH_temp[j] / NGMS_temp[j]

    print(data_vars[0,:])
    print('==')

    # Plot the time series
    #fig = plt.figure()
    ax1 = plt.subplot(3,1,i_case+1)
    x = np.arange(1,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = 'DiabaticHeating / NGMS')
    #plt.ylim([-2.0, 5.0])
    plt.xlabel('time, hr')
    #plt.ylabel('Q tendency, kg/kg /hr')
    plt.ylabel('DH / NGMS, watt/m2')
    plt.title(cases[i_case]+', Amazon avg')
    plt.grid(True)

#plt.legend(loc = 'best')
plt.legend(bbox_to_anchor=(1.05, 1), loc='best', borderaxespad=0.)
plt.tight_layout()
#plt.show()
plt.savefig('../Figures/1_Raymond_Diabatic_heating_over_NGMS_decomp.png',dpi=400)
