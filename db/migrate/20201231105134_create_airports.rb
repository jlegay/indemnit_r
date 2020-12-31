class CreateAirports < ActiveRecord::Migration[6.0]
  def change
    create_table :airports do |t|
      t.string :name
      t.string :city
      t.string :itata_code
      t.float :latitude
      t.float :longitude
      t.boolean :european_union, default: :false

      t.timestamps
    end
  end
end
