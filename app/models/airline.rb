require 'csv'

class Airline < ApplicationRecord

  def self.create_from_collection
    european_union_countries = ['Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Cyprus', 'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 'Slovakia', 'Slovenia', 'Spain', 'Sweden']
    CSV.foreach('./public/airlines.csv', headers: true, encoding:'UTF-8') do |row|
      belongs_to_eu = false
      if european_union_countries.include?(row[6])
        belongs_to_eu = true
      end
      Airline.create(name: row[1], belongs_to_eu: belongs_to_eu)
    end
  end
end
