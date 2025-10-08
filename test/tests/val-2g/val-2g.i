# Validation problem to address hydrogen concentration, trapping, and diffusion through a 304 stainless steel mini canister
# Report: https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_129733.pdf

# Geometry
inner_radius = '${units 1.415 in -> mm}' # Radius of canister containing gases
steel_thickness =  '${units 0.085 in -> mm}' # Thickness of steel enclosure
total_radius = '${fparse inner_radius + steel_thickness}'

# Ambient Physical & Chemical Parameters
temperature = '${units 313.15 K}' # mild temp
initial_pressure_gas = '${units 2.4 psi -> Pa}' # Anywhere from 1-10% of 24 psi
# initial_pressure_air = '${units 0.051 Pa}' # Dalton's Law: Total Pressure of Atmosphere times Volume Percentage
initial_pressure_air = '${units 0 psi -> Pa}'
ideal_gas_constant = '${units 8.31446261815324 J/K/mol}'

# Parameters related to Gas in Canister
diffusivity_H_in_gas = '${units 2.7 cm^2/s -> mm^2/s}' # Table 1 https://www.sciencedirect.com/science/article/pii/S1540748902801675

# Initial Concentrations
initial_concentration_gas = '${units ${fparse initial_pressure_gas/(ideal_gas_constant*temperature)} mol/m^3}' # P = C_gRT from interface kernel
initial_concentration_steel = '${units ${fparse initial_pressure_air/(ideal_gas_constant*temperature)} mol/m^3}'

# Diffusivity in Steel
# diffusivity_H_in_steel = '${units 2.86e-13 m^2/s -> mm^2/s}' # https://pdf.sciencedirectassets.com/271609/1-s2.0-S0925838800X00473/1-s2.0-S0925838896028460/main.pdf?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEPj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJFMEMCH06lR8h%2BQeV%2F%2BWPSlTbpcAZM6nj0BCSME5n0nB3sYV8CIAx6yxTZ%2BJIpkpARYB7mbXS8CPq4eje8aIuikdKGreuDKrsFCJD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQBRoMMDU5MDAzNTQ2ODY1IgwwlLoItAwYQdJrUpMqjwUanStcho50OBvN4WhTU8b3xmuKS%2F3ER%2FwNgfvbKAi9UjXUNGdFWoc%2BcL%2B4bsml3oz1MwH%2BJP9H37JjQJbGyLj2VrKK4k0xhtPu9tE7kFOepedJvcjPmCe3PLBiFJPSI9a2SsLpq0Y%2Bd88w7DIB33OTYTvmVM8pYYrxWq20wVgo3RdIThsjHwxm%2FkDlYwSJpxPe1HcJVEdnRPofYhK4LEJKnjsGyUIFj4tABaAEjYKfg1d0aFgUrev%2BBKJq5rZbt39xr9YifnqRw%2FLQ%2BbIL4E0Cx3dcF%2BszcPkqAb%2FYRn2qBT51vrA444fXv295JpnMjk%2FYJlCfOdq8OrAClOfFt4oVb62bKHnqLK2GOfgXkG%2B1GW051vYghKXzf76SNNvEkcMOaBvJwqPVHk1U2XTA%2FwWli4m1ZwNbxAz%2BMQKdbATLecRit4N07B2eWUb%2FMT8seOcjR0vT2Ih3v6guOzHjmjgvuk61gsjFhhs2j5HqgsjbpTnHoEVuI2kSPGDoesiLjpSRsok4Rtyy%2FfcLy8H46PVs%2FfmEeQnYBicQ63JhAMZ1C6ghuGUGK0XCNs0o5decDxZgVxptfxRc2Kw9%2BZ63M8AQCpkGfHc%2FB3cz%2BL42jNz1GswcZvMKMB6lwvbJCkpa7NHbJViD7CYco3dMzq4xjyNlX92Tzr9r%2ByNpvTXv82kmPVVZkLh5Yh49%2BUxH9RZOOJgj6vdKmCwnQD6ak0Isxl%2BmXanjPXT0pvQLJs5jX%2F5X9z7u2274CLuesgeIOGxeHQJ4j9l7AxgnrDd%2F16wR76WS%2F50o1RZ6RClx9dSlNbK7icZjcODW8X6WATAyiXxeStLbX3jfm4Zh%2FkvbQaw6pQ%2Fjx7EHTOaPqYfDzX4VBrjWMOG2j8cGOrMBWMyoEJbJ9Aq255MIA6N9B%2BgVguUseD%2BbGbnCrjE1M1eBA0Dk9pTkaRKI9t5z0RIO8ajvPj%2F%2B3ia9Y52uwwH2WrV7dDfT8Xg90legndHUEuTBAKyq0sw%2FIm6nXA9bv8OXA3pq%2FY35%2Bwa%2FxK%2Bkp4zIOk7XOUU9Kku8vWN%2BxiMJmppSFPo2jcHkTM2GfAfEBFQ5RySxhPgqL0Pkn1RFzDogFsa396kO5KaUWRE1dZIiVn4kWwE%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20251006T155752Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAQ3PHCVTYSO4WZR6Z%2F20251006%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=b344f187b722db2da048edb3013670503007a603e4fc950277ac4b2fb309062b&hash=d09ced7b2aa14f89e8b753abc7a3c3143071f7d4774644da6e7f73ca1e99fcd2&host=68042c943591013ac2b2430a89b270f6af2c76d8dfd086a07176afe7c76c2c61&pii=S0925838896028460&tid=spdf-801f8509-398d-47ac-8572-298a70b38a7c&sid=48da626760d6e841fa58b19662bd1d4a88c7gxrqa&type=client&tsoh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&rh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&ua=10145a5d075951075550&rr=98a65b63fb2da3b6&cc=us
diffusivity_preexponential_factor = '${units 0.20e-6 m^2/s -> mm^2/s}' #https://www.sandia.gov/app/uploads/sites/158/2021/12/1500TechRef_ferriticSS.pdf
diffusivity_activation_energy_in_steel = '${units 49.3 kJ/mol -> J/mol}'
diffusivity_H_in_steel = '${fparse diffusivity_preexponential_factor * exp(-diffusivity_activation_energy_in_steel/(ideal_gas_constant*temperature))}'

