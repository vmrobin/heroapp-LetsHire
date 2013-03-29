class OpeningCandidate < ActiveRecord::Base
  attr_accessible :candidate_id, :opening_id

  belongs_to :candidate
  belongs_to :opening

  validates :candidate_id, :opening_id, :presence => true
end
