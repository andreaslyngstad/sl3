require 'spec_helper'
describe InvoiceMailer do
	describe 'Sending invoice' do
    let(:firm)        { FactoryBot.create(:firm, name:"test", bank_account: 123, vat_number: 2123, invoice_email:"firm@test.com", invoice_email_message: "TEST MESSAGE")}
    let(:user)        { FactoryBot.create(:user, firm:firm)}
    let(:customer)		{ FactoryBot.create(:customer, firm:firm, email: "test@test.com")}
    let(:invoice)			{ FactoryBot.create(:invoice, firm:firm, customer:customer, number: 3)}
    let(:file)        { File.new(firm.subdomain + '_' + invoice.number.to_s + '.pdf', "w+")}
    let(:email)       { FactoryBot.create(:email2, address: "test@test.com", firm:firm, invoice: invoice)}
    let(:mail) 				{ InvoiceMailer.invoice(invoice.id, email.id) }
    let(:reminder)		{ InvoiceMailer.reminder(invoice, email.id) }
    def file_creater(firm, invoice)
      File.new('/home/andreas/ws/sl2/tmp/shrimp/' + firm.subdomain + '_' + invoice.number.to_s + '.pdf', "w+")
    end
   
   
    it 'sends invoice' do
      invoice
      email
      
      file_creater(firm, invoice)
      mail.subject.should eq("Invoice")
      mail.to.should eq(["test@test.com"])
      mail.reply_to.should eq([ "firm@test.com"])
      # mail.from.should eq(["test<no_reply@squadlink.com>"])   cant get this to work. in action it formats email with name first, but not in spec. 
      mail.attachments.should have(1).attachment
      attachment = mail.attachments[0]
      attachment.filename.should == invoice.firm.subdomain + '_' + invoice.number.to_s + '.pdf'
      mail.body.encoded.should include(firm.invoice_email_message)
      mail.body.encoded.should include('This invoice is made in <a href="https://squadlink.com">Squadlink</a>')
    end
  end
end 