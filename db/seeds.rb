# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Cleaning the database"

Survey.destroy_all

Question.destroy_all

Answer.destroy_all

puts "Database cleaned"

puts "Creating survey"

indemnites_vol = Survey.new(name: "Indemnités vol perturbé")
indemnites_vol.save!

puts "Survey created!"

puts "Creating questions and answers"

# TYPE DE PERTURBATION

type_perturbation = Question.create(name: "type_perturbation", question_text: "Votre vol a été :", survey: indemnites_vol)

type_perturbation_annulation = Answer.create(answer_text: "Annulé", question: type_perturbation, dependency: "information_annulation")

type_perturbation_retard = Answer.create(answer_text: "Retardé", question: type_perturbation)


# SI ANNULATION : DELAI DE PREVENANCE

information_annulation = Question.create(name: "information_annulation", question_text: "Combien de temps avant le départ prévu avez-vous été informé(e) de l'annulation ?", survey: indemnites_vol)

information_annulation_deux_semaines = Answer.create(answer_text: "Plus de 2 semaines", question: information_annulation, final_answer: true)

information_annulation_une_semaine = Answer.create(answer_text: "Entre 1 et 2 semaines", question: information_annulation, dependency: "reacheminement_propose_plus_une_semaine")

information_annulation_moins_une_semaine = Answer.create(answer_text: "Moins d'une semaine", question: information_annulation, dependency: "reacheminement_propose_moins_une_semaine")


# SI DELAI DE PREVENANCE DE MOINS D'UNE SEMAINE

puts "Done"

reacheminement_propose_moins_une_semaine = Question.create(name: "reacheminement_propose_moins_une_semaine", question_text: "Un réacheminement vous a-t-il été proposé?", survey: indemnites_vol)
Answer.create(answer_text: "Oui", question: reacheminement_propose_moins_une_semaine, dependency: "conditions_reacheminement_moins_une_semaine_depart")
Answer.create(answer_text: "Non", question: reacheminement_propose_moins_une_semaine, final_answer: true, open_to_indemnities: true)

# SI REACHEMINEMENT PROPOSE

conditions_reacheminement_moins_une_semaine_depart = Question.create(name: "conditions_reacheminement_moins_une_semaine_depart", question_text: "Le réacheminement proposé vous permettait-il de partir moins de 4 heures avant l'heure de départ initialement prévue ?", survey: indemnites_vol)
Answer.create(answer_text: "Oui", question: conditions_reacheminement_moins_une_semaine_depart, dependency: "conditions_reacheminement_moins_une_semaine_arrivee")
Answer.create(answer_text: "Non", question: conditions_reacheminement_moins_une_semaine_depart, final_answer: true, open_to_indemnities: true)

conditions_reacheminement_moins_une_semaine_arrivee = Question.create(name: "conditions_reacheminement_moins_une_semaine_arrivee", question_text: "Le réacheminement proposé vous permettait-il d'arriver moins de 2 heures après l'heure d'arrivée initialement prévue ?", survey: indemnites_vol)
Answer.create(answer_text: "Oui", question: conditions_reacheminement_moins_une_semaine_arrivee, dependency: "Aucune indemnité ne vous est dûe par la compagnie pour ce vol")
Answer.create(answer_text: "Non", question: conditions_reacheminement_moins_une_semaine_arrivee, final_answer: true, open_to_indemnities: true)


# SI DELAI DE PREVENANCE ENTRE 1 ET 2 SEMAINES

reacheminement_propose_plus_une_semaine = Question.create(name: "reacheminement_propose_plus_une_semaine", question_text: "Un réacheminement vous a-t-il été proposé?", survey: indemnites_vol)
Answer.create(answer_text: "Oui", question: reacheminement_propose_plus_une_semaine, dependency: "conditions_reacheminement_plus_une_semaine_depart")
Answer.create(answer_text: "Non", question: reacheminement_propose_plus_une_semaine, final_answer: true, open_to_indemnities: true)

# SI REACHEMINEMENT PROPOSE

conditions_reacheminement_plus_une_semaine_depart = Question.create(name: "conditions_reacheminement_plus_une_semaine_depart", question_text: "Le réacheminement proposé vous permettait-il de partir moins de 2 heures avant l'heure de départ initialement prévue ?", survey: indemnites_vol)
Answer.create(answer_text: "Oui", question: conditions_reacheminement_plus_une_semaine_depart, dependency: "conditions_reacheminement_plus_une_semaine_arrivee")
Answer.create(answer_text: "Non", question: conditions_reacheminement_plus_une_semaine_depart, final_answer: true, open_to_indemnities: true)

conditions_reacheminement_plus_une_semaine_arrivee = Question.create(name: "conditions_reacheminement_plus_une_semaine_arrivee", question_text: "Le réacheminement proposé vous permettait-il d'arriver moins de 1 heure après l'heure d'arrivée initialement prévue ?", survey: indemnites_vol)
Answer.create(answer_text: "Oui", question: conditions_reacheminement_plus_une_semaine_arrivee, dependency: "Aucune indemnité ne vous est dûe par la compagnie pour ce vol")
Answer.create(answer_text: "Non", question: conditions_reacheminement_plus_une_semaine_arrivee, final_answer: true, open_to_indemnities: true)



puts "Finished !"
