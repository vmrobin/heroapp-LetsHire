class Interview < ActiveRecord::Base
  attr_accessible :assessment, :created_at, :description, :duration, :location, :phone, :scheduled_at, :score, :status, :title, :type, :updated_at

  module Constants
    # interview status constants
    INTERVIEW_STATUS_NEW = "new"
    INTERVIEW_STATUS_PROGRESS = "progress"
    INTERVIEW_STATUS_PENDING = "pending"
    INTERVIEW_STATUS_CLOSED = "closed"

    # interview type constants
    INTERVIEW_TYPE_PHONE = "phone interview"
    INTERVIEW_TYPE_ONSITE = "onsite interview"
  end
  include Constants

  INTERVIEW_TYPES = [INTERVIEW_TYPE_PHONE, INTERVIEW_TYPE_ONSITE]

  INTERVIEW_STATUS = [INTERVIEW_STATUS_NEW, INTERVIEW_STATUS_PROGRESS, INTERVIEW_STATUS_PENDING, INTERVIEW_STATUS_CLOSED]

  validates :type, :title, :scheduled_at, :presence => true
end
