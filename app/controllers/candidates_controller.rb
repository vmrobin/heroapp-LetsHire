class CandidatesController < AuthenticatedController
  load_and_authorize_resource :except => [:create, :update]

  def index
    @candidates = Candidate.all
  end

  def show
    @candidate = Candidate.find params[:id]
    @interviews = []
    @candidate.opening_candidates.each do |opening_candidates|
      @interviews.concat opening_candidates.interviews.all.to_a
    end
    @interviews.sort_by! { |interview| interview.scheduled_at }
    @resume = File.basename(@candidate.resume) unless @candidate.resume.nil?
  end

  def new
    @candidate = Candidate.new
    @departments = Department.with_at_least_n_openings
    @selected_department_id = @departments[0].id if @departments.size > 0
  end

  def edit
    @candidate = Candidate.find params[:id]
    @departments = Department.with_at_least_n_openings
    @resume = File.basename(@candidate.resume) unless @candidate.resume.nil?
    @assigned_departments = get_assigned_departments(@candidate)
    @selected_department_id = @assigned_departments[0].id if @assigned_departments.size > 0
    @selected_department_id ||= @departments[0].id if @departments.size > 0
  end

  def create
    unless params[:candidate][:resume].nil?
      # FIXME: how to handle error if exception between file io and database access?
      upload_file(params[:candidate][:resume], params[:candidate][:name])
      params[:candidate][:resume] = upload_resume_file(params[:candidate][:name], params[:candidate][:resume].original_filename)
    end

    params[:candidate].delete(:department_ids)
    opening_id = params[:candidate].delete(:opening_ids)

    @candidate = Candidate.new params[:candidate]

    error = true
    ActiveRecord::Base.transaction do
      if @candidate.save
        # NOTE: There might be no opening positions.
        unless opening_id.nil?
          if not @candidate.opening_candidates.create(:opening_id => opening_id)
            # exception will trigger transaction do rollback
            raise ActiveRecord::Rollback
          end
        end
        error = false
      else
        raise ActiveRecord::Rollback
      end
    end

    if not error
      redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully created."
    else
      @departments = Department.with_at_least_n_openings
      @selected_department_id = @departments[0].id if @departments.size > 0
      render :action => 'new'
    end
  end

  def update
    unless params[:candidate][:resume].nil?
      # FIXME: how to handle error if exception between file io and database access?
      upload_file(params[:candidate][:resume], params[:candidate][:name])
      params[:candidate][:resume] = upload_resume_file(params[:candidate][:name], params[:candidate][:resume].original_filename)
    end

    params[:candidate].delete(:department_ids)
    # FIXME: Currently one candidate cannot be assigned to multiple opening positions on web UI.
    new_opening_id = params[:candidate].delete(:opening_ids)

    @candidate = Candidate.find params[:id]
    @opening_candidates = @candidate.opening_candidates
    old_opening_id = nil
    old_opening_id = @opening_candidates[0].opening_id if @opening_candidates.size > 0

    error = true
    ActiveRecord::Base.transaction do
      if @candidate.update_attributes(params[:candidate])
        # NOTE: Candidate might not have been assigned opening positions.
        if old_opening_id.nil?
          # assign a new opening position to candidate
          if not new_opening_id.nil?
            if not @candidate.opening_candidates.create(:opening_id => new_opening_id)
              raise ActiveRecord::Rollback
            end
          end
        else
          if not new_opening_id.nil?
            # update the assigned opening position
            if not @candidate.opening_candidates.where(:opening_id => old_opening_id).update_all(:opening_id => new_opening_id)
              raise ActiveRecord::Rollback
            end
          else
            # delete the assigned opening position
            if not @candidate.opening_candidates.delete(@opening_candidates[0])
              raise ActiveRecord::Rollback
            end
          end
        end
        error = false
      else
        raise ActiveRecord::Rollback
      end
    end

    if not error
      redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully updated."
    else
      @departments = Department.with_at_least_n_openings
      @resume = File.basename(@candidate.resume) unless @candidate.resume.nil?
      @assigned_departments = get_assigned_departments(@candidate)
      @selected_department_id = @assigned_departments[0].id if @assigned_departments.size > 0
      @selected_department_id ||= @departments[0].id if @departments.size > 0
      render :action => 'edit'
    end
  end

  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy

    remove_file(@candidate.resume)
    redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully deleted."
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, notice: 'Invalid user'
  rescue
    redirect_to candidates_url, :error => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) cannot be deleted."
  end

  def opening_options
    @selected_department_id = params[:selected_department_id]
    render :partial => 'opening_select'
  end

  def resume
    @candidate = Candidate.find params[:id]
    download_file(File.join(upload_top_folder, @candidate.resume))
  end

private
  def get_assigned_departments(candidate)
    opening_candidates = candidate.opening_candidates
    # NOTE: Currently one candidate cannot be assigned to multiple opening jobs on web UI
    assigned_departments = []
    if opening_candidates.size > 0
      opening_id = opening_candidates[0].opening_id
      assigned_departments = Department.joins(:openings).where( "openings.id = ?", opening_id )
    end
    return assigned_departments
  end

  def upload_file(iostream, subfolder)
    begin
      # TODO list
      #   1. upload file size limit
      #   2. eliminate local file storage
      Dir.mkdir(upload_top_folder) unless Dir.exists?(upload_top_folder)
      Dir.mkdir(upload_resume_folder(subfolder)) unless Dir.exists?(upload_resume_folder(subfolder))

      File.open(File.join(upload_resume_folder(subfolder), iostream.original_filename), 'wb') do |file|
        file.write(iostream.read)
      end
      return true
    rescue => error
      puts "===> #{error}"
      return false
    end
  end

  def download_file(filepath)
    mimetype = MIME::Types.type_for(filepath)
    filename = File.basename(filepath)
    send_file(filepath, :filename => filename, :type => "#{mimetype[0]}", :disposition => "inline")
  end

  def remove_file(resume_file)
    filepath = File.join(upload_top_folder, resume_file)
    File.delete(filepath) if File.exists?(filepath)
  end

  def upload_top_folder
    Rails.root.join('public', 'uploads').to_s
  end

  def upload_resume_folder(subfolder)
    File.join(upload_top_folder, subfolder)
  end

  def upload_resume_file(subfolder, filename)
    File.join('/', subfolder, filename)
  end

end
