class CreateParameters < ActiveRecord::Migration[5.1]
  def change
    create_table :parameters do |t|
      t.float :hourly_rate
      t.float :overtime_rate
      t.float :overtime_hours
      t.float :life_insurance_premium
      t.float :vision_insurance
      t.float :health_insurance
      t.float :fsa_contribution
      t.float :non_taxable_additional
      t.float :tax_deferred_additional
      t.integer :federal_exemptions
      t.integer :state_exemptions
      t.integer :additional_state_allowances
      t.string :home_state
      t.string :marital_status
      t.float :tsp_percentage
      t.float :tsp_fixed_amount
      t.float :fers_code
      t.timestamps
    end
  end
end
