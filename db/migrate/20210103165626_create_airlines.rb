class CreateAirlines < ActiveRecord::Migration[6.0]
  def change
    create_table :airlines do |t|
      t.string :name
      t.boolean :belong_to_eu

      t.timestamps
    end
  end
end
