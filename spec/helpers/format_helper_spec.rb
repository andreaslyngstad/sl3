require 'spec_helper'
describe ApplicationHelper do
	before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user] 
    @user = FactoryBot.create(:user) 
    sign_in @user
    @firm = @user.firm
    @firm.date_format = 1
    @firm.clock_format = 1
    @firm.time_format = 1
  	@request.host = "#{@firm.subdomain}.example.com" 	
  end
	it 'returns correct date format' do
		helper.date_format(Date.today).should == Date.today.strftime("%d.%m.%Y")
	end 
	it 'returns correct date format' do
		@firm.date_format = 2
		@firm.save
		helper.date_format(Date.today).should == Date.today.strftime("%m/%d/%Y")
	end 
	it 'returns correct date format' do
		helper.clock_format(Time.zone.now).should == Time.zone.now.strftime("%H:%M")
	end 
	it 'returns correct date format' do
		@firm.clock_format = 2
		@firm.save
		helper.clock_format(Time.zone.now).should == Time.zone.now.strftime("%I:%M%P")
	end 
	it 'returns correct date format' do
		helper.time_format(7500).should == '2:05'
	end 
	it 'returns correct date format' do
		@firm.time_format = 2
		@firm.save
		helper.time_format(7500).should == '2.08'
	end 
end
