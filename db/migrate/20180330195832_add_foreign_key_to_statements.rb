class AddForeignKeyToStatements < ActiveRecord::Migration[5.1]
  def change
    change_table :statements do |t|
      t.references :user, foreign_key: true
    end
  end
end
