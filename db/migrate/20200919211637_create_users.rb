# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :username
      t.string :password
      t.string :hashed_pwd
      t.boolean :is_admin
      t.integer :points
      t.integer :events, array: true

      t.timestamps
    end
  end
end
