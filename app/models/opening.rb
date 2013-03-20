require 'carmen'
include Carmen

class Opening < ActiveRecord::Base
  attr_accessible :title, :country, :description, :state, :department_id
  belongs_to :department


  def full_address
    unless country.nil?
      country_obj = Country.coded(country)
      unless country_obj.nil?
        country_name = country_obj.official_name
        state_obj = country_obj.subregions.coded(state)
        if state_obj.nil?
          state.to_s + ', ' + country_name
        else
          state_obj.name.to_s + ',' + country_name
        end
      end

    end
  end

end
