class PaymentsController < ApplicationController
	respond_to :html
  def index
  	@payments = current_firm.payments.order_by_date
  end

  def show
   	@payment = current_firm.payments.find(params[:id])
 	respond_with @payment do |format|
 # headers["Content-Disposition"] = 
 #    "attachment; filename=\"squadlink#{@payment.id}\""
 #  		html = render_to_string(:action => "../invoices/show_pdf.html.erb") 
 #     mail(:to => @registration.billing_email, :subject => "Påminnelse") do |format|
 #      format.text
 #      format.html
 #      format.pdf do
 #        attachments['faktura.pdf'] = PDFKit.new(html).to_pdf
    format.html { render :layout => false}
  	end
 end

	def download_pdf
	  @payment = current_firm.payments.find(params[:id])
	  html = render_to_string(:action => '../payments/download_pdf', :layout => false)
	  pdf = PDFKit.new(html)
	  send_data(pdf.to_pdf, :filename => "squadlink_payment#{@payment.id}.pdf", :type => 'application/pdf')
	end
end
