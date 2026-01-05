# Validation problem to address hydrogen concentration, trapping, and diffusion through a 304 stainless steel mini canister
# Report: https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_129733.pdf

# Geometry
inner_radius = '${units 1.415 in -> mm}' # Radius of canister containing gases
steel_thickness = '${units 0.085 in -> mm}' # Thickness of steel enclosure
total_radius = '${fparse inner_radius + steel_thickness}'
height = '${units 7.06 in -> mm}'
# total_volume = '${fparse pi * total_radius^2*height}'
# gas_volume = '${fparse pi * inner_radius^2*height}'
# steel_volume = '${fparse total_volume - gas_volume}'
# mass_aluminum_plate = '${units 0.0829200251 kg}' #calculated using known density of aluminum and plate dimensions given in report

# Ambient Physical & Chemical Parameters
temperature = '${units 313.15 K}' # mild temp
initial_pressure_gas = '${units 2.4 psi -> Pa}' # Anywhere from 1-10% of 24 psi
# initial_pressure_air = '${units 0.051 Pa}' # Hydrogen in atmosphere is negligible?
initial_pressure_air = '${units 0 psi -> Pa}'
ideal_gas_constant = '${units 8.31446261815324 J/K/mol -> J/K/mumol}'
# ideal_gas_constant = '${units 8.31446261815324e-06 J/K/mumol}'

# Initial Concentrations
initial_concentration_steel = '${units ${fparse initial_pressure_air/(ideal_gas_constant*temperature)} mumol/mm^3}'
# initial_concentration_gas = '${units ${fparse initial_pressure_gas/(ideal_gas_constant*temperature)} mumol/mm^3}'
initial_total_mass = '${units 1466.5 mumol}' # atoms of hydrogen
# Parameters Related to Stainless Steel walls of Canister
# diffusivity_H_in_steel = '${units 2.86e-13 m^2/s -> mm^2/s}' # https://pdf.sciencedirectassets.com/271609/1-s2.0-S0925838800X00473/1-s2.0-S0925838896028460/main.pdf?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEPj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJFMEMCH06lR8h%2BQeV%2F%2BWPSlTbpcAZM6nj0BCSME5n0nB3sYV8CIAx6yxTZ%2BJIpkpARYB7mbXS8CPq4eje8aIuikdKGreuDKrsFCJD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQBRoMMDU5MDAzNTQ2ODY1IgwwlLoItAwYQdJrUpMqjwUanStcho50OBvN4WhTU8b3xmuKS%2F3ER%2FwNgfvbKAi9UjXUNGdFWoc%2BcL%2B4bsml3oz1MwH%2BJP9H37JjQJbGyLj2VrKK4k0xhtPu9tE7kFOepedJvcjPmCe3PLBiFJPSI9a2SsLpq0Y%2Bd88w7DIB33OTYTvmVM8pYYrxWq20wVgo3RdIThsjHwxm%2FkDlYwSJpxPe1HcJVEdnRPofYhK4LEJKnjsGyUIFj4tABaAEjYKfg1d0aFgUrev%2BBKJq5rZbt39xr9YifnqRw%2FLQ%2BbIL4E0Cx3dcF%2BszcPkqAb%2FYRn2qBT51vrA444fXv295JpnMjk%2FYJlCfOdq8OrAClOfFt4oVb62bKHnqLK2GOfgXkG%2B1GW051vYghKXzf76SNNvEkcMOaBvJwqPVHk1U2XTA%2FwWli4m1ZwNbxAz%2BMQKdbATLecRit4N07B2eWUb%2FMT8seOcjR0vT2Ih3v6guOzHjmjgvuk61gsjFhhs2j5HqgsjbpTnHoEVuI2kSPGDoesiLjpSRsok4Rtyy%2FfcLy8H46PVs%2FfmEeQnYBicQ63JhAMZ1C6ghuGUGK0XCNs0o5decDxZgVxptfxRc2Kw9%2BZ63M8AQCpkGfHc%2FB3cz%2BL42jNz1GswcZvMKMB6lwvbJCkpa7NHbJViD7CYco3dMzq4xjyNlX92Tzr9r%2ByNpvTXv82kmPVVZkLh5Yh49%2BUxH9RZOOJgj6vdKmCwnQD6ak0Isxl%2BmXanjPXT0pvQLJs5jX%2F5X9z7u2274CLuesgeIOGxeHQJ4j9l7AxgnrDd%2F16wR76WS%2F50o1RZ6RClx9dSlNbK7icZjcODW8X6WATAyiXxeStLbX3jfm4Zh%2FkvbQaw6pQ%2Fjx7EHTOaPqYfDzX4VBrjWMOG2j8cGOrMBWMyoEJbJ9Aq255MIA6N9B%2BgVguUseD%2BbGbnCrjE1M1eBA0Dk9pTkaRKI9t5z0RIO8ajvPj%2F%2B3ia9Y52uwwH2WrV7dDfT8Xg90legndHUEuTBAKyq0sw%2FIm6nXA9bv8OXA3pq%2FY35%2Bwa%2FxK%2Bkp4zIOk7XOUU9Kku8vWN%2BxiMJmppSFPo2jcHkTM2GfAfEBFQ5RySxhPgqL0Pkn1RFzDogFsa396kO5KaUWRE1dZIiVn4kWwE%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20251006T155752Z&X-Amz-SignedHeaders=host&X-Amz-Expires=300&X-Amz-Credential=ASIAQ3PHCVTYSO4WZR6Z%2F20251006%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=b344f187b722db2da048edb3013670503007a603e4fc950277ac4b2fb309062b&hash=d09ced7b2aa14f89e8b753abc7a3c3143071f7d4774644da6e7f73ca1e99fcd2&host=68042c943591013ac2b2430a89b270f6af2c76d8dfd086a07176afe7c76c2c61&pii=S0925838896028460&tid=spdf-801f8509-398d-47ac-8572-298a70b38a7c&sid=48da626760d6e841fa58b19662bd1d4a88c7gxrqa&type=client&tsoh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&rh=d3d3LnNjaWVuY2VkaXJlY3QuY29t&ua=10145a5d075951075550&rr=98a65b63fb2da3b6&cc=us

