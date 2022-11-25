require 'spec_helper'

describe SubscriptionsController do
  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
    
  end
  
  describe "GET 'new'" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    it "returns http success" do
      @plan = FactoryBot.create(:plan, paymill_id: "bull" )
      get 'new', plan_id: @plan.id.to_s
      response.should be_success
    end 
  end
# comment 06.06.13
# describe "GET #show" do
#     it "assigns the requested project to @project" do
#       @subscription = FactoryBot.create(:subscription, :firm => @user.firm)
#       get :show, :id => @subscription
#       assigns(:subscription) == [@subscription] 
#     end
#     it "renders the #show view" do
#       @subscription = FactoryBot.create(:subscription, :firm => @user.firm)
#       get :show, :id => @subscription
#       response.should render_template :show
#     end
#   end
  describe "POST create", :vcr do
    let(:subscription) { mock_model(Subscription).as_null_object }

    before do
      Subscription.stub(:new).and_return(subscription)
    end

    it "creates a new Subscription" do
      Subscription.should_receive(:new).
        with("card_expiration" => "a quick brown fox").
        and_return(subscription)
      post :create, :subscription => { "card_expiration" => "a quick brown fox" }
    end

    it "saves the Subscription" do
      subscription.should_receive(:save_with_payment)
      post :create, :subscription => { "card_expiration" => "a quick brown fox" }
    end

    it "redirects to the Subscription index" do
       post :create, :subscription => { "card_expiration" => "a quick brown fox" }
      response.should redirect_to(:controller => "plans", :action => "index")
    end
  end 
  describe 'DELETE destroy', :vcr do
    let(:firm)          { FactoryBot.create(:firm)}
    let(:subscription)  { FactoryBot.create(:subscription, last_four: "1234", card_type: "VISA", firm_id: firm.id, paymill_id: "test")}
    let(:plan)          { FactoryBot.create(:plan, name: 'Free')}
   
    it "deletes the subscription", :vcr do
      old_subscription = firm.subscription
      delete :destroy, id: old_subscription
      Subscription.where(firm_id: @user.firm.id).first.plan.name.should == 'Free'
      @user.firm.subscription.should_not == old_subscription  
      expect{Subscription.find(old_subscription.id)}.to raise_error(ActiveRecord::RecordNotFound)   
    end
    
    it "redirects to project#index" do
      delete :destroy, id: subscription
      response.should redirect_to plans_url
    end
    it "shows flach notice" do
      delete :destroy, id: subscription
      flash[:notice].should == "You are now on the free plan"
    end

  end
end