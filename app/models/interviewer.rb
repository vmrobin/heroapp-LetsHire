class Interviewer < ActiveRecord::Base
  belongs_to :interview
  belongs_to :user

  attr_accessible :interview, :interview_id, :user, :user_id
end
