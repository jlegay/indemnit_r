class PagesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def home
    survey = Survey.first
    @first_question = survey.questions.first
  end


  def indemnities_amount
    departure_airport = find_airport(params[:departure_airport])
    arrival_airport = find_airport(params[:arrival_airport])

    departure_airport_coordinates = [departure_airport.latitude, departure_airport.longitude]
    arrival_airport_coordinates = [arrival_airport.latitude, arrival_airport.longitude]

    distance = distance(departure_airport_coordinates, arrival_airport_coordinates)

    delay_at_arrival = params[:delay] != nil ? transform_delay(params[:delay]) : 0

    eu_flight = departure_airport.european_union && arrival_airport.european_union

    if !eu_flight
      airline = Airline.where("airlines.name LIKE ?", "%#{params[:airline]}%").first
    end

    if departure_airport.european_union || (airline.belongs_to_eu && arrival_airport.european_union)
      @indemnities = indemnities(distance, eu_flight, delay_at_arrival)
      redirect_to display_indemnities_path(indemnities: @indemnities)
    else
      redirect_to no_indemnities_path
    end
  end


  def display_indemnities
    @indemnities = params[:indemnities]
  end


  private

  def find_airport(airport_name)
    airport = Airport.where("airports.name LIKE ?", "%#{airport_name}%").first
  end

  def transform_delay(delay)
    if params[:delay] == "Moins de 2 heures"
      delay = 1
    elsif params[:delay] == "2 à 3 heures"
      delay = 2
    elsif params[:delay] == "3 à 4 heures"
      delay = 3
    else
      delay = 4
    end
  end

  def indemnities(distance, eu_flight, delay)
    if distance < 1500
      amount = delay == 1? 125 : 250
    else
      if eu_flight || distance < 3500
        if delay == 1 || delay == 2
          amount = 200
        else
          amount = 400
        end
      else
        if delay == 1 || delay == 2 || delay == 3
          amount = 300
        else
          amount = 600
        end
      end
    end
    amount
  end

  def distance(loc1, loc2)
    rad_per_deg = Math::PI/180
    rkm = 6371
    rm = rkm * 1000

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    (rm * c)/1000
  end

end
