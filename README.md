L'app permet de déterminer le montant des indemnités qui nous sont dûes en cas de vol perturbé
(annulation, retard, refus d'embarquement).

L'utilisateur répond à un questionnaire pour déterminer son droit ou non à des indemnités
et leur montant.

Le questionnaire est construit en arborescence : la réponse à la qestion précédente
définit la question affichée ensuite.


BASE DE DONNEES


 1/ Surveys

 Attributs : :id, :name
 Has_many :questions

 Chaque survey (1 seul ici) est composé d'un nom (ici 'Indemnités vol perturbé'),
 et plusieurs questions lui sont rattachées.


 2/ Questions

 Attributs: :id, :name, :question_text, survey_id
 Belongs_to :survey
 Has_many :answers

 Chaque question est rattachée à un survey(ici 'Indemnités vol perturbé'), et
 plusieurs réponses lui sont rattachées.


 3/Answers

 Attributs: :id, :answer_text, :question_id, :dependency, :final_answer, :open_to_indemnities, :indemnity_reason
 Belongs_to :question

 Chaque réponse est rattachée à une question. Pour prévoir que le choix de cette réponse
 envoie vers telle question, indiquer le nom de la question dans :dependency.

 :final_answer est true s'il n'y a plus de quesitons ensuite
 :open_to_indemnities est true si l'ensemble de réponses données (i.e. la branche suivie)
 ouvre potentiellement droit à indemnités (à affiner ensuite selon notamment
 le caractère intra ou extra communautaire du vol)
 :indemnity_reason indique le motif d'ouverture aux indemnités (delay, cancel, no boarding)

 L'ensemble des questions, réponses et surveys figurent dans le fichier db/disturbed_flight_survey.rb
 lancé via db:seed.


 4/Airports

 Attributs: :name, :city, :latitude, :longitude, :iata_code, :european_union

 Cette base de données est nécessaire pour les questions sur les aéroports
 de départ et d'arrivée du vol.

 Elle est alimentée par un fichier (public/airports.csv) parsé par la méthode create_from_collection.

 :european_union est true si l'aéroport appartient à l'Union Européenne ou à un des territoires
 concernés par le Réglement Européens (Norvège, Islande, Suisse).


 5/Airlines

 Attributs: :name, :belongs_to_eu

 Cette base de données est nécessaire pour la question concernant la compagnie
 utilisée pour le vol (détermine l'éligibilité ou non aux indemnités).

 Elle est alimentée par un fichier (public/airlines.csv) parsé par la méthode create_from_collection.

 :belongs_to_eu est true si c'ets une compagnie intra-communautaire.


PARCOURS

  Le questionnaire débute sur la home. Les questions se suivent en fonciton
  des réponses choisies par l'utilisateur.
  Une fois que l'utilisateur clique sur une final_answer (liens définis dans views/questions/show/html.erb) :
    - si open_to_indemnities est true, envoyé vers flight_details pour demander les détails
    du vol
    - si open_to_indemnities est false, envoyé vers no_indemnities

  flight_details : formulaire récupérant les informations sur le vol nécessaire pour définir:
    - l'éligibilité finale aux indemnités
    - le montant des indemnités

  Informations demandées :
    - Aéroport de départ
    - Aéroport d'arrivée
    - Compagnie aérienne
    - Eventuellement : retard à l'arrivée en cas de réacheminement

  3 critères sont combinés pour déterminer les indemnités finales :
    - caractère intra/extra communautaire du vol
    - distance parcourue
    - éventuellement : retard à l'arrivée en cas de réacheminement

  Le résultat est affiché :
    - sur display_indemnities.html.erb si éligible à des indemnités (et redirigé
      vers Air Indelnités pour en faire la demande)
    - sur no_indemnities.html.erb si pas éligible

