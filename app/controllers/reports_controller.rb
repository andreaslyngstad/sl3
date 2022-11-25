class ReportsController < ApplicationController
	def index
     # authorize! :read, Firm
     # if can? :manage, Firm
		 if true
  	 @users = current_firm.users
  	 @projects = current_firm.projects
  	 @customers = current_firm.customers
    else
     @users = User.where(id: current_user.id)
     @projects = current_user.projects
     @customers = current_firm.customers
   end
  end

  def squadlink_report
    # authorize! :read, Firm
    range = (params[:from].to_date..params[:to].to_date)
  	@logs = current_firm.logs
                        .where.not(end_time: nil)
  	                    .where(log_date: range)
  	                    .order(:log_date)
  	                    .includes(:user, :project, :customer)
  	                    .try_find_logs(user_id: params[:user_id],
                                       project_id: params[:project_id],
                                       customer_id: params[:customer_id])

    respond_to do |format|
      format.html
      format.csv do
        response.headers['Content-Disposition'] = 'attachment; filename="squadlink_report.csv"'
        render "squadlink_report", formats: [:csv], handler: [:erb]
      end
      format.xls do
        response.headers['Content-Disposition'] = 'attachment; filename="squadlink_report.xls"'
        render "squadlink_report", formats: [:xls], handler: [:erb]
      end
    end
  end
  def dashboard
    # authorize! :read, Firm
    @users = current_firm.users.includes(:logs).order(:current_sign_in_at)
    @log_worth = LogWorker.calulate_logs_worth(current_firm.logs.uninvoiced.group(:rate).sum(:hours)).try(:prettify_to_s)
    @tasks_overdue_and_to_day = current_user.todos.overdue_and_to_day
    # @logs = @klass.logs.order("log_date DESC").limit(3).includes(:user)
    @logs_uninvoiced = current_firm.logs.uninvoiced.sum(:hours)
  end
end
