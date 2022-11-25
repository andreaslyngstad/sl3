require 'spec_helper'
require 'support/active_admin_spec_helper'
describe Obeqaslksdssdfnfdfysdfxm::GuidesController do
active_admin_signing_in
describe "Get firms" do

  it "GET index" do
  	guide = FactoryBot.create(:guide)
  	get :index
    assigns(:guides).should == [guide]
  end
end
describe "GET #show" do
    it "assigns the requested guide to @guide" do
      guide = FactoryBot.create(:guide)
      get :show, :id => guide
      assigns(:guide).should eq(guide) 
    end
    it "renders the #show view" do
      guide = FactoryBot.create(:guide)
      get :show, :id => guide
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign guide to @guide" do
      guide = FactoryBot.create(:guide)
      get :edit, :id => guide
      assigns(:guide).should eq(guide) 
    end 
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new guide" do
        expect{
          post :create, guide: FactoryBot.attributes_for(:guide)
        }.to change(Guide,:count).by(1)
      end
      
      it "redirects to the new guide" do
        post :create, guide: FactoryBot.attributes_for(:guide)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @guide = FactoryBot.create(:guide)
  end
  
  context "valid attributes" do
    it "located the requested @guide" do
      put :update, id: @guide, guide: FactoryBot.attributes_for(:guide)
      assigns(:guide).should eq(@guide)      
    end
  
    it "changes @guide's attributes" do
      put :update, id: @guide, guide: FactoryBot.attributes_for(:guide, title: "something else")
       @guide.reload
      @guide.title.should eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @guide = FactoryBot.create(:guide)
    end
    
    it "deletes the guide" do
      expect{
        delete :destroy, id: @guide     
      }.to change(Guide,:count).by(-1)
    end
      
    it "redirects to guide#index" do
      delete :destroy, id: @guide
      flash[:notice].should_not be_nil
    end
  end
  
end
