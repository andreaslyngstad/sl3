module FormatHelper
	def date_format(date,options = {} )
    if current_firm.date_format == 1
      date.strftime("%d.%m.%Y")
    elsif current_firm.date_format == 2 
      date.strftime("%m/%d/%Y")
    end
  end
  def clock_format(time,options = {} )
    if current_firm.clock_format == 1
      time.strftime("%H:%M")
    elsif current_firm.clock_format == 2 
      time.strftime("%I:%M%P")
    end
  end
  def time_format(time,options = {} )
    if current_firm.time_format == 1
      time_diff(time)
    elsif current_firm.time_format == 2 
      if time > 0 
        (time.to_f/3600.0).round(2).to_s
      end
    end
  end
  def time_diff(time)
  	seconds    	=  (time % 60).to_i
    time 		= (time - seconds) / 60
    minutes    	=  (time % 60).to_i
    time 		= (time - minutes) / 60
    hours      	=  (time).to_i
    if minutes == 0 
    	return hours.to_s + ":00"
    elsif minutes < 10
    	return hours.to_s + ":0" + minutes.to_s
	else
  		return hours.to_s + ":" + minutes.to_s
  	end
  end
end