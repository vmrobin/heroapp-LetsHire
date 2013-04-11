class OpeningCandidateAssessment < ActiveRecord::Base
  attr_accessible :comment, :creator

  belongs_to :opening_candidate
end
