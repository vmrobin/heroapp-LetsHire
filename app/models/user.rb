class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :registerable, :recoverable, :rememberable, :trackable, :validatable
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable

  validates_confirmation_of :password

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  attr_accessible :email, :password, :password_confirmation, :name, :department_id, :roles, :admin

  ROLES = %w[interviewer recruiter hiringmanager]

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

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def roles_string
    roles.join(',')
  end

  def add_role(role)
    self.roles = roles | [role]
  end

  def department_string
    Department.find(self.department_id).name if self.department_id
  end
end
