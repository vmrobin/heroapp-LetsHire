class AssessmentsController < ApplicationController
  before_filter { authorize! :manage, Candidate }
  def new
    @opening_candidate = OpeningCandidate.find params[:opening_candidate_id]
    if @opening_candidate
      @assessment = Assessment.new(:opening_candidate_id => @opening_candidate.id,
        :creator => current_user)
      render 'assessments/edit'
    else
      render "static_pages/home", :notice => "The parent doesn't exist anymore"
    end
  end


  # GET /opening_candidates/:opening_candidate_id/assessments/:id/edit
  def edit
    @assessment = Assessment.find(params[:id])

    raise ActiveRecord::RecordNotFound if (params[:opening_candidate_id] != @assessment.opening_candidate_id)
    @opening_candidate = OpeningCandidate.find params[:opening_candidate_id]
    render 'assessments/edit'

  rescue ActiveRecord::RecordNotFound
    render "static_pages/home", :notice => "The object doesn't exist anymore"
  end

  # POST /opening_candidates/:opening_candidate_id/assessments
  # POST /opening_candidates.json
  def create
    @opening_candidate = OpeningCandidate.find(params[:opening_candidate_id])
    @candidate = @opening_candidate.candidate
    @opening_candidate.status = params[:opening_candidate][:status]
    @assessment = @opening_candidate.assessments.build(params[:assessment].merge(:creator => current_user))
    respond_to do |format|
      if @assessment.save && @opening_candidate.save
        format.html { redirect_to @candidate, notice: 'Assessment was successfully made.' }
        format.json { render json: @candidate, status: :created, location: @candidate }
      else
        format.html { render action: "edit" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end

  #rescue ActiveRecord::RecordNotFound
  #  render "static_pages/home", :notice => "The object doesn't exist anymore"
  end

  # PUT /opening_candidates/:opening_candidate_id/assessments/:id
  # PUT /opening_candidates/:opening_candidate_id/assessments/:id.json
  def update
    @assessment = Assessment.find(params[:id])
    if params[:opening_candidate_id] != @assessement.opening_candidate_id
      raise ActiveRecord::RecordNotFound
    end
    @opening_candidate = @assessment.opening_candidate
    @candidate = @opening_candidate.candidate
    @opening_candidate.status = params[:assessment][:status]
    params[:assessment].delete(:status)

    @assessment.creator = current_user
    respond_to do |format|
      if @assessment.update_attributes(params[:assessment]) && @opening_candidate.save
        format.html { redirect_to @candidate, notice: 'Assessment was successfully updated.' }
        format.json { render json: @candidate, status: :created, location: @candidate }
      else
        format.html { render action: "edit" }
        format.json { render json: @assessment.errors, status: :unprocessable_entity }
      end
    end

  rescue ActiveRecord::RecordNotFound
    render "static_pages/home", :notice => "The object doesn't exist anymore"
  end

end
