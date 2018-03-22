class CalculationsController < ApplicationController
  include CalculationsHelper

  def index
  end

  def create
    calculation_params = params['calculation']
    @hourly_rate = calculation_params['hourly_rate'].to_f
    @overtime_rate = calculation_params['overtime_rate'].to_f
    @overtime_hours = calculation_params['overtime_hours'].to_f
    @life_insurance = calculation_params['life_insurance'].to_f
    @vision_insurance = calculation_params['vision_insurance'].to_f
    @health_insurance = calculation_params['health_insurance'].to_f
    @flex_savings_acct = calculation_params['flex_savings_acct'].to_f
    @federal_exemptions = calculation_params['federal_exemptions'].to_i
    @state_exemptions = calculation_params['state_exemptions'].to_i
    @marital_status = calculation_params['marital_status']
    @tsp_percentage = calculation_params['tsp_percentage'].to_f
    @fers_code = calculation_params['fers_code']


    @regular_pay =  (@hourly_rate * 80).round(2)
    @overtime_pay =  (@overtime_rate * @overtime_hours).round(2)
    @gross_pay = @regular_pay + @overtime_pay

    @tsp_contribution = (@regular_pay * ( @tsp_percentage / 100.0)).round(2)

    @non_taxable_wages = @health_insurance
    @tax_deferred_wages = @tsp_contribution
    @taxable_wages = @gross_pay - @non_taxable_wages - @tax_deferred_wages

    #Deductions
    medicare_percentage = 1.45
    @medicare_deduction = ((@gross_pay - @non_taxable_wages) * medicare_percentage / 100).round(2)

    oasdi_percentage = 6.2
    @OASDI_deduction = ((@gross_pay - @non_taxable_wages) * oasdi_percentage / 100).round(2)

    fers_percentage = fers_code_string_to_percentage(@fers_code)
    @FERS_deduction = ((@regular_pay) * fers_percentage / 100).round(2)

    @state_tax = state_tax(@taxable_wages, @state_exemptions)
    @federal_tax = federal_tax(@taxable_wages, @federal_exemptions)

    # refresh index page
    render "index"
  end
end
