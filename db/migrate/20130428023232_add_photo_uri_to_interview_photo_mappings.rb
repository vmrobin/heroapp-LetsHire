class AddPhotoUriToInterviewPhotoMappings < ActiveRecord::Migration
  def change
    add_column :interview_photo_mappings, :photo_uri, :string
  end
end
