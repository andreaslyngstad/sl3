class InvoiceLine < ActiveRecord::Base
	belongs_to :invoice
	validates_presence_of :description
	validates_presence_of :quantity
	validates_presence_of :price

	validates_numericality_of :quantity
	validates_numericality_of :price
	def total_price
		((quantity*price*((100 + tax)/100)).prettify)
	end

end
