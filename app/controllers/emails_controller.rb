class EmailsController < ApplicationController
	respond_to :js
	def new
    @email = current_firm.emails.new
    @invoice = current_firm.invoices.find(params[:id])
    # authorize! :read, @email
    respond_with(@email)
	end
  def create
  	 @email = current_firm.emails.new(permitted_params.email)
     @invoice = @email.invoice
     InvoiceSender.give_invoice_number(@invoice,Invoice.last_with_number(current_firm))
      @invoice.set_status_when_sending

      if @invoice.save and @email.save


      # QC.enqueue "InvoiceSender.invoice_to_pdf_and_send", @invoice.id, @email.id
      flash[:notice] = flash_helper((t'activerecord.models.email.one').capitalize + ' ' + (t'activerecord.attributes.email.was_sent'))
      respond_with @email
      else
        flash[:notice] = flash_helper(@invoice.errors.first[1].to_s)
        render "error"
      end

  end

   def create_slow_sending
    @invoice = current_firm.invoices.find(params[:id])
    InvoiceSender.give_invoice_number(@invoice,Invoice.last_with_number(current_firm))
     if @invoice.update_attributes(permitted_params.invoice_send)
      # QC.enqueue "InvoiceSender.invoice_to_pdf_and_send", @invoice.id
      respond_with @invoice
    else

    end
  end

  def reminder
    @email = current_firm.emails.new
    @invoice = current_firm.invoices.find(params[:id])
    @reminder = current_firm.invoices.new
    # authorize! :read, @invoice
    respond_with(@invoice)
  end

  def reminder_create
    @email = current_firm.emails.new(permitted_params.email)
    @overdue_invoice = current_firm.invoices.find(params[:id])
    if @overdue_invoice.receivable > 0
      @invoice = @overdue_invoice.create_reminder(params[:email][:reminder])
      respond_to do |format|
        if @email.save

          flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + (t'activerecord.flash.saved'))
          # QC.enqueue "InvoiceSender.invoice_to_pdf_and_send", @invoice.id,@email.id
          format.js
          else
            flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + (t'activerecord.flash.could_not_save'))
          format.js { render "credit_note_validate_create" }
        end
       end
      else
      flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + (t'activerecord.flash.nothing_to_collect'))
      end
  end

  def quick_send
    @invoice = current_firm.invoices.find(params[:id])

    InvoiceSender.give_invoice_number(@invoice,Invoice.last_with_number(current_firm))
    @invoice.set_status_when_sending
     if @invoice.save
			 debugger
      @email = make_quickmail(@invoice)
      flash[:notice] = flash_helper((t'activerecord.models.email.one').capitalize + ' ' + (t'activerecord.attributes.email.was_sent'))
      InvoiceSender.invoice_to_pdf_and_send(@invoice.id,@email.id)

      respond_with @invoice
    else
      flash[:notice] = flash_helper(@invoice.errors.to_s)
      render "error"
    end
  end
  def make_quickmail(invoice)
    email = current_firm.emails.new
    email.invoice = invoice
    email.status  = 1
    email.address = invoice.customer.email
    email.subject = current_firm.invoice_email_subject
    email.content = current_firm.invoice_email_message
    email.save
    email
  end
end
