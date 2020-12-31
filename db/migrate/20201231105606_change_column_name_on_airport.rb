class ChangeColumnNameOnAirport < ActiveRecord::Migration[6.0]
  def change
    remove_column :airports, :itata_code
    add_column :airports, :iata_code, :string
  end
end
