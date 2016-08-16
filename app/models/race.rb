class Race < ActiveRecord::Base
  # Remember to create a migration!
  has_many :candidates
  belongs_to :office
end
