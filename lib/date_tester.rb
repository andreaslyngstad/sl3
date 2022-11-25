class DateTester
   def date?(t)
    begin
      t.to_date.is_a?(Date)
    rescue
      false
    end  
  end
end