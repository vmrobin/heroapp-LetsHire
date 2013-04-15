class OpeningCandidate < ActiveRecord::Base
  attr_accessible :candidate, :candidate_id, :opening, :opening_id, :status

  belongs_to :candidate
  belongs_to :opening

  has_many :interviews, :dependent => :destroy
  
  has_many :assessments, :dependent => :destroy

  validates :candidate_id, :opening_id, :presence => true


  #Don't change order randomly. order matters.
  STATUS_LIST = { :interview_loop => 1,
                  :fail => 2,
                  :quit => 3,
                  :offer_pending => 7,
                  :offer_sent => 8,
                  :offer_declined => 9,
                  :offer_accepted => 10}

  STATUS_STRINGS = STATUS_LIST.invert

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

  def next_status_options
    STATUS_LIST
  end


  def in_interview_loop?
    status == OpeningCandidate::STATUS_LIST[:interview_loop]
  end

end
