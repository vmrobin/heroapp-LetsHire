class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :registerable, :recoverable, :rememberable, :trackable, :validatable
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable

  validates_confirmation_of :password

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  attr_accessible :email, :password, :password_confirmation, :name, :department_id, :roles, :remember_me

  ROLES = %w[interviewer recruiter hiring_manager]

  validates :name,  :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :email, :email_format => { :message => 'email format error'}


  has_many :openings_to_be_interviewed, :through => :opening_participants
  has_many :opening_participants, :inverse_of => :participant, :dependent => :destroy

  def admin?
    read_attribute :admin
  end

  def self.name2role(name)
    offset = ROLES.index(name.to_s)
    offset ? 2**offset : 0
  end

  def has_role?(role_name)
    admin? || (roles_mask & User::name2role(role_name) ) != 0
  end

  # The class method used in seed.rb to create the only admin user
  def self.new_admin(options = {})
    user = self.new options
    user.assign_attributes({ :admin => true }, :without_protection => true)
    user
  end

  def self.users_with_role(role_name)
    role_mask = name2role(role_name)
    all.select { |user|  user.admin? || (user.roles_mask & role_mask) != 0}
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
