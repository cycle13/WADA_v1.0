'''
Function: using output files under /DFS-L/DATA/pritchard/hongcheq/OLD/scratch
/hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications
DTCOND.nc, DTV.nc, PTTEND.nc, QRL.nc TTGWORO.nc
plot time series and figure out the diurnal cycle and which term contributes to the
PTTEND negative over the Andes in the TOPO group
Date: 2019/06/11
'''

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt

data_path = '/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/\
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/PTTEND_budget/'
file_names = ['PRECT']

data_vars = np.zeros((len(file_names),96)) # 6 vars x 96 hours

cases = ['CTR', 'TOPO', 'CTR_TOPO']

for i_case in range(len(cases)):
    for i in range(len(file_names)):
        ds = xr.open_dataset(data_path+file_names[i]+'.nc', decode_times=False)
        data_vars[i,:] = ds['Amazon_mean_'+cases[i_case]]
        print(data_vars[i,:])
        print('==')

    # Plot the time series
    #fig = plt.figure()
    ax1 = plt.subplot(3,1,i_case+1)
    x = np.arange(1,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = file_names[i])
    if i_case <= 1:
        plt.ylim([2.0, 9.5])
    else:
        plt.ylim([-2.0, 2.0])
    plt.xlabel('time, hr')
    plt.ylabel('PRECT, mm/day')
    plt.title(cases[i_case]+', Amazon avg')
    plt.grid(True)

#plt.legend(loc = 'best')
plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0.)
plt.tight_layout()
plt.show()
#plt.savefig('../Figures/CTR_TOPO_Amazon_mean_PRECT.png')

