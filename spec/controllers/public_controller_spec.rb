require 'spec_helper'


describe PublicController do 
  describe "registration frim" do
    it "Shows form for new firm" do
      get :register
      response.should render_template("register")
    end
  end
  
  describe "registration save frim" do
    describe "success" do
      it "Saves firm and goes to first user registration" do
        @firm = FactoryBot.attributes_for(:firm, :name => "Firm", :subdomain => "Test")
        post :create_firm, :firm => @firm 
        @firm = Firm.last
        @firm.name.should  == "Firm" 
        @firm.subdomain.should == "test"
        response.should redirect_to(register_user_path(@firm))
      end
    describe "failure" do
      it "Does not save firm without name" do
        @firm = FactoryBot.attributes_for(:firm, :name => "", :subdomain => "test")
        post :create_firm, :firm => @firm
        flash[:error].should_not be_nil 
        response.should render_template("register")
      end
      it "Does not save firm without subdomain" do
        @firm = FactoryBot.attributes_for(:firm, :name => "firm", :subdomain => "")
        post :create_firm, :firm => @firm
        flash[:error].should_not be_nil 
        response.should render_template("register")
      end
      it "Does not save firm with faulty subdomain" do
        @firm = FactoryBot.attributes_for(:firm, :name => "firm", :subdomain => "[:_")
        post :create_firm, :firm => @firm
        flash[:error].should_not be_nil
        response.should render_template("register") 
      end
    end
    end
  end
  describe "registration of first user in firm" do
    
    it "Shows form for new firm" do
      @firm = FactoryBot.create(:firm, :name => "Firm", :subdomain => "subdomain")
      get :first_user, :firm_id => @firm.id.to_s
      response.should render_template("first_user")
    end
  end
  describe "registration save first user" do
    before(:each) do
      @firm = FactoryBot.create(:firm)
    end   
    describe "success" do
      it "Saves user and gets redirected to application", :vcr do

        @user = FactoryBot.attributes_for(:user)
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user     
        flash[:error].should be_nil 
        user = @firm.users.first
        user.name.should  == @user[:name]
        user.email.should == @user[:email]
        # r = ActiveRecord::Base.connection.execute("SELECT * FROM queue_classic_jobs")
        # r.first["method"].should == "FirmMailer.sign_up_confirmation"
        # r.first["args"].should == "[#{user.id}]"

      end
    describe "failure" do
      it "Does not save user without name" do
        @user = FactoryBot.attributes_for(:user, name: '')
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        assigns[:user].errors[:name].should include "can't be blank"
        flash[:error].should_not be_nil
        response.should render_template("first_user")
      end
      it "Does not save user without email" do
        @user = FactoryBot.attributes_for(:user, :email => "")
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        assigns[:user].errors[:email].should include "can't be blank"
        flash[:error].should_not be_nil
        response.should render_template("first_user")
      end
      it "Does not save user with faulty email"  do
        @user = FactoryBot.attributes_for(:user, :email => "blah")
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        assigns[:user].errors[:email].should include "is not formatted properly"
        flash[:error].should_not be_nil
        response.should render_template("first_user") 
      end
      it "Does not save user without password" do
        @user = FactoryBot.attributes_for(:user, :password => "")
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        assigns[:user].errors[:password].should include "can't be blank"
        flash[:error].should_not be_nil
        response.should render_template("first_user") 
      end
      it "Does not save user with short password" do
        @user = FactoryBot.attributes_for(:user, :password => "1234")
        post :create_first_user, :firm_id => @firm.id.to_s, :user => @user
        assigns[:user].errors[:password].should include "is too short (minimum is 8 characters)"
        flash[:error].should_not be_nil
        response.should render_template("first_user") 
      end
      end
     end
    end
end