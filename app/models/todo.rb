class Todo < ActiveRecord::Base

  include ActiveModel::Validations
  validates_with Validator
  
  belongs_to :customer
  belongs_to :project
  belongs_to :user
  belongs_to :firm
  belongs_to :done_by_user, :class_name => "User", :foreign_key => "done_by_user_id"
  has_many :logs
  validates_presence_of :due
  validates_presence_of :name
  validate :project_must_exist
  validate :user_must_exist
  validate :correct_time

  scope :overdue_and_to_day, -> {not_complete.where(["due <= ?",  Date.current]).order("due").includes(:project)}
  scope :due_to_day, -> {where(due:  Date.current, :completed => false)}

  def correct_time
    errors.add(:due, "is wrong format") if !DateTester.new.date?(due)
  end
  
  def user_must_exist
    errors.add(:user_id, "must be selected.") if user_id.nil? && user.nil?
  end
  
  def project_must_exist
    errors.add(:project_id, "must be selected.") if project_id.nil? && project.nil?
  end
  
  def self.not_complete
    where(:completed => false)
  end
  
  def due_to_day
    Time.zone.now.strftime("%Y%j") == due.strftime("%Y%j") && completed == false
  end
  
  def overdue
    Time.zone.now.in_time_zone.strftime("%Y%j") > due.strftime("%Y%j") && completed == false
  end
end