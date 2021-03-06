class Office < ActiveRecord::Base
  belongs_to :division
  has_and_belongs_to_many :politicians
  has_one :race

  validates :name, presence: true
  validates :division_id, presence: true
  
end
