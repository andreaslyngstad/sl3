class InvoicesController < ApplicationController
  respond_to :html, :js, :json
  def index
    # authorize! :read, Invoice
    @invoices = current_firm.invoices.where(date: ((time_zone_now - 6.months)..time_zone_now) ).where.not(status: 10).includes(:customer).order_by_date
    @invoice = current_firm.invoices.new
    @logs = current_firm.logs.includes(:customer, {:customer => :employee}, :project, {:project =>:todo}, :user)
  end
  def new
    @invoice = current_firm.invoices.new
    if params[:url] == "index" or params[:url] == "new"
      @logs = []
    else
      @instance = eval(params[:url]).find(params[:id])
      klass = params[:url].downcase 
      if klass == 'project'
        @logs = @instance.logs.where("end_time IS NOT NULL").order("log_date DESC").includes(:customer, :project, :todo, :user, :firm)
      elsif klass == 'customer'
        @logs = @instance.logs.where("end_time IS NOT NULL").order("log_date DESC").includes(:customer, {:customer => :employees}, :project, {:project =>:todo}, :user)
      end
      @invoice.send(klass+'=', @instance)
    end
  end

  def show  
    @klass = current_firm.invoices.find(params[:id])
    if @klass.invoice_id.nil?
    @logs = Log.credit_noted.where(firm: current_firm).where(invoice: @klass)
    # .includes(:customer, :project, :user) 
  else
    @logs = Log.credit_noted.where(firm: current_firm).where(credit_note: @klass)
  end
    # @invoice_lines = @klass.invoice_lines
    @tax_lines = @klass.tax_lines
    # authorize! :read, @klass
    respond_with(@klass)
  end 
  
  def edit
    @invoice = current_firm.invoices.find(params[:id])
    if @invoice.status == 1
      @logs = @invoice.logs.includes(:customer, :project, {:project => :firm}, :user, :firm, :employee, :todo)
      # authorize! :read, @invoice
      respond_with(@invoice)
    end
  end

  def create
    @klass = current_firm.invoices.new(permitted_params.invoice)
    @klass.set_status_and_currency(current_firm)
    logs = params[:logs_attributes]
    if logs
      logs.each do |k,v|
        log = current_firm.logs.find(k.to_i)
        log.update_attributes(v)
        @klass.logs << log
        log.save
      end
    end
    respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + (t'activerecord.flash.saved'))
        format.js 
        else
          flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + (t'activerecord.flash.could_not_save'))
        format.js { render "shared/validate_create" }
      end
     end

  end
  
  def update
    @klass = current_firm.invoices.find(params[:id])
    if @klass.status == 1
      logs = params[:logs_attributes]
      if logs
        logs.each do |k,v|
          log = current_firm.logs.find(k.to_i)

          log.update_attributes(v)
          log.save
        end
      end
      @klass.receivable = params[:invoice][:total]
      if @klass.update_attributes(permitted_params.invoice)
        flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + (t'activerecord.flash.saved'))
        respond_to do |format|
          format.js
        end
      else
        flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + (t'activerecord.flash.could_not_save'))
        respond_to do |format|
          format.js { render "shared/validate_update" }
        end
      end
    end
  end
  
  def destroy
    @invoice = Invoice.find(params[:id])
    if @invoice.status == 1
      @invoice.logs.each do |l|
        l.invoice_id = 0
        l.save
      end
      @invoice.destroy   
      respond_to do |format|
        flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' '  + (t'activerecord.flash.deleted'))
        format.js
      end
    end
  end

  def credit_note
    @invoice = current_firm.invoices.find(params[:id])
    @logs = @invoice.logs.includes(:customer, :project, {:project => :firm}, :user, :firm, :employee, :todo)
    @credit_note = current_firm.invoices.new
    
    # authorize! :read, @invoice
    respond_with(@invoice)
  end
  
  def credit_note_create
    @klass = current_firm.invoices.new(permitted_params.invoice)
    @invoice = current_firm.invoices.find(params[:id])
    @klass.set_status_and_currency(current_firm)
    InvoiceSender.give_invoice_number(@klass,Invoice.last_with_number(current_firm)) 
    @klass.paid = Date.current
    @klass.status = 8
    respond_to do |format|
      if @klass.save
        @logs = params[:logs_attributes]
        if @logs
          @logs.each do |k,v|
            log = current_firm.logs.find(k.to_i)
            log.credit_note_log(@klass.id)

          end
        end
        @invoice.status = 7
        @invoice.receivable = @invoice.receivable + @klass.total
        @invoice.save
        flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + (t'activerecord.flash.saved'))
        format.js 
        else
          flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + (t'activerecord.flash.could_not_save'))
        format.js { render "credit_note_validate_create" }
      end
     end
  end

  

  def customer_select
    if params[:invoice] != "null"
      @invoice = Invoice.find(params[:invoice]) if params[:invoice]
    end
    @customer = current_firm.customers.find(params[:id])
    if !params[:other_object].blank?
      @project = current_firm.projects.find(params[:other_object])
      @logs = @customer.logs.uninvoiced.where(project_id: @project.id).includes(:employee, :customer, :firm, :todo, :user, :project)
    else
      @logs = @customer.logs.uninvoiced.includes(:employee, :customer, :firm, :todo, :user, {:project => :firm})
    end
  end

  def customers_create
    @klass = current_firm.customers.new(permitted_params.customer) 
    # authorize! :manage, @klass
    respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper((t'activerecord.models.customer.one').capitalize + ' ' + (t'activerecord.flash.saved'))
        format.js 
        else
        format.js { render "shared/validate_create" }
      end
    end 
  end

  # def project_select
  #   @project = current_firm.projects.find(params[:id])
  #   @customer = @project.customer
  #   if !params[:other_object].blank? and @customer.nil?
  #     @selected_customer = current_firm.customers.find(params[:other_object])
  #     @logs = @project.logs.uninvoiced.where(customer_id: @selected_customer.id).includes(:employee, :customer, :firm, :todo, :user, :project)
  #   else
  #     @logs = @project.logs.uninvoiced.includes(:employee, :customer, :firm, :todo, :user, :project)
  #   end
  #   if params[:invoice] != "null"
  #     @invoice = Invoice.find(params[:invoice]) if params[:invoice]
  #   end
  # end
    # def projects_create
  #   @klass = current_firm.projects.new(permitted_params.project)
  #   @klass.active = true
  #   @klass.users << current_user
  #   # authorize! :manage, @klass
  #   respond_to do |format|
  #     if @klass.save
  #       flash[:notice] = flash_helper((t'activerecord.models.project.one').capitalize + ' ' + (t'activerecord.flash.saved'))
  #       format.js
  #     else
  #       format.js { render "shared/validate_create" }
  #     end
  #   end
  # end
end