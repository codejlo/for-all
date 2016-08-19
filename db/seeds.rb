require 'faker'
require 'csv'
require "awesome_print"


### SEED USERS & RELATED POLITICIANS ###

20.times do
  user = User.create(name: Faker::Name.name, party: ["Democratic", "Republican", "Independent"].sample, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "633 Folsom Street", city: "San Francisco", state: "CA")
  user.populate_google_reps
end

20.times do
  user = User.create(name: Faker::Name.name, party: ["Democratic", "Republican", "Independent"].sample, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "385 29th Street", city: "San Francisco", state: "CA")
  user.populate_google_reps
end

1.times do
  user = User.create(name: Faker::Name.name, party: ["Democratic", "Republican", "Independent"].sample, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "4345 Harbor Lane N", city: "Plymouth", state: "MN")
  user.populate_google_reps
end

1.times do
  user = User.create(name: Faker::Name.name, party: ["Democratic", "Republican", "Independent"].sample, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "21 Goethe Street", city: "Chicago", state: "IL")
  user.populate_google_reps
end

1.times do
  user = User.create(name: Faker::Name.name, party: ["Democratic", "Republican", "Independent"].sample, age: rand(21..67), email: Faker::Internet.email, password: "asdf", street: "1008 Massachussets Ave", city: "Cambridge", state: "MA")
  user.populate_google_reps
end



### SEED CANDIDATE DATA ###

candidate_data = []
CSV.foreach("db/resources/FEC-Clean.csv") do |row|
  candidate_data << row
end

headers = candidate_data.shift

candidate_data.map! { |row| Hash[headers.zip(row)] }

# Set associations
candidate_data.each do |this_candidate|
  division = Division.find_or_create_by(identifier: this_candidate["divisionId"])
  office = Office.find_or_create_by(name: this_candidate["office_name"])
  division.offices << office unless division.offices.include?(office)

  race = Race.find_or_create_by(office_name: this_candidate["office_name"], division: this_candidate["divisionId"], office_id: office.id)

  candidate = Candidate.create(name: this_candidate["name"],
                               party: this_candidate["can_par_aff"],
                               state: this_candidate["state"],
                               fecId: this_candidate["FEC_id"],
                               fec_url: this_candidate["FEC_url"])
  race.candidates << candidate unless race.candidates.include?(candidate)
end



### SEED INITIATIVE DATA ###

initiative_data = []

CSV.foreach("db/resources/california_propositions.csv") do |row|
  initiative_data << row
end

headers = initiative_data.shift

initiative_data.map! { |row| Hash[headers.zip(row)] }

# Set associations
initiative_data.each do |this_initiative|
  division = Division.find_or_create_by(identifier: this_initiative["Division"])

  initiative = Initiative.create(title: this_initiative["Title"],
                               subject: this_initiative["Subject"],
                               description: this_initiative["Description"])
  division.initiatives << initiative unless division.initiatives.include?(initiative)
end


### SEED VOTING DATA ###

users = User.all

users.each do |user|

  divisions = user.divisions
  initiatives = divisions.select { |division| division.initiatives }.map { |division| division.initiatives }.flatten
  offices = divisions.map { |division| division.offices }.flatten
  races = offices.select { |office| office.race }.map { |office| office.race }

  races.each do |race|
    candidates = race.candidates
    vote = Vote.create()
    user.votes << vote
    race.votes << vote
    candidates.sample.votes << vote
  end

  initiatives.each do |initiative|
    vote = Vote.create(initiative_selection: ['yes', 'no'].sample)
    user.votes << vote
    initiative.votes << vote
  end

end
