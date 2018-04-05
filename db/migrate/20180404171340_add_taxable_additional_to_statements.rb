class AddTaxableAdditionalToStatements < ActiveRecord::Migration[5.1]
  def change
    change_table :statements do |t|
      t.float :taxable_additional
    end
  end
end
