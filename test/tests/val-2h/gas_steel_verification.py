import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import glob

# Load CSV data
# data = pd.read_csv('csv_data_steel_only/verification.csv') # CHANGE BELOW TOO
data = pd.read_csv('csv_data/verification_RZ.csv')

interface_location = 35.941 # mm

# Pull necessary columns
t = data['time']
absorbed_dose = t*65.21904/365.25 # Roughly 50 MGy/year absorbed does for Cobalt 60 irraditator
num_time_steps = len(t)
gas_total_mass = data['annulus_total_mass_gas']
steel_total_mass = data['annulus_total_mass_steel']
annulus_total_mass = 2*gas_total_mass + steel_total_mass # Count Atomic Hydrogen

plt.figure(figsize=(10, 6))
plt.plot(t,gas_total_mass)
plt.ylabel(r'Total Mass ($\mu$mol)')
plt.xlabel('Time (days)')
plt.title(f'Atomic H Total Mass in Gas Phase')
# plt.xlim(0)
# plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

plt.figure(figsize=(10, 6))
plt.plot(t,steel_total_mass)
plt.ylabel(r'Total Mass ($\mu$mol)')
plt.xlabel('Time (days)')
plt.title(f'Atomic H Total Mass in Steel Phase')
# plt.xlim(0)
# plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

# plt.figure(figsize=(10, 6))
# plt.plot(t,annulus_total_mass)
# plt.ylabel(r'Total Mass ($\mu$mol)')
# plt.xlabel('Time (days)')
# plt.title(f'Atomic H Total Mass in Annulus')
# # plt.xlim(annulus_total_mass.min()*0.95)
# # plt.ylim(annulus_total_mass.max()*1.05)
# plt.grid(True)
# plt.tight_layout()
# plt.show()

# Percentage of Hydrogen in steel vs hydrogen in canister

plt.figure(figsize=(10, 6))
plt.plot(t,100*steel_total_mass/gas_total_mass)
plt.ylabel('Percentage %')
plt.xlabel('Time (days)')
plt.title(f'Percentage of Steel to Gas')
plt.xlim(0)
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()

plt.figure(figsize=(10, 6))
plt.plot(t,100*steel_total_mass/annulus_total_mass)
plt.ylabel('Percentage %')
plt.xlabel('Time (days)')
plt.title(f'Percentage of Total Hydrogen in Steel')
plt.xlim(0)
plt.ylim(0)
plt.grid(True)
plt.tight_layout()
plt.show()
