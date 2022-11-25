require "rails_helper"
describe FirmMailer do
   let(:firm)         { FactoryBot.create(:firm)}
    let(:user)         { FactoryBot.create(:user, firm:firm)}
    let(:subscription) { FactoryBot.create(:subscription, firm: firm, email:user.email) }
   
  describe 'sign up confirmation' do
     let(:mail) { FirmMailer.sign_up_confirmation(user) }
    it 'sends sign up confirmation' do
      mail.subject.should eq("Squadlink sign up confirmation.")
      mail.to.should eq([user.email])
      mail.from.should eq(["no_reply@squadlink.com"])
      mail.body.encoded.should include(user.name)
      mail.body.encoded.should include("We hope you'll enjoy your stay and are proud that you put your trust in us.")
    end
  end


  describe "overdue" do
   
    let(:mail) { FirmMailer.overdue(subscription) }
    it "sends overdue mail" do
      mail.subject.should eq("Squadlink payment is overdue.")
      mail.to.should eq([subscription.email])
      mail.from.should eq(["no_reply@squadlink.com"])
      mail.body.encoded.should include(user.name)
      mail.body.encoded.should include('We have not received payment for the ' + firm.name + ' account at squadlink.com')
      
    
    end
  end
  describe "two_weeks_overdue" do

    let(:mail) { FirmMailer.two_weeks_overdue(subscription) }
    it "sends two_weeks_overdue mail" do
      mail.subject.should eq("Squadlink payment is two weeks overdue.")
      mail.to.should eq([subscription.email])
      mail.from.should eq(["no_reply@squadlink.com"])
      mail.body.encoded.should include(user.name)
      mail.body.encoded.should include('squadlink.com is 14 days overdue')
      mail.body.encoded.should include('After that it will be reverted to a free account')
    end
  end
  describe "reverting_to_free" do
  
    let(:mail) { FirmMailer.reverting_to_free(subscription) }
    it "sends reverting_to_free mail" do
      mail.subject.should eq("Squadlink account revertet to free due to missing payment.")
      mail.to.should eq([subscription.email])
      mail.from.should eq(["no_reply@squadlink.com"])
      mail.body.encoded.should include(user.name)
      mail.body.encoded.should include('Your account is reverted to a free account. This process might have caused loss of data.')
     # mail.body.encoded.should match(edit_password_reset_path(user.password_reset_token))
    end
  end
  
    

end