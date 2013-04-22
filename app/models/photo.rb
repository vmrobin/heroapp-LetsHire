class Photo < ActiveRecord::Base
  mount_uploader :p, PUploader

  attr_accessible :description, :name
end
