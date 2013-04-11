class InterviewsController < AuthorizedController
  def index
    authorize! :read, Interview
    @interviews = Interview.all.to_a.sort_by! { |interview| interview.opening_candidate.candidate.name }
    unless can? :create, Interview
      @interviews.reject! do |interview|
        not interview.interviewers.any? { |interviewer| interviewer.user_id == current_user.id }
      end
    end
  end

  def show
    @interview = Interview.find params[:id]
    authorize! :read, @interview
    @candidate = @interview.opening_candidate.candidate
    @opening = @interview.opening_candidate
  end

  def new
    authorize! :manage, Interview
    @candidate = Candidate.find params[:candidate_id]
    load_openings
    @interview = Interview.new
  end

  def edit
    @interview = Interview.find params[:id]
    authorize! :update, @interview
    @candidate = @interview.opening_candidate.candidate
    @opening = @interview.opening_candidate
    load_openings
  end

  def create
    authorize! :manage, Interview
    if params[:opening_candidate_id].nil?
      redirect_to candidates_path, :notice => "No opening is selected for the candidate"
      return
    end
    @opening = OpeningCandidate.find params[:opening_candidate_id]
    @interview = Interview.new params[:interview]
    @interview.opening_candidate = @opening
    @interview.status = Interview::STATUS_NEW
    if @interview.save
      redirect_to candidate_path(@opening.candidate), :notice => "Interview created"
    else
      render :action => 'edit'
    end
  end

  def update
    @interview = Interview.find params[:id]
    authorize! :update, @interview
    if @interview.update_attributes(params[:interview])
      redirect_to interview_path(@interview), :notice => "Interview updated"
    else
      render :action => 'edit'
    end
  end

  private

  def load_openings
    @openings = OpeningCandidate.find_all_by_candidate_id @candidate.id
    @interviewers = []
    interviewers_hash = {}
    @openings.each do |opening|
      if can? :manage, opening
        interviewers = []
        OpeningParticipant.find_all_by_opening_id(opening.opening_id).each do |participant|
          @interviewers << { :opening => opening, :interviewer => participant.participant }
          interviewers << {
              id: participant.participant.id,
              name: participant.participant.name,
              email: participant.participant.email
          }
        end
        interviewers_hash[opening.id] = interviewers
      end
    end
    @interviewers_json = interviewers_hash.to_json
  end
end
