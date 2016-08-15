require 'faker'

user1 = User.create(name: Faker::Name.name, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "633 Folsom Street", city: "San Francisco", state: "CA")
user2 = User.create(name: Faker::Name.name, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "385 29th Street", city: "San Francisco", state: "CA")
user3 = User.create(name: Faker::Name.name, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "4345 Harbor Lane N", city: "Plymouth", state: "MN")
user4 = User.create(name: Faker::Name.name, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "21 Goethe Street", city: "Chicago", state: "IL")
user5 = User.create(name: Faker::Name.name, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "1008 Massachussets Ave", city: "Cambridge", state: "MA")

user1.populate_google_reps
user2.populate_google_reps
user3.populate_google_reps
user4.populate_google_reps
user5.populate_google_reps
