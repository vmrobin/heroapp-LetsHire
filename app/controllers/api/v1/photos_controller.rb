class Api::V1::PhotosController < Api::V1::ApiController


  def upload_file
    puts params
    photo = Photo.new
    photo.p = params[:file]
    photo.save!
    render :json => {:photo_id => photo.id, :p_id => photo.p }, :status => 200
  end

  def get_file
    photo = Photo.find(params[:photo_id])
    stream = photo.p.file.read
    send_data(stream , :filename => 'stream')
  end
end