class Assessment < ActiveRecord::Base
  attr_accessible :comment, :creator, :opening_candidate_id

  belongs_to :opening_candidate

  validates :comment, :length => { :minimum => 1 }

  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id, :readonly => true
end
