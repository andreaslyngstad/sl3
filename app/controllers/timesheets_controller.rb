class TimesheetsController < ApplicationController
  include TabsHelper 
  include FormatHelper
  def timesheet_day
    get_log_for_tracking
    get_instance_if_not_index(params)
    if @klass
      @logs = @klass.logs.where(:log_date => params[:date])
    else
      @logs = current_firm.logs.where(:log_date => params[:date])
    end 
  end

  def timesheet_week 
    # authorize! :read, Firm
    get_log_for_tracking 
    get_instance_if_not_index(params) 
    if !params[:user_id].blank?
      @user = current_firm.users.find(params[:user_id])
    end
    date = params[:date] ? Time.zone.parse(params[:date]) : time_zone_now.to_date
    @dates = (date.beginning_of_week.to_date)..(date.end_of_week.to_date)
    find_users(current_user)
    variables_bag(@klass, @user)
  end

  def timesheet_month
    # authorize! :read, Firm
    get_log_for_tracking
    get_instance_if_not_index(params)
    @date = params[:date] ? Time.zone.parse(params[:date]).to_date : time_zone_now.to_date
    if !params[:user_id].blank?
      @user = current_firm.users.find(params[:user_id])
      if @klass
        @logs_by_date = @klass.logs.where(user_id: @user.id).group("date(log_date)").sum(:hours)
      else
        @logs_by_date = @user.logs.group("date(log_date)").sum(:hours)
      end
    else
      if @klass
        @logs_by_date = @klass.logs.group("date(log_date)").sum(:hours)
      else
        @logs_by_date = current_firm.logs.group("date(log_date)").sum(:hours)
      end
      
    end
    find_users(current_user)
    
  end
 
  def add_log_timesheet
    date = params[:log][:log_date] ? Time.zone.parse(params[:log][:log_date]) : time_zone_now.to_date
    @dates = (date.beginning_of_week.to_date)..(date.end_of_week.to_date)
    @user = current_firm.users.find(params[:log][:user_id])
    @log = LogWorker.create(current_firm.logs.new(permitted_params.log), params[:done], @user, current_firm)
    variables_bag(nil, @user)
    
    respond_to do |format|
      if @log.save
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
  end
  
  def add_hour_to_project
    @log = Log.find_by_id(params[:log_id]) || current_firm.logs.new
    select_klass = params[:select_klass]
    klass        = params[:klass]
    @log.user = current_user
    @log.rate = current_user.hourly_rate
    @log.send(select_klass + '=', current_firm.send(params[:select_klass].pluralize).find(params[:select_id]))
    @log.send(klass + '=', current_firm.send(params[:klass].pluralize).find(params[:id]))
    @dates = (Time.zone.now.beginning_of_week.to_date)..(Time.zone.now.end_of_week.to_date)
    @log.log_date = params[:date]
    @log.event = t('general.timesheet')
    @log.begin_time = @log.log_date.beginning_of_day
    @log.firm = current_firm
    if !@log.project.nil? && !@log.project.customer.nil?
      @log.customer = @log.project.customer
    end
    if params[:val_input].include?(":")
      a = params[:val_input].split(":")
      b = a[0].to_f + a[1].to_f/60
      @log.end_time =  @log.begin_time + (b * 3600)
    else
      @log.end_time =  @log.begin_time + (params[:val_input].to_f * 3600)
    end
    @log.save!
  end
  
  private 

  def find_users(user)
    if user.role != "external_user"
     @users = current_firm.users
     else
     @users = []
     end
  end
  def variables_bag(klass, user)
    if klass.class == Project
      @projects = current_user.firm.users
      @log_project = klass.logs.where(:log_date => @dates).group("user_id").sum(:hours)
      @log_week = klass.logs.where(:log_date => @dates).group("date(log_date)").sum(:hours)
      @log_week_project = klass.logs.where(:log_date => @dates).group("user_id").group("date(log_date)").sum(:hours)
      # @log_week_no_project = klass.logs.where(:log_date => @dates, :project_id => nil).group("date(log_date)").sum(:hours)
      @log_total = klass.logs.where(:log_date => @dates).sum(:hours) 
    
    elsif klass.class == Customer or klass.class == User
      @projects = current_user.projects

      if user
      @log_project          = fetcher(klass).where(user_id: user.id).group("project_id").sum(:hours)
      @log_week             = fetcher(klass).where(user_id: user.id).group("date(log_date)").sum(:hours)
      @log_week_project     = fetcher(klass).where(user_id: user.id).group("project_id").group("date(log_date)").sum(:hours)
      @log_week_no_project  = fetcher(klass).where(user_id: user.id).where( :project_id => nil).group("date(log_date)").sum(:hours)
      @log_total            = fetcher(klass).where(user_id: user.id).sum(:hours)   
      else
      @log_project          = fetcher(klass).group("project_id").sum(:hours)
      @log_week             = fetcher(klass).group("date(log_date)").sum(:hours)
      @log_week_project     = fetcher(klass).group("project_id").group("date(log_date)").sum(:hours)
      @log_week_no_project  = fetcher(klass).where( :project_id => nil).group("date(log_date)").sum(:hours)
      @log_total            = fetcher(klass).sum(:hours)     
      end
    else
      if current_user.admin?
        @projects             = current_firm.projects
        if user
        @log_project          = fetcher(current_firm).where(user_id: user.id).group("project_id").sum(:hours)
        @log_week             = fetcher(current_firm).where(user_id: user.id).group("date(log_date)").sum(:hours)
        @log_week_project     = fetcher(current_firm).where(user_id: user.id).group("project_id").group("date(log_date)").sum(:hours)
        @log_week_no_project  = fetcher(current_firm).where(user_id: user.id).where(:project_id => nil).group("date(log_date)").sum(:hours)
        @log_total            = fetcher(current_firm).where(user_id: user.id).sum(:hours)  
        else
        @log_project          = fetcher(current_firm).group("project_id").sum(:hours)
        @log_week             = fetcher(current_firm).group("date(log_date)").sum(:hours)
        @log_week_project     = fetcher(current_firm).group("project_id").group("date(log_date)").sum(:hours)
        @log_week_no_project  = fetcher(current_firm).where(:project_id => nil).group("date(log_date)").sum(:hours)
        @log_total            = fetcher(current_firm).sum(:hours)  
        end
      else
        @projects             = current_user.projects
        if user
          @log_project          = fetcher(current_firm).where(project_id: @projects).where(user_id: user.id).group("project_id").sum(:hours)
          @log_week             = fetcher(current_firm).where(project_id: @projects).where(user_id: user.id).group("date(log_date)").sum(:hours)
          @log_week_project     = fetcher(current_firm).where(project_id: @projects).where(user_id: user.id).group("project_id").group("date(log_date)").sum(:hours)
          @log_week_no_project  = fetcher(current_firm).where(project_id: @projects).where(user_id: user.id).where(:project_id => nil).group("date(log_date)").sum(:hours)
          @log_total            = fetcher(current_firm).where(project_id: @projects).where(user_id: user.id).sum(:hours) 
        else
          @log_project          = fetcher(current_firm).group("project_id").sum(:hours)
          @log_week             = fetcher(current_firm).group("date(log_date)").sum(:hours)
          @log_week_project     = fetcher(current_firm).group("project_id").group("date(log_date)").sum(:hours)
          @log_week_no_project  = fetcher(current_firm).where(:project_id => nil).group("date(log_date)").sum(:hours)
          @log_total            = fetcher(current_firm).sum(:hours) 
        end
      end
      
  end

    # if klass.class != Project
    #   @projects = klass.projects
    # else
    #   # @projects = current_user.projects.where(id: klass.id )
    # end
  end
  def fetcher(klass)
    klass.logs.where(:log_date => @dates)
  end
  def get_log_for_tracking
    if params[:id] == "index"
      @log = current_user.logs.where("end_time IS ?",nil).last
    end
  end
  def get_instance_if_not_index(params)
    if params[:id] != "index"
      @klass = current_firm.send(params[:class].downcase.pluralize).find(params[:id])
    end
  end
end