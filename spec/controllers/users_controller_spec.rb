require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe UsersController do 
  login_user
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
  end
  
  describe "GET #index" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    it "populates an array of users" do
      @user = FactoryBot.create(:user)
      get :index
      assigns(:users) == [@user]   
    end
    it "renders the :index view" do
      get :index
      response.should render_template("index")
    end
  end 
  
  describe "GET #show" do
    it "assigns the requested user to @user" do
      get :show, :id => @user
      assigns(:klass).should eq(@user) 
    end
    it "renders the #show view" do
      @user = FactoryBot.create(:user, :firm => @user.firm)
      get :show, :id => @user
      response.should redirect_to tabs_state_path(@user.class.to_s.downcase.pluralize, @user.id)
    end
  end
  describe "GET edit" do
    it "should assign user to @user" do
      xhr :get, :edit, :id => @user, :format => 'js'
      assigns(:user).should eq(@user) 
    end 
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new user", :vcr do
        expect{
          post :create, user: FactoryBot.attributes_for(:user), :format => 'js'
        }.to change(User,:count).by(1)
      end
      
      it "redirects to the new user", :vcr do
        post :create, user: FactoryBot.attributes_for(:user), :format => 'js'
        flash[:notice].should_not be_nil 
        
      end
    end 
  end
  describe 'PUT update' do
  context "valid attributes" do
    it "located the requested @user" do
      put :update, id: @user, user: FactoryBot.attributes_for(:user), :format => 'js'
      assigns(:user).should eq(@klass)      
    end
  
    it "changes @user's attributes" do
      put :update, id: @user, user: FactoryBot.attributes_for(:user, :name => "something else"), :format => 'js'
      @user.reload
      @user.name.should eq("something else")
    end
    it "does not change password or password_confirmation when the fields are blank" do
      put :update, id: @user, user: FactoryBot.attributes_for(:user, password: "", password_confirmation: "testtest"), :format => 'js'
      controller.params[:user].should_not include "password"
      put :update, id: @user, user: FactoryBot.attributes_for(:user, password: "testtest", password_confirmation: "testtest"), :format => 'js'
      controller.params[:user].should include "password" => "testtest"  
    end
  end
  context "invalid attributes" do
    it "locates the requested @user" do
      put :update, id: @user, user: FactoryBot.attributes_for(:user, :name => nil), :format => 'js'
      assigns(:user).should eq(nil)      
    end
    
    it "does not change @user's attributes" do
      put :update, id: @user, 
        user: FactoryBot.attributes_for(:user, :name => nil), :format => 'js'
      @user.reload
      @user.name.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @user = FactoryBot.create(:user, :firm => @user.firm)
    end
   
    it "deletes the user" do
     
      expect{
        delete :destroy, id: @user, :format => 'js'        
      }.to change(User,:count).by(-1)
    end
      it "deletes the current_user" do
        @user = subject.current_user
      expect{
        delete :destroy, id: @user, :format => 'js'        
      }.to change(User,:count).by(0)
    end
    # it "redirects to user#index" do
    #   delete :destroy, id: @user, :format => 'js'
    #   response.should redirect_to users_url
    # end
  end 
end