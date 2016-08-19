class Vote < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :user
  belongs_to :race
  belongs_to :candidate
  belongs_to :initiative

  #validates :candidate, :uniqueness => {:scope => [:user, :race]}
  #validates :initiative_selection, :uniqueness => {:scope => [:user, :initiative]}
end
