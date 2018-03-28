class Statement
  include CalculationsHelper

  attr_reader :parameters, :calculations

  PAY_PERIOD_HOURS    = 80
  MEDICARE_PERCENTAGE = 1.45
  OASDI_PERCENTAGE    = 6.2

  def initialize(parameters_hash = {})
    @parameters   = parameters_hash
    @calculations = {}

    if @parameters.class == ActionController::Parameters && !@parameters.empty?
      perform_calculations
    else
      @parameters = {}
    end
  end

  def perform_calculations
    @calculations['regular_pay']        = calculate_regular_pay
    @calculations['overtime_pay']       = calculate_overtime_pay
    @calculations['gross_pay']          = calculate_gross_pay
    @calculations['non_taxable_wages']  = calculate_non_taxable_wages
    @calculations['tsp_contribution']   = calculate_TSP_contribution
    @calculations['tax_deferred_wages'] = calculate_tax_deferred_wages
    @calculations['taxable_wages']      = calculate_taxable_wages
    @calculations['medicare_deduction'] = calculate_medicare_deduction
    @calculations['FERS_deduction']     = calculate_FERS_deduction
    @calculations['state_tax']          = calculate_state_tax
    @calculations['OASDI_deduction']    = calculate_OASDI_deduction
    @calculations['federal_tax']        = calculate_federal_tax
    @calculations['deductions']         = add_all_deductions
    @calculations['take_home_pay']      = calculate_take_home_pay
  end

  def calculate_regular_pay
    hourly_rate = @parameters['hourly_rate'].to_f
    pay = hourly_rate * PAY_PERIOD_HOURS
  end

  def calculate_overtime_pay
    overtime_rate  = @parameters['overtime_rate'].to_f
    overtime_hours = @parameters['overtime_hours'].to_f
    overtime_rate * overtime_hours
  end

  def calculate_gross_pay
    regular_pay  = @calculations['regular_pay']
    overtime_pay = @calculations['overtime_pay'].to_f
    regular_pay + overtime_pay
  end

  def calculate_non_taxable_wages
    health_insurance       = @parameters['health_insurance'].to_f
    fsa_contribution       = @parameters['fsa_contribution'].to_f
    vision_insurance       = @parameters['vision_insurance'].to_f
    non_taxable_additional = @parameters['non_taxable_additional'].to_f
    health_insurance + fsa_contribution + vision_insurance + non_taxable_additional
  end

  def calculate_tax_deferred_wages
    tsp_contribution        = @calculations['tsp_contribution']
    tax_deferred_additional = @parameters['tax_deferred_additional'].to_f
    tsp_contribution + tax_deferred_additional
  end

  def calculate_taxable_wages
    gross_pay          = @calculations['gross_pay']
    non_taxable_wages  = @calculations['non_taxable_wages']
    tax_deferred_wages = @calculations['tax_deferred_wages']
    gross_pay - non_taxable_wages - tax_deferred_wages
  end

  def calculate_medicare_deduction
    gross_pay           = @calculations['gross_pay']
    non_taxable_wages   = @calculations['non_taxable_wages']
    @medicare_deduction = (gross_pay - non_taxable_wages) * MEDICARE_PERCENTAGE / 100
  end

  def calculate_FERS_deduction
    fers_code_string = @parameters['fers_code']
    fers_percentage  = fers_code_string_to_percentage(fers_code_string)
    regular_pay      = @calculations['regular_pay']
    regular_pay * fers_percentage / 100
  end

  def calculate_state_tax
    taxable_wages               = @calculations['taxable_wages']
    state_exemptions            = @parameters['state_exemptions'].to_i
    home_state                  = @parameters['home_state'].to_sym
    marital_status              = @parameters['marital_status'].to_sym
    additional_state_allowances = @parameters['additional_state_allowances'].to_i
    biweekly_CA_state_tax(taxable_wages, state_exemptions, home_state, marital_status, additional_state_allowances)
  end

  def calculate_OASDI_deduction
    gross_pay         = @calculations['gross_pay']
    non_taxable_wages = @calculations['non_taxable_wages']
    (gross_pay - non_taxable_wages) * OASDI_PERCENTAGE / 100
  end

  def calculate_federal_tax
    taxable_wages      = @calculations['taxable_wages']
    federal_exemptions = @parameters['federal_exemptions'].to_i
    marital_status     = @parameters['marital_status'].to_sym
    biweekly_federal_tax(taxable_wages, federal_exemptions, marital_status)
  end

  def calculate_TSP_contribution
    regular_pay      = @calculations['regular_pay']
    tsp_percentage   = @parameters['tsp_percentage'].to_f
    tsp_fixed_amount = @parameters['tsp_fixed_amount'].to_f

    if tsp_fixed_amount == 0.0
      regular_pay * tsp_percentage / 100.00
    else
      tsp_fixed_amount
    end
  end

  def add_all_deductions
    deductions = [
      @parameters['life_insurance_premium'].to_f,
      @calculations['medicare_deduction'],
      @calculations['FERS_deduction'],
      @calculations['state_tax'],
      @parameters['vision_insurance'].to_f,
      @parameters['fsa_contribution'].to_f,
      @parameters['health_insurance'].to_f,
      @calculations['OASDI_deduction'],
      @calculations['federal_tax'],
      @calculations['tsp_contribution']
    ]

    deductions.sum
  end

  def calculate_take_home_pay
    @calculations['gross_pay'] - @calculations['deductions']
  end
end
