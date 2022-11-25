require 'spec_helper'
describe SessionsController do 
	let(:user)					{ FactoryBot.create(:user, loginable_token: "secret")}
	let(:firm)          { user.firm}
 
	describe "sign_in_at_subdomain" do
    context "with valid token" do
      it "sign_in_at_subdomain and creates last signin on user firm" do
      	@request.env["devise.mapping"] = Devise.mappings[:user]
      	user.loginable_token.should == 'secret'
      	@request.cookies[:token] = 'secret'
      	get :sign_in_at_subdomain
      	flash[:notice].should == "Signed in successfully."
      	firm.reload
      	firm.last_sign_in_at.should == Date.current
      end
    end
    context "with invalid token" do
      it "redirects to root with flash" do
      	@request.env["devise.mapping"] = Devise.mappings[:user]
      	@request.cookies[:token] = 'false_secret'
      	get :sign_in_at_subdomain
      	flash[:alert].should == "Login could not be validated"
      	firm.last_sign_in_at.should_not == Date.current
      end
    end
  end
  describe "create" do
    context "with params" do
      it "sign_in_at_subdomain and creates last signin on user firm" do
      	@request.env["devise.mapping"] = Devise.mappings[:user]	
      	post :create, user: {
      :email => user.email,
      :password => "user.password"
   		 }
      	# flash[:notice].should == "Signed in successfully"
      	assert_equal 200, @response.status
      	assert_template "devise/sessions/new"
      end
    end
    context "with invalid password" do
      it "redirects to root with flash", :vcr do
      	@request.env["devise.mapping"] = Devise.mappings[:user]
        @request.session["user_return_to"] = 'foo.bar'	
      	post :create, user: {
      :email => user.email,
      :password => user.password
   		 }
   		 assert_equal 'foo.bar', request.session["user_return_to"]
      end
    end
  end
end