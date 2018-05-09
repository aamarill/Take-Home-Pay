require 'rails_helper'
include CalculationsHelper

RSpec.describe Statement, type: :model do
  let(:user) { create(:user)}
  let(:statement) { create(:statement, user: user) }

  it "has all of its attributes" do
    expect(statement).to have_attributes(
      hourly_rate:                 statement.hourly_rate,
      overtime_rate:               statement.overtime_rate,
      overtime_hours:              statement.overtime_hours,
      life_insurance_premium:      statement.life_insurance_premium,
      vision_insurance:            statement.vision_insurance,
      health_insurance:            statement.health_insurance,
      fsa_contribution:            statement.fsa_contribution,
      non_taxable_additional:      statement.non_taxable_additional,
      tax_deferred_additional:     statement.tax_deferred_additional,
      tsp_percentage:              statement.tsp_percentage,
      tsp_fixed_amount:            statement.tsp_fixed_amount,
      fers_code:                   statement.fers_code,
      taxable_additional:          statement.taxable_additional,
      roth_tsp_percentage:         statement.roth_tsp_percentage,
      roth_tsp_fixed_amount:       statement.roth_tsp_fixed_amount,
      dental_insurance:            statement.dental_insurance,
      federal_exemptions:          statement.federal_exemptions,
      state_exemptions:            statement.state_exemptions,
      additional_state_allowances: statement.additional_state_allowances,
      home_state:                  statement.home_state,
      marital_status:              statement.marital_status,
      user_id:                     statement.user_id
    )
  end

  before do
    @PAY_PERIOD_HOURS    = CalculationsHelper::PAY_PERIOD_HOURS
    @MEDICARE_PERCENTAGE = CalculationsHelper::MEDICARE_PERCENTAGE
    @OASDI_PERCENTAGE    = CalculationsHelper::OASDI_PERCENTAGE

    # Ordered alphabetically
    @additional_state_allowances = statement.additional_state_allowances
    @dental_insurance = statement.dental_insurance
    @federal_exemptions = statement.federal_exemptions
    @federal_tax = statement.federal_tax
    @fers_code = statement.fers_code
    @fers_deduction = statement.fers_deduction
    @fsa_contribution = statement.fsa_contribution
    @gross_pay = statement.gross_pay
    @health_insurance = statement.health_insurance
    @home_state = statement.home_state
    @hourly_rate = statement.hourly_rate
    @life_insurance_premium = statement.life_insurance_premium
    @marital_status = statement.marital_status
    @medicare_deduction = statement.medicare_deduction
    @non_taxable_additional = statement.non_taxable_additional
    @non_taxable_wages = statement.non_taxable_wages
    @oasdi_deduction = statement.oasdi_deduction
    @overtime_rate = statement.overtime_rate
    @overtime_hours = statement.overtime_hours
    @overtime_pay = statement.overtime_pay
    @regular_pay = statement.regular_pay
    @roth_tsp_contribution = statement.roth_tsp_contribution
    @roth_tsp_fixed_amount = statement.roth_tsp_fixed_amount
    @roth_tsp_percentage = statement.roth_tsp_percentage
    @state_exemptions = statement.state_exemptions
    @state_tax = statement.state_tax
    @summed_deductions = statement.summed_deductions
    @tax_deferred_wages = statement.tax_deferred_wages
    @tax_deferred_additional = statement.tax_deferred_additional
    @taxable_wages = statement.taxable_wages
    @taxable_additional = statement.taxable_additional
    @tsp_contribution = statement.tsp_contribution
    @tsp_fixed_amount = statement.tsp_fixed_amount
    @tsp_percentage = statement.tsp_percentage
    @vision_insurance = statement.vision_insurance
  end

  describe "#regular_pay" do
    it "calculates regular (non-overtime) pre-tax wages" do
      expect(statement.regular_pay).to \
        equal(@hourly_rate * @PAY_PERIOD_HOURS)
    end
  end

  describe "#overtime_pay" do
    it "calculates overtime pay" do
      expect(statement.overtime_pay).to \
        equal(@overtime_rate * @overtime_hours)
    end
  end

  describe "#gross_pay" do
    it "adds up regular and overtime pre-tax pay" do
      expect(statement.gross_pay).to \
        equal(@regular_pay + @overtime_pay)
    end
  end

  describe "#non_taxable_wages" do
    it "calculates non-taxable wages" do
      expect(statement.non_taxable_wages).to \
        equal(@health_insurance + @fsa_contribution + @vision_insurance + \
          @non_taxable_additional)
    end
  end

  describe "#tax_deferred_wages" do
    it "calculates tax-deferred wages" do
      expect(statement.tax_deferred_wages).to \
        equal(@tsp_contribution + @tax_deferred_additional)
    end
  end

  describe "#taxable_wages" do
    it "calculates taxable wages" do
      expect(statement.taxable_wages).to \
        eq(@gross_pay - @non_taxable_wages - @tax_deferred_wages)
    end
  end

  describe "#medicare_deduction" do
    it "calculates the Medicare deduction" do
      expect(statement.medicare_deduction).to \
        eq( (@gross_pay - @non_taxable_wages) * @MEDICARE_PERCENTAGE / 100 )
    end
  end

  describe "#fers_deduction" do
    it "calculates the FERS deduction" do
      expect(statement.fers_deduction).to \
        equal(@regular_pay * @fers_code / 100)
    end
  end

  describe "#state_tax" do
    it "calculates the state tax" do
      calculated_state_tax = biweekly_CA_state_tax(
        @taxable_wages,
        @state_exemptions,
        @home_state.to_sym,
        @marital_status.parameterize.underscore.to_sym,
        @additional_state_allowances
      )

      expect(statement.state_tax).to eq(calculated_state_tax)
    end
  end

  describe "#oasdi_deduction" do
    it "calculates the old age, survivors and disability insurance tax" do
      expect(statement.oasdi_deduction).to \
        equal( (@gross_pay - @non_taxable_wages) * @OASDI_PERCENTAGE / 100 )
    end
  end

  describe "#federal_tax" do
    it "calculates federal tax owed" do
      calculated_fed_tax = biweekly_federal_tax(
        @taxable_wages,
        @federal_exemptions,
        @marital_status.parameterize.underscore.to_sym
      )

      expect(statement.federal_tax).to eq(calculated_fed_tax)
    end
  end

  describe "#tsp_contribution" do
    it "calculates the user's tsp contribution" do
      tsp_contribution = statement.tsp_contribution
      if @tsp_fixed_amount && @tsp_fixed_amount > 0
        expect(tsp_contribution).to eq(@tsp_fixed_amount)
      elsif @tsp_percentage
        expect(tsp_contribution).to eq(@regular_pay * @tsp_percentage / 100.0)
      else
        expect(tsp_contribution).to eq(0.0)
      end
    end
  end

  describe "#roth_tsp_contribution" do
    it "calculates the roth TSP contribution" do
      contribution = statement.roth_tsp_contribution

      if @roth_tsp_fixed_amount && @roth_tsp_fixed_amount > 0
        expect(contribution).to eq(@roth_tsp_fixed_amount)
      elsif @roth_tsp_percentage
        expect(contribution).to eq(@regular_pay * @roth_tsp_percentage / 100.0)
      else
        expect(contribution).to eq(0.0)
      end
    end
  end

  describe "#summed_deductions" do
    it "adds up all deductions" do
      deductions = [
        @health_insurance,
        @vision_insurance,
        @dental_insurance,
        @life_insurance_premium,
        @fsa_contribution,
        @medicare_deduction,
        @fers_deduction,
        @oasdi_deduction,
        @state_tax,
        @federal_tax,
        @tsp_contribution,
        @roth_tsp_contribution,
        @non_taxable_additional,
        @taxable_additional
      ]

      expect(statement.summed_deductions).to eq(deductions.sum)
    end
  end

  describe "#take_home_pay" do
    it "calculates the final take-home pay" do
      expect(statement.take_home_pay).to equal(@gross_pay - @summed_deductions)
    end
  end

  describe "#check_for_nil_values" do
    it "turns all blank attributes to '0.0'" do
      # Force an non-string attribute to be 'nil'.
      statement.hourly_rate = nil

      # Change all 'nil' values (only 'hourly_rate' is blank in this case) to
      # be '0.0'.
      statement.check_for_nil_values

      expect(statement.hourly_rate).to equal(0.0)
    end
  end
end
