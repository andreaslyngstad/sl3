require 'spec_helper'

describe TimerangeController do
	login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
    
  end
  describe "logs" do
	 	let(:project)  	{FactoryBot.create(:project, firm: @user.firm)}
	 	let(:customer)	{FactoryBot.create(:customer, firm: @user.firm)}
		let(:range)   	{Date.today - 5.days..Date.today}
		let(:log)	{FactoryBot.create(:log, project: project, firm: @user.firm, user: @user, log_date: Date.today)}

	  it "log_range date fields" do
	  	project.users << @user
	  	xhr :get, :log_range, from:(Date.today - 5.days).strftime('%Y-%m-%d'), to:(Date.today).strftime('%Y-%m-%d'), url: "Project", id: project.id, :format => 'js'
	  	assigns(:customers).should == [customer]
	  	assigns(:all_projects).should == [project]
	  	assigns(:logs).should == [log]
	  end
	  it "log_range select field" do
	  	project.users << @user
	  	xhr :get, :log_range, time: "to_day", url: "Project", id: project.id, :format => 'js'
	  	assigns(:customers).should == [customer]
	  	assigns(:all_projects).should == [project]
	  	assigns(:logs).should == [log]
	  end
	end	
	describe "todos" do
	 	let(:project)  	{FactoryBot.create(:project, firm: @user.firm)}
	 	let(:customer)	{FactoryBot.create(:customer, firm: @user.firm)}
		let(:range)   	{Date.today - 5.days..Date.today}
	 	let(:todo1)			{FactoryBot.create(:todo, project: project, firm: @user.firm, user: @user, completed: true, due: Date.today)}
	 	let(:todo2)			{FactoryBot.create(:todo, project: project, firm: @user.firm, user: @user, completed: false, due: Date.today)}

	  it "todo_range" do
	  	project.users << @user
	  	xhr :get, :todo_range,{from: (Date.today - 5.days).to_s, to:Date.today.to_s, url: "Project", id: project.id , :format => 'js'}
	  	assigns(:done_todos).should == [todo1]
	  	assigns(:not_done_todos).should == [todo2]
	  end
	  it "todo_range" do
	  	project.users << @user
	  	xhr :get, :todo_range, time: "to_day", url: "Project", id: project.id, :format => 'js'
	  	assigns(:done_todos).should == [todo1]
	  	assigns(:not_done_todos).should == [todo2]
	  end
	end	

end