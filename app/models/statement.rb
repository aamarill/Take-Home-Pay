class Statement < ApplicationRecord
  include CalculationsHelper
  belongs_to :user

  def regular_pay
    hourly_rate * PAY_PERIOD_HOURS
  end

  def overtime_pay
    overtime_rate * overtime_hours
  end

  def gross_pay
    regular_pay + overtime_pay
  end

  def non_taxable_wages
    health_insurance + fsa_contribution + vision_insurance + non_taxable_additional
  end

  def tax_deferred_wages
    tsp_contribution + tax_deferred_additional
  end

  def taxable_wages
    gross_pay - non_taxable_wages - tax_deferred_wages
  end

  def medicare_deduction
    (gross_pay - non_taxable_wages) * MEDICARE_PERCENTAGE / 100
  end

  def fers_deduction
    regular_pay * fers_code / 100
  end

  def state_tax
    biweekly_CA_state_tax(
      taxable_wages,
      state_exemptions,
      home_state.to_sym,
      marital_status.parameterize.underscore.to_sym,
      additional_state_allowances
    )
  end

  def oasdi_deduction
    (gross_pay - non_taxable_wages) * OASDI_PERCENTAGE / 100
  end

  def federal_tax
    biweekly_federal_tax(
      taxable_wages,
      federal_exemptions,
      marital_status.parameterize.underscore.to_sym
    )
  end

  def tsp_contribution
    if tsp_fixed_amount > 0
      tsp_fixed_amount
    else
      regular_pay * tsp_percentage / 100.0
    end
  end

  def roth_tsp_contribution
    if roth_tsp_fixed_amount > 0
      roth_tsp_fixed_amount
    else
      regular_pay * roth_tsp_percentage / 100.0
    end
  end

  def summed_deductions
    deductions = [
      health_insurance,
      vision_insurance,
      dental_insurance,
      life_insurance_premium,
      fsa_contribution,
      medicare_deduction,
      fers_deduction,
      oasdi_deduction,
      state_tax,
      federal_tax,
      tsp_contribution,
      roth_tsp_contribution,
      non_taxable_additional,
      taxable_additional
    ]

    deductions.sum
  end

  def take_home_pay
    gross_pay - summed_deductions
  end

  def check_for_nil_values
    all_attributes = self.attribute_names
    attributes_to_ignore = ["id", "created_at", "updated_at", "user_id"]

    attributes_to_ignore.each do |attribute|
      all_attributes.delete(attribute)
    end
    attributes_to_check = all_attributes

    attributes_to_check.each do |attribute|
      self.send(attribute + "=", 0.0) if self.send(attribute).blank?
    end
  end
end
