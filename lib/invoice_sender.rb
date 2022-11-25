module InvoiceSender
require 'mail'
	extend self
	def give_invoice_number(invoice,last_invoice)
		if invoice.number.nil?
	    if last_invoice
	      invoice.number = last_invoice.number + 1
	    else
	      invoice.number = invoice.firm.starting_invoice_number
	    end
  	end
	end

	def format_address(email,name)
		address = Mail::Address.new email # ex: "john@example.com"
		address.display_name = name # ex: "John Doe"
		# Set the From or Reply-To header to the following:
		address.format
	end
	
	def invoice_to_pdf(invoice_id) 
		Invoice.find(invoice_id).to_pdf
	end

	def invoice_to_pdf_and_send(invoice_id, email_id)
		invoice_to_pdf(invoice_id)
		InvoiceMailer.invoice(invoice_id, email_id)
	end
	def tester_dete(test)
		puts test
	end

	def invoice_to_pdf_and_download(invoice_id)
		invoice_to_pdf(invoice_id)
		Rails.logger.info "queue classic FUNGERE"
		Invoice.find(invoice_id).to_pdf
		filename = 
		send_file("#{Rails.root}/tmp/shrimp/" + params[:file], :filename => params[:file],  :type=>"application/pdf" )
	end

	def pdf_finished?(invoice)
		File.exists?("#{Rails.root}/tmp/shrimp/#{invoice.firm.subdomain}_#{invoice.number}.pdf")
	end
	
	def set_email(firm, user)
		if firm.invoice_email
			"#{firm.name} <#{firm.invoice_email}>"
		else
			"#{user.name} <#{user.email}>"
		end
	end

	def delete_old_files
		require 'fileutils'; Dir.glob("#{Rails.root}/tmp/shrimp/*.*").each{|f| File.delete(f) if File.mtime(f) < ( Time.now - (3600*24)) }
	end
end