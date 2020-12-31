require 'csv'

class Airport < ApplicationRecord

  def self.create_from_collection
    european_union_iso_codes = ['DE', 'BE', 'FR', 'IT', 'LU', 'NL', 'DK', 'IE', 'GB', 'GR', 'ES', 'PT', 'AT', 'FI', 'SE', 'CY', 'EE', 'HU', 'LV', 'LT', 'MT', 'PL', 'CZ', 'SK', 'SI', 'BG', 'RO', 'HR']
    CSV.foreach('./public/airport_codes_csv.csv') do |row|
      if row[9] != nil
        lat = row[11].split(", ")[0].to_f
        long = row[11].split(", ")[1].to_f
        belongs_to_eu = false
        if european_union_iso_codes.include?(row[5])
          belongs_to_eu = true
        end
        Airport.create(name: row[2], city: row[7], iata_code: row[9], latitude: lat, longitude: long, european_union: belongs_to_eu)
      end
    end
  end

end
