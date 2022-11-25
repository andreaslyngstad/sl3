require 'spec_helper'
require 'support/active_admin_spec_helper'



describe Obeqaslksdssdfnfdfysdfxm::UsersController do
active_admin_signing_in
describe "Get firms" do

  it "GET index" do
  	user = FactoryBot.create(:user)
  	get :index
    assigns(:users).should == [user]
  end
end
describe "GET #show" do
    it "assigns the requested user to @user" do
      user = FactoryBot.create(:user)
      get :show, :id => user
      assigns(:user).should eq(user) 
    end
    it "renders the #show view" do
      user = FactoryBot.create(:user)
      get :show, :id => user
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign user to @user" do
      user = FactoryBot.create(:user)
      get :edit, :id => user
      assigns(:user).should eq(user) 
    end 
  end

  describe 'PUT update' do
  before :each do
    @user = FactoryBot.create(:user)
  end
  
  context "valid attributes" do
    it "located the requested @user" do
      put :update, id: @user, user: FactoryBot.attributes_for(:user)
      assigns(:user).should eq(@user)      
    end
  
    it "changes @user's attributes" do
      put :update, id: @user, user: FactoryBot.attributes_for(:user, name: "something else")
       @user.reload
      @user.name.should eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @user = FactoryBot.create(:user)
    end
    
    it "deletes the user" do
      expect{
        delete :destroy, id: @user     
      }.to change(User,:count).by(-1)
    end
      
    it "redirects to user#index" do
      delete :destroy, id: @user
      flash[:notice].should_not be_nil
    end
  end
  
end
