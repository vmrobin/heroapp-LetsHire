class OpeningCandidate < ActiveRecord::Base
  attr_accessible :candidate, :candidate_id, :opening, :opening_id, :status

  belongs_to :candidate
  belongs_to :opening

  has_many :interviews, :dependent => :destroy
  
  has_many :opening_candidate_assessments, :dependent => :destroy

  validates :candidate_id, :opening_id, :presence => true


  STATUS_LIST = { :interview_loop => 1,
                  :fail => 2,
                  :quit => 3,
                  :offer_pending => 7,
                  :offer_sent => 8,
                  :offer_declined => 9,
                  :offer_accepted => 10}

  STATUS_STRINGS = STATUS_LIST.invert

  NORMAL_STATUS_CONVERSION_HASH = {
      :interview_loop => [:fail, :quit, :offer_pending],
      :offer_pending => [:offer_sent, :interview_loop],
      :offer_sent => [:offer_declined, :offer_accepted]
  }

  def status_str
    if status.nil?
      return "interview unscheduled"
    elsif STATUS_STRINGS[status] == :interview_loop
      if interviews.count == 0
        return "interview unscheduled"
      else
        return Interview.overall_status(interviews)
      end
    else
      STATUS_STRINGS[status]
    end
  end

end
