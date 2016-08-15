require 'dotenv'
Dotenv.load
require 'open-uri'
require 'json'

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
    p base_url = "https://www.googleapis.com/civicinfo/v2/representatives?address="
    p address = "#{self.parse_address}&"
    p api_key = "key=#{ENV['GOOGLE_CIVIC_API_KEY']}"
    
    p full_request_uri = base_url + address + api_key

    JSON.parse(open(full_request_uri).read)

  end

  def populate_divisions(division_data)
    division_data.keys.each do |division_key|
      p division_key
      p division = Division.find_by(identifier: division_key) || Division.create(identifier: division_key, name: division_data[division_key]["name"])
      p self.divisions << division

    end
  end

  def populate_offices_reps(office_official_data)
    office_official_data["offices"].each_with_index do |office, index|

      division = Division.find_by(identifier: office["divisionId"])
      current_office = Office.find_by(name: office["name"]) || Office.create(name: office["name"])
      division.offices << current_office unless division.offices.include?(current_office)

      politician = Politician.find_by(name: office_official_data["officials"][index]["name"]) || 
                            Politician.create(name: office_official_data["officials"][index]["name"], 
                                         street:office_official_data["officials"][index]["address"][0]["line1"],
                                         city: office_official_data["officials"][index]["address"][0]["city"],
                                         state: office_official_data["officials"][index]["address"][0]["state"],
                                         zip_code: office_official_data["officials"][index]["address"][0]["zip"],
                                         party: office_official_data["officials"][index]["party"],
                                         phone: office_official_data["officials"][index]["phones"][0],
                                         website_url: office_official_data["officials"][index]["urls"][0],
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

