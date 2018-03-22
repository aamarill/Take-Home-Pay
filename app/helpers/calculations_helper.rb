module CalculationsHelper

  def test1(args)
    output = args
    return output
  end

  def fers_code_string_to_percentage(fers_code_string)
    start_index = fers_code_string.index('-') + 2
    end_index   = fers_code_string.length - 2
    fers_code_string[start_index..end_index].to_f
  end

  def state_tax(taxable_wages, state_exemptions)
    state_tax_formula_output = (26.05 + 0.044 * ((taxable_wages - (state_exemptions * 163)) - 1500)) - 4.82
    state_tax_formula_output.round(2)
  end

  def federal_tax(taxable_wages, federal_exemptions)
    federal_tax_formula_output = 71.7 + 0.15 * (((taxable_wages - (federal_exemptions * 155.8))) - 1050)
    federal_tax_formula_output.round(2)
  end
end
