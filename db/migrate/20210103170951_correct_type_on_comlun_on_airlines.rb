class CorrectTypeOnComlunOnAirlines < ActiveRecord::Migration[6.0]
  def change
    remove_column :airlines, :belong_to_eu
    add_column :airlines, :belongs_to_eu, :boolean
  end
end
