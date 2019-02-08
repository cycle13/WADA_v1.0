'''
Function: Two panels 2x1
LEFT: CTR-TOPOX, CLOUD VS HCforcing
RIGHT: CTR-TOPOX, CLOUD VS Vint_(Cpair*PTTEND + Lw*PTEQ) term

'''

import numpy as np
import matplotlib.pyplot as plt
import xarray as xr

PCT = ['TOPO00','TOPO20','TOPO40','TOPO60','TOPO80']
PCT_tag = ['HEAT100','HEAT80','HEAT60','HEAT40','HEAT20']

#Xdire = '/gdata/pritchard/hongcheq/WetAndesDryAmazon/WADA_CTR_TOPO_Linear_Test_data/'
#Ydire = '/gdata/pritchard/hongcheq/WetAndesDryAmazon/Linear_Monotonicity_TEST/'
Xdire = '/data21/pritchard/hongcheq/WetAndesDryAmazon/WADA_CTR_TOPO_Linear_Test_data/'
Ydire = '/data21/pritchard/hongcheq/WetAndesDryAmazon/Linear_Monotonicity_TEST/'

X1 = np.zeros((5,1)) # HCforcing as x-axis
X2 = np.zeros((5,1)) # vint(Cpair*PTTEND+Lw*PTEQ) as x-axis

Y1 = np.zeros((5,1)) # H_CLOUD
Y2 = np.zeros((5,1)) # L_CLOUD

for i_PCT in range(5):
    X1files = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.'+PCT[i_PCT]+'.nc'
    X2files = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.'+PCT[i_PCT]+'.nc'

    Yfiles = 'H_CLOUD_L_CLOUD_'+PCT[i_PCT]+'.nc'

    ds_X1 = xr.open_dataset(Xdire+X1files)
    ds_X2 = xr.open_dataset(Xdire+X2files)
    ds_Y = xr.open_dataset(Ydire+Yfiles)

    X1[i_PCT] = ds_X1['Andes_vint_forcing_CTR_TOPO_mean']
    X2[i_PCT] = ds_X2['Andes_vint_PTTEND_PTEQ_CTR_TOPO_mean']

    Y1[i_PCT] = ds_Y['H_CLOUD']
    Y2[i_PCT] = ds_Y['L_CLOUD']

print('-----------')
print(X1)
print(X2)
print(Y1)
print(Y2)

# Plot Figures
plt.figure(figsize=(10,7))

plt.subplot(1,2,1)
plt.axis([0, 130, -0.07, 0.0])
#plt.errorbar(X1,Y1,fmt='--o',label='H_CLOUD')
plt.plot(X1,Y1,'--o',label='H_CLOUD')
plt.plot(X1,Y2,'--o',label='L_CLOUD')
#plt.title('High/Low cloud VS Direct forcing, CTR-TOPOX')
plt.title('High/Low cloud VS Direct forcing, CTR-HEATX')
plt.xlabel('Direct forcing (Andes), $ W/m^2 $')
plt.ylabel('Cloud fraction (EastFlank), $ fraction $')

for i_text in range(5):
    plt.text(X1[i_text]*0.95,Y2[i_text]*0.9,PCT_tag[i_text],fontsize=8)

plt.grid(True)
plt.legend()

plt.subplot(1,2,2)
plt.axis([0, 130, -0.07, 0.0])
#plt.errorbar(X2,Y1,fmt='--o',label='H_CLOUD')
#plt.errorbar(X2,Y2,fmt='--o',label='L_CLOUD')
plt.plot(X2,Y1,'--o',label='H_CLOUD')
plt.plot(X2,Y2,'--o',label='L_CLOUD')
#plt.title('High/Low cloud VS Total Effect, CTR-TOPOX')
plt.title('High/Low cloud VS Total Effect, CTR-HEATX')
plt.xlabel('Vint_(Cpair*PTTEND + Lw*PTEQ) (Andes), $ W/m^2 $')
#plt.ylabel('Cloud fraction (EastFlank), $ fraction $')

for i_text in range(5):
    plt.text(X2[i_text]*0.95,Y2[i_text]*0.9,PCT_tag[i_text],fontsize=8)

plt.grid(True)
plt.legend()

### Save figures
#plt.show()
plt.savefig("../Figures/12_a_CLOUD_HCforcing_PTTEND_PTEQ.png")
plt.savefig("../Figures/12_a_CLOUD_HCforcing_PTTEND_PTEQ.pdf")

