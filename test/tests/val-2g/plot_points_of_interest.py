# Need to have all standard postprocessors active for this
import pandas as pd
import matplotlib.pyplot as plt

# Load CSV data
data = pd.read_csv('csv_data/.csv')

# Assume the CSV has columns 'x' and 'value'
t = data['time']
Mobile_gas_interface = data['Mobile_gas_interface']
Mobile_steel_interface = data['Mobile_steel_interface']
Mobile_gas_center_of_canister = data['Mobile_gas_center']
Mobile_steel_edge_to_air = data['Mobile_steel_edge_air']

# Define interface location (adjust as needed)
interface = 0.35941 #meters

# Function to plot data
def plot_data(t, y_data, y_label, title_suffix):
    plt.figure(figsize=(10, 6))
    plt.plot(t, y_data, label=y_label)

    # Highlight blocks and interface
    # plt.axvline(interface, color='red', linestyle='--', label='Interface')
    # plt.text(t.min(), 0, 'Gas', fontsize=12, color='black')
    # plt.text(interface, 0 , 'Steel', fontsize=12, color='black')

    # Labels and title
    plt.xlabel('Time (s)')
    plt.ylabel('Concentration (mol/m^3)')
    plt.title(f'1D Hydrogen Canister Simulation: {title_suffix}')
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()

# Plot for Mobile_gas_center_of_canister
plot_data(t, Mobile_gas_center_of_canister, 'Mobile_gas_center_of_canister', 'Mobile Concentration in Center of Canister')

# Plot for gas-steel interface
plot_data(t, Mobile_gas_interface, 'Mobile_gas_interface', 'Mobile Concentration in Gas at Interface')

plot_data(t, Mobile_steel_interface, 'Mobile_steel_interface', 'Mobile Concentration in Steel at Interface')

# Plot for Mobile_steel_edge_to_air
plot_data(t, Mobile_steel_edge_to_air, 'Mobile_steel_edge_to_air', 'Steel Edge to Air: EquilibriumBC')
