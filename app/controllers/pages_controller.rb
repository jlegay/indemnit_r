class PagesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def home
    survey = Survey.first
    @first_question = survey.questions.first
  end

  def indemnities_amount
    departure_a = Airport.where("airports.name LIKE ?", "%#{params[:departure_airport]}%").first
    arrival_a = Airport.where("airports.name LIKE ?", "%#{params[:arrival_airport]}%").first

    departure_coordinates = [departure_a.latitude, departure_a.longitude]
    arrival_coordinates = [arrival_a.latitude, arrival_a.longitude]

    distance = distance(departure_coordinates, arrival_coordinates)

    airline = Airline.where("airlines.name LIKE ?", "%#{params[:airline]}%").first
    eu_flight = departure_a.european_union && arrival_a.european_union

    if params[:delay] != nil
      if params[:delay] == "Moins de 2 heures"
        delay = 1
      elsif params[:delay] == "2 à 3 heures"
        delay = 2
      elsif params[:delay] == "3 à 4 heures"
        delay = 3
      else
        delay = 4
      end
    else
      delay = 0
    end

    if departure_a.european_union || (airline.belongs_to_eu && arrival_a.european_union)
      @indemnities = indemnities(distance, eu_flight, delay)
      redirect_to display_indemnities_path(indemnities: @indemnities)
    else
      redirect_to no_indemnities_path
    end




  end

  def display_indemnities
    @indemnities = params[:indemnities]
  end


  private

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
