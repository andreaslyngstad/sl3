require 'spec_helper'
describe RosterController do 
  login_user
  before(:each) do
    @request.host = "#{ @user.firm.subdomain}.example.com"
    @project = FactoryBot.create(:project, :firm => @user.firm)
    @project.users << @user
  end

  describe "GET milestones" do
	  it "populates an array of milestones" do 
	  	milestone1 = FactoryBot.create(:milestone, :due => Time.zone.now - 1.day, :firm => @user.firm,:project => @project)
			milestone2 = FactoryBot.create(:milestone, :due => Time.zone.now + 1.day, :firm => @user.firm,:project => @project)
			milestone3 = FactoryBot.create(:milestone, :due => Time.zone.now + 15.days, :firm => @user.firm,:project => @project)
	    xhr :get, :get_milestones, :format => 'js'
	    assigns(:milestones).should eq([milestone1,milestone2])
	    assigns(:milestones).should_not include (milestone3)
	  end 
  end 
  describe "get tasks" do
    it "assigns the requested get tasks to @tasks_overdue_and_to_day" do
    	todo1 = FactoryBot.create(:todo, user: @user, firm: @user.firm, project: @project, due: Time.zone.now.to_date, completed: false )  
      todo2 = FactoryBot.create(:todo, user: @user, firm: @user.firm, project: @project, due: Time.zone.now.to_date + 1.day, completed: false )  
      xhr :get, :get_tasks, :format => 'js'
      assigns(:tasks_overdue_and_to_day).should eq([todo1])
      assigns(:tasks_overdue_and_to_day).should_not include (todo2)
    end
  end
end