require 'spec_helper'


describe UrlHelper do
	# before(:each) do
 #    @user = FactoryBot.create(:user) 
 #    login_as @user
 #    firm = @user.firm
 #  	@request.host = "#{firm.subdomain}.example.com" 	
 #  	@sub = FactoryBot.create(:subscription, plan_id: firm.plan.id, firm_id:firm.id )
 #  	@plan = FactoryBot.create(:plan)
 #  end
	it 'with_subdomain' do
		helper.with_subdomain("subdomain").should == "subdomain.test.host"
	end
	
	# it 'returns true with the current plan' do
	# 	helper.current_plan?(@user.firm.plan).should == true
	# end
	# it 'returns false with the current plan' do
	# 	helper.current_plan?(@plan).should == false
	# end 
	# it 'returns blue as the current plan style' do
	# 	helper.current_plan_style(@user.firm.plan).should == "blue"
	# end 
	# it 'returns blue as the current plan style' do
	# 	helper.current_plan_style(@plan).should == nil
	# end 
end      