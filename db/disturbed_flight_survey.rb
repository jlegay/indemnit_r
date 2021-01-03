
def create_disturbed_flight_survey
  puts "CREATING DISTURBED FLIGHT SURVEY AND QUESTIONS"

  indemnites_vol = Survey.new(name: "Indemnités vol perturbé")
  indemnites_vol.save!

  puts "Survey created!"

  puts "Creating questions and answers"

  # TYPE DE PERTURBATION

  type_perturbation = Question.create(name: "type_perturbation", question_text: "Quel a été votre problème sur le vol ?", survey: indemnites_vol)

  type_perturbation_annulation = Answer.create(answer_text: "Annulé", question: type_perturbation, dependency: "information_annulation")

  type_perturbation_retard = Answer.create(answer_text: "Retardé", question: type_perturbation, dependency: 'duree_retard')

  type_perturbation_refus_embarquement = Answer.create(answer_text: "Refus d'embarquement", question: type_perturbation, dependency: "volontaire_refus_embarquement")


  # QUESTIONNAIRE ANNULATION

  # DELAI DE PREVENANCE

  information_annulation = Question.create(name: "information_annulation", question_text: "Combien de temps avant le départ avez-vous été informé(e) de l'annulation ?", survey: indemnites_vol)

  information_annulation_deux_semaines = Answer.create(answer_text: "Plus de 2 semaines", question: information_annulation, final_answer: true)

  information_annulation_une_semaine = Answer.create(answer_text: "Entre 1 et 2 semaines", question: information_annulation, dependency: "reacheminement_propose_plus_une_semaine")

  information_annulation_moins_une_semaine = Answer.create(answer_text: "Moins d'une semaine", question: information_annulation, dependency: "reacheminement_propose_moins_une_semaine")


  # SI DELAI DE PREVENANCE DE MOINS D'UNE SEMAINE : REACHEMINEMENT PROPOSE ?

  puts "Done"

  reacheminement_propose_moins_une_semaine = Question.create(name: "reacheminement_propose_moins_une_semaine", question_text: "Un réacheminement vous a-t-il été proposé?", survey: indemnites_vol)
  Answer.create(answer_text: "Oui", question: reacheminement_propose_moins_une_semaine, dependency: "conditions_reacheminement_moins_une_semaine_depart")
  Answer.create(answer_text: "Non", question: reacheminement_propose_moins_une_semaine, final_answer: true, open_to_indemnities: true, indemnity_reason: 'cancel one week no replacement')

  # SI DELAI DE PREVENANCE MOINS D'UNE SEMAINE ET REACHEMINEMENT PROPOSE : CONDITIONS REACHEMINEMENT ?

  conditions_reacheminement_moins_une_semaine_depart = Question.create(name: "conditions_reacheminement_moins_une_semaine_depart", question_text: "Le réacheminement proposé vous permettait-il de partir moins de 1 heure avant l'heure de départ initialement prévue ?", survey: indemnites_vol)
  Answer.create(answer_text: "Oui", question: conditions_reacheminement_moins_une_semaine_depart, dependency: "conditions_reacheminement_moins_une_semaine_arrivee")
  Answer.create(answer_text: "Non", question: conditions_reacheminement_moins_une_semaine_depart, final_answer: true, open_to_indemnities: true, indemnity_reason: 'cancel one week')

  conditions_reacheminement_moins_une_semaine_arrivee = Question.create(name: "conditions_reacheminement_moins_une_semaine_arrivee", question_text: "Le réacheminement proposé vous permettait-il d'arriver moins de 2 heures après l'heure d'arrivée initialement prévue ?", survey: indemnites_vol)
  Answer.create(answer_text: "Oui", question: conditions_reacheminement_moins_une_semaine_arrivee, final_answer: true, open_to_indemnities: false)
  Answer.create(answer_text: "Non", question: conditions_reacheminement_moins_une_semaine_arrivee, final_answer: :true, open_to_indemnities: true, indemnity_reason: 'cancel one week')

  # SI DELAI DE PREVENANCE ENTRE 1 ET 2 SEMAINES : REACHEMINEMENT PROPOSE ?

  reacheminement_propose_plus_une_semaine = Question.create(name: "reacheminement_propose_plus_une_semaine", question_text: "Un réacheminement vous a-t-il été proposé?", survey: indemnites_vol)
  Answer.create(answer_text: "Oui", question: reacheminement_propose_plus_une_semaine, dependency: "conditions_reacheminement_plus_une_semaine_depart")
  Answer.create(answer_text: "Non", question: reacheminement_propose_plus_une_semaine, final_answer: true, open_to_indemnities: true, indemnity_reason: 'cancel two weeks no replacement')

  # SI DELAI DE PREVENANCE ENTRE 1 ET 2 SEMAINES ET REACHEMINEMENT PROPOSE : CONDITIONS REACHEMINEMENT ?

  conditions_reacheminement_plus_une_semaine_depart = Question.create(name: "conditions_reacheminement_plus_une_semaine_depart", question_text: "Le réacheminement proposé vous permettait-il de partir moins de 2 heures avant l'heure de départ initialement prévue ?", survey: indemnites_vol)
  Answer.create(answer_text: "Oui", question: conditions_reacheminement_plus_une_semaine_depart, dependency: "conditions_reacheminement_plus_une_semaine_arrivee")
  Answer.create(answer_text: "Non", question: conditions_reacheminement_plus_une_semaine_depart, final_answer: true, open_to_indemnities: true, indemnity_reason: 'cancel two weeks')

  conditions_reacheminement_plus_une_semaine_arrivee = Question.create(name: "conditions_reacheminement_plus_une_semaine_arrivee", question_text: "Le réacheminement proposé vous permettait-il d'arriver moins de 4 heures après l'heure d'arrivée initialement prévue ?", survey: indemnites_vol)
  Answer.create(answer_text: "Oui", question: conditions_reacheminement_plus_une_semaine_arrivee, final_answer: true, open_to_indemnities: false)
  Answer.create(answer_text: "Non", question: conditions_reacheminement_plus_une_semaine_arrivee, final_answer: true, open_to_indemnities: true,  indemnity_reason: 'cancel two weeks')

  # FIN QUESTIONNAIRE ANNULATION

  # QUESTIONNAIRE RETARD

  duree_retard = Question.create(name: 'duree_retard', question_text: "Quelle était la durée du retard ?", survey: indemnites_vol)
  Answer.create(answer_text: 'Moins de 3 heures', question: duree_retard, final_answer: true, open_to_indemnities: false)
  Answer.create(answer_text: 'Plus de 3 heures', question: duree_retard, final_answer: true, open_to_indemnities: true, indemnity_reason: 'delay')

  # QUESTIONNAIRE REFUS D'EMBARQUEMENT

  volontaire_refus_embarquement = Question.create(name: "volontaire_refus_embarquement", question_text: 'Vous êtes-vous porté(e) volontaire pour ne pas embarquer ?', survey: indemnites_vol)
  Answer.create(answer_text: 'Oui', question: volontaire_refus_embarquement, final_answer: true, open_to_indemnities: false)
  Answer.create(answer_text: 'Non', question: volontaire_refus_embarquement, final_answer: true, open_to_indemnities: true, indemnity_reason: 'no boarding')

  # FIN DU QUESTIONNAIRE REFUS D'EMBARQUEMENT

puts "DISTURBED FLIGHT SURVEY CREATED"

end
