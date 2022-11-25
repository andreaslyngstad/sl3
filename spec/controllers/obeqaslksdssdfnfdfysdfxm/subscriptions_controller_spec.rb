require 'spec_helper'
require 'support/active_admin_spec_helper'



describe Obeqaslksdssdfnfdfysdfxm::SubscriptionsController do
  active_admin_signing_in
  let!(:subscription)  {t = FactoryBot.build(:subscription)
                t.save(:validate => false)
                t}
                active_admin_signing_in
describe "Get subscriptions" do

  it "GET index" do

  	get :index
    assigns(:subscriptions).should include(subscription)
  end
end
describe "GET #show" do
    it "assigns the requested subscription to @subscription" do
  
      get :show, :id => subscription
      assigns(:subscription).should eq(subscription) 
    end
    it "renders the #show view" do
     
      get :show, :id => subscription
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign subscription to @subscription" do
     
      get :edit, :id => subscription
      assigns(:subscription).should eq(subscription) 
    end 
  end

  describe 'DELETE destroy' do
    
    
    it "deletes the subscription" do
      expect{
        delete :destroy, id: subscription     
      }.to change(Subscription,:count).by(-1)
    end
      
    it "redirects to subscription#index" do
      delete :destroy, id:  subscription
      flash[:notice].should_not be_nil
    end
  end
end