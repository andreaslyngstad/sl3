require "validator"
class Log < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with Validator
  validates_with MadeWithInLimit, on: :create
  default_scope { where(credit_note: nil ) }
  scope :credit_noted, -> { unscope(:where) }
  belongs_to :customer
  belongs_to :user
  belongs_to :firm, :counter_cache => true
  belongs_to :project
  belongs_to :todo
  belongs_to :employee
  belongs_to :invoice
  belongs_to :credit_note, class_name: "Invoice", foreign_key: 'credit_note_id'
  before_save :set_hours 
  validate :log_made_on_project
  validate :end_time_before_begin_time
  validates_presence_of :log_date 
  
  scope :uninvoiced, -> {where(invoice_id: 0).where.not(end_time: nil).where.not(rate: 0)}
  
  def log_made_on_project
    errors.add(:project_id, "cannot be empty for this log") if
    user.can_validate? && project == nil
  end

  def invoiced?
    invoice_id != 0
  end

  def set_hours
  	if end_time?
  	self.hours = end_time - begin_time
  	end
  end

  def time
    if end_time
  	 end_time - begin_time 
    end
  end
  
  def credit_note_log(credit_id)
    self.credit_note_id = credit_id
    self.save
    duplicate_credit_note_log
  end

  def duplicate_credit_note_log
    new_log = dup
    new_log.invoice_id = 0
    new_log.credit_note_id = nil
    new_log.save
  end

  
  def end_time_before_begin_time
    errors.add(:end_time, "You end before you begin.") if
    if tracking != true
      end_time < begin_time
    end
  end
  
  
  def self.logs_for_timesheet(user)
    user.logs.where(:log_date => (Date.current.beginning_of_week..Date.current.end_of_week)).group("project_id").group("date(log_date)").sum(:hours)
  end
  
  def self.hours_by_day_and_model(firm, range, model)
    model_id = model.to_s + "_id"
    logs = firm.logs
    .where(:log_date => range)
    .where(Log.arel_table[:end_time].not_eq(nil))
    .includes(model)
    .group([:log_date, model_id.intern])
    .select("sum(hours) as total_hours, log_date, #{model_id}")     
  end
  def self.hours_by_model(firm, range, model)
      model_id = model.to_s + "_id"
     logs = firm.logs.includes(model)
     .where(log_date: range)
     .where(Log.arel_table[:end_time].not_eq(nil))
     .group([model_id.intern])
     .select("sum(hours) as total_hours, #{model_id}")    
  end
  def placed_between?(date_range)
    date_range.include?(log_date)
  end

  def self.try_find_logs(options)
     options.map do |k,v|
       unless v.blank?
         where(k => v)
       end
     end.compact.inject(:&)
  end
  def total_price
    ((hours*rate*tax/360000) + (hours*rate/3600)).prettify
  end
end