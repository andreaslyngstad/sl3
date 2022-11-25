require 'spec_helper'
describe TrackingHelper do
	it "spits out array of hours, minutes and seconds" do
		helper.time_difference(7530).should == [2, 5, 30]
	end 
	it 'returns hours with 0 infront if < 10' do 
		helper.hours(7530).should == '02'
	end
  it 'returns hours without 0 infront if > 10' do 
		helper.hours(36000).should == '10'
	end
  it 'returns minutes with 0 infront if < 10' do 
		helper.min(7530).should == '05'
	end
  it 'returns minutes without 0 infront if > 10' do 
		helper.min(7830).should == '10'
	end
  it 'returns seconds with 0 infront if < 10' do 
		helper.sec(7505).should == '05'
	end
  it 'returns seconds without 0 infront if > 10' do 
		helper.sec(7810).should == '10'
	end
end 