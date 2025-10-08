import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import os
import glob

# Directory containing your CSV files
data_dir = 'csv_data'

# Load the corrective data once
corrective_df = pd.read_csv(os.path.join(data_dir, ".csv"), skipinitialspace=True)

# Get all gas files to determine number of timesteps
gas_files = sorted(glob.glob(os.path.join(data_dir, "_line_plot_gas_*.csv")))
num_timesteps = len(gas_files)

# Set up the figure and axes
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8), sharex=False)

def animate(timestep):
    ax1.clear()
    ax2.clear()

    timestep += 1  # because your files start at 0001

    # File paths
    gas_path = os.path.join(data_dir, f"_line_plot_gas_{timestep:04d}.csv")
    steel_path = os.path.join(data_dir, f"_line_plot_steel_{timestep:04d}.csv")

    # Load data
    gas_df = pd.read_csv(gas_path, skipinitialspace=True)
    steel_df = pd.read_csv(steel_path, skipinitialspace=True)

    # Correct the last gas value
    gas_df.iloc[-1, gas_df.columns.get_loc('H_mobile_gas')] = \
        corrective_df.iloc[timestep - 1, corrective_df.columns.get_loc('Mobile_gas_interface')]

    # Extract data
    gas_x = gas_df['x']
    steel_x = steel_df['x']
    gas_var = gas_df.columns[0]
    steel_var = steel_df.columns[0]
    gas_values = gas_df[gas_var]
    steel_values = steel_df[steel_var]
    time = corrective_df['time']

    # Plot gas
    ax1.plot(gas_x, gas_values, color='blue')
    ax1.set_xlim(gas_x.min(), gas_x.max())
    ax1.set_ylim(gas_values.min() * 0.5, gas_values.max() * 1.5)
    ax1.set_ylabel('Concentration in Gas (mol/mm³)')
    ax1.set_title(f'Timestep {timestep} at Time: {time[timestep-1]:04f} s')
    ax1.grid(True)

    # Plot steel
    ax2.plot(steel_x, steel_values, color='green')
    ax2.set_xlim(steel_x.min(), steel_x.max())
    ax2.set_ylim(steel_values.min(), steel_values.max())
    ax2.set_ylabel('Concentration in Steel (mol/mm³)')
    ax2.set_xlabel('Distance from Canister Center (mm)')
    # ax2.set_title(f'Steel - Timestep {timestep}')
    ax2.grid(True)

    return ax1, ax2

# Create animation
ani = animation.FuncAnimation(fig, animate, frames=num_timesteps, interval=300, blit=False)

# Save animation
ani.save('subplot_bar_profile_animation.mp4', writer='ffmpeg', fps=5)

plt.close()
