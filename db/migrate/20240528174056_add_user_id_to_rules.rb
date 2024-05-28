class AddUserIdToRules < ActiveRecord::Migration[6.1]
  def change
    add_reference :rules, :user, foreign_key: true
  end
end
