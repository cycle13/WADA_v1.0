'''
Function: using output files under /DFS-L/DATA/pritchard/hongcheq/OLD/scratch/
hongcheq/HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/NGMS
NGMS.nc Numerator.nc Denominator.nc inte_numerator_hori.nc inte_numerator_verti.nc
Date: 2019/07/12
'''

import numpy as np
import xarray as xr
import matplotlib.pyplot as plt

data_path = '/DFS-L/DATA/pritchard/hongcheq/OLD/scratch/hongcheq/\
HCforcing_sim2_WADA_CTR_TOPO_ENSEMBLE_post-processing_h2_tapes_New_Modifications/NGMS/'
file_names = ['Numerator','Denominator','inte_numerator_hori','inte_numerator_vert']

data_vars = np.zeros((len(file_names),96)) # X vars x 96 hours

cases = ['CTR', 'TOPO', 'CTR_TOPO']

for i_case in range(len(cases)):
    for i in range(len(file_names)):
        #ds = xr.open_dataset(data_path+file_names[i]+'.nc', decode_times=False)
        ds = xr.open_dataset(data_path+file_names[i]+'.new.nc', decode_times=False)
        data_vars[i,:] = ds['Andes_mean_'+cases[i_case]]
        print(data_vars[i,:])
        print('==')

    # Plot the time series
    #fig = plt.figure()
    plt.subplot(3,2,i_case*2+2)
    x = np.arange(1,97,1)
    for i in range(len(data_vars[:,0])):
        plt.plot(x, data_vars[i,:], label = file_names[i])

    #plt.ylim([-2.0, 5.0])
    plt.xlabel('time, hr')
    plt.ylabel('watts/m2')
    plt.title(cases[i_case]+', Andes avg')
    plt.grid(True)

plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0.)

file_names2 = ['NGMS']
data_vars2 = np.zeros((len(file_names2),96)) # X vars x 96 hours

for i_case in range(len(cases)):
        #ds = xr.open_dataset(data_path+file_names2[0]+'.nc', decode_times=False)
        ds = xr.open_dataset(data_path+file_names2[0]+'.new.nc', decode_times=False)
        data_vars2[0,:] = ds['Andes_mean_'+cases[i_case]]
        print(data_vars2[0,:])
        print('==')

        # Plot the time series
        #fig = plt.figure()
        plt.subplot(3,2,i_case*2+1)
        x = np.arange(1,97,1)
        for i in range(len(data_vars2[:,0])):
            plt.plot(x, data_vars2[0,:], label = file_names2[0])

        #plt.ylim([-2.0, 5.0])
        plt.xlabel('time, hr')
        plt.ylabel('NGMS, Unitless')
        plt.title(cases[i_case]+', Andes avg')
        plt.grid(True)

#plt.legend(loc = 'best')
#plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0.)
#plt.legend(bbox_to_anchor=(1.05, 1), loc='upper left', borderaxespad=0.)

plt.tight_layout()
#plt.show()
plt.savefig('../Figures/CTR_TOPO_Andes_mean_NGMS_decomp.new.png',dpi=300)

