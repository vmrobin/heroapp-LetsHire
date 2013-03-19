class User < ActiveRecord::Base
  attr_accessible :email, :password, :name

  validates :email, :presence => true, :uniqueness => true
  validates :password, :presence => true

  def is_admin?
    read_attribute :admin
  end

  def self.new_admin(options = {})
    user = self.new options
    user.assign_attributes({ :admin => true }, :without_protection => true)
    user
  end
end
