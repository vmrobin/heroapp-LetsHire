class Interview < ActiveRecord::Base
  attr_accessible :assessment, :created_at, :description, :duration, :location, :phone, :scheduled_at, :score, :status, :title, :modality, :updated_at

  # interview status constants
  STATUS_NEW      = "new"
  STATUS_PROGRESS = "progress"
  STATUS_PENDING  = "pending"
  STATUS_CLOSED   = "closed"

  # interview modality constants
  MODALITY_PHONE = "phone interview"
  MODALITY_ONSITE = "onsite interview"

  MODALITIES = [MODALITY_PHONE, MODALITY_ONSITE]

  STATUS = [STATUS_NEW, STATUS_PROGRESS, STATUS_PENDING, STATUS_CLOSED]

  validates :modality, :title, :scheduled_at, :presence => true
  validates :modality, :inclusion => MODALITIES
  validates :status, :inclusion => STATUS
end
