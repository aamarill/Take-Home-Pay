FactoryBot.define do
  factory :statement do
    # floats
    hourly_rate 45.0
    overtime_rate 50.0
    overtime_hours 0.0
    life_insurance_premium 10.0
    vision_insurance 0.0
    health_insurance 50.0
    fsa_contribution 150.0
    non_taxable_additional 0.0
    tax_deferred_additional 0.0
    tsp_percentage 10.0
    tsp_fixed_amount 0.0
    fers_code 0.8
    taxable_additional 0.0
    roth_tsp_percentage 0.0
    roth_tsp_fixed_amount 0.0
    dental_insurance 12.0

    # integers
    federal_exemptions 3
    state_exemptions 1
    additional_state_allowances 0

    # strings
    home_state 'California'
    marital_status 'single'
  end
end
