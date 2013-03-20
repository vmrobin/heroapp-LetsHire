class Candidate < ActiveRecord::Base
  attr_accessible :name, :email, :phone, :source, :description

  validates :name, :presence => true
  validates :email, :presence => true

end
