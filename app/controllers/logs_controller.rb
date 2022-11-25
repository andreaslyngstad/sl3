class LogsController < ApplicationController
  def index
    @logs = current_firm.logs.where(:log_date => Date.current).order("updated_at DESC").includes({:project => [:users, :firm]} , :todo, :firm, :user, :customer, :employee)
    @log = current_user.logs.where("end_time IS ?",nil).last
  end

  def edit
    @log = Log.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @klass = LogWorker.create(current_firm.logs.new(permitted_params.log), check_done(params[:done]), current_user, current_firm)
     # authorize! :manage, @klass
    create_resonder(@klass)
  end

  def update
    @klass = current_firm.logs.find(params[:id])
    if !@klass.invoiced?
      # authorize! :manage, @klass
      @pre_hours = @klass.time
      LogWorker.check_todo_on_log(@klass, current_user, check_done(params[:done])) if !@klass.todo.nil?
      update_responder(@klass,permitted_params.log)
    end
  end

  def destroy
    @log = Log.find(params[:id])
    # authorize! :manage, @log
    if !@log.invoiced?
    @log.destroy
    respond_to do |format|
      flash[:notice] = flash_helper((t'activerecord.models.log.one') + ' ' + (t'activerecord.flash.deleted'))
      format.js
    end
  end
  end

  def start_tracking
    @log = LogWorker.start_tracking(current_firm.logs.new(permitted_params.log), check_done(params[:done]), current_user, current_firm)
    create_resonder(@log)
  end

  def stop_tracking
    @log_new = Log.new
  	@log = Log.find(params[:id])
    @log.end_time = Time.zone.now
	  LogWorker.check_todo_on_log(@log, current_user, check_done(params[:done])) unless @log.todo.nil?
	  update_responder(@log,permitted_params.log)
  end

  def get_logs_todo
    @todo = Todo.find(params[:todo_id])
    @logs = @todo.logs
    respond_to do |format|
      format.js
    end
  end
private
  def check_done(done)
    done == "1"
  end

  def create_resonder(log)
     respond_to do |format|
      if log.save
        flash[:notice] = flash_helper((t'activerecord.models.log.one') + ' ' + (t'activerecord.flash.saved'))
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
  end

  def update_responder(log, params)
    respond_to do |format|
      if log.update(params)
        flash[:notice] = flash_helper((t'activerecord.models.log.one') + ' ' + (t'activerecord.flash.saved'))
        format.js
      else
        format.js { render "shared/validate_update" }

      end
    end
  end
end
