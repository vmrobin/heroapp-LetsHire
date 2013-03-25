class CandidatesController < ApplicationController
  def index
    @candidates = Candidate.all
  end

  def show
    @candidate = Candidate.find params[:id]
  end

  def new
    @candidate = Candidate.new
  end

  def edit
    @candidate = Candidate.find params[:id]
  end

  def create
    @candidate = Candidate.new params[:candidate]
    if @candidate.save
      redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully created."
    else
      render :action => 'new'
    end
  end

  def update
    @candidate = Candidate.find params[:id]
    if @candidate.update_attributes(params[:candidate])
      redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully updated."
    else
      render :action => 'edit'
    end
  end
end
