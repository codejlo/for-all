class Politician < ActiveRecord::Base
  # Remember to create a migration!
  has_and_belongs_to_many :offices
end
