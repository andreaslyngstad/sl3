class Validator < ActiveModel::Validator
   def validate(record)
     record.errors.add(:base, (I18n.translate"errors.messages.firm_is_secure")) if
     check_if_current_firm(record).include?(true) 
   end

   private
 	  def class_reflections(record)
 	    arr = record.class.reflections.collect{|a, b| b.class_name.downcase if b.macro==:belongs_to}.compact.uniq
 	    arr.delete("firm")
 	    arr
 	  end

    def check_if_current_firm(record) 
   	  class_reflections(record).map do |ass|  
      parent = record.instance_eval(ass)
      if parent && parent.firm != nil 
        record.firm != parent.firm 
     end
   end 
   end
 end

class MadeWithInLimit < ActiveModel::Validator
  include ActionView::Helpers::UrlHelper
  def validate(record)
    records = record.class.to_s.downcase.pluralize
    # Rails.logger.info(records)
    # Rails.logger.info(record.firm.name)
    records_count = records + "_count"
    record_string = record.class.to_s.downcase
    record.errors.add(:base, 
      (I18n.translate"errors.messages.over_limit", 
      count: record.firm.plan.send(records), 
      model: (I18n.translate"activerecord.models.#{record_string}.more")) + ". #{link_to (I18n.translate"general.please_upgrade"), Rails.application.routes.url_helpers.plans_path}") if
    PlanLimit.new.over_limit?(record.firm.send(records_count), record.firm.plan.send(records))
  end
end