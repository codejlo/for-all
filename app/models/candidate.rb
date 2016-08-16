class Candidate < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :race
end
