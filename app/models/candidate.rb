class Candidate < ActiveRecord::Base
  attr_accessible :name, :email, :phone, :source, :description, :resume

  validates :name, :presence => true
  validates :email, :presence => true

  has_many :interviews
  has_many :opening_candidates, :class_name => "OpeningCandidate"
  has_many :openings, :class_name => "Opening", :through => :opening_candidates
end
