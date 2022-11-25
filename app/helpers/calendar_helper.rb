module CalendarHelper
  include ApplicationHelper
  def calendar(date, &block)
    Calendar.new(self, date, block).table
  end


 class Calendar < Struct.new(:view, :date, :callback)
    
    # HEADER = translated_day_names

    START_DAY = :monday

    delegate :content_tag, to: :view

    def table
      content_tag :table, class: "calendar" do
        header + week_rows
      end
    end

    def header
      content_tag :tr do
        translated_day_names.map { |day| content_tag :th, day }.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << "today" if day == date
      classes << "notmonth" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end

    def translated_day_names
      first = date.beginning_of_week()
      last = date.end_of_week()
      (first..last).map do |n|
        I18n.localize n, :format => '%A'
      end
    end
    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end
end