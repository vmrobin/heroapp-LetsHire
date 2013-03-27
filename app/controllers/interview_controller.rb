class InterviewController < AuthenticatedController
  rescue_from Exception, :with => :handle_exceptions
  authorize_resource :class => false

  def edit
    @user = "Mrs. Nya Treutel"
  end

  def create
    args = params[:interview]

    interview = {}
    [:type, :title, :description, :duration, :location].each do |field|
      interview[field] = args[field]
    end
    interview[:status]       = Interview::INTERVIEW_STATUS_NEW
    interview[:phone]        = "#{args[:phone_num]}-#{args[:phone_ext]}"
    interview[:scheduled_at] = DateTime.parse("#{args[:date]}-#{args[:time]}")

    @interview = Interview.new(interview)
    respond_to do |format|
      if @interview.save
        format.html {flash[:notice] = "Succeed to create interview."}
        format.json {render :json => @interview, :status => 'created', :location => @interview}
      else
        flash[:error] = "Failed to create interview, #{@interview.errors.full_messages}."
        format.html {render :action => "edit"}
        format.json {render :json => @interview.errors, :status => :unprocessable_entity}
      end
    end
  end

private
  def handle_exceptions(error)
    render :file => File.join(Rails.root, 'public', '500.html'), :layout => false, :status => 500
  end
end
