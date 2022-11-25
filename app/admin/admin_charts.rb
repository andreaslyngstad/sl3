class AdminChart
  def subscription_count
    [{"values" => 
      Firm.count_by_plan.map do |k, v|    
        {"label" => k.name, "value" => v.to_s}
      end
    }].to_json
  end
  
  def firms_count
    stats = Statistics.where(created_at: (Time.now.years_ago(1)..Time.now))
    [ entry(:free, stats),
      entry(:bronze, stats),
      entry(:silver, stats),
      entry(:gold, stats),
      entry(:platinum, stats)].to_json
  end
  
  def firms_resources_count
    stats = Statistics.where(created_at: (Time.now.years_ago(1)..Time.now))
    [ entry(:users, stats),
      entry(:logs, stats),
      entry(:projects, stats),
      entry(:customers, stats)].to_json
  end
  def new_firms_count
    [{"key" => "New firms", "values" =>
      Firm.group("DATE(created_at)").count.map do |k,v|
        [time_to_miliseconds(k), v]
      end
     }].to_json
  end
  def entry(value, stats)
    {"key" => value.capitalize, "values" => 
    stats.map do |stat|
      [time_to_miliseconds(stat.created_at), stat.send(value)]
    end
    }
  end
  def time_to_miliseconds(created_at)
    (Time.parse(created_at.to_date.to_s).to_i * 1000)
  end
end 