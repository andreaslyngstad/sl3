require 'spec_helper'

describe Statistics do
  it "Saves a instance of it self" do
    Statistics.destroy_all
    User.stub(:count).and_return(1)    
    Log.stub(:count).and_return(1)    
    Project.stub(:count).and_return(1)    
    Customer.stub(:count).and_return(1)    
    Firm.stub_chain(:group, :count).and_return({1=>1,2=>2,1=>3,3=>4,2=>5})  
    Statistics.write_count
    Statistics.all.count.should be 1
    Statistics.last.logs.should be 1
  end
end
