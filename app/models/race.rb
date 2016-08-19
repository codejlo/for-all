class Race < ActiveRecord::Base
  # Remember to create a migration!
  has_many :candidates
  has_many :votes
  belongs_to :office
end
