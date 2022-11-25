class JobsController < ApplicationController
  newrelic_ignore
  respond_to :html, :js, :json
  layout :resolve_layout
  include InvoiceSender
	def show_pdf 
    @klass = current_firm.invoices.find(params[:id])
    # authorize! :read, @klass
    @logs = @klass.logs.order(:log_date).includes(:user, :project, :todo, :customer, :employee)
    
  end
  def download_invoice
    @klass = current_firm.invoices.find(params[:id])
    @logs = @klass.logs.order(:log_date).includes(:user, :project, :todo, :customer, :employee)
    html = render_to_string(:action => '../jobs/download_invoice', :layout => false)
    pdf = PDFKit.new(html)
    send_data(pdf.to_pdf, :filename => "#{@klass.firm.name}_#{@klass.id}.pdf", :type => 'application/pdf')
  end
 

  # def download
  #   @invoice = current_firm.invoices.find(params[:id])
  #   InvoiceSender.give_invoice_number(@invoice,Invoice.last_with_number(current_firm)) 
  #   @invoice.set_status_when_sending
  #   filename = current_firm.subdomain + "_" + @invoice.number.to_s + ".pdf"
  #    if @invoice.save

  #     QC.enqueue "InvoiceSender.invoice_to_pdf", @invoice.id
  #     sleep 9
  #      send_file("#{Rails.root}/tmp/shrimp/" + filename, :filename => filename,  :type=>"application/pdf" )
  #   respond_with @invoice
     
    
    
      
  #   end  
  # end

  def handeling_invoice
    @invoice = current_firm.invoices.find(params[:id])
    sending_tasks(@invoice)
  end


  def fetch_job
    invoice = current_firm.invoices.find(params[:id])
    if InvoiceSender.pdf_finished?(invoice)
      
       render :status => 200, :json => {file: "#{current_firm.subdomain}_#{invoice.number}.pdf", id: params[:id] }
    else
      render :status => 202, :text => ''
    end
  end

  def ajax_download
    @klass = current_firm.invoices.find(params[:id])
    @klass.set_status_when_sending
    send_file("#{Rails.root}/tmp/shrimp/" + params[:file], :filename => params[:file],  :type=>"application/pdf" )
    @klass.save
  end

  def ajax_sending
    @klass = current_firm.invoices.find(params[:id])
    @klass.set_status_when_sending
    @klass.save 
    QC.enqueue "InvoiceMailer.invoice", current_firm, @klass.id
    flash[:notice] = flash_helper((t'activerecord.models.invoice.one').capitalize + ' ' + @klass.number.to_s + ' ' + (t'general.was_sent'))
    # send_file("#{Rails.root}/tmp/shrimp/test.txt", :filename => "test.txt",  :type=>"application/pdf" )
  end

  def time_out
    @klass = current_firm.invoices.find(params[:id])
    @klass.status = 9
    @klass.save
    flash[:notice] = flash_helper((t'general.generation_of') + ' ' + (t'activerecord.models.invoice.one').capitalize + ' ' + @klass.number.to_s + ' ' + (t'general.timed_out'))

  end
  
  def invoice_paid
    @klass = current_firm.invoices.find(params[:id])
    @klass.paid!
  end
  def invoice_lost
    @klass = current_firm.invoices.find(params[:id])
    @klass.lost!
  end
  
  private
  
  def sending_tasks(invoice)
    InvoiceSender.give_invoice_number(invoice,Invoice.last_with_number(current_firm)) 
    if invoice.save
      QC.enqueue "InvoiceSender.invoice_to_pdf", invoice.id
      render :status => 200, :json => { id: invoice.id }
    else

      render :status => 202, :json => {flash: invoice.errors.first}
    end   
  end
 # def test(filename, time)
 #  if time < 3
 #    send_file("#{Rails.root}/tmp/shrimp/" + filename, :filename => filename,  :type=>"application/pdf" )
 #  else
 #    flash_helper("something failed")
 #  end
 # end

  def resolve_layout
    case action_name
    when "show_pdf"
      "pdf"
    when "download_invoice"
      "pdf"
    else
      "application"
    end
  end

end
