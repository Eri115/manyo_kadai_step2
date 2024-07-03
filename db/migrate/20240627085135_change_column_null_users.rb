class ChangeColumnNullUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :name, :string, null: false
    change_column :users, :email, :string, null: false
    change_column :users, :password_digest, :string, null: false
    change_column :users, :admin, :boolean, null: false
  end
end