# Hydrogen Diffusivity in Steel
diffusivity_preexponential_factor_in_steel = '${units 0.20e-6 m^2/s -> mm^2/day}'
diffusivity_activation_energy_in_steel = '${units 49.3 kJ/mol -> J/mumol}'
diffusivity_H_in_steel = '${fparse diffusivity_preexponential_factor_in_steel * exp(-diffusivity_activation_energy_in_steel/(ideal_gas_constant*temperature))}'

# Hydrogen Solubility in Steel
# solubility_preexponential_factor_in_steel = '${units 2.66e5 mol/m^3/Pa -> mumol/mm^3/Pa}' #https://www.sandia.gov/app/uploads/sites/158/2021/12/1500TechRef_ferriticSS.pdf
solubility_preexponential_factor_in_steel = '${units 266e-3 mol/m^3/Pa -> mumol/mm^3/Pa}' #sqrt Pa used in BC due to sievert's law
solubility_activation_energy_in_steel = '${units 6.86 kJ/mol -> J/mumol}'
# solubility_H_in_steel = '${fparse solubility_preexponential_factor_in_steel * exp(-solubility_activation_energy_in_steel/(ideal_gas_constant*temperature))}'

# Mesh
num_intervals_steel = 5000

# Numerics
dt_max = '${units 7 day -> day}'
dt_min = '${units 1 h -> day}'
endtime = '${units 10 year -> day}'
# endtime = '${units 0.25 year -> day}'
dt_start = '${units 1 h -> day}' # 3 hours does not give negative concentration for current input parameters

