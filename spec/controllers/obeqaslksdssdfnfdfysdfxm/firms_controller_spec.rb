require 'spec_helper'
require 'support/active_admin_spec_helper'


describe Obeqaslksdssdfnfdfysdfxm::FirmsController do
active_admin_signing_in
describe "Get firms" do
  before(:each) do
    @firm = FactoryBot.create(:firm)
    # Firm.should_receive(:find).at_least(:once).and_return(@firm)
  end

  after(:each) do
    @firm.destroy
  end

  it "finds firms" do
  	get :index
    assigns(:firms).should == [@firm]
  end
end
end