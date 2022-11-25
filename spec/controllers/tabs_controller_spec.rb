require 'spec_helper'

describe TabsController do
	login_user
  let(:project)  	{FactoryBot.create(:project, firm: @user.firm)}
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
  end
  describe "milestones" do
	 	let(:milestone)	{FactoryBot.create(:milestone, project: project, firm: project.firm)}
	  it "should get milestones" do
	  	xhr :get, :milestones, id: project.id, class: "projects", :format => 'js'
	  	assigns(:milestones).should == [milestone]
	  end
	end	
	describe "todos" do
	 	let(:todo1)			{FactoryBot.create(:todo, project: project, firm: @user.firm, user: @user, completed: false, due: Date.current)}
	 	let(:todo2)			{FactoryBot.create(:todo, project: project, firm: @user.firm, user: @user, completed: true, due: Date.current)}
	  it "should get todos" do
	  	xhr :get, :todos, id: project.id, class: "projects", :format => 'js'
	  	assigns(:not_done_todos).should == [todo1]
	  	assigns(:done_todos).should == [todo2]
	  	assigns(:members).should == [@user]
	  end
	end	
	describe "logs" do	
	 	let(:log)	{FactoryBot.create(:log, project: project, firm: @user.firm, user: @user, log_date: Date.current)}
	  it "should get logs" do
	  	xhr :get, :logs, id: project.id, class: "projects", :format => 'js'
	  	assigns(:logs).should == [log]
	  end
	end	
	describe "users" do
	 	it "should get users" do
	  	project.users << @user
	  	xhr :get, :users, id: project.id, class: "projects", :format => 'js'
	  	assigns(:members).should == [@user]
	  end
	end	
	describe "statistics" do
	 	let(:log)	{FactoryBot.create(:log, project: project, firm: @user.firm, user: @user, log_date: Date.current)}

	  it "should get statistics" do
	  	xhr :get, :statistics, id: project.id, class: "projects", :format => 'js'
	  	assigns(:logs).should == [log]
	  end
	end	
	describe "statistics" do
	 	let(:log)	{FactoryBot.create(:log, project: project, firm: @user.firm, user: @user, log_date: Date.current)}

	  it "should get statistics" do
	  	project.users << @user
	  	xhr :get, :spendings, id: project.id, class: "projects", :format => 'js'
	  	assigns(:logs).should == [log]
	  	assigns(:users).should == [@user]
	  end
	end	
end  