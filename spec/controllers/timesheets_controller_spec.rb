require 'spec_helper'

describe TimesheetsController do
	login_user
  
  
    let(:firm)          {@user.firm}
    let(:customer)      {FactoryBot.create(:customer, firm: firm)}
    let(:project)       {FactoryBot.create(:project, firm: firm)}
    let(:log)           {FactoryBot.create(:log, customer: customer, firm: firm, user: @user, hours:1, log_date: Date.current)}
    let(:log_no_customer){FactoryBot.create(:log, firm: firm, user: @user, hours:1,log_date: Date.current)}
    let(:external_user) {FactoryBot.create(:user, firm: firm, role: "external_user")}
    let(:log_ex)           {FactoryBot.create(:log,  customer: customer, firm: firm, project:project,user: external_user, hours:1, log_date: Date.current)}
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
  end

  describe "timesheet_day" do	
	  it "timesheet_week user admin" do
	  	firm.users << external_user
	  	get :timesheet_day, class: "customers", id: customer.id, date: Date.current
	  	assigns(:logs).should == customer.logs.where(:log_date => Date.current)
	  end
  end

  describe "timesheet_week different users" do
  	let(:firm) 					{@user.firm}
  	let(:external_user) {FactoryBot.create(:user, firm: firm, role: "external_user")}
	  it "timesheet_week user admin" do
      log
      log_no_customer
      log_ex
	  	firm.users << external_user
	  	get :timesheet_week, class: "customers", id: customer.id, date: Date.current
	  	assigns(:users).should =~ [@user, external_user]
	  	assigns(:dates).should == ((Time.zone.now.beginning_of_week.to_date)..(Time.zone.now.end_of_week.to_date))
    	assigns(:log_project).should == {nil=>60.0, project.id=>60.0}
    	assigns(:log_week).should == {Date.current=>120.0}
    	assigns(:log_week_project).should == {[project.id,Date.current]=>60.0, [nil, Date.current]=>60.0}
    	assigns(:log_week_no_project).should == {Date.current=>60.0}
    	assigns(:projects).should == @user.projects
    	# assigns(:log_total).should == @user.logs.where(:log_date => range).sum(:hours) 
	  end
  	it "timesheet_week user external_user" do
  		@user.role = "external_user"
  		@user.save
	  	firm.users << external_user
	  	get :timesheet_week, class: "customers", id: customer.id, date: Date.current
	  	expect(response).to render_template("access_denied")
	  end
  end
  describe "timesheet_month" do
  	let(:firm) 					{@user.firm}
  	let(:external_user) {FactoryBot.create(:user, firm: firm, role: "external_user")}
	  it "timesheet_week user admin" do
      log
      log_no_customer
      log_ex
	  	firm.users << external_user
	  	get :timesheet_month, class: "customers", id: customer.id, date: Date.current
	  	assigns(:date).should == Date.current
	  	assigns(:logs_by_date).should == {Date.current=>120.0}
    end
  end
  describe "adding logs to timesheet" do
  	let(:firm) {@user.firm}
  	let(:log)  {FactoryBot.attributes_for(:log, end_time: Time.zone.now + 2.hours, begin_time: Time.zone.now, user_id: @user.id)}
  	it "should get the user" do
  		post :add_log_timesheet, log: log, :format => 'js'
  		assigns(:user).should == @user
  	end
  	it "increases log count" do
  		 expect{
          post :add_log_timesheet, log: FactoryBot.attributes_for(:log, user_id: @user.id), :format => 'js'
        }.to change(Log,:count).by(1)
  	end
  end
  describe "add_hour_to_project" do
  	let(:firm)     {@user.firm}
    let(:project)  {FactoryBot.create(:project, firm: firm)}
    let(:log)      {FactoryBot.create(:log, event: "old log", user: @user, project: project, firm: firm)}
    it "With empty field" do
  		post :add_hour_to_project, select_klass: project.class.to_s.downcase, select_id: project.id, klass: @user.class.to_s.downcase, id: @user.id, date: Date.current, val_input: "3:34", :format => 'js'
  		assigns(:log).project.should == project
  	end
  	it "with already typed field" do
  		 post :add_hour_to_project, log_id: log.id, select_klass: project.class.to_s.downcase, select_id: project.id, klass: @user.class.to_s.downcase, id: @user.id, date: Date.current, val_input: "3:34", :format => 'js'
      assigns(:log).project.should == project
      assigns(:log).event.should == "Timesheet"
  	end
  end
end