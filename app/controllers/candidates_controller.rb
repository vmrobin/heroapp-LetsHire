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
    @resume = File.basename(@candidate[:resume])
  end

  def create
    upload_file(params[:candidate][:resume], params[:candidate][:name])
    params[:candidate][:resume] = upload_resume_file(params[:candidate][:name], params[:candidate][:resume].original_filename)

    @candidate = Candidate.new params[:candidate]
    if @candidate.save
      redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully created."
    else
      render :action => 'new'
    end
  end

  def update
    upload_file(params[:candidate][:resume], params[:candidate][:name])
    params[:candidate][:resume] = upload_resume_file(params[:candidate][:name], params[:candidate][:resume].original_filename)

    @candidate = Candidate.find params[:id]
    if @candidate.update_attributes(params[:candidate])
      redirect_to candidates_url, :notice => "Candidate \"#{@candidate.name}\" (#{@candidate.email}) was successfully updated."
    else
      render :action => 'edit'
    end
  end

  def resume
    @candidate = Candidate.find params[:id]
    download_file(@candidate[:resume])
  end

private
  def upload_file(iostream, subfolder)
    begin
      # TODO list
      #   1. upload file size limit
      #   2. eliminate local file storage
      Dir.mkdir(upload_top_folder) unless Dir.exists?(upload_top_folder)
      Dir.mkdir(upload_resume_folder(subfolder)) unless Dir.exists?(upload_resume_folder(subfolder))

      File.open(upload_resume_file(subfolder, iostream.original_filename), 'wb') do |file|
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

  def upload_top_folder
    Rails.root.join('public', 'uploads').to_s
  end

  def upload_resume_folder(subfolder)
    File.join(upload_top_folder, subfolder)
  end

  def upload_resume_file(subfolder, filename)
    File.join(upload_top_folder, subfolder, filename)
  end

end
