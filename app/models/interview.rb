class Interview < ActiveRecord::Base
  attr_accessible :assessment, :created_at, :description, :duration, :location, :phone, :scheduled_at, :score, :status, :title, :type, :updated_at

  INTERVIEW_TYPE = ['phone interview', 'onsite interview']

  validates :type, :title, :scheduled_at, :created_at, :updated_at, :presence => true
end
