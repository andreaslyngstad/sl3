module LogWorker
  extend self
  def create(log, done, user, firm)
    unless log.user
    log.user = user
    end
    log.firm = firm
    log.tracking = false
    if log.todo
      check_todo_on_log(log, user, done)
    end
    log
  end
  
  def start_tracking(log,done,user,firm)
    log = LogWorker.create(log,done,user,firm)
    log.tracking = true
    log.rate = user.hourly_rate
    log.begin_time = Time.zone.now
    log.log_date = Date.current
    log
  end
  
  def check_todo_on_log(log, user, done)
    log.todo.done_by_user = user
    log.todo.completed = done
    log.todo.save!
  end 
  def calulate_logs_worth(hash)
    hash.map do |k,v|
      k*v/3600
    end.inject(:+)
  end
end