# Solubility in Steel
solubility_H_in_steel = '${units 2.66e5 mol/m^3/Pa -> mol/mm^3/Pa}' # Table 2.1 for H2 so need to divide by 2 if tracking atoms: https://www.sandia.gov/app/uploads/sites/158/2021/12/1500TechRef_ferriticSS.pdf
solubility_activation_energy_in_steel = '${units 6.86e3 J/mol}'

# Interface Kernel Scaling: May need to change as units are changed
unit_scale = 1
unit_scale_neighbor = 1

# Mesh
num_intervals_steel = 1e3
num_intervals_gas = ${fparse int(num_intervals_steel * inner_radius / steel_thickness)} # How to round? Gives roughly same element length in two blocks

# Numerics
dt_max = ${units 7 day -> s}
dt_min = ${units 1e-6 s}
endtime = ${units 1 year -> s}
dt_start = ${units 60 s}

[Mesh]
  [total_length]
    type = CartesianMeshGenerator
    dim = 1
    show_info = true
    dx = '${inner_radius} ${steel_thickness}'
    ix = '${num_intervals_gas} ${num_intervals_steel}'
    subdomain_id = '0 1'
  []

  [interface_left]
    type = SideSetsBetweenSubdomainsGenerator
    input = total_length
    primary_block = '0' # gas
    paired_block = '1' # steel
    new_boundary = 'interface_gas_to_steel'
  []
  [interface_right]
    type = SideSetsBetweenSubdomainsGenerator
    input = interface_left
    primary_block = '1' # steel
    paired_block = '0' # gas
    new_boundary = 'interface_steel_to_gas'
  []
[]

[Variables]
  [H_mobile_gas]
    block = 0
    initial_condition = '${initial_concentration_gas}'
  []
  [H_mobile_steel]
    block = 1
    initial_condition = '${initial_concentration_steel}'
  []
[]

[AuxVariables]
  [H_partial_pressure_air]
    initial_condition = '${initial_pressure_air}'
    block = '1'
  []
  [Temperature]
  []
[]

[AuxKernels]
  [ramping_temperature] # May need this to ease into interface condition. What to scale? Temperature?
    type = FunctionAux
    function = time_ramp_temp_function
    variable = Temperature # May need two variables for each block
  []
[]

[Kernels]
  [gas_mobile_time]
    type = ADTimeDerivative
    variable = H_mobile_gas
    block = 0
  []
  [gas_mobile_diff]
    type = ADMatDiffusion # What is diffusivity of Hydrogen in hydrogen-helium gas mix?
    variable = H_mobile_gas
    diffusivity = '${diffusivity_H_in_gas}'
    block = 0
  []
  [steel_mobile_time]
    type = ADTimeDerivative
    variable = H_mobile_steel
    block = 1
  []
  [steel_mobile_diff]
    type = ADMatDiffusion
    variable = H_mobile_steel
    diffusivity = '${diffusivity_H_in_steel}'
    block = 1
  []
[]

