class AirportsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def airports_distance
    @indemnity_reason = params[:indemnity_reason]
    @arrival_delay = params[:arrival_delay]
    @airports = Airport.all.pluck(:name)
    departure_airport = params[:departure_airport]
    arrival_airport = params[:arrival_airport]
  end

end
