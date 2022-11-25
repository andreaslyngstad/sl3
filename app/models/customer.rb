require 'validator'
class Customer < ActiveRecord::Base
  # acts_as_paranoid
  include ActiveModel::Validations
  validates_with MadeWithInLimit, on: :create

  # attr_accessible :name,:phone,:email,:address,:created_at,:updated_at, :firm
  belongs_to :firm, :counter_cache => true
  has_many :logs, :dependent => :destroy
  has_many :todos
  has_many :recent_logs, -> {  where('log_date >= ?', Time.zone.now.beginning_of_week).order("log_date DESC") }, :class_name => "Log"
  has_many :projects
  has_many :employees, :dependent => :destroy
  has_many :invoices
  validates_presence_of :name
  scope :order_by_name, -> {order("name ASC")}
end
