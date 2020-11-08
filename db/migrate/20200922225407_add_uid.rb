class AddUid < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uid, :string, after: :last_name
    add_column :users, :provider, :string, after: :email
    remove_column :users, :hashed_pwd
  end
end
