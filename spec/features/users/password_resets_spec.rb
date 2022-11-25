require 'spec_helper'
require 'features/subdomain_login_features'
include Features
include MailHelpers
describe "PasswordResets" do
  before(:each) do
    @user = FactoryBot.create(:user)
    visit root_url
    find("#sign_in_link").click
    first(:link, 'Forgot your password?').click
    fill_in "Email", :with => @user.email
    click_button "Send instructions"
    current_path.should eq('/users/sign_in')
    page.should have_content("You will receive an email with instructions about how to reset your password in a few minutes.")
    last_email.to.should include(@user.email)
    @token = extract_token_from_email(:reset_password)
    
  end

  it "emails user when requesting password reset" do
    
    visit edit_password_url(reset_password_token: @token)
    fill_in "user_password", :with => "foobar12"
    fill_in "user_password_confirmation", :with => "foobar123"
    find('.signup_firm').find(".submit").click 
    page.should have_content("Password confirmation doesn't match")
  end
 
  it "does not email invalid user when requesting password reset" do
    visit sign_in_url
    first(:link, 'Forgot your password?').click
    fill_in "Email", :with => "nobody@example.com"
    click_button "Send instructions"
    current_path.should eq("/users/password")
    # page.should have_content("not found")
    last_email.to.should_not include("nobody@example.com")

  end

  it "reports when password token has expired" do
    @user.reset_password_sent_at = 6.hours.ago
    @user.save
    visit edit_password_url(:reset_password_token =>  @token)
    fill_in "user_password", :with => "foobar12"
    fill_in "Confirm", :with => "foobar12"
    click_button "Change my password"
    page.should have_content("Reset password token has expired, please request a new one")
  end

  it "raises record not found when password token is invalid" do
    visit edit_password_url(@user, :reset_password_token => "bla")
    fill_in "user_password", :with => "foobar"
    fill_in "Confirm", :with => "foobar"
    click_button "Change my password"
    page.should have_content("Reset password token is invalid")
  end
end