require 'spec_helper'
require 'support/active_admin_spec_helper'


describe Obeqaslksdssdfnfdfysdfxm::LogsController do
 active_admin_signing_in 
 
  let!(:log)  {t = FactoryBot.build(:log)
                t.save(:validate => false)
                t}
                active_admin_signing_in
describe "Get firms" do

  it "GET index" do

  	get :index
    assigns(:logs).should == [log]
  end
end
describe "GET #show" do
    it "assigns the requested log to @log" do
  
      get :show, :id => log
      assigns(:log).should eq(log) 
    end
    it "renders the #show view" do
     
      get :show, :id => log
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign log to @log" do
     
      get :edit, :id => log
      assigns(:log).should eq(log) 
    end 
  end

  describe 'DELETE destroy' do
    
    
    it "deletes the log" do
      expect{
        delete :destroy, id: log     
      }.to change(Log,:count).by(-1)
    end
      
    it "redirects to log#index" do
      delete :destroy, id:  log
      flash[:notice].should_not be_nil
    end
  end
end