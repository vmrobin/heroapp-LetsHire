class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :registerable, :recoverable, :rememberable, :trackable, :validatable
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  attr_accessible :email, :password, :name, :department_id, :role

  ROLES = %w[Recruiter HiringManager Interviewer Other]

  validates :name,  :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :email, :email_format => { :message => 'email format error'}

  def admin?
    read_attribute :admin
  end

  # The class method used in seed.rb to create the only admin user
  def self.new_admin(options = {})
    user = self.new options
    user.assign_attributes({ :admin => true }, :without_protection => true)
    user
  end


  def self.hiringManagers
    #fixme  Need narrow down the scope once Role is ready
    all
  end

end
