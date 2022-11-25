class Milestone < ActiveRecord::Base

  include ActiveModel::Validations
  validates_with Validator

  belongs_to :project
  belongs_to :user
  belongs_to :firm
  validates_presence_of :goal
  validates_presence_of :due
  scope :overdue, -> {where(["due < ?",  Date.current])}
  scope :due_this_week, -> {where(due:  Date.current, :completed => false)} 
  scope :next, -> {where('due >= ?', DateTime.now).order("due ASC") }

  def self.user_milestones_two_weeks(firm, user)
    where(:firm_id => firm.id, :project_id => user.projects, :due => Date.current - 1.week..Date.current + 1.week).order("due ASC")
  end

  # comment 06.06.13
  # def self.user_milestones_overdue(firm, user)
  #   where(:firm_id => firm.id, :project_id => user.projects).where(["due < ?",  Date.current])
  # end
  def overdue?
    due < Date.current
  end 
  # def self.next
  #   where("due > ?", Date.current).order("due asc").try(:first)
  # end
end
