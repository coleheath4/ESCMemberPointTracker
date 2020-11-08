class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :name
      t.string :description
      t.integer :points_required
      t.datetime :when

      t.timestamps
    end
  end
end
