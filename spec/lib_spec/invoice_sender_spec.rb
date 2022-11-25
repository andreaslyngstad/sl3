
require "./lib/invoice_sender.rb"
describe InvoiceSender do
	let(:firm)        { double(:firm, starting_invoice_number: 3, name:"test",invoice_email:"firm@test.com", invoice_email_message: "TEST MESSAGE", bank_account: "12", vat_number: "1123")}
	let(:firm2)        { double(:firm, invoice_email_message: "TEST MESSAGE", bank_account: "12", vat_number: "1123")}
  let(:user)        { double(:user, firm:firm, name: "test_user",email:"test_user@test.com")}
  let(:customer)		{ double(:customer, firm:firm, email: "test@test.com")}
  let(:invoice)			{ double(:invoice, firm:firm, customer:customer)}
  let(:invoice2)		{ double(:invoice, firm:firm, customer:customer, number: 100)}
  let(:invoice3)			{invoice.class.stub(last_with_number: nil )}

	it 'formats email address' do
	  InvoiceSender.format_address("test@test.no","test").should eq "test <test@test.no>"
	end


	it "should get a invoice number" do
		# invoice4 = invoice.class.stub(last_with_number: nil )
		# invoice4.class.should_receive(:last_with_number).with(firm) 
		invoice.should_receive(:number).nil?
		invoice.should_receive(:number=).with(3)
		firm.should_receive(:starting_invoice_number).with()
		InvoiceSender.give_invoice_number(invoice, nil).should eq 3 
	end 
	it "should get number after last invoice" do
		invoice.should_receive(:number).nil?
		invoice.should_receive(:number=).with(101)
		InvoiceSender.give_invoice_number(invoice,invoice2) 
	end
	
	it "should return the firms invoice email if it exists" do
		InvoiceSender.set_email(firm,nil).should == "#{firm.name} <#{firm.invoice_email}>"
	end
	it "should return the first user email if firms invoice email does not exists" do
		firm2.should_receive(:invoice_email).with()
		user.should_receive(:name).with()
		user.should_receive(:email).with()
		InvoiceSender.set_email(firm2, user).should == "#{user.name} <#{user.email}>"
	end
end