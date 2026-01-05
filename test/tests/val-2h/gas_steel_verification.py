import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import glob

# Load CSV data
# data = pd.read_csv('csv_data_steel_only/verification.csv') # CHANGE BELOW TOO
data = pd.read_csv('csv_data/verification_RZ.csv')
SRNL_data = pd.read_csv('SRNL_data.csv')

interface_location = 35.941 # mm

# Pull necessary columns
t = data['time']
absorbed_dose = t*65.21904/365.25 # Roughly 50 MGy/year absorbed does for Cobalt 60 irraditator
num_time_steps = len(t)
cylinder_total_mass_steel = data['cylinder_total_mass_steel']
cylinder_total_mass_gas = data['cylinder_total_mass_gas']
circle_concentration = data['circle_concentration']
circle_time_integrated_flux = data['circle_time_integrated_flux']
circle_time_integrated_generation = data['circle_time_integrated_generation']
cylinder_total_mass = data['cylinder_total_mass']
cylinder_time_integrated_flux = data['cylinder_time_integrated_flux']
cylinder_time_integrated_generation = data['cylinder_time_integrated_generation']

# SRNL data for validation
SRNL_absorbed_dose = SRNL_data['Dose (MGy)']
# SRNL_time_data = 365.25/65.21904*SRNL_absorbed_dose
SRNL_total_mass_gas = 2 * SRNL_data['Cum. H2 yield (μmol)']
# test = np.argwhere(np.isclose(SRNL_time_data,t))
# print(test)


def numerical_solution_on_experiment_input(experiment_input, tmap_input, tmap_output): # Linear Mapping of simulation data to experimental data
    """Get new numerical solution based on the experimental input data points

    Args:
        experiment_input (float, ndarray): experimental input data points
        tmap_input (float, ndarray): numerical input data points
        tmap_output (float, ndarray): numerical output data points

    Returns:
        float, ndarray: updated tmap_output based on the data points in experiment_input
    """
    new_tmap_output = np.zeros(len(experiment_input))
    for i in range(len(experiment_input)):
        left_limit = np.argwhere((np.diff(tmap_input < experiment_input[i])))[0][0]
        right_limit = left_limit + 1
        new_tmap_output[i] = (experiment_input[i] - tmap_input[left_limit]) / (tmap_input[right_limit] - tmap_input[left_limit]) * (tmap_output[right_limit] - tmap_output[left_limit]) + tmap_output[left_limit]
    return new_tmap_output


# Total Hydrogen in the Gas compared to experimental data

simulation_mapped_total_mass_gas = numerical_solution_on_experiment_input(SRNL_absorbed_dose, absorbed_dose, cylinder_total_mass_gas) # Pulled from val 2a
plt.figure(figsize=(10, 6))
plt.plot(absorbed_dose,cylinder_total_mass_gas, label = 'Simulation')
plt.plot(SRNL_absorbed_dose,SRNL_total_mass_gas, 'ro', label = 'Experimental Data')
RMSE = np.sqrt(np.mean((simulation_mapped_total_mass_gas - SRNL_total_mass_gas)**2))
RMSPE = RMSE*np.sqrt(len(SRNL_absorbed_dose))/np.mean(SRNL_total_mass_gas)
print(f'RMSPE = %.2f '%RMSPE+'%')
plt.text(10,1000, 'RMSPE = %.2f '%RMSPE+'%',fontweight='bold')
plt.legend()
plt.ylabel(r'Atomic H Total Mass ($\mu$mol)')
plt.xlabel('Absorbed Dose (MGy)')
plt.title(f'Hydrogen in Gas Phase of Cylinder vs Absorbed Dose')
plt.xlim(0)
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# Total Hydrogen in the Steel

plt.figure(figsize=(10, 6))
plt.plot(t,cylinder_total_mass_steel)
plt.ylabel(r'Atomic H Total Mass ($\mu$mol)')
plt.xlabel('Time (days)')
plt.title(f'Hydrogen in Steel of Cylinder vs Time')
plt.xlim(0)
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# Percentage of Hydrogen in steel vs hydrogen in canister
plt.figure(figsize=(10, 6))
# plt.plot(t,100*annulus_total_mass/initial_canister_concentration) # Total mass vs concentration?? Units off
plt.plot(t,100*cylinder_total_mass_steel/cylinder_total_mass)
plt.ylabel('Percentage (Atomic H) %')
plt.xlabel('Time (days)')
plt.title(f'Percentage of Total Hydrogen in Steel')
plt.xlim(0)
# plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# Measure and Plot Conservation of Mass in 2D (for axisymmetric coordinates)
plt.figure(figsize=(10, 6))
plt.plot(t, circle_time_integrated_flux + circle_time_integrated_generation, label = 'Accumulated Boundary Flux + Source')
plt.plot(t,circle_concentration, label = 'Total Concentration in Circle')
RMSE = np.sqrt(np.mean((circle_concentration - circle_time_integrated_flux - circle_time_integrated_generation)**2))
RMSPE = RMSE*np.sqrt(num_time_steps)/np.mean(circle_concentration)
print(f'RMSPE = %.2f '%RMSPE+'%')
plt.text(50,5, 'RMSPE = %.2f '%RMSPE+'%',fontweight='bold')
plt.xlabel('Time (days)')
plt.ylabel(r'$\mu$mol H/mm')
plt.title(f'Conservation of Mass: 2D Circle')
plt.xlim(0,t.max())
plt.ylim(0,max(circle_concentration.max(),circle_time_integrated_flux.max()+circle_time_integrated_generation.max()))
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()

difference = abs(circle_time_integrated_flux + circle_time_integrated_generation-circle_concentration)
plt.figure(figsize=(10, 6))
plt.plot(t,difference)
plt.xlabel('Time (days)')
plt.ylabel(r'$\mu$mol H/mm')
plt.title(f'Conservation of Mass Difference: 2D Circle')
plt.xlim(0,t.max())
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# Measure and Plot Conservation of Mass in 3D (for axisymmetric coordinates)
plt.figure(figsize=(10, 6))
plt.plot(t, cylinder_time_integrated_flux + cylinder_time_integrated_generation, label = 'Accumulated Boundary Flux + Source')
plt.plot(t,cylinder_total_mass, label = 'Total Mass in Cylinder')
RMSE = np.sqrt(np.mean((cylinder_total_mass - cylinder_time_integrated_flux - cylinder_time_integrated_generation)**2))
RMSPE = RMSE*np.sqrt(num_time_steps)/np.mean(cylinder_total_mass)
print(f'RMSPE = %.2f '%RMSPE+'%')
plt.text(50,1000, 'RMSPE = %.2f '%RMSPE+'%',fontweight='bold')
plt.xlabel('Time (Days)')
plt.ylabel(r'$\mu$mol H')
plt.title(f'Conservation of Mass: 3D Cylinder')
plt.xlim(0,t.max())
plt.ylim(0)
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()

difference = abs(cylinder_time_integrated_flux + cylinder_time_integrated_generation - cylinder_total_mass)
plt.figure(figsize=(10, 6))
plt.plot(t,difference)
plt.xlabel('Time (Days)')
plt.ylabel(r'$\mu$mol H')
plt.title(f'Conservation of Mass Difference: 3D Cylinder')
plt.xlim(0,t.max())
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()
