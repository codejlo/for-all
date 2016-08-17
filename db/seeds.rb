require 'faker'
require 'csv'
require "awesome_print"

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

# CSV::Converters[:blank_to_nil] = lambda do |field|
#   field && field.empty? ? nil : field
# end

# p csv = CSV.new("FEC-Clean.csv", :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil])

# p candidates = csv.to_a.map {|row| row.to_hash }


candidate_data = []
CSV.foreach("db/resources/FEC-Clean.csv") do |row|
  candidate_data << row
end

headers = candidate_data.shift

candidate_data.map! { |row| Hash[headers.zip(row)] }

ap candidate_data

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


initiative_data = []
CSV.foreach("db/resources/california_propositions.csv") do |row|
  initiative_data << row
end

headers = initiative_data.shift

initiative_data.map! { |row| Hash[headers.zip(row)] }

ap initiative_data

initiative_data.each do |this_initiative|
  division = Division.find_or_create_by(identifier: this_initiative["Division"])

  initiative = Initiative.create(title: this_initiative["Title"],
                               subject: this_initiative["Subject"],
                               description: this_initiative["Description"])
  division.initiatives << initiative unless division.initiatives.include?(initiative)
end
