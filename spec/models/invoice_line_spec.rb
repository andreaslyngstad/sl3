require 'spec_helper'
describe InvoiceLine do
	let(:firm)				 { FactoryBot.create(:firm) }
	let(:customer) {FactoryBot.create(:customer, firm:firm)}
  let(:user)      	 { FactoryBot.create(:user, :firm => firm)}
	let(:invoice)  {FactoryBot.create(:invoice, status: 2, customer:customer, firm:firm, due: Date.today)}
	let(:invoice_line) { FactoryBot.create(:invoice_line, invoice: invoice, quantity: 2, price: 5.222, tax: 25.00001) }  
	let(:invoice_line2) { FactoryBot.create(:invoice_line, invoice: invoice, quantity: 2, price: 5, tax: 25) }  
	it { should belong_to(:invoice) }

	it "total_line returns total price" do 
		invoice_line.total_price.should eq 13.06
		invoice_line2.total_price.should eq 12.5
	end

end