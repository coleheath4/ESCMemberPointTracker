class AddPasswordDigestToAdminUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :password, after: :username
    add_column :users, :password_digest, :string  
  end

  def down
    remove_column :users, :password_digest
    add_column :users, :password, :string, after: :username
  end
end
