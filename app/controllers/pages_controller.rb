class PagesController < ApplicationController

  skip_before_action :verify_authenticity_token
  def home
  end

  def indemnities_amount
    departure_a = Airport.where("airports.name LIKE ?", "%#{params[:departure_airport]}%").first
    arrival_a = Airport.where("airports.name LIKE ?", "%#{params[:arrival_airport]}%").first
    departure_coordinates = [departure_a.latitude, departure_a.longitude]
    arrival_coordinates = [arrival_a.latitude, arrival_a.longitude]
    @distance = distance(departure_coordinates, arrival_coordinates)
    @eu_flight = departure_a.european_union && arrival_a.european_union
  end

  def distance(loc1, loc2)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    (rm * c)/1000 # Delta in meters
  end

end