[InterfaceKernels]
 [Equilibrium_gas_to_steel]
  type = ADInterfaceSorption
  K0 = '${solubility_H_in_steel}'
  n_sorption = 0.5 # Sievert
  # temperature = '${temperature}'
  temperature = Temperature
  Ea = '${solubility_activation_energy_in_steel}'
  neighbor_var = H_mobile_gas
  variable = H_mobile_steel
  boundary = interface_steel_to_gas
  diffusivity = '${diffusivity_H_in_steel}'
  unit_scale = '${unit_scale}' # moles of gas molecules or atoms. Check literature where diffusivity and solvability are from
  unit_scale_neighbor = '${unit_scale_neighbor}' # mm necessary here. How to apply appropriate scaling?
 []
[]

[BCs]
  [steel_air_boundary] # Boundary of outside edge of steel and open air
    type = EquilibriumBC
    Ko = '${solubility_H_in_steel}'
    boundary = '1'
    activation_energy = '${solubility_activation_energy_in_steel}'
    enclosure_var = H_partial_pressure_air
    variable = H_mobile_steel
    temperature = '${temperature}'
    p = 0.5 #Sievert's Law
  []
[]

[Functions]
  [time_ramp_temp_function]
    type = TimeRampFunction
    final_value = '${temperature}'
    initial_value = 0
    ramp_duration = '${units 600 s}' # 10 minutes
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[VectorPostprocessors] # Interpolation based so boundaries not well measured
  [line_plot_gas]
    type = LineValueSampler
    start_point = '0 0 0'
    end_point = '${inner_radius} 0 0'
    num_points ='${fparse num_intervals_gas + 1}' # n intervals gives n+1 nodes
    sort_by = x
    execute_on = 'TIMESTEP_END'
    variable = 'H_mobile_gas'
  []
  [line_plot_steel]
    type = LineValueSampler
    start_point = '${inner_radius} 0 0'
    end_point = '${total_radius} 0 0'
    num_points ='${fparse num_intervals_steel + 1}' # n intervals gives n+1 nodes plus double node at interface
    sort_by = x
    variable = 'H_mobile_steel'
  []
[]

[Postprocessors]
  [Mobile_gas_interface] # Needed to replace malfunctioning vpp
    type = PointValue
    point = '${inner_radius} 0 0'
    variable = H_mobile_gas
    outputs = csv_data
  []
  [Mobile_steel_interface]
    type = PointValue
    point = '${inner_radius} 0 0'
    variable = H_mobile_steel
    outputs = csv_data
  []
  [Mobile_gas_center]
    type = PointValue
    point = '0 0 0'
    variable = H_mobile_gas
    outputs = csv_data
  []
  [Mobile_steel_edge_air]
    type = PointValue
    point = '${total_radius} 0 0'
    variable = H_mobile_steel
    outputs = csv_data
  []
  [influx]
    type = SideDiffusiveFluxIntegral
    boundary = '0'
    variable = H_mobile_gas
    diffusivity = ${diffusivity_H_in_gas}
    outputs = csv_data
  []
  [outflux]
    type = SideDiffusiveFluxIntegral
    boundary = '1'
    variable = H_mobile_steel
    diffusivity = ${diffusivity_H_in_steel}
    outputs = csv_data
  []
  [mass_in_gas] # Are we properly accounting for the mass in the interface?
    type = ElementIntegralVariablePostprocessor
    variable = H_mobile_gas
    block = 0
    outputs = csv_data
  []
  [mass_in_steel]
    type = ElementIntegralVariablePostprocessor
    variable = H_mobile_steel
    block = 1
    outputs = csv_data
  []
  [flux_difference]
    type = ParsedPostprocessor
    expression = 'outflux - influx'
    pp_names = 'influx outflux'
    outputs = csv_data
  []
  [time_integrated_flux]
    type = TimeIntegratedPostprocessor
    value = flux_difference
    outputs = csv_data
  []
  [timesteps]
    type = NumTimeSteps
  []
  [time]
    type = TimePostprocessor
  []
[]

[Executioner]
  type = Transient
  scheme = bdf2
  dtmax = '${dt_max}'
  dtmin = '${dt_min}'
  solve_type = Newton
  # automatic_scaling = true
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_type'
  # petsc_options_value = 'hypre boomeramg cg'
  # petsc_options = '-pc_svd_monitor -snes_test_jacobian '
  # petsc_options_iname = '-snes_linesearch_damping' # add -snes_type if bounds system active
  # petsc_options_value = '0.5' # add  vinewtonrsls if bounds system active
  line_search = NONE
  nl_max_its = 50
  nl_abs_tol = 1e-50
  nl_rel_tol = 1e-06
  end_time = ${endtime}
  # steady_state_detection = true
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = ${dt_start}
    optimal_iterations = 5
    growth_factor = 1.1
    cutback_factor_at_failure = .9
  []
[]

[Outputs]
  # print_linear_residuals = true
  exodus = true
  [csv_data]
    type = CSV
    file_base = 'csv_data/verification'
    execute_on = 'TIMESTEP_END'
  []
[]
