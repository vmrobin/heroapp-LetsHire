class Interview < ActiveRecord::Base
  belongs_to :candidate

  attr_accessible :candidate, :candidate_id
  attr_accessible :title, :modality, :scheduled_at, :scheduled_at_iso, :duration, :phone, :location, :description
  attr_accessible :status, :score, :assessment
  attr_accessible :created_at, :updated_at

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

  validates :candidate_id, :presence => true
  validates :modality, :title, :scheduled_at, :presence => true
  validates :modality, :inclusion => MODALITIES
  validates :status, :inclusion => STATUS

  def scheduled_at_iso
    scheduled_at.iso8601
  end

  def scheduled_at_iso=(val)
    self.scheduled_at = Time.parse val
  end
end
