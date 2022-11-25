require 'spec_helper'
describe TodoHelper do
	before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user] 
    @user = FactoryBot.create(:user) 
    sign_in @user
    @firm = @user.firm
  	@request.host = "#{@firm.subdomain}.example.com" 	
  end
  it 'returns color based on priority' do
  	helper.todo_priority(3).should == 'todo_red'
  	helper.todo_priority(2).should == 'todo_yellow'
  	helper.todo_priority(1).should == 'todo_green'
  end
  it 'returns not done todos in procent' do 
  	helper.done_not_done([1,1,1,1,1], [1,1,1,1,1]).should == '50.0%'
  	helper.done_not_done([1,1,1,1,1], [1,1,1]).should == '62.5%'
  end
end