class CreateInterviewPhotoMappings < ActiveRecord::Migration
  def change
    create_table :interview_photo_mappings do |t|
      t.integer :interview_id
      t.integer :photo_id
      t.integer :p_id

      t.timestamps
    end
  end
end
