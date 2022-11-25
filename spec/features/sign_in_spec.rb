require 'spec_helper'
feature 'Sign in user' do 
  
   before(:all) do 
      @user = FactoryBot.create(:user)
      @firm = @user.firm 
      @sign_in_url = "http://#{@firm.subdomain}.lvh.me:3000/users/sign_in" 
      @root_url = "http://#{@firm.subdomain}.lvh.me:3000/"
      @root_path = "http://lvh.me:3000/"
      Capybara.server_port = 31234 
      sub = @firm.subdomain
      Capybara.app_host = @root_url 
    end
    scenario "at subdomain" do
      logout 
      visit @root_url
      page.current_url.should == @sign_in_url
      page.should have_content("You need to sign in or register before continuing.")
      fill_in "user_email2", :with => @user.email
      fill_in "user_password2", :with => "password"
      click_button "sign_in2"
      page.should have_content("Signed in successfully")
      page.current_url.should == @root_url 
    end
     
    scenario 'at root' do  
      visit @root_path
      find("#sign_in_link").click
      fill_in "user_email_popup", :with => @firm.users.first.email
      fill_in "user_password_popup", :with => "password"
      click_button "Sign in"
      #page.current_url.should == @root_url
      page.should have_content("Signed in successfully")
    end
end  