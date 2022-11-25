require 'spec_helper'
feature 'Sign up' do
  before(:all) do
    FactoryBot.create(:plan)
  end
  def signing_up
    visit root_url
     click_link 'Sign up for free'
     fill_in 'firm_name', :with => "Test"
     fill_in 'firm_subdomain', :with => "Test2"
     click_button "next"
     success_message = "Firm was successfully created! Now create the first user."
     page.should have_content(success_message) 
     fill_in 'user_name', :with => 'Test'
     fill_in 'user_email_reg', :with => 'test@example.com'
     fill_in 'user_password_reg', :with => 'password'  
     click_button "Save"
     page.should have_content("Signed in successfully")
     page.current_url.should == "http://test2.example.com/" 
  end
   scenario "creating an firm and first user" do 
     signing_up
   end
    
   scenario 'creating an firm and first user with wrong data' do 
     visit root_url 
     click_link 'Sign up for free'
     click_button "next" 
     page.should have_content ("Firm could not be created")
     page.should have_content ("can't be blank") 
     page.should have_content ("is invalid")
     fill_in 'firm_name', :with => "Test" 
     fill_in 'firm_subdomain', :with => "Test"
     click_button "next"
     click_button "Save"
     page.should have_content("can't be blank")
     page.should have_content("Registration could not be saved")
   end
   # scenario 'emails user on succsessfull signup' do
   #  signing_up
   #  r = ActiveRecord::Base.connection.execute("SELECT * FROM queue_classic_jobs")
   #  r.first["method"].should == "FirmMailer.sign_up_confirmation"
   # end
end