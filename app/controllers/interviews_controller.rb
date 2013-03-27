class InterviewsController < ApplicationController
  def index
    @interviews = Interview.all
  end

  def show
    @interview = Interview.find params[:id]
  end

  def new
    @interview = Interview.new
  end

  def edit
    @interview = Interview.find params[:id]
  end

  def create
    @interview = Interview.new params[:interview]
    @interview.status = Interview::STATUS_NEW
    if @interview.save
      redirect_to interviews_url, :notice => "Interview created"
    else
      render :action => 'edit'
    end
  end

  def update
    @interview = Interview.find params[:id]
    if @interview.update_attributes(params[:interview])
      redirect_to interviews_url, :notice => "Interview updated"
    else
      render :action => 'edit'
    end
  end
end
