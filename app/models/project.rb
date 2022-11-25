class Project < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with Validator
  validates_with MadeWithInLimit, on: :create

  belongs_to :firm, :counter_cache => true
  belongs_to :customer
  has_many :todos, :dependent => :destroy
  has_many :logs
  has_many :recent_logs, -> {  where('log_date >= ?', Time.zone.now.beginning_of_week).order("log_date DESC") }, :class_name => "Log"
  has_many :milestones, :dependent => :destroy
  has_many :invoices
  validates_presence_of :name
  has_many :memberships
  has_many :users, :through => :memberships
  scope :is_active, -> {where(["active = ?", true])}
  scope :is_inactive, -> {where(["active = ?", false])}
  scope :order_by_name, -> {order("name ASC")}
end 