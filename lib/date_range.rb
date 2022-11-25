class DateRange < Struct.new(:start_date, :end_date)
  def include?(date)
     (start_date..end_date).cover?(date)
  end
end