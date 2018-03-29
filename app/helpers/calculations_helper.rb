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
  STATE_PERCENTAGE_METHOD_TABLES   = {
    california: {
      low_income_exemption_table: {
        biweekly: {
          single: 540,
          married:{
            zero_or_one_allowances: 540,
            two_or_more_allowances: 1081
          },
          head_of_household: 1081
        }
      },
      estimated_deduction_table: {
        biweekly: [0, 38, 77, 115, 154, 192, 231, 269, 308, 346, 385]
      },
      standard_deduction_table: {
        biweekly: {
          single: 163,
          married: {
            zero_or_one_allowances: 163,
            two_or_more_allowances: 326
          },
          head_of_household: 326
        }
      },
      exemption_allowance_table:{
        biweekly: [0, 4.82, 9.65, 14.47, 19.29, 24.12, 28.94, 33.76, 38.58, 43.41, 48.23]
      },
      tax_rate_table:{
        biweekly:{
          single:{
            thresholds:    [ 0.00, 316.00, 750.00, 1184.00, 1642.00, 2076.00, 10606.00, 12762.00, 21210.00, 38462.00],
            percentages:   [ 1.10,   2.20,   4.40,    6.60,    8.80,   10.23,    11.33,    12.43,    13.53,    14.63],
            minimum_taxes: [ 0.00,   3.48,   13.02,  32.13,   62.36,  100.55,   973.17,  1213.37,  2267.93,  4602.13]
          },
          married: {
            thresholds:    [ 0.00, 632.00, 1500.00, 2368.00, 3284.00, 4152.00, 21212.00, 25452.00, 38462.00, 42420.00],
            percentages:   [ 1.10,   2.20,    4.40,    6.60,    8.80,   10.23,    11.33,    12.43,    13.53,    14.63],
            minimum_taxes: [ 0.00,   6.95,   26.05,   64.24,  124.70,  201.08,  1946.32,  2426.71,  4043.85,  4579.37]
          },
          head_of_household: {
            thresholds:    [ 0.00, 632.00, 1500.00, 1934.00, 2392.00, 2826.00, 14424.00, 17308.00, 28846.00, 38462.00],
            percentages:   [ 1.10,   2.20,    4.40,    6.60,    8.80,   10.23,    11.33,    12.43,    13.53,    14.63],
            minimum_taxes: [ 0.00,   6.95,   26.05,   45.15,   75.38,  113.57,  1300.05,  1626.81,  3060.98,  4362.02]
          }
        }
      }
    }
  }

  # def fers_code_string_to_percentage(fers_code_string)
  #   p fers_code_string
  #   start_index = fers_code_string.index('-') + 2
  #   end_index   = fers_code_string.length - 2
  #   fers_code_string[start_index..end_index].to_f
  # end

  def biweekly_CA_state_tax(taxable_wages, state_exemptions, home_state, marital_status, additional_state_allowances)
    # Table 1.
    low_income_exemption_table = STATE_PERCENTAGE_METHOD_TABLES[home_state][:low_income_exemption_table][:biweekly]
    if marital_status == :single || marital_status == :head_of_household
      if taxable_wages <= low_income_exemption_table[marital_status]
        return 0
      end
    else
      if state_exemptions <= 1
        if taxable_wages <= low_income_exemption_table[marital_status][:zero_or_one_allowances]
          return 0
        end
      else
        if taxable_wages <= low_income_exemption_table[marital_status][:two_or_more_allowances]
          return 0
        end
      end
    end

    # Table 2.
    estimated_deduction_table = STATE_PERCENTAGE_METHOD_TABLES[home_state][:estimated_deduction_table][:biweekly]
    taxable_wages -= estimated_deduction_table[additional_state_allowances]

    # Table 3.
    standard_deduction_table = STATE_PERCENTAGE_METHOD_TABLES[home_state][:standard_deduction_table][:biweekly]
    if marital_status == :single || marital_status == :head_of_household
      taxable_wages -= standard_deduction_table[marital_status]
    else
      if state_exemptions <= 1
        taxable_wages -= standard_deduction_table[marital_status][:zero_or_one_allowances]
      else
        taxable_wages -= standard_deduction_table[marital_status][:two_or_more_allowances]
      end
    end

    # Table 5.
    thresholds    = STATE_PERCENTAGE_METHOD_TABLES[home_state][:tax_rate_table][:biweekly][marital_status][:thresholds]
    percentages   = STATE_PERCENTAGE_METHOD_TABLES[home_state][:tax_rate_table][:biweekly][marital_status][:percentages]
    minimum_taxes = STATE_PERCENTAGE_METHOD_TABLES[home_state][:tax_rate_table][:biweekly][marital_status][:minimum_taxes]

    index = 0
    thresholds.each_with_index do |threshold, i|
      if taxable_wages <= threshold
        index = i - 1
        break
      elsif taxable_wages > thresholds.last
        index = thresholds.length - 1
      end
    end

    if taxable_wages <= 0
      state_tax = 0
    else
      minimum_tax = minimum_taxes[index]
      percentage = percentages[index]
      threshold = thresholds[index]

      tax = minimum_tax + (percentage / 100) * ( taxable_wages - threshold)
    end

    # Table 4.
    exemption_allowance_table = STATE_PERCENTAGE_METHOD_TABLES[home_state][:exemption_allowance_table][:biweekly]
    tax - exemption_allowance_table[state_exemptions]
  end

  def biweekly_federal_tax(taxable_wages, federal_exemptions, marital_status)
    if marital_status == :head_of_household
      marital_status = :single
    end

    allowance_amount = FEDERAL_PERCENTAGE_METHOD_TABLES[:allowances][:biweekly]
    minimum_taxes    = FEDERAL_PERCENTAGE_METHOD_TABLES[:biweekly][marital_status][:minimum_taxes]
    percentages      = FEDERAL_PERCENTAGE_METHOD_TABLES[:biweekly][marital_status][:percentages]
    thresholds       = FEDERAL_PERCENTAGE_METHOD_TABLES[:biweekly][marital_status][:thresholds]

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
