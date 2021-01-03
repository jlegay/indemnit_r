class PagesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def home
    survey = Survey.first
    @first_question = survey.questions.first
  end

  def flight_details
    # Affiche le questionnaire concernant:
      # les aéroports de départ et d'arrivée
      # la compagnie aérienne utilisée
      # la durée du retard à l'arrivée en cas de réacheminement
    @indemnity_reason = params[:indemnity_reason]
    @arrival_delay = params[:arrival_delay]
    @airports = Airport.all.pluck(:name)
    @airlines = Airline.all.pluck(:name)
    departure_airport = params[:departure_airport]
    arrival_airport = params[:arrival_airport]
  end


  def indemnities_amount
    #Défini si des indemnités sont dûes et leur montant en fonction:
      # de la distance parcourue
      # du caractère intra ou extracommunautaire du vol
      # du retard à l'arrivée en cas de réacheminement

    # Calcul de la distance parcourue
    departure_airport = find_airport(params[:departure_airport])
    arrival_airport = find_airport(params[:arrival_airport])

    departure_airport_coordinates = [departure_airport.latitude, departure_airport.longitude]
    arrival_airport_coordinates = [arrival_airport.latitude, arrival_airport.longitude]

    distance = distance(departure_airport_coordinates, arrival_airport_coordinates)


    # En cas d'annulation du vol : détermine le retard à l'arrivée du vol de réacheminement

    delay_at_arrival = params[:delay] != nil ? transform_delay(params[:delay]) : 0


    # Détermine le caractère intra ou extra communautaire du vol

    eu_flight = departure_airport.european_union && arrival_airport.european_union

    # Si vol extracommunautaire, recherche la compagnie aérienne pour déterminer si communautaire
    if !eu_flight
      airline = Airline.where("airlines.name LIKE ?", "%#{params[:airline]}%").first
    end

    # Si indemnités dûes : calcule le montant et redirige vers la page d'affichage du montant,
    # sinon affiche que rien n'est dû
    if departure_airport.european_union || (airline.belongs_to_eu && arrival_airport.european_union)
      @indemnities = indemnities(distance, eu_flight, delay_at_arrival)
      redirect_to display_indemnities_path(indemnities: @indemnities)
    else
      redirect_to no_indemnities_path
    end
  end


  def display_indemnities
    # Si des indemnités sont dûes, affiche leur montant
    @indemnities = params[:indemnities]
  end


  private

  def find_airport(airport_name)
    # Trouve l'aéroport correspondant à l'input de l'utilisateur dans la base
    airport = Airport.where("airports.name LIKE ?", "%#{airport_name}%").first
  end

  def transform_delay(delay)
    # Si applicable, transforme l'input de l'utilisateur concernant le retard à l'arrivée
    # en integer pour utilisation par la méthode indemnities
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
    # Calcule le montant des indemnitiés dûes
    if distance < 1500
    # Vols de moins de 1500km
      amount = delay == 1? 125 : 250
      # Montant divisé par 2 si retard à l'arrivée de moins de 2 heures
    else
      if eu_flight || distance < 3500
      # Vols intracommunautaires ou extracommunautaires de moins de 3500 km
        if delay == 1 || delay == 2
          # Montant divisé par 2 si retard à l'arrivée de moins de 3 heures
          amount = 200
        else
          amount = 400
        end
      else
      # Vols extracommunautaires de plus de 3500km
        if delay == 1 || delay == 2 || delay == 3
          # Montant divisé par 2 si retard à l'arrivée de moins de 4 heures (réacheminement)
          amount = 300
        else
          amount = 600
        end
      end
    end
    amount
  end

  def distance(loc1, loc2)
    #Calcule la distance entre les 2 aéroports
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
