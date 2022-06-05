class AddAuthTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :auth_type, :integer
  end
end
