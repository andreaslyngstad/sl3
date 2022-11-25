require "rails_helper"
require "./lib/invoice_render.rb"
describe InvoiceRender do
	
	let(:firm)        {FactoryBot.create(:firm, bank_account: 12, vat_number: 123)}
  let(:firm1)       {FactoryBot.create(:firm)}
  let(:time_now)    {Time.zone.now}
  let(:user)        {FactoryBot.create(:user, :firm => firm)}
  let(:invoice)     {FactoryBot.create(:invoice, status: 2, customer:customer, firm:firm, due: Date.current, total: 200, receivable: 200)}
  let(:log2)        {FactoryBot.create(:log, invoice: invoice, rate: 100, tax: 25, :user => user, :firm => firm, :begin_time => time_now, :end_time => time_now + 1.hours ) }
  let(:log4)        {FactoryBot.create(:log, invoice: invoice, rate: 50, tax: 25, :user => user, :firm => firm, :begin_time => time_now, :end_time => time_now + 2.hours) }
  let(:log3)        {FactoryBot.create(:log, invoice: invoice, rate: 100, tax: 10, :user => user, :firm => firm, :begin_time => time_now, :end_time => time_now + 1.hours ) }
  let(:invoice_line) { FactoryBot.create(:invoice_line, invoice: invoice, quantity: 2, price: 15, tax: 25) }  
  let(:invoice_line2) { FactoryBot.create(:invoice_line, invoice: invoice, quantity: 2, price: 6, tax: 10) }
  let(:customer) {FactoryBot.create(:customer, firm:firm)}
	it 'creates a hash with values' do
		log2
		log3
		log4
		invoice_line
		invoice_line2
	  InvoiceRender.make_hash(invoice.id).should == {10.0=>112.0, 25.0=>230.0}
	end
  
end  