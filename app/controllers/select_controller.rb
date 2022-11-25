class SelectController < ApplicationController
  respond_to :js
  def project_select
    check_log_status(params[:log_id]) 
    if params[:project_id] != "0"
      @project = Project.find(params[:project_id])
      @todos = @project.todos.where(["completed = ?", false])
    end
  end
  def project_select_tracking
    @tracking = true
    check_log_status(params[:log_id])
    if params[:project_id] != "0"
      @project = Project.find(params[:project_id])
      @todos = @project.todos.where(["completed = ?", false])
    end
    if @log
      @log.project = @project 
      @log.todo = nil
        if @project 
          @log.customer = @project.customer
          @log.employee = nil
        end    
      @log.save
    end
    render :template => 'select/project_select'
  end
  
  def todo_select
      check_log_status(params[:log_id])
    if params[:todo_id] != "0"
      @todo = Todo.find(params[:todo_id])    
    end 
  end
  
 
  def todo_select_tracking
    @tracking = true
    check_log_status(params[:log_id])
      @todo = Todo.find(params[:todo_id]) if params[:todo_id] != "0"
      if !@log.nil?
        @log.todo = @todo
        if @todo and @todo.customer 
          @log.customer = @todo.customer
          @log.employee = nil
        end
        @log.save
      end
    render :template => 'select/todo_select'
  end

  def customer_select
    check_log_status(params[:log_id])
    @customer = Customer.try(:find, params[:customer_id]) if params[:customer_id] != "0"
  end

  def customer_select_tracking
    @tracking = true
    check_log_status(params[:log_id])
    @customer = Customer.find(params[:customer_id]) if params[:customer_id] != "0"
      if !@log.nil?
        @log.customer = @customer
        @log.employee = nil 
        @log.save
      end
    render :template => 'select/customer_select'
  end

  def employee_select_tracking
    check_log_status(params[:log_id])
    @employee = Employee.find(params[:employee_id]) if params[:employee_id] != "0"
    if !@log.nil?
      @log.employee = @employee
      @log.save
      @customer = @log.try(:customer)      
    end
  end

private
  def check_log_status(params_log_id)
    if params_log_id.class == String
    @log = Log.find(params_log_id)
    end
  end
end