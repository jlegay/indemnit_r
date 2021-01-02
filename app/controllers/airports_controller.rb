class AirportsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def airports_distance
    @airports = Airport.all.pluck(:name)
    departure_airport = params[:departure_airport]
    arrival_airport = params[:arrival_airport]
  end

end
