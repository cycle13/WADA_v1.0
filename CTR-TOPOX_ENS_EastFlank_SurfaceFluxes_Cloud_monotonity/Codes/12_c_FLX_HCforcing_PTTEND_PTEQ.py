'''
Function: Two panels 2x1
LEFT: CTR-TOPOX, (Cloud forcing+Surface flux) VS HCforcing
RIGHT: CTR-TOPOX, (CLOUD+Surface flux) VS Vint_(Cpair*PTTEND + Lw*PTEQ) term

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

Y = np.zeros((5,1)) # (CF+FLX)

for i_PCT in range(5):
    X1files = 'Andes_TEST_direct_forcing.EF.mean_std.avg_day3-7.'+PCT[i_PCT]+'.nc'
    X2files = 'Andes_TEST_Vint_CpairPTTEND_LwPTEQ.mean_std.avg_day3-7.'+PCT[i_PCT]+'.nc'

    Yfiles = 'CF_FLX_'+PCT[i_PCT]+'.nc'

    ds_X1 = xr.open_dataset(Xdire+X1files)
    ds_X2 = xr.open_dataset(Xdire+X2files)
    ds_Y = xr.open_dataset(Ydire+Yfiles)

    X1[i_PCT] = ds_X1['Andes_vint_forcing_CTR_TOPO_mean']
    X2[i_PCT] = ds_X2['Andes_vint_PTTEND_PTEQ_CTR_TOPO_mean']

    Y[i_PCT] = ds_Y['CF'] #+ds_Y['FLX']

print('-----------')
print(X1)
print(X2)
print(Y)

# Plot Figures
plt.figure(figsize=(10,7))

plt.subplot(1,2,1)
plt.axis([30, 125, 0, 17])

plt.plot(X1,Y,'--o',label='CF+FLX')

plt.title('(CF+FLX) VS Direct forcing, CTR-HEATX')
plt.xlabel('Direct forcing (Andes), $ W/m^2 $')
plt.ylabel('[CloudForcing + SurfaceFlux] (EastFlank), $ W/m^2 $')

for i_text in range(5):
    plt.text(X1[i_text]*0.95,Y[i_text]*0.9,PCT_tag[i_text],fontsize=8)

plt.grid(True)
plt.legend(loc='upper left')

plt.subplot(1,2,2)

plt.axis([30, 125, 0, 17])

plt.plot(X2,Y,'--o',label='CF+FLX')

plt.title('(CF+FLX) VS Total Effect, CTR-HEATX')
plt.xlabel('Vint_(Cpair*PTTEND + Lw*PTEQ) (Andes), $ W/m^2 $')

for i_text in range(5):
    plt.text(X2[i_text]*0.95,Y[i_text]*0.9,PCT_tag[i_text],fontsize=8)

plt.grid(True)
plt.legend(loc='upper left')

### Save figures
#plt.show()
plt.savefig("../Figures/12_c_CF_plus_FLX_HCforcing_PTTEND_PTEQ.png")
plt.savefig("../Figures/12_c_CF_plus_FLX_HCforcing_PTTEND_PTEQ.pdf")

