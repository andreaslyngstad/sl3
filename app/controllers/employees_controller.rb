class EmployeesController < ApplicationController
  def edit
    @employee = current_firm.employees.find(params[:id])
    respond_to do |format|
        format.js 
    end 
  end
  def create
    @klass = current_firm.employees.new(permitted_params.employee)
	  @customer = @klass.customer
    respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper((t'general.employee') + ' ' + (t'activerecord.flash.saved')) 
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
  end

  def update
    @klass = current_firm.employees.find(params[:id])
    @customer = @klass.customer
    respond_to do |format|
      if @klass.update_attributes(permitted_params.employee)
        flash[:notice] = flash_helper((t'general.employee') + ' ' + (t'activerecord.flash.saved'))
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
  end

  def destroy
    @employee =  current_firm.employees.find(params[:id])
    @employee.destroy
    respond_to do |format|
       flash[:notice] = flash_helper((t'general.employee') + ' ' + (t'activerecord.flash.deleted'))
      format.js
    end
  end
end
