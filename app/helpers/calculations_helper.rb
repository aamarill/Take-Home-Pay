module CalculationsHelper

  FEDERAL_PERCENTAGE_METHOD_TABLES = {
    allowances:{
      biweekly: 159.60
    },
    biweekly:{
      single:{
        thresholds:    [ 142.00, 509.00, 1631.00, 3315.00,  6200.00,  7835.00, 19373.00],
        minimum_taxes: [   0.00,  39.70,  185.62,  587.12,  1337.12,  1903.84,  6278.84],
        percentages:   [  10.00,  12.00,   22.00,   24.00,    32.00,    35.00,    37.00]
      },
      married:{
        thresholds:    [ 444.00, 1177.00, 3421.00, 6790.00, 12560.00, 15829.00, 23521.00],
        minimum_taxes: [   0.00,   73.30,  342.58, 1083.76,  2468.56,  3514.64,  6206.84],
        percentages:   [  10.00,   12.00,   22.00,   24.00,    32.00,    35.00,    37.00]
      }
    }
  }

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

  def biweekly_federal_tax(taxable_wages, federal_exemptions, marital_status)
    allowance_amount = FEDERAL_PERCENTAGE_METHOD_TABLES[:allowances][:biweekly]
    minimum_taxes    = FEDERAL_PERCENTAGE_METHOD_TABLES[:biweekly][marital_status.to_sym][:minimum_taxes]
    percentages      = FEDERAL_PERCENTAGE_METHOD_TABLES[:biweekly][marital_status.to_sym][:percentages]
    thresholds       = FEDERAL_PERCENTAGE_METHOD_TABLES[:biweekly][marital_status.to_sym][:thresholds]

    excess_wages = taxable_wages - allowance_amount * federal_exemptions
    index = 0
    thresholds.each_with_index do |threshold, i|
      if excess_wages <= threshold
        index = i
        break
      elsif excess_wages > thresholds.last
        index = thresholds.length
        break
      end
    end

    if index == 0
      0
    else
      index -= 1

      min_tax    = minimum_taxes[index]
      percentage = percentages[index]
      threshold  = thresholds[index]

      min_tax + (percentage / 100.00) * (excess_wages - threshold)
    end
  end
end
