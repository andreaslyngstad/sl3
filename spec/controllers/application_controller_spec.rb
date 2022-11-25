require 'spec_helper'
include ApplicationHelper
describe ApplicationController do
	describe "flash_helper" do
  		it "should return flash" do
			message = "test" 
			ApplicationController.new.flash_helper(message).should == "test"
  		end 
  	end
  end
  describe ApplicationController do
  	controller do
			def index
				render text: "hello"
			end
			
		end
		
	
		let(:firm){FactoryBot.create(:firm, subdomain: "test")}
		let(:user){FactoryBot.create(:user, firm: firm)}
	describe "current" do
		before(:each) do 
  		@request.host = "#{firm.subdomain}.example.com"
			sign_in(user) 
			get :index, subdomain: "test"
		end
		it "should current_firm" do
			response.code.should eq "200"
 			response.body.should include "hello"
 			assigns(:current_firm).subdomain.should == "test"
		end
		# it "should give Not found error" do
		# 	get "http://test.example.com/uggabugga"
		# 	flash.should == 'Not Found'
		# end
		# it "should return current subdomain" do
		# 	assigns(:current_subdomain).should == "test"
		# end
	end
	

end   