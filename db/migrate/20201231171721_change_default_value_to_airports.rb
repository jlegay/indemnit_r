class ChangeDefaultValueToAirports < ActiveRecord::Migration[6.0]
  def change
    remove_column :airports, :european_union
    add_column :airports, :european_union, :boolean
  end
end
