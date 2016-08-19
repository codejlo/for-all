class Candidate < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :race
  has_many :votes

  validates :name, :uniqueness => { :scope => [:state] }
end
