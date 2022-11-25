class TabsController < ApplicationController
  include TabsHelper
  respond_to :js, :html
  def state
    get_instance(params)
     # authorize! :read, @klass 
    if params[:class] == "projects"
      @milestone = @klass.milestones.next
      @logs = @klass.logs.order("log_date DESC").limit(3).includes(:user)
      @logs_uninvoiced = @klass.logs.uninvoiced.sum(:hours)
    
    else
      @logs = @klass.logs.order("log_date DESC").limit(3).includes(:user)
      @logs_uninvoiced = @klass.logs.uninvoiced.sum(:hours)
    end
  end
  def milestones
    get_instance(params)
    # authorize! :read, @klass
    @milestones = @klass.milestones.order("due ASC").includes(:project)
    respond_with(@milestones)
  end 
  def todos  
    time_range = (Time.zone.now.midnight - 7.day)..(Time.zone.now.midnight + 7.day)
    get_instance(params)
    # authorize! :read, @klass
    @done_todos = get_klass(params[:class]).find(params[:id]).todos.where(["completed = ?", true]).where(:due => time_range).includes( :user, :done_by_user, :logs, :project,:customer).order("due ASC")
    @not_done_todos = get_klass(params[:class]).find(params[:id]).todos.where(["completed = ?", false]).where(:due => time_range).includes(:user, :done_by_user, :logs, :project,:customer).order("due ASC") 
    @members = current_firm.users
    respond_with( @done_todos, @not_done_todos, @members)
  end
  def logs
    get_instance(params)
    # authorize! :read, @klass
    if @klass.logs.where(log_date: Date.current).empty?
      @logs = @klass.logs.last
    else  
      @logs = @klass.logs.where(log_date: Date.current).includes([:user, :todo, :employee, :customer, :firm,{:project => [:firm]}])
    end
    respond_with(@logs)
  end
  def users
    get_instance(params)
    # authorize! :read, @klass
    @members = @klass.users
    @not_members = all_users - @members
    respond_with(@members)
  end
  def statistics
    get_instance(params)
    # authorize! :read, @klass
    @logs = @klass.recent_logs.includes([:user, :todo, :employee, :customer, {:project => [:firm]}])
    respond_with( @logs)
  end
  def spendings
    get_instance(params)
    # authorize! :read, @klass
    @users = @klass.users
    @logs = @klass.recent_logs.includes([:user, :todo, :employee, :customer, {:project => [:firm]}])
    respond_with(@logs, @users)
  end
  def projects
    get_instance(params)
    # authorize! :read, @klass
    @project = current_firm.projects.new
    @projects = @klass.projects.where(:active => true)
    respond_with(@projects)
  end
  def employees
    get_instance(params)
    # authorize! :read, @klass
    @employees = @klass.employees
    respond_with(@employees)
  end
  def invoices
    get_instance(params)
    # authorize! :read, @klass
    @invoices = @klass.invoices.where(date: ((time_zone_now - 1.week)..time_zone_now) ).includes(:customer).order_by_date
    @invoice = @klass.invoices.new
    @logs = current_firm.logs.includes(:customer, {:customer => :employee}, :project, {:project =>:todo}, :user)
    respond_with(@invoices)
  end
  private

end