module CalculationsHelper
  def fers_code_string_to_percentage(fers_code_string)
    start_index = fers_code_string.index('-') + 2
    end_index   = fers_code_string.length - 2
    fers_code_string[start_index..end_index].to_f
  end

  def state_tax(taxable_wages, state_exemptions)
    if taxable_wages <= 0.0
      0
    else
      26.05 + 0.044 * ((taxable_wages - state_exemptions * 163) - 1500) - 4.82
    end
  end

  def federal_tax(taxable_wages, federal_exemptions)
    if taxable_wages <= 0
      0
    else
      71.7 + 0.15 * ((taxable_wages - federal_exemptions * 155.8) - 1050)
    end
  end
end
