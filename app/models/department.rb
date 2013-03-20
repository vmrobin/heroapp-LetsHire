class Department < ActiveRecord::Base
  attr_accessible :description, :name
  validates_uniqueness_of :name
  has_many :openings
end
