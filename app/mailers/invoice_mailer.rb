class InvoiceMailer < ActionMailer::Base
	def invoice(invoice, email)
		@invoice = Invoice.find(invoice)
		@firm = @invoice.firm
		@email = @firm.emails.find(email)
		if @invoice.status == 10 
			file = "#{I18n.translate('economic.email_reminder').downcase}_#{@firm.subdomain}_#{@invoice.reminder_on.number}.pdf"
		else
			file = @firm.subdomain + '_' + @invoice.number.to_s + '.pdf'
		end
		attachments[file] = File.read("#{Rails.root}/tmp/shrimp/" + file)
		invoice_mail =  mail 	to: @email.address,  
													from:  InvoiceSender.format_address("no_reply@squadlink.com", @email.firm.name), 
													reply_to: InvoiceSender.set_email(@firm, @firm.users.where(role: "Admin").first),
													subject: @email.subject,
													content: @email.content
		invoice_mail.deliver
	end
end