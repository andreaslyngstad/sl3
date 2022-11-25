class TimeHelp
  def time_to_hours(time)
    seconds     =  (time % 60).to_i
    time    = (time - seconds) / 60
    minutes     =  (time % 60).to_i
    time    = (time - minutes) / 60
    hours       =  (time).to_i
    if minutes == 0 
      return hours.to_s + ":00"
    elsif minutes < 10
      return hours.to_s + ":0" + minutes.to_s
  else
      return hours.to_s + ":" + minutes.to_s
    end
  end
 
 def time_to_hours_test(time)
    seconds     =  (time % 60).to_i
    time    = (time.to_i - seconds) / 60
    minutes     =  (time % 60).to_i
    time    = (time.to_i - minutes) / 60
    hours       =  (time).to_i
    if minutes == 0 
      return (hours.to_s + ".00").to_f
    elsif minutes < 10
      return (hours.to_s + ".0" + minutes.to_s).to_f
  else
      return (hours.to_s + "." + minutes.to_s).to_f.round
    end
  end
end