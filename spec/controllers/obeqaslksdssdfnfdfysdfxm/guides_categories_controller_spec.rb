require 'spec_helper'
require 'support/active_admin_spec_helper'
describe Obeqaslksdssdfnfdfysdfxm::GuidesCategoriesController do
active_admin_signing_in
describe "Get firms" do

  it "GET index" do
  	guides_category = FactoryBot.create(:guides_category)
  	get :index
    assigns(:guides_categories).should == [guides_category]
  end
end
describe "GET #show" do
    it "assigns the requested guides_category to @guides_category" do
      guides_category = FactoryBot.create(:guides_category)
      get :show, :id => guides_category
      assigns(:guides_category).should eq(guides_category) 
    end
    it "renders the #show view" do
      guides_category = FactoryBot.create(:guides_category)
      get :show, :id => guides_category
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign guides_category to @guides_category" do
      guides_category = FactoryBot.create(:guides_category)
      get :edit, :id => guides_category
      assigns(:guides_category).should eq(guides_category) 
    end 
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new guides_category" do
        expect{
          post :create, guides_category: FactoryBot.attributes_for(:guides_category)
        }.to change(GuidesCategory,:count).by(1)
      end
      
      it "redirects to the new guides_category" do
        post :create, guides_category: FactoryBot.attributes_for(:guides_category)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @guides_category = FactoryBot.create(:guides_category)
  end
  
  context "valid attributes" do
    it "located the requested @guides_category" do
      put :update, id: @guides_category, guides_category: FactoryBot.attributes_for(:guides_category)
      assigns(:guides_category).should eq(@guides_category)      
    end
  
    it "changes @guides_category's attributes" do
      put :update, id: @guides_category, guides_category: FactoryBot.attributes_for(:guides_category, title: "something else")
       @guides_category.reload
      @guides_category.title.should eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @guides_category = FactoryBot.create(:guides_category)
    end
    
    it "deletes the guides_category" do
      expect{
        delete :destroy, id: @guides_category     
      }.to change(GuidesCategory,:count).by(-1)
    end
      
    it "redirects to guides_category#index" do
      delete :destroy, id: @guides_category
      flash[:notice].should_not be_nil
    end
  end
  
end
