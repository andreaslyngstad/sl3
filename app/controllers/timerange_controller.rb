class TimerangeController < ApplicationController
  include FormatHelper
  respond_to :js
  def log_range
    @customers = current_firm.customers.includes(:employees)
    @all_projects = current_user.projects.where(["active = ?", true]).includes(:customer, {:todos => [:logs]})
    find_logs_on(params[:url], get_time_range(params))
    if ["Admin", "Member"].include? current_user.role
    @hours = @logs.sum(:hours)
  else
    ids = current_user.projects.pluck(:id)
    @hours = current_firm.logs.where(project:ids).where(log_date: get_time_range(params)).sum(:hours)
  end
    respond_with( @logs)
  end
  
  def todo_range
    # @klass = eval(params[:url]).find(params[:id])
    find_todos_on(params[:url],get_time_range(params))
    respond_with(@not_done_todos,@done_todos)
  end

  def invoice_range
    # @klass = eval(params[:url]).find(params[:id])
    find_invoices_on(params[:url], get_time_range(params), params[:status])
    respond_with(@invoices)
  end
  private

  def get_time_range(params)
    if params[:from]
      ((Date.parse(params[:from]))..Date.parse(params[:to]))
    else
      timerange(params[:time])
    end
  end

  def find_todos_on(url, time_range)
    @done_todos = eval(url).find(params[:id]).todos.where(["completed = ?", true]).where(:due => time_range).order("due ASC").includes(:logs,:project,:user)
    @not_done_todos = eval(url).find(params[:id]).todos.where(["completed = ?", false]).where(:due => time_range).order("due ASC").includes(:logs,:project,:user)
    first_and_last_date(time_range)
  end

  def find_logs_on(url, time_range)
    if url == "index"
      logs_on = current_firm 
    else
      logs_on = eval(url).find(params[:id])
    end
    @logs = logs_on.logs.where(:log_date => time_range).order("log_date DESC").includes(:project, :todo, :user, :customer, :employee,:firm )
    first_and_last_date(time_range)
  end

  def find_invoices_on(url, time_range, status)
    if url == "index"
      invoices_on = current_firm
    else
      invoices_on = eval(url).find(params[:id])
    end
    logger.info(time_range)
    @invoices = invoices_on.invoices.where(:date => time_range).where(status: eval(status)).where.not(status: 10).order("date DESC").includes(:customer)
    first_and_last_date(time_range)
  end
  def first_and_last_date(time_range)
    @time_range_first = date_format(time_range.first)
    @time_range_last = date_format(time_range.last)
  end
  def timerange(time)
    case time
      when "to_day"     then (time_zone_now.midnight)..(time_zone_now.midnight + 1.day)
      when "this_week"  then (time_zone_now.beginning_of_week)..(time_zone_now.end_of_week)
      when "this_month" then (time_zone_now.beginning_of_month)..(time_zone_now.end_of_month) 
      when "this_year"  then (time_zone_now.beginning_of_year)..(time_zone_now.end_of_year)
      when "yesterday"  then (time_zone_now.midnight - 1.day)..(time_zone_now.midnight - 1.second) 
      when "last_week"  then (time_zone_now.beginning_of_week - 7.day)..(time_zone_now.beginning_of_week - 1.second) 
      when "last_month" then (time_zone_now.beginning_of_month - 1.month)..(time_zone_now.beginning_of_month - 1.second)
      when "last_year"  then (time_zone_now.beginning_of_year - 1.year)..(time_zone_now.beginning_of_year - 1.second)
      end  
  end
end