[Mesh]
  coord_type = 'RZ' # Specify 2D axisymmetric coordinates
  rz_coord_axis = Y # Specifies X is radial direction and Y is axial coordinate
  [steel]
    type = GeneratedMeshGenerator
    dim = 1
    nx = '${num_intervals_steel}'
    xmin = '${inner_radius}'
    xmax = '${total_radius}'
  []
[]

[Variables]
  [H_mobile_steel]
    initial_condition = '${initial_concentration_steel}'
  []
[]

[AuxVariables]
  [H_partial_pressure_gas] # No initial condition as pressure is ramped up
  # initial_condition = '${initial_pressure_gas}'
    # order = FIRST
    # family = LAGRANGE
  []
  [H_partial_pressure_air]
    initial_condition = '${initial_pressure_air}'
    # order = FIRST
    # family = SCALAR
  []
  [H_mobile_steel_derivative]
    order = FIRST
    family = MONOMIAL
  []
[]

[AuxKernels]
  [ramping_pressure] # Pressure term starts at zero and ramps up over time
    type = FunctionAux
    function = time_ramp_pressure
    variable = H_partial_pressure_gas
  []

  [concentration_gradient_left_boundary]
    type = DiffusionFluxAux
    component = x
    diffusion_variable = H_mobile_steel
    diffusivity = negative_unity
    variable = H_mobile_steel_derivative
    boundary = '0'
  []
[]

[Kernels]
  [steel_mobile_time]
    type = ADTimeDerivative
    variable = H_mobile_steel
  []
  [steel_mobile_diff]
    type = ADMatDiffusion
    variable = H_mobile_steel
    diffusivity = '${diffusivity_H_in_steel}'
  []
[]

[Materials]
  [unity]
    type = ConstantMaterial
    property_name = negative_unity
    value = -1
    boundary = '0'
  []
[]

[BCs]
  [gas_steel_boundary] # Boundary of gas in canister and steel wall
    type = EquilibriumBC
    Ko = '${solubility_preexponential_factor_in_steel}'
    boundary = '0'
    activation_energy = '${solubility_activation_energy_in_steel}'
    enclosure_var = H_partial_pressure_gas # Should include time scaling from Aux Kernel
    variable = H_mobile_steel
    temperature = '${temperature}'
    p = 0.5 #Sievert's Law
  []

  [steel_air_boundary] # Boundary of outside edge of steel and open air
    type = EquilibriumBC
    Ko = '${solubility_preexponential_factor_in_steel}'
    boundary = '1'
    activation_energy = '${solubility_activation_energy_in_steel}'
    enclosure_var = H_partial_pressure_air
    variable = H_mobile_steel
    temperature = '${temperature}'
    p = 0.5 #Sievert's Law
  []
[]

[Functions]
  [time_ramp_pressure]
    type = TimeRampFunction
    final_value = '${initial_pressure_gas}'
    initial_value = 0
    ramp_duration = '${units 1 day -> day}'
  []
  [diffusion_length_fun]
    type = ParsedFunction
    expression = 'sqrt(pi*${diffusivity_H_in_steel}*t)'
  []
[]

[VectorPostprocessors]
  [solution_profile]
    type = NodalValueSampler
    sort_by = x
    variable = H_mobile_steel
  []
[]

