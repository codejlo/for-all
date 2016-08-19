require 'dotenv'
Dotenv.load
require 'open-uri'
require 'json'
require 'pp'

# use http party?

class User < ActiveRecord::Base
  has_and_belongs_to_many :divisions
  has_many :votes

  has_many :active_relationships, class_name: "Relationship",
                    foreign_key: "follower_id",
                    dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                     foreign_key: "followed_id",
                     dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # validate database inputs
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  # include external modules
  include BCrypt

  # implement authentication
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate?(submitted_password)
    self.password == submitted_password
  end

  # create string out of address
  def parse_address
    if self.street && self.city && self.state
      self.street.to_s + "%2C" + self.city.to_s + "%2C" + self.state.to_s
    end
  end

  # get representative data from google
  def fetch_rep_data
    base_url = "https://www.googleapis.com/civicinfo/v2/representatives?address="
    address = "#{self.parse_address}&"
    api_key = "key=#{ENV['GOOGLE_CIVIC_API_KEY']}"
    
    full_request_uri = base_url + address + api_key

    pp JSON.parse(open(full_request_uri).read)
  end

  # populate database with political divisions for user location
  def populate_divisions(division_data)
    division_data.keys.each do |division_key|
      division = Division.find_by(identifier: division_key) || Division.create(identifier: division_key, name: division_data[division_key]["name"])
      self.divisions << division
    end
  end

  # populate offices and representatives based on google data
  def populate_offices_reps(office_official_data)
    reformatted_offices = []

    these_offices = office_official_data["offices"]
    these_offices.map do |office|
      office["officialIndices"].length.times do 
        reformatted_offices << office
      end
    end

    my_officials = office_official_data["officials"]

    reformatted_offices.each_with_index do |office, index|

      division = Division.find_by(identifier: office["divisionId"])
      current_office = Office.find_by(name: office["name"], division_id: division.id) || Office.create(name: office["name"])
      division.offices << current_office unless division.offices.include?(current_office)

      politician = Politician.find_by(name: my_officials[index]["name"],
                                      state: if my_officials[index]["address"] != nil then my_officials[index]["address"][0]["state"] end) || 
                            Politician.create(name: my_officials[index]["name"], 
                                              street: if my_officials[index]["address"] != nil then my_officials[index]["address"][0]["line1"] end,
                                              city: if my_officials[index]["address"] != nil then my_officials[index]["address"][0]["city"] end,
                                              state: if my_officials[index]["address"] != nil then my_officials[index]["address"][0]["state"] end,
                                              zip_code: if my_officials[index]["address"] != nil then my_officials[index]["address"][0]["zip"] end,
                                              party: my_officials[index]["party"],
                                              phone: if my_officials[index]["phones"] != nil then my_officials[index]["phones"][0] end,
                                              website_url: if my_officials[index]["urls"] != nil then my_officials[index]["urls"][0] end,
                                              photo_url: my_officials[index]["photoUrl"],
                                              twitter_id: if my_officials[index]["channels"] != nil &&
                                                             my_officials[index]["channels"].find { |hash| hash["type"] == "Twitter" } != nil
                                                          then my_officials[index]["channels"].find { |hash| hash["type"] == "Twitter" }["id"] end,
                                              status: "active")

      current_office.politicians << politician unless current_office.politicians.include?(politician)
    end 
  end


  # populate ruby objects and database with representative data
  def populate_google_reps(args = {})
    if !self.has_reps || args.fetch(:overwrite, false)
      self.has_reps = true
      
      rep_data = self.fetch_rep_data

      self.populate_divisions(rep_data["divisions"])
      self.populate_offices_reps(rep_data)

    end
  end
end

