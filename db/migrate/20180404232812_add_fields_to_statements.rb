class AddFieldsToStatements < ActiveRecord::Migration[5.1]
  def change
    change_table :statements do |t|
      t.float :roth_tsp_percentage
      t.float :roth_tsp_fixed_amount
      t.float :dental_insurance
    end
  end
end