[Postprocessors]

  ## Length of Diffusion Front ##

  [exact_diffusion_length]
    type = FunctionValuePostprocessor
    function = diffusion_length_fun
    outputs = csv_data
  []

  [gradient_left_boundary]
    type = PointValue
    point = '${inner_radius} 0 0'
    variable = H_mobile_steel_derivative
    outputs = csv_data
  []

  [interface_concentration]
    type = PointValue
    point = '${inner_radius} 0 0'
    variable = H_mobile_steel
    outputs = csv_data
  []

  [simulated_diffusion_length]
    type = ParsedPostprocessor
    expression = '-interface_concentration/gradient_left_boundary'
    constant_expressions = ${inner_radius}
    constant_names = interface_location
    pp_names = 'interface_concentration gradient_left_boundary'
    outputs = csv_data
  []

  ### 2D Conservation of Mass ###

  [mass_in_domain] # Axisymmetric: 2D Integral of Annulus Cross section ; Cartesian: 1D Integral of line cross section
    type = ElementIntegralVariablePostprocessor
    variable = H_mobile_steel
    outputs = csv_data
  []

  [influx]
    type = ADSideDiffusiveFluxIntegral
    boundary = '0'
    variable = H_mobile_steel
    diffusivity = ${diffusivity_H_in_steel}
    # outputs = csv_data
  []

  [outflux]
    type = ADSideDiffusiveFluxIntegral
    boundary = '1'
    variable = H_mobile_steel
    diffusivity = ${diffusivity_H_in_steel}
    # outputs = csv_data
  []

  [flux_difference] # Ensure that we are accounting for atomic vs molecular hydrogen
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

  ### 3D Conservation of Mass ###

  [3d_mass_in_domain] ## Extruded concentration of annulus
    type = ScalePostprocessor
    value = mass_in_domain
    scaling_factor = '${height}'
    outputs = csv_data
  []

  [3d_time_integrated_flux]
    type = ScalePostprocessor
    value = time_integrated_flux
    scaling_factor = ${height}
    outputs = csv_data
  []


  ### Miscellaneous ###

  [initial_total_mass]
    type = ConstantPostprocessor
    value = '${initial_total_mass}' # Currently mols of H2 molecules
    execute_on = 'Initial'
    outputs = csv_data
  []

  [min_steel] # Rough Check for Negative Concentrations
  type = ADElementExtremeFunctorValue
  functor = H_mobile_steel
  value_type = min
  # outputs = csv_data
  []

  ### Analytical Solution ###

  # [total_initial_concentration]
  #   type = ElementIntegralVariablePostprocessor
  #   variable = H_mobile_steel
  #   execute_on = 'Initial'
  #   outputs = csv_data
  # []

  # [H_partial_pressure_gas_pp]
  #   type = PointValue
  #   variable = H_partial_pressure_gas
  #   point = '${inner_radius} 0 0' # Any point on mesh should work
  #   outputs = csv_data
  # []

  # [exact_3d_mass_in_domain] ## Exact solution based on disc geometry from paper
  #   type = ParsedPostprocessor
  #   expression = '2 * 1.12 * sqrt(D*t) * (K*sqrt(p)-C_U) *(1/h + 1/r) + C_U' # Slightly different than paper
  #   # expression = '2*pi*r*h*(2 * 1.12 * sqrt(D*t) * (K*sqrt(p)-C_U) *(1/h + 1/r) + C_U)' # Slightly different than paper
  #   pp_names = 'total_initial_concentration H_partial_pressure_gas_pp'
  #   pp_symbols = 'C_U p'
  #   constant_names = 'h r D K R T pi' # radius from paper may not be well defined in our case. r could be total radius, steel thickness, or somehow related to height.
  #   constant_expressions = '${steel_thickness} ${height} ${diffusivity_H_in_steel} ${solubility_H_in_steel} ${ideal_gas_constant} ${temperature} 3.14159265359'
  #   use_t = true
  # []

  # [validation_mass]
  #   type = ScalePostprocessor
  #   value = 3d_mass_in_domain
  #   scaling_factor = ${fparse 1e6/mass_aluminum_plate} # convert to mu mol/kg
  #   outputs = csv_data
  # []

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
  dtmax = '${dt_max}'
  dtmin = '${dt_min}'
  # dt = '${dt_start}'
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
  # nl_abs_tol = 1e-50
  # nl_rel_tol = 1e-06
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
    file_base = 'csv_data_steel_only/verification_RZ'
    # file_base = 'csv_data_steel_only/verification'
    execute_on = 'TIMESTEP_END'
  []
[]
