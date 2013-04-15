class CandidatesController < AuthenticatedController
  load_and_authorize_resource :except => [:create, :update]

  def index
    opening = nil
    if (params[:q] && params[:q][:opening_id])
      opening = Opening.find(params[:q][:opening_id])
    end
    if opening
      @candidates = opening.candidates.paginate(:page => params[:page])
    else
      @candidates = Candidate.paginate(:page => params[:page])
    end
  end

  def show
    @candidate = Candidate.find params[:id]
    @resume = File.basename(@candidate.resume) unless @candidate.resume.nil?
  end

  def new
    @candidate = Candidate.new
    @departments = Department.with_at_least_n_openings
  end

  def edit
    @candidate = Candidate.find params[:id]
    @resume = File.basename(@candidate.resume) unless @candidate.resume.nil?
  end


  def assign_opening
    @candidate = Candidate.find params[:id]
    @departments = Department.with_at_least_n_openings
    assigned_departments = get_assigned_departments(@candidate)
    @selected_department_id = assigned_departments[0].try(:id)
    render "candidates/assign_opening"
  end

  def create
    unless params[:candidate][:resume].nil?
      # FIXME: how to handle error if exception between file io and database access?
      upload_file(params[:candidate][:resume], params[:candidate][:name])
      params[:candidate][:resume] = upload_resume_file(params[:candidate][:name], params[:candidate][:resume].original_filename)
    end

    params[:candidate].delete(:department_ids)
    opening_id = params[:candidate][:opening_ids]
    params[:candidate].delete(:opening_ids)
    @candidate = Candidate.new params[:candidate]
    if @candidate.save
      if opening_id
        @candidate.opening_candidates.create(:status =>OpeningCandidate::STATUS_LIST[:interview_loop],
                                                                :opening_id => opening_id)
      end
      redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully created."
    else
      @departments = Department.with_at_least_n_openings
      render :action => 'new'
    end
  end

  #TODO: split the jd-assignment logic from other attribute-modification
  #Don't support remove JD assignment via update API
  #To avoid removing a JD assignment accidentally, should use an independent API.
  def update
    unless params[:candidate][:resume].nil?
      # FIXME: how to handle error if exception between file io and database access?
      upload_file(params[:candidate][:resume], params[:candidate][:name])
      params[:candidate][:resume] = upload_resume_file(params[:candidate][:name], params[:candidate][:resume].original_filename)
    end

    @candidate = Candidate.find params[:id]
    new_opening_id = params[:candidate][:opening_ids].to_i
    opening_candidate = nil
    unless @candidate.opening_ids.index(new_opening_id)
      opening_candidate = @candidate.opening_candidates.build(:status =>OpeningCandidate::STATUS_LIST[:interview_loop],
          :opening_id => new_opening_id)
    end
    params[:candidate].delete(:department_ids)
    params[:candidate].delete(:opening_ids)
    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])  && ( opening_candidate.nil? || opening_candidate.save)
        format.html { redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully updated." }
        format.json { head :no_content }
      else
        @departments = Department.with_at_least_n_openings
        @resume = File.basename(@candidate.resume) unless @candidate.resume.nil?
        assigned_departments = get_assigned_departments(@candidate)
        @selected_department_id = assigned_departments[0].try(:id)
        render :action => 'edit'
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to candidates_url, notice: 'Invalid Candidate'
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
