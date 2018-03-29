class CreateCalculations < ActiveRecord::Migration[5.1]
  def change
    create_table :calculations do |t|
      t.float :gross_pay
      t.float :taxable_wages
      t.float :non_taxable_wages
      t.float :tax_deferred_wages
      t.float :deductions
      t.float :take_home_pay
      t.float :regular_pay
      t.float :overtime_pay
      t.float :medicare_deduction
      t.float :fers_deduction
      t.float :state_tax
      t.float :oasdi_deduction
      t.float :federal_tax
      t.float :tsp_contribution
      t.timestamps
    end
  end
end
