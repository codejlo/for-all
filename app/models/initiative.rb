class Initiative < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :division
  has_many :votes
end
