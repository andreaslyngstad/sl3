class CustomersController < ApplicationController
 
  def index
    @customers = current_firm.customers.order_by_name
     # authorize! :read, Customer 
     
  end
  def show
    @klass = current_firm.customers.find(params[:id])
    # authorize! :manage, @klass
    redirect_to(tabs_state_path(string_for_klass(@klass),@klass.id))
  end
   
  def edit
    @customer = current_firm.customers.find(params[:id])
  end

  def create
    @klass = current_firm.customers.new(permitted_params.customer) 
    # authorize! :manage, @klass
    respond_to do |format|
      if @klass.save
      	flash[:notice] = flash_helper(@klass.name + ' ' + (t'activerecord.flash.saved'))
      	format.js 
        else
        format.js { render "shared/validate_create" }
      end
    end 
  end

  def update
    @klass = current_firm.customers.find(params[:id])
     # authorize! :manage, @klass
    respond_to do |format|
      if @klass.update_attributes(permitted_params.customer)
        flash[:notice] = flash_helper(@klass.name + ' ' + (t'activerecord.flash.saved'))
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
  end

  def destroy
    @customer = current_firm.customers.find(params[:id])
     # authorize! :manage, @customer 
    @customer.destroy
      respond_to do |format|
      flash[:notice] = flash_helper(@customer.name + ' ' + (t'activerecord.flash.deleted'))
      format.js
    end  
  end
end