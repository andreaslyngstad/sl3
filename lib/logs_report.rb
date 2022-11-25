class LogsReport
  def initialize(logs, date_range)
    @logs = logs
    @date_range = date_range 
  end
  
  def total_hours_on_date(date)
      
  end
  
  def total_hours_within_time_range
    total_hours(logs_within_range)
  end
 
  private
  def hours_on_date(logs, date)
    logs.detect { |key| key[0][0].to_i == project.id && key[0][1].to_time.strftime('%a') == date.to_time.strftime('%a')}
  end
  def total_hours(logs)
    logs.map(&:hours).inject(0,:+)
  end
  
  def logs_within_range
    @logs.select {|log| log.placed_between?(@date_range)} 
  end
end