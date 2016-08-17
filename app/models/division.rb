class Division < ActiveRecord::Base
  # Remember to create a migration!
  has_and_belongs_to_many :users
  has_many :offices
  has_many :initiatives
end
