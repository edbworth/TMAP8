import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import glob

# Load CSV data
# data = pd.read_csv('csv_data_steel_only/verification.csv') # CHANGE BELOW TOO
data = pd.read_csv('csv_data_steel_only/verification_RZ.csv')

interface_location = 35.941 # mm

# Pull necessary columns
t = data['time']
absorbed_dose = t*65.21904/365.25 #124.7 Gy/min absorbed dose for Cobalt 60 irraditator
num_time_steps = len(t)
ring_flux = data['time_integrated_flux']
ring_concentration = data['mass_in_domain']
annulus_total_mass = data['3d_mass_in_domain']
annulus_flux = data['3d_time_integrated_flux']
exact_diffusion_length = data['exact_diffusion_length']
simulated_diffusion_length = data['simulated_diffusion_length']
# analytic_concentration = data['exact_3d_mass_in_domain']
# initial_canister_concentration = 2*data['initial_canister_concentration'] # Count Atomic Hydrogen
initial_total_mass = 2*data['initial_total_mass'] # Count Atomic Hydrogen

# Percentage of Hydrogen in steel vs hydrogen in canister
plt.figure(figsize=(10, 6))
# plt.plot(t,100*annulus_total_mass/initial_canister_concentration) # Total mass vs concentration?? Units off
plt.plot(t,100*annulus_total_mass/initial_total_mass)
plt.ylabel('Percentage %')
plt.xlabel('Time (days)')
plt.title(f'Percentage of Total Hydrogen in Steel')
plt.xlim(0)
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# Check length of diffusion front
plt.figure(figsize=(10, 6))
plt.plot(t,exact_diffusion_length, label = 'Exact Diffusion Length sqrt(pi*D*t)')
plt.plot(t,simulated_diffusion_length, label =f'Simulated Diffusion Length')
RMSE = np.sqrt(np.mean((simulated_diffusion_length - exact_diffusion_length)**2))
RMSPE = RMSE*np.sqrt(num_time_steps)/np.mean(exact_diffusion_length)
print(f'RMSPE = %.2f '%RMSPE+'%')
plt.text(150,0.1, 'RMSPE = %.2f '%RMSPE+'%',fontweight='bold')
plt.legend()
plt.ylabel('Length (mm)')
plt.xlabel('Time (days)')
plt.title(f'Hydrogen Canister Simulation: 1D Diffusion Front Length')
plt.xlim(0)
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# Plot Difference

plt.figure(figsize=(10, 6))
plt.plot(t,abs(exact_diffusion_length - simulated_diffusion_length))
plt.text(150,0.005, 'RMSPE = %.2f '%RMSPE+'%',fontweight='bold')
plt.legend()
plt.ylabel('Difference in Length (mm)')
plt.xlabel('Time (days)')
plt.title(f'Hydrogen Canister Simulation: 1D Diffusion Front Length Difference')
plt.xlim(0)
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# # # Compare simulated and analytical total hydrogen over time
# plt.figure(figsize=(10, 6))
# # plt.plot(t,analytic_concentration, label = 'Exact Solution')
# # # plt.plot(t, ring_concentration, label = r"2D Circular Extension ($\mu$mol H/mm)")
# plt.plot(t,annulus_total_mass, label = '3D Cylindrical Extension')
# # RMSE = np.sqrt(np.mean((annulus_total_mass - analytic_concentration)**2))
# # RMSPE = RMSE*np.sqrt(num_time_steps)/np.mean(analytic_concentration)
# # print(f'RMSPE = %.2f '%RMSPE+'%')
# # plt.text(150,0.05, 'RMSPE = %.2f '%RMSPE+'%',fontweight='bold')
# plt.xlabel('Time (Days)')
# plt.ylabel(r'Concentration ($\mu$mol H)')
# plt.title(f'1D Hydrogen Canister Simulation: Total Concentration in Steel')
# plt.xlim(0,t.max())
# plt.ylim(0)
# plt.legend()
# plt.grid(True)
# plt.tight_layout()
# plt.show()

# # Adsorbed Dose plot
# plt.figure(figsize=(10, 6))
# ax = plt.gca()
# plt.plot(t,annulus_total_mass)
# plt.ylabel(r'H Total Mass ($\mu$mol)')
# plt.xlabel('Time (days)')
# plt.title(f'Atomic Hydrogen in Steel of 3D Annulus')
# plt.xlim(0)
# plt.ylim(0)
# plt.grid(True)
# plt.tight_layout()

# # Add secondary x-axis for absorbed dose
# ax_secondary = ax.secondary_xaxis('top', functions=(lambda x: x*65.21904/365.25, lambda x: x*365.25/65.21904))
# ax_secondary.set_xlabel('Absorbed Dose (MGy)')
# ax_secondary.tick_params(axis='x', which='both', labelrotation=45, labelsize=8)  # Adjust tick parameters
# plt.show()

