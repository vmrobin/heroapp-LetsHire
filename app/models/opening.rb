require 'carmen'

class Opening < ActiveRecord::Base
  include Carmen

  attr_accessible :title, :country, :province, :description, :department_id, :status, :hiring_manager_id, :recruiter_id
  belongs_to :department
  belongs_to :hiring_manager, :class_name => "User", :foreign_key => :hiring_manager_id, :readonly => true
  belongs_to :recruiter, :class_name => "User", :foreign_key => :recruiter_id, :readonly => true

  validates :title, :presence => true


  STATUSES = { :active => 1, :draft => 0, :closed => -1 }
  STATUS_STRINGS = STATUSES.invert

  def status_str
    STATUS_STRINGS[status]
  end

  def full_address
    unless country.nil?
      Country.coded(country).try { |country_obj|
        sub_regions = country_obj.subregions
        province_obj = sub_regions.respond_to?(:coded) ?  sub_regions.coded(province) : nil
        logger.debug sub_regions.inspect
        logger.debug province
        if province_obj.nil?
          (province ||  "UNKNOWN") + ', ' + country_obj.name
        else
          province_obj.name.to_s + ',' + country_obj.name
        end
      }
    end
  end

end
