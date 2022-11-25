require 'spec_helper'
require 'support/active_admin_spec_helper'
describe Obeqaslksdssdfnfdfysdfxm::BlogsController do
active_admin_signing_in
describe "Get firms" do

  it "finds firms" do
    @blog = FactoryBot.create(:blog)
  	get :index
    assigns(:blogs).should == [@blog]
  end
end
describe "GET #show" do
    it "assigns the requested blog to @blog" do
      @blog = FactoryBot.create(:blog)
      get :show, id: @blog
      assigns(:blog).should eq(@blog) 
    end
    it "renders the #show view" do
      test = FactoryBot.create(:blog)
      get :show, :id => test, :subdomain => nil
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign blog to @blog" do
      blog = FactoryBot.create(:blog)
      get :edit, :id => blog
      assigns(:blog).should eq(blog) 
    end 
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new blog" do
        expect{
          post :create, blog: FactoryBot.attributes_for(:blog)
        }.to change(Blog,:count).by(1)
      end
      
      it "redirects to the new blog" do
        post :create, blog: FactoryBot.attributes_for(:blog)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @blog = FactoryBot.create(:blog)
  end
  
  context "valid attributes" do
    it "located the requested @blog" do
      put :update, id: @blog, blog: FactoryBot.attributes_for(:blog)
      assigns(:blog).should eq(@blog)      
    end
  
    it "changes @blog's attributes" do
      put :update, id: @blog, blog: FactoryBot.attributes_for(:blog, title: "something else")
       @blog.reload
      @blog.title.should eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @blog = FactoryBot.create(:blog)
    end
    
    it "deletes the blog" do
      expect{
        delete :destroy, id: @blog     
      }.to change(Blog,:count).by(-1)
    end
      
    it "redirects to blog#index" do
      delete :destroy, id: @blog
      flash[:notice].should_not be_nil
    end
  end
  
end