# Adsorbed Dose plot
plt.figure(figsize=(10, 6))
plt.plot(absorbed_dose,annulus_total_mass)
plt.ylabel(r'H Total Mass ($\mu$mol)')
plt.xlabel('Absorbed Dose (MGy)')
plt.title(f'Atomic Hydrogen in Steel of 3D Annulus vs Dose')
plt.xlim(0)
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# Time plot
plt.figure(figsize=(10, 6))
plt.plot(t,annulus_total_mass)
plt.ylabel(r'H Total Mass ($\mu$mol)')
plt.xlabel('Time (days)')
plt.title(f'Atomic Hydrogen in Steel of 3D Annulus vs Time')
plt.xlim(0)
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# Measure and Plot Conservation of Mass in 2D (for axisymmetric coordinates)
plt.figure(figsize=(10, 6))
plt.plot(t, ring_flux, label = 'Accumulated Boundary Flux')
plt.plot(t,ring_concentration, label = 'Total Concentration in Ring')
RMSE = np.sqrt(np.mean((ring_concentration - ring_flux)**2))
RMSPE = RMSE*np.sqrt(num_time_steps)/np.mean(ring_flux)
print(f'RMSPE = %.2f '%RMSPE+'%')
plt.text(150,0.05, 'RMSPE = %.2f '%RMSPE+'%',fontweight='bold')
plt.xlabel('Time (days)')
plt.ylabel(r'$\mu$mol H/mm')
plt.title(f'Conservation of Mass: 2D Ring')
plt.xlim(0,t.max())
plt.ylim(0)
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()

difference = abs(ring_flux-ring_concentration)
plt.figure(figsize=(10, 6))
plt.plot(t,difference)
plt.xlabel('Time (days)')
plt.ylabel(r'$\mu$mol H/mm')
plt.title(f'Conservation of Mass Difference: 2D Ring')
plt.xlim(0,t.max())
plt.grid(True)
plt.tight_layout()
plt.show()

# Measure and Plot Conservation of Mass in 3D (for axisymmetric coordinates)
plt.figure(figsize=(10, 6))
plt.plot(t, annulus_flux, label = 'Accumulated Boundary Flux')
plt.plot(t,annulus_total_mass, label = 'Total Mass in Annulus')
RMSE = np.sqrt(np.mean((annulus_total_mass - annulus_flux)**2))
RMSPE = RMSE*np.sqrt(num_time_steps)/np.mean(annulus_flux)
print(f'RMSPE = %.2f '%RMSPE+'%')
plt.text(150,100, 'RMSPE = %.2f '%RMSPE+'%',fontweight='bold')
plt.xlabel('Time (Days)')
plt.ylabel(r'$\mu$mol H')
plt.title(f'Conservation of Mass: 3D Annulus')
plt.xlim(0,t.max())
plt.ylim(0)
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()

difference = abs(annulus_flux-annulus_total_mass)
plt.figure(figsize=(10, 6))
plt.plot(t,difference)
plt.xlabel('Time (Days)')
plt.ylabel(r'$\mu$mol H')
plt.title(f'Conservation of Mass Difference: 3D Annulus')
plt.xlim(0,t.max())
plt.grid(True)
plt.tight_layout()
plt.show()

# Measure and Plot Diffusion Length

# Set your threshold value as to what to consider as "0"
# threshold = 7.125e-3

# Get all CSV files matching the pattern
# csv_files_steel_only = sorted(glob.glob("csv_data_steel_only/verification_solution_profile_*.csv"))
# csv_files_steel_only = sorted(glob.glob("csv_data_steel_only/verification_RZ_solution_profile_*.csv"))
# Store x-values where solution drops below threshold
# simulated_diffusion_length = []

# for file in csv_files_steel_only:
#     df = pd.read_csv(file)
#     below = df[df['H_mobile_steel'] < threshold]
#     if not below.empty:
#         simulated_diffusion_length.append(below.iloc[0]['x']) # id measures distance from starting x value in 1D mesh
#     else:
#         simulated_diffusion_length.append(simulated_diffusion_length[-1]) ## Append previously found result if threshold not satisfied

# Convert to column vector (as a NumPy array or DataFrame)
# simulated_diffusion_length = np.array(simulated_diffusion_length).reshape(-1, 1)
# simulated_diffusion_length = simulated_diffusion_length - interface_location # Translate for mesh starting at not zero
# exact_diffusion_length = np.array(exact_diffusion_length).reshape(-1,1)

# plt.figure(figsize=(10, 6))
# plt.plot(exact_diffusion_length,simulated_diffusion_length)
# plt.ylabel('Simulated D_L (mm)')
# plt.xlabel('Analytical sqrt(pi*D*t) (mm)')
# plt.title(f'1D Hydrogen Canister Simulation: Diffusion Length Proportionality Test') ## Should be Linear
# plt.xlim(0,exact_diffusion_length.max())
# plt.ylim(0,simulated_diffusion_length.max())
# plt.grid(True)
# plt.tight_layout()
# plt.show()


