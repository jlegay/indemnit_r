require 'csv'

class Airport < ApplicationRecord

  def self.create_from_collection
    # Crée en base (à partir du fichier csv correspondant) la liste des aéroports
    # en indiquant pour chacun si c'est un aéroport européen (UE + Norvège, Islande, Suisse) ou non
    european_union_iso_codes = ['DE', 'BE', 'FR', 'IT', 'LU', 'NL', 'DK', 'IE', 'GR', 'ES', 'PT', 'AT', 'FI', 'SE', 'CY', 'EE', 'HU', 'LV', 'LT', 'MT', 'PL', 'CZ', 'SK', 'SI', 'BG', 'RO', 'HR', 'NO', 'IS', 'CH', 'BQ', 'GP', 'GF', 'MQ', 'RE', 'YT', 'MF', 'SX', 'NC', 'PF', 'PM', 'TF', 'WF']
    CSV.foreach('./public/airports.csv', headers: true, encoding:'UTF-8') do |row|
      belongs_to_eu = false
      if row[13] != nil
        if european_union_iso_codes.include?(row[8])
          belongs_to_eu = true
        end
        Airport.create(name: row[3], city: row[10], iata_code: row[13], latitude: row[4], longitude: row[5], european_union: belongs_to_eu)
      end
    end
  end

end
