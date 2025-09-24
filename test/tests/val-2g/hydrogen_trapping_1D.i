# Validation problem to address hydrogen concentration, trapping, and diffusion through a 304 stainless steel mini canister
# Report: https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_129733.pdf

### Geometry ###
inner_radius = '${units 1.415 in -> mm}' # Radius of canister containing gases
steel_thickness =  '${units 0.085 in -> mm}' # Thickness of steel enclosure
# total_radius = '${fparse inner_radius + steel_thickness}'
# interface_width = '${units 1e-06 in -> mm}' # Having node directly on interface is not well defined for InterfaceSorption kernel it seems

### Physical & Chemical Constants ###
temperature = '${units 313.15 K}' # mild temp
initial_pressure = '${units 2.4 psi}' # Anywhere from 1-10% of 24 psi

# Gas internal to canister
diffusivity_H_in_gas = '${units 2.7e-02 m^2/s -> mm^2/s}' # Table 1 https://www.sciencedirect.com/science/article/pii/S1540748902801675
# solubility_H_in_gas = '${units 1e5 at/m^3/Pa -> at/mm^3/psi}'
# solubility_activation_energy_in_gas = '${units 1e3 J/mol}'

# Steel walls of canister
diffusivity_H_in_steel = '${units 2.86e-13 m^2/s -> mm^2/s}'
solubility_H_in_steel = '${units 2.66e5 at/m^3/Pa -> at/mm^3/psi}' # Table 2.1 https://www.sandia.gov/app/uploads/sites/158/2021/12/1500TechRef_ferriticSS.pdf
solubility_activation_energy_in_steel = '${units 6.86e3 J/mol}'

### Additional Parameters
# atomic_density = 1
# trapping_density = 1
# trapping_energy = 1
# R = '${units 8.31446261815324 J/mol/K}' # Gas constant

# Numerics
# dt_max_large = ${units 100 s}
# dt_max_small = ${units 10 s}
endtime = ${units 3e7 s}
dt_start = ${units 1e-3 s}
# trap_per_free = 1

[Mesh]
  [radial_cross_section]
    type = CartesianMeshGenerator
    dim = 1
    show_info = true
    dx = '${inner_radius} ${steel_thickness}'
    ix = '1000 100'
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
  []
  [H_mobile_steel]
    block = 1
  []
[]

[AuxVariables]
  [H_partial_pressure] # Hydrogen Partial Pressure
  []
[]

[AuxKernels]
  [constant_pressure]
    type = ConstantAux
    variable = H_partial_pressure
    value = '${initial_pressure}'
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
 []
[]

[ICs]
  [mobile_steel]
    type = ConstantIC
    value = 0
    variable = H_mobile_steel
  []
  [mobile_gas]
    type = ConstantIC
    value = 1
    variable = H_mobile_gas
  []
  [pressure]
    type = ConstantIC
    value = ${initial_pressure}
    variable = H_partial_pressure
  []
[]

[BCs]
  [steel_air_boundary] # Boundary of outside edge and open air
    type = EquilibriumBC
    Ko = '${solubility_H_in_steel}'
    boundary = '0 1'
    activation_energy = '${solubility_activation_energy_in_steel}'
    enclosure_var = H_partial_pressure
    variable = H_mobile_steel
    temperature = '${temperature}'
    p = 0.5 #Sievert's Law
  []
  [center_of_canister_gas] # Boundary for center of canister
    type = ADDirichletBC
    value = 1
    variable = H_mobile_gas
    boundary = 0
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  scheme = bdf2
  dt = ${dt_start}
  solve_type = PJFNK
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  line_search = none
  # nl_rel_tol = 1e-10
  # nl_abs_tol = 5e-12
  end_time = ${endtime}
  # automatic_scaling = true
  # compute_scaling_once = false
  # nl_max_its = 7
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
  # perf_graph = true
[]
