# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require_relative 'disturbed_flight_survey'

puts "Cleaning the database"

Survey.destroy_all

Question.destroy_all

Answer.destroy_all

puts "Database cleaned"

puts "Creating surveys"

create_disturbed_flight_survey


puts "Finished !"
