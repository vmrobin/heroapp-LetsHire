class Api::V1::PhotosController < Api::V1::ApiController


  def upload_file
    puts params
    photo = Photo.new
    photo.p = params[:file]
    photo.save!

    interview_id = params[:interview_id]
    mapping = InterviewPhotoMapping.new
    mapping.interview_id= interview_id
    mapping.photo_id = photo.id
    mapping.photo_uri = photo.p.url
    mapping.save!

    render :json => {:photo_id => photo.id, :p_id => photo.p }, :status => 200
  end

  def get_file
    photo = Photo.find(params[:photo_id])
    stream = photo.p.file.read
    send_data(stream , :filename => 'stream')
  end
end