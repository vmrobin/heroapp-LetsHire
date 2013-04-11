class OpeningCandidate < ActiveRecord::Base
  attr_accessible :candidate, :candidate_id, :opening, :opening_id

  belongs_to :candidate
  belongs_to :opening

  has_many :interviews, :dependent => :destroy
  
  has_many :opening_candidate_assessments, :dependent => :destroy

  validates :candidate_id, :opening_id, :presence => true
end
