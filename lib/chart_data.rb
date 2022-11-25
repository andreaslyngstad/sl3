require "symbol.rb"
require 'hash_diff'
class ChartData
  attr_accessor :firm, :range, :model
  def initialize(firm,range,model)
    @firm = firm
    @range = range
    @model = model  
  end
  
  def get_logs_by_day_and_model
    Log.hours_by_day_and_model(@firm, @range, @model)
  end

  def stacked
    key_user_value_date_hours = compile_hash
    output = '[' 
    key_user_value_date_hours.each do |name,dates|
      output << '{ "key" : "' + name.gsub("\n", "") + '", ' 
      output << '"values" : [' 
      dates.sort_by{|k,v| k}.each do |date|
        if model != :invoice
          output << '[' + (Time.parse("#{date[0]}").to_i * 1000).to_s + ',' + TimeHelp.new.time_to_hours_test(date[1]).to_s + '],'
        else 
          output << '[' + (Time.parse("#{date[0]}").to_i * 1000).to_s + ',' + ((date[1]).round(2)).to_s + '],'
        end
      end 
      output.chomp!(',') 
      output << ']},'
    end
    output.chomp!(',')
    output << ']'
  end 
  def no_translation(model)
    I18n.translate'general.no_model', model: (I18n.translate"activerecord.models.#{model}.one")
  end
  def pie
    hash = Log.hours_by_model(@firm, @range, @model).map do |l|
      [(l.send(model).name if !l.send(model).nil?), l.total_hours] 
    end.to_h
    no_model = hash[nil]
    hash.delete(nil)
    
    output = '['
    if no_model
      output << '{ "label" : "' + no_translation(model.to_s) + '","value" :' + (no_model/3600).to_s + '},'
    end
    hash.sort.to_h.each do |k,v|
      output << '{ "label" : "' + k  + '","value" :' + (v/3600).to_s + '},'
    end

    # logs = Log.hours_by_model(@firm, @range, @model)
    # Rails.logger.info( @model)
    # output = '['
    # logs.each do |log|
    #   if !log.send(model).nil?
    #     output << '{ "label" : "' + log.send(model).name.gsub("\n", "") + '",'
    #   else
    #     output << '{ "label" : "' + no_translation(model.to_s) + '",'
    #   end
    #    log.total_hours.to_f < 10.0 ? output << '"value" : 0.01},': output << '"value" : ' + TimeHelp.new.time_to_hours_test(log.total_hours.to_f).to_s + '},'
    #  end
    output.chomp!(',')
    output << ']'
  end 

  def by_day
    days_with_hours = Hash.new{|h, k| h[k] = Hash.new(&h.default_proc)}
    if model != :invoice
      get_logs_by_day_and_model.each do |log|
        if log.total_hours.to_f > 10.0
          if log.send(@model) 
            days_with_hours[log.send(@model).name][log.log_date] = log.total_hours.to_f
          else
            days_with_hours[no_translation(model.to_s)][log.log_date] = log.total_hours.to_f
          end
        end
      end
    elsif model == :invoice
      firm.invoices.select("date_trunc( 'month', date ) as month, sum(total) as total").group('month').each do |v| 
        days_with_hours['Income'][v.month.strftime('%B %Y')] = v.total.to_f
      end
    end  
   
    days_with_hours
  end
  
  def income_by_day
    
  end

  
  def chart_lables
    @firm.send(@model.pluralize).map do |model_instance|
       model_instance.name.gsub(/["]/, "'")  
    end
  end
  
  def all_dates_nothing
    ms = []
    ms << no_translation(model.to_s)
    models = ms + chart_lables
    date_hours_empty = Hash.new{|h, k| h[k] = Hash.new(&h.default_proc)}      
    models.each do |m|
      (@range).each do |day|
      date_hours_empty[m][day] = 0
      end
    end
    date_hours_empty
  end
  
  def income_per_month
    months_with_income = Hash.new #{|h, k| h[k] = Hash.new(&h.default_proc)}
    months_without_income = Hash.new
    firm.invoices.where.not(paid: nil).select("date_trunc( 'month', paid ) as month, sum(paid_amount) as total").group('month').each { |v|months_with_income[I18n.l(v.month.to_date, format: :month_n)] = v.total.to_f}
    
    range.map(&:beginning_of_month).uniq.map{|b| I18n.l(b, format: :month_n)}.each { |x| months_without_income[x] = 0.0} 
    output = '[' 
    output << '{ "key" : "", ' 
      output << '"values" : ['
      if !months_with_income.blank?
       months_without_income.merge(months_with_income).each do |month,sum|
      output << '["' +  month + '",' + sum.to_s + '],'
      end
    end
     output.chomp!(',')
     
    output << ']}]'

    

    output
  end
  
  def compile_hash
   key_user_value_date_hours = Hash.new
   emtpy_hours = all_dates_nothing
   log_hours = by_day
   emtpy_hours.each do |k,v|
     if log_hours.has_key?(k)
      c = log_hours.values_at(k)[0].diff_sq(emtpy_hours.values_at(k)[0])
      key_user_value_date_hours[k] = c 
     end   
   end 
   Rails.logger.info(key_user_value_date_hours.sort.to_h)
     key_user_value_date_hours.sort.to_h
   end
end