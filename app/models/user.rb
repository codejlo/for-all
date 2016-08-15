require 'dotenv'
Dotenv.load
require 'open-uri'
require 'json'
require 'pp'

# use http party?

class User < ActiveRecord::Base
  has_and_belongs_to_many :divisions

  # validate database inputs
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :age, numericality: true

  # include external modules
  include BCrypt

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

  def parse_address
    if self.street && self.city && self.state
      self.street.to_s + "%2C" + self.city.to_s + "%2C" + self.state.to_s
    end
  end

  def fetch_rep_data
    base_url = "https://www.googleapis.com/civicinfo/v2/representatives?address="
    address = "#{self.parse_address}&"
    api_key = "key=#{ENV['GOOGLE_CIVIC_API_KEY']}"
    
    full_request_uri = base_url + address + api_key

    pp JSON.parse(open(full_request_uri).read)

  end

  def populate_divisions(division_data)
    division_data.keys.each do |division_key|
      division = Division.find_by(identifier: division_key) || Division.create(identifier: division_key, name: division_data[division_key]["name"])
      self.divisions << division
    end
  end

  def populate_offices_reps(office_official_data)
    reformatted_offices = []

    these_offices = office_official_data["offices"]
    these_offices.map do |office|
      office["officialIndices"].length.times do 
        reformatted_offices << office
      end
    end

    p "*"*100
    pp reformatted_offices
    p reformatted_offices.length
    p "*"*100
    pp office_official_data["officials"]
    p office_official_data["officials"].length
    p "*"*100

    reformatted_offices.each_with_index do |office, index|

      division = Division.find_by(identifier: office["divisionId"])
      current_office = Office.find_by(name: office["name"], division_id: division.id) || Office.create(name: office["name"])
      division.offices << current_office unless division.offices.include?(current_office)

      politician = Politician.find_by(name: office_official_data["officials"][index]["name"],
                                      state: if office_official_data["officials"][index]["address"] != nil then office_official_data["officials"][index]["address"][0]["state"] end) || 
                            Politician.create(name: office_official_data["officials"][index]["name"], 
                                              street: if office_official_data["officials"][index]["address"] != nil then office_official_data["officials"][index]["address"][0]["line1"] end,
                                              city: if office_official_data["officials"][index]["address"] != nil then office_official_data["officials"][index]["address"][0]["city"] end,
                                              state: if office_official_data["officials"][index]["address"] != nil then office_official_data["officials"][index]["address"][0]["state"] end,
                                              zip_code: if office_official_data["officials"][index]["address"] != nil then office_official_data["officials"][index]["address"][0]["zip"] end,
                                              party: office_official_data["officials"][index]["party"],
                                              phone: if office_official_data["officials"][index]["phones"] != nil then office_official_data["officials"][index]["phones"][0] end,
                                              website_url: if office_official_data["officials"][index]["urls"] != nil then office_official_data["officials"][index]["urls"][0] end,
                                              photo_url: office_official_data["officials"][index]["photoUrl"],
                                              twitter_id: "placeholder",
                                              status: "active")

      current_office.politicians << politician unless current_office.politicians.include?(politician)
    end 
  end

  def populate_google_reps(args = {})
    if !self.has_reps || args.fetch(:overwrite, false)
      self.has_reps = true
      
      rep_data = self.fetch_rep_data

      self.populate_divisions(rep_data["divisions"])
      self.populate_offices_reps(rep_data)

    end
  end
end

