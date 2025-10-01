# Validation problem to address hydrogen concentration, trapping, and diffusion through a 304 stainless steel mini canister
# Report: https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_129733.pdf

# Geometry
inner_radius = '${units 1.415 in -> m}' # Radius of canister containing gases
steel_thickness =  '${units 0.085 in -> m}' # Thickness of steel enclosure
total_radius = '${fparse inner_radius + steel_thickness}'

# Ambient Physical & Chemical Parameters
temperature = '${units 313.15 K}' # mild temp
initial_pressure = '${units 2.4 psi -> Pa}' # Anywhere from 1-10% of 24 psi
ideal_gas_constant = '${units 8.31446261815324 J/K/mol}'

# Parameters related to Gas in Canister
diffusivity_H_in_gas = '${units 2.7e-02 m^2/s}' # Table 1 https://www.sciencedirect.com/science/article/pii/S1540748902801675

# Initial Concentrations
initial_concentration_gas = '${fparse initial_pressure/(ideal_gas_constant*temperature)}' # P = C_gRT from interface kernel
initial_concentration_steel = '${units 0 mol/m^3}'

# Paramters Related to Stainless Steel walls of Canister
diffusivity_H_in_steel = '${units 2.86e-13 m^2/s}'
solubility_H_in_steel = '${units 2.66e5 mol/m^3/Pa}' # Table 2.1 for H2 so need to divide by 2 if tracking atoms: https://www.sandia.gov/app/uploads/sites/158/2021/12/1500TechRef_ferriticSS.pdf
solubility_activation_energy_in_steel = '${units 6.86e3 J/mol}'

# Interface Kernel Scaling: May need to change as units are changed
unit_scale = 1
unit_scale_neighbor = 1

### Additional Parameters that may be needed
# atomic_density = 1
# trapping_density = 1
# trapping_energy = 1
# R = '${units 8.31446261815324 J/mol/K}' # Gas constant

# Mesh
num_intervals_gas = 10
num_intervals_steel = 1000
# num_intervals_steel = '${fparse num_intervals_gas * steel_thickness // total_radius}' # Gives roughly same element length in two blocks

# Numerics
dt_max = ${units 100 s}
dt_min = ${units 1e-12 s}
# endtime = ${units 3e7 s}
endtime = ${units 3e3 s}
dt_start = ${units 1e-10 s}

[Mesh]
  [radial_cross_section]
    type = CartesianMeshGenerator
    dim = 1
    show_info = true
    dx = '${inner_radius} ${steel_thickness}'
    ix = '${num_intervals_gas} ${num_intervals_steel}'
    subdomain_id = '0 1'
  []

  [interface_left]
    type = SideSetsBetweenSubdomainsGenerator
    input = radial_cross_section
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
  [H_partial_pressure] # Ambient pressure through whole system
    initial_condition = '${initial_pressure}'
  []
  [dummy_var] # Variable needed for bounds system
  []
  [time]
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
  temperature = '${temperature}'
  Ea = '${solubility_activation_energy_in_steel}'
  neighbor_var = H_mobile_gas
  variable = H_mobile_steel
  boundary = interface_steel_to_gas
  diffusivity = '${diffusivity_H_in_steel}'
  unit_scale = '${unit_scale}'
  unit_scale_neighbor = '${unit_scale_neighbor}'
 []
[]

[BCs]
  [steel_air_boundary] # Boundary of outside edge of steel and open air
    type = EquilibriumBC
    Ko = '${solubility_H_in_steel}'
    boundary = 'right'
    activation_energy = '${solubility_activation_energy_in_steel}'
    enclosure_var = H_partial_pressure
    variable = H_mobile_steel
    temperature = '${temperature}'
    p = 0.5 #Sievert's Law
  []
[]

[Bounds]
  [mobile_steel_lower_bound]
    type = ConstantBounds
    bound_value = -1e-20
    bound_type = lower
    block = 1
    # boundary = interface_steel_to_gas
    bounded_variable = H_mobile_steel
    variable = dummy_var
  []
  [mobile_gas_lower_bound]
    type = ConstantBounds
    bound_value = -1e-20
    bound_type = lower
    block = 0
    # boundary = interface_gas_to_steel
    bounded_variable = H_mobile_gas
    variable = dummy_var
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[VectorPostprocessors]
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
  []
  [timesteps]
    type = NumTimeSteps
  []
  [time]
    type = TimePostprocessor
  []
  [Mobile_steel_interface]
    type = PointValue
    point = '${inner_radius} 0 0'
    variable = H_mobile_steel
  []
  [Mobile_gas_center]
    type = PointValue
    point = '0 0 0'
    variable = H_mobile_gas
  []
  [Mobile_steel_edge_air]
    type = PointValue
    point = '${total_radius} 0 0'
    variable = H_mobile_steel
  []
[]

[Executioner]
  type = Transient
  scheme = bdf2
  dtmax = '${dt_max}'
  dtmin = '${dt_min}'
  solve_type = Newton
  petsc_options_iname = '-pc_type -snes_type' # add -snes_type if bounds system active
  petsc_options_value = 'lu vinewtonrsls' # add  vinewtonrsls if bounds system active
  line_search = DEFAULT
  end_time = ${endtime}
  steady_state_detection = true
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = ${dt_start}
    optimal_iterations = 5
    growth_factor = 1.1
    cutback_factor_at_failure = .9
  []
[]

[Outputs]
  exodus = true
  [csv_data]
    type = CSV
    file_base = 'csv_data/'
    execute_on = 'TIMESTEP_END'
  []
[]
