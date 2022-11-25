class User < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with Validator
  validates_with MadeWithInLimit, on: :create

	# has_attached_file :avatar, :styles => { :original => "100x100#", :small => "32x32#" }
	# validates_attachment_size :avatar, :less_than => 2.megabytes
	# validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # :timeoutable


  has_many :recent_logs, -> {  where('log_date >= ?', Time.zone.now.beginning_of_week).order("log_date DESC") }, :class_name => "Log"
  has_many :memberships
  has_many :projects, :through => :memberships
  has_many :logs, :dependent => :destroy
  has_many :todos, :dependent => :destroy
  has_many :done_todos, :class_name => "Todo", :foreign_key => "done_by_user"
  belongs_to :firm, :counter_cache => true
  validates_presence_of :name
  validates :hourly_rate, numericality: true, :allow_nil => true
  validates :email, :presence => true, :email_format => true

  def self.valid_recover?(params)
    token_user = self.where(:loginable_token => params).first
    if token_user
      token_user.loginable_token = nil
      token_user.save
    end
    token_user
  end

  def can_validate?
    role == "external_user"
  end

  def admin?
    role == "Admin"
  end

  def logout_stamp!
    self.current_sign_in_at = nil
    self.current_sign_in_ip = nil
    self.save
  end
  # This is for the image upload. When uploading without a image there are no params. Adding this fake param fixed it
  attr_writer :fake

  def fake
    @fake ||= 'default'
  end

  # def self.valid?(params)
  #   token_user = self.where(:loginable_token => params[:id]).first
  #   if token_user
  #     token_user.loginable_token = nil
  #     token_user.save
  #   end
  #   return token_user
  # end
end
