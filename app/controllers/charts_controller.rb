class ChartsController < ApplicationController
  # comment on 06.06.13
  # def admin_firms_chart
  #   @firm = Firm.count_by_subscription
  # end
  def index
    # authorize! :read, Firm
  end
  def users_logs  
    var_setter(params,:user)
  end
  
  def projects_logs
    var_setter(params,:project)
  end
  
  def customers_logs   
    var_setter(params,:customer)
  end
  
  def project_users_logs
    tabs_var_setter(params,:user)
  end
  def project_todos_logs
    tabs_var_setter(params,:todo) 
  end
  def statistics
    @log_worth = LogWorker.calulate_logs_worth(current_firm.logs.uninvoiced.group(:rate).sum(:hours)).try(:prettify_to_s)
    @logs_uninvoiced = current_firm.logs.uninvoiced.sum(:hours)
  end
  
  def economicstatistics_json
    range2 = Date.current - 12.months..Date.current
    @income_stack = ChartData.new(current_firm,range2,:invoice).income_per_month
  end
  
  def dashboard_json
    range = params[:from].to_date..params[:to].to_date
    range2 = Date.current - 12.months..Date.current
    @user_pie = ChartData.new(current_firm,range,:user).pie
    @project_pie = ChartData.new(current_firm,range,:project).pie
    @income_stack = ChartData.new(current_firm,range2,:invoice).income_per_month
    render :formats => [:json] 
  end
  # def customer_users_logs
  #   tabs_var_setter(params,:user) 
  # end
  # def customer_todos_logs
  #   tabs_var_setter(params,:todo) 
  # end
  private
  def tabs_var_setter(params,model)
    range = params[:from].to_date..params[:to].to_date
    instance = params[:klass].constantize.find(params[:id])
    @stacked = ChartData.new(instance,range,model).stacked
    @pie = ChartData.new(instance,range,model).pie
    render :formats => [:json] 
  end
  
  def var_setter(params,model)
    range = params[:from].to_date..params[:to].to_date
    @stacked = ChartData.new(current_firm,range,model).stacked
    @pie = ChartData.new(current_firm,range,model).pie
    render :formats => [:json] 
  end
end