class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :host
      t.integer :point_value
      t.datetime :event_date

      t.timestamps
    end
  end
end
