module InvoiceRender
	extend self
	def make_hash(invoice_id)
		invoice = Invoice.find(invoice_id)
		logs 	= invoice.logs.group(:tax).sum('(hours/3600)*rate')
		lines	=	invoice.invoice_lines.all.group(:tax).sum('quantity*price')
		logs.merge(lines){|key, oldval, newval| newval + oldval}
	end 

end