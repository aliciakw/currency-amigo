class CreateRules < ActiveRecord::Migration[6.1]
  def change
    create_table :rules do |t|
      t.string :base_currency
      t.string :quote_currency
      t.float :multiplier
      t.string :comparison_operator

      t.timestamps
    end
  end
end
