require 'spec_helper'

describe LogsController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
  end
  
  describe "GET #index" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    it "populates an array of logs" do
      log = FactoryBot.create(:log, log_date: Time.zone.now.to_date, :user => @user, :firm => @user.firm)
      get :index
      assigns(:logs).should == [log]   
    end
    it "renders the :index view" do
      get :index
      response.should render_template("index")
    end
  end 
   
  describe "GET edit" do
    it "should assign project to @project" do
      log = FactoryBot.create(:log, :user => @user, :firm => @user.firm)
      xhr :get, :edit, :id => log, :format => 'js'
      assigns(:log).should eq(log) 
    end 
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new log" do
        expect{
          post :create, log: FactoryBot.attributes_for(:log), :format => 'js'
        }.to change(Log,:count).by(1)
      end
      
      it "gives flash notice when creating new log" do
        post :create, log: FactoryBot.attributes_for(:log), :format => 'js'
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe "POST create" do
    context "with invalid attributes" do
      it "creates a new log" do
        expect{
          post :create, log: FactoryBot.attributes_for(:log, begin_time: Time.zone.now, end_time: Time.zone.now - 1.hour), :format => 'js'
        }.to change(Log,:count).by(0)
      end
      
      it "gives flash notice when creating new log" do
        post :create, log: FactoryBot.attributes_for(:log, begin_time: Time.zone.now, end_time: Time.zone.now - 1.hour), :format => 'js'
        response.should render_template("shared/validate_create")
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @log = FactoryBot.create(:log, user: @user, firm: @user.firm)
  end
  
  context "valid attributes" do
    
  
    it "changes @log's attributes" do
      put :update, id: @log, log: FactoryBot.attributes_for(:log, :event => "something else"), :format => 'js'
      @log.reload
      @log.event.should eq("something else")
    end
  end
  context "with invalid attributes" do
    it "does not changes a invalid log" do
      put :update, id: @log, log: FactoryBot.attributes_for(:log, :event => "something wrong", begin_time: Time.zone.now, end_time: Time.zone.now - 1.hour), :format => 'js'
      @log.reload
      @log.event.should eq("customer man")
    end
    
    it "gives error when changes invalid log" do
      put :update, id: @log, log: FactoryBot.attributes_for(:log, begin_time: Time.zone.now, end_time: Time.zone.now - 1.hour), :format => 'js'
      response.should render_template("shared/validate_update")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @log = FactoryBot.create(:log, :user => @user,:firm => @user.firm)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @log , :format => 'js'       
      }.to change(Log,:count).by(-1)
    end
  end
  describe 'post start tracking' do
    it "creates a new log" do
        expect{
          post :start_tracking, log: FactoryBot.attributes_for(:log), :format => 'js'
        }.to change(Log,:count).by(1)
      end
    it 'should get vaild repsonse' do 
    end
  end
  describe 'post stop tracking' do
    before :each do
      @log = FactoryBot.create(:log, user: @user, firm: @user.firm)
    end
  
    context "valid attributes" do
      it "changes @log's attributes" do
        put :stop_tracking, id: @log, log: FactoryBot.attributes_for(:log, :event => "something else"), :format => 'js'
        assigns(:log).should eq(@log)
        @log.reload
        @log.event.should eq("something else")
      end
    end
  end
  describe 'get_logs_todo' do
    it 'should assign todo to @todo' do  
      project = FactoryBot.create(:project, firm: @user.firm)
      project.users << @user
      todo = FactoryBot.create(:todo, user: @user, firm: @user.firm, project: project)
      log = FactoryBot.create(:log, todo: todo, project: project, user: @user, firm: @user.firm)
      xhr :get, :get_logs_todo, todo_id: todo, :format => 'js'
      assigns(:todo).should eq(todo)
    end
    it 'should send it off to LogWorker' do
    end
  end
end

