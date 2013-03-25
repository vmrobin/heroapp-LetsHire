class Candidate < ActiveRecord::Base
  attr_accessible :name, :email, :phone, :source, :description, :resume

  validates :name, :presence => true
  validates :email, :presence => true

end
