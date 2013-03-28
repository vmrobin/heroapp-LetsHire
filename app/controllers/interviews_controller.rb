class InterviewsController < AuthenticatedController
  authorize_resource :class => false

  def index
    authorize! :read, Interview
    @interviews = Interview.all
  end

  def show
    @interview = Interview.find params[:id]
    authorize! :read, @interview
    @candidate = @interview.candidate
  end

  def new
    authorize! :manage, Interview
    @candidate = Candidate.find params[:candidate_id]
    @interview = Interview.new
    @interview.candidate = @candidate
  end

  def edit
    @interview = Interview.find params[:id]
    authorize! :update, @interview
    @candidate = @interview.candidate
  end

  def create
    authorize! :manage, Interview
    @candidate = Candidate.find params[:candidate_id]
    @interview = Interview.new params[:interview]
    @interview.candidate = @candidate
    @interview.status = Interview::STATUS_NEW
    if @interview.save
      redirect_to candidate_path(@candidate), :notice => "Interview created"
    else
      render :action => 'edit'
    end
  end

  def update
    @interview = Interview.find params[:id]
    authorize! :update, @interview
    if @interview.update_attributes(params[:interview])
      redirect_to interviews_url, :notice => "Interview updated"
    else
      render :action => 'edit'
    end
  end
end
