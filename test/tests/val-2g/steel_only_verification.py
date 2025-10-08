import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import glob

# Load CSV data
data = pd.read_csv('csv_data_steel_only/verification.csv')

# Pull necessary columns
t = data['time']
num_time_steps = len(t)
flux = data['time_integrated_flux']
profile_concentration = data['mass_in_domain']
exact_diffusion_length = data['exact_diffusion_length']

# Measure and Plot Conservation of Mass
plt.figure(figsize=(10, 6))
plt.plot(t, flux, label = 'Accumulated Flux on Boundaries')
plt.plot(t,profile_concentration, label = 'Concentration in Interior Domain')
RMSE = np.sqrt(np.mean((profile_concentration - flux)**2))
RMSPE = RMSE*np.sqrt(num_time_steps)/np.mean(flux)
plt.text(1.5e7,0.00025, 'RMSPE = %.2f '%RMSPE+'%',fontweight='bold')
plt.xlabel('Time (s)')
plt.ylabel('Concentration (mol/mm^3)')
plt.title(f'1D Hydrogen Canister Simulation: Conservation of Mass')
plt.xlim(0,t.max())
plt.ylim(0)
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()

# Measure and Plot Diffusion Length

# Set your threshold value as to what to consider as "0"
threshold = 1e-6

# Get all CSV files matching the pattern
csv_files_steel_only = sorted(glob.glob("csv_data_steel_only/verification_solution_profile_*.csv"))
# Store x-values where solution drops below threshold
experimental_diffusion_length = []

for file in csv_files_steel_only:
    df = pd.read_csv(file)
    # print(df)
    below = df[df['H_mobile_steel'] < threshold]
    # print(below)
    if not below.empty:
        experimental_diffusion_length.append(below.iloc[0]['x'])
    else:
        experimental_diffusion_length.append(df.iloc[-1]['x'])  # or skip, or use a sentinel value

# Convert to column vector (as a NumPy array or DataFrame)
experimental_diffusion_length = np.array(experimental_diffusion_length).reshape(-1, 1)
# print(experimental_diffusion_length)
exact_diffusion_length = np.array(exact_diffusion_length).reshape(-1,1)
# print(type(exact_diffusion_length),type(experimental_diffusion_length))

plt.figure(figsize=(10, 6))
plt.plot(exact_diffusion_length,experimental_diffusion_length)
plt.ylabel('Experimental D_L (mm)')
plt.xlabel('Analytical sqrt(Dt) (mm)')
plt.title(f'1D Hydrogen Canister Simulation: Diffusion Length Proportionality Test') ## Should be Linear
plt.xlim(0,exact_diffusion_length.max())
plt.ylim(0,experimental_diffusion_length.max())
plt.grid(True)
plt.tight_layout()
plt.show()
