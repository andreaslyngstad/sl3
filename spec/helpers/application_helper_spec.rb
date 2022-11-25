require 'spec_helper'
describe ApplicationHelper do
	before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user] 
    @user = FactoryBot.create(:user) 
    sign_in @user
    @firm = @user.firm
  	@request.host = "#{@firm.subdomain}.example.com" 	
  end
	 
	it 'returns the current_firm' do
		helper.current_firm.should == @firm
	end

	it 'returns all users' do
		helper.all_users.should == [@user]
	end 
	it 'returns all_projects' do
		project = FactoryBot.create(:project, firm:@firm, active: true)
		project.users << @user
		project.save
		helper.all_projects.should == [project] 
	end 
	it 'returns all_customers when not external_user' do
		customer = FactoryBot.create(:customer, firm:@firm)
		helper.all_customers.should == [customer]
	end 
	it 'returns no customers when external_user' do
		@user.role = "external_user"
		@user.save
		customer = FactoryBot.create(:customer, firm:@firm)
		helper.all_customers.should == []
	end 

	it 'returns time now in current firms time zone' do

		helper.time_zone_now.to_i.should == Time.zone.now.in_time_zone.to_i
	end
	it "truncate_string" do
	  helper.truncate_string("1234567891234567891").should == "123456789123456..."
	  helper.truncate_string("12345678912345678").should == "12345678912345678"
	  helper.truncate_string("123456789123456789").should == "123456789123456789"

	end
	it "displays gravatar image of user", :vcr do
		helper.image(@user,"image32").should include("https://secure.gravatar.com/avatar/")
	end
	it "displays image32 of user" do
		user = mock_model(User, avatar:double(url: "test"),  avatar_file_name: "test")
		helper.image(user, 'image32').should == "<img alt=\"Test\" class=\"image32\" src=\"/images/test\" />"
	end
	it "displays image100 of user" do
		user = mock_model(User, avatar:double(url: "test"),  avatar_file_name: "test")
		helper.image(user, 'image100').should == "<img alt=\"Test\" class=\"image100\" src=\"/images/test\" />"
	end
	it "gives time difference in hours and minutes" do
	  helper.time_diff(7200).should == '2:00'
	end
	# it "returns :user as resource_name " do
	  
	# end
	# it 'returns blue as the current plan style' do
	# 	helper.current_plan_style(@plan).should == nil
	# end 
end      