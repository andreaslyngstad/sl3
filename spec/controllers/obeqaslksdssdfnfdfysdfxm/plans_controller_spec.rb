require 'spec_helper'
require 'support/active_admin_spec_helper'

describe Obeqaslksdssdfnfdfysdfxm::PlansController do
  active_admin_signing_in
describe "Get firms" do

  it "GET index" do
  	plan = FactoryBot.create(:plan)
  	get :index
    assigns(:plans).should == [plan]
  end
end
describe "GET #show" do
    it "assigns the requested plan to @plan" do
      plan = FactoryBot.create(:plan)
      get :show, :id => plan
      assigns(:plan).should eq(plan) 
    end
    it "renders the #show view" do
      plan = FactoryBot.create(:plan)
      get :show, :id => plan
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign plan to @plan" do
      plan = FactoryBot.create(:plan)
      get :edit, :id => plan
      assigns(:plan).should eq(plan) 
    end 
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new plan" do
        expect{
          post :create, plan: FactoryBot.attributes_for(:plan)
        }.to change(Plan,:count).by(1)
      end
      
      it "redirects to the new plan" do
        post :create, plan: FactoryBot.attributes_for(:plan)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @plan = FactoryBot.create(:plan)
  end
  
  context "valid attributes" do
    it "located the requested @plan" do
      put :update, id: @plan, plan: FactoryBot.attributes_for(:plan)
      assigns(:plan).should eq(@plan)      
    end
  
    it "changes @plan's attributes" do
      put :update, id: @plan, plan: FactoryBot.attributes_for(:plan, name: "something else")
       @plan.reload
      @plan.name.should eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @plan = FactoryBot.create(:plan)
    end
    
    it "deletes the plan" do
      expect{
        delete :destroy, id: @plan     
      }.to change(Plan,:count).by(-1)
    end
      
    it "redirects to plan#index" do
      delete :destroy, id: @plan
      flash[:notice].should_not be_nil
    end
  end
  
end
