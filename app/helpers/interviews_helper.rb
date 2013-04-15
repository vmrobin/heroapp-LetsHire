module InterviewsHelper
  def is_interviewer?(interviewers)
    interviewers.each do |interviewer|
      return true if current_user.id == interviewer.user_id
    end
    nil
  end
end
