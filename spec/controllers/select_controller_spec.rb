require 'spec_helper'

describe SelectController do
	login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
    
  end
  describe "project_select" do
    let(:firm)          {@user.firm}
    let(:project)       {FactoryBot.create(:project, firm:firm)} 
    let(:external_user) {FactoryBot.create(:user, firm: firm, role: "external_user")}
    let(:todo)          {FactoryBot.create(:todo, completed: false, project: project, user: @user, firm: firm)}    
    let(:log)           {FactoryBot.create(:log, user: @user, firm: firm)}
    it "assigns project with todos if project_id" do
      # project.todos << todo
    	xhr :get, :project_select, project_id: project.id, log_id:nil, format: [:js]
      assigns(:project).should == project
      assigns(:todos).should == [todo]
    end
    
    it 'assigns log when log_id > 0' do
      xhr :get, :project_select, project_id: 0, log_id: log.id, format: [:js]
      assigns(:log).should == log
    end
	end
  describe "project_select_tracking" do
    let(:firm)          {@user.firm}
    let(:project)       {FactoryBot.create(:project, firm:firm)} 
    let(:external_user) {FactoryBot.create(:user, firm: firm, role: "external_user")}
    let(:todo)          {FactoryBot.create(:todo, completed: false, project: project, user: @user, firm: firm)}    
    let(:log)           {FactoryBot.create(:log, user: @user, firm: firm)}
    let(:log1)          {FactoryBot.create(:log, project: project, user: @user, firm: firm)}
    
    it 'assigns project and todos if project_id' do
      post :project_select_tracking, project_id: project.id, log_id: nil, format: [:js]
      assigns(:project).should == project
      assigns(:todos).should == [todo]
    end
   
    it 'assigns log when log_id > 0' do
      post :project_select_tracking, project_id: 0, log_id: log.id, format: [:js]
      assigns(:log).should == log
    end
    it 'assigns project to log and saves' do
      post :project_select_tracking, project_id: project.id , log_id: log.id, format: [:js]
      assigns(:log).project.should == project 
    end
    it 'removes todos and project from log and saves when project_id == 0 ' do
      post :project_select_tracking, project_id: 0 , log_id: log1.id, format: [:js]
      assigns(:log).project.should == nil 
      assigns(:log).todo.should == nil 
      assigns(:log).customer.should == nil 
      assigns(:log).employee.should == nil 
    end
  end
  
  describe "todo_select" do
    let(:firm)          {@user.firm}
    let(:project)       {FactoryBot.create(:project, firm:firm)} 
    let(:todo)          {FactoryBot.create(:todo, completed: false, project: project, user: @user, firm: firm)}    
    let(:log)           {FactoryBot.create(:log, user: @user, firm: firm)}
    let(:log1)          {FactoryBot.create(:log, customer: customer, user: @user, firm: firm)}
    
    it 'assigns todo todo_id > 0' do
      xhr :get, :todo_select, todo_id: todo.id, log_id: log.id, format: [:js]
      assigns(:todo).should == todo
    end
    it 'assigns log when log_id > 0' do
      xhr :get, :todo_select, todo_id: 0, log_id: log.id, format: [:js]
      assigns(:log).should == log
    end
  end
  describe "todo_select_tracking" do
    let(:firm)      {@user.firm}
    let(:project)       {FactoryBot.create(:project, firm:firm)} 
    let(:todo)          {FactoryBot.create(:todo, completed: false, project: project, user: @user, firm: firm)}    
    let(:log)       {FactoryBot.create(:log, user: @user, firm: firm)}
    let(:log1)      {FactoryBot.create(:log, todo: todo, user: @user, firm: firm)}
    
    it 'assigns todo if todo_id' do
      post :todo_select_tracking, todo_id: todo.id, log_id: nil, format: [:js]
      assigns(:todo).should == todo    
    end
    
    it 'assigns log when log_id > 0' do
      post :todo_select_tracking, todo_id: 0, log_id: log.id, format: [:js]
      assigns(:log).should == log
    end
    it 'assigns todo to log and saves' do
      post :todo_select_tracking, todo_id: todo.id , log_id: log.id, format: [:js]
      assigns(:log).todo.should == todo 
    end
    it 'removes todo from log and saves when project_id == 0 ' do
      post :todo_select_tracking, todo_id: 0 , log_id: log1.id, format: [:js] 
      assigns(:log).todo.should == nil 
      assigns(:log).customer.should == nil 
      assigns(:log).employee.should == nil 
    end
  end

  describe "customer_select" do
    let(:firm)          {@user.firm}
    let(:customer)      {FactoryBot.create(:customer, firm:firm)} 
    let(:employee)      {FactoryBot.create(:employee, customer: customer, firm: firm)}    
    let(:log)           {FactoryBot.create(:log, user: @user, firm: firm)}
    let(:log1)          {FactoryBot.create(:log, customer: customer, user: @user, firm: firm)}
    
    it 'assigns customer and employees when customer_id > 0' do
      customer.employees << employee
      xhr :get, :customer_select, customer_id: customer.id, log_id: log.id, format: [:js]
      assigns(:customer).should == customer
    end
   
    it 'assigns log when log_id > 0' do
      xhr :get, :customer_select, customer_id: 0, log_id: log.id, format: [:js]
      assigns(:log).should == log
    end
  end
  describe "customer_select_tracking" do
    let(:firm)      {@user.firm}
    let(:customer)  {FactoryBot.create(:customer, firm:firm)} 
    let(:employee)  {FactoryBot.create(:employee, customer: customer,firm: firm)}    
    let(:log)       {FactoryBot.create(:log, user: @user, firm: firm)}
    let(:log1)      {FactoryBot.create(:log, customer: customer, user: @user, firm: firm)}
    
    it 'assigns customer and todos if customer_id' do
      customer.employees << employee
      post :customer_select_tracking, customer_id: customer.id, log_id: nil, format: [:js]
      assigns(:customer).should == customer
    end
    
    it 'assigns log when log_id > 0' do
      post :customer_select_tracking, customer_id: 0, log_id: log.id, format: [:js]
      assigns(:log).should == log
    end
    it 'assigns customer to log and saves' do
      post :customer_select_tracking, customer_id: customer.id , log_id: log.id, format: [:js]
      assigns(:log).customer.should == customer 
    end
    it 'removes employee and customer from log and saves when project_id == 0 ' do
      post :customer_select_tracking, customer_id: 0 , log_id: log1.id, format: [:js] 
      assigns(:log).customer.should == nil 
      assigns(:log).employee.should == nil 
    end
  end


  describe "employee_select_tracking" do
    let(:firm)      {@user.firm}
    let(:customer)  {FactoryBot.create(:customer, firm:firm)} 
    let(:employee)  {FactoryBot.create(:employee, customer: customer,firm: firm)}      
    let(:log)       {FactoryBot.create(:log, user: @user, firm: firm)}
    let(:log1)      {FactoryBot.create(:log, employee: employee, user: @user, firm: firm)}
    
    it 'assigns employee if employee_id' do
      post :employee_select_tracking, employee_id: employee.id, log_id: nil, format: [:js]
      assigns(:employee).should == employee    
    end
    
    it 'assigns log when log_id > 0' do
      post :employee_select_tracking, employee_id: 0, log_id: log.id, format: [:js]
      assigns(:log).should == log
    end
    it 'assigns employee to log and saves' do
      post :employee_select_tracking, employee_id: employee.id , log_id: log.id, format: [:js]
      assigns(:log).employee.should == employee 
    end
    it 'removes employee from log and saves when employee_id == 0 ' do
      post :employee_select_tracking, employee_id: 0 , log_id: log1.id, format: [:js] 
      assigns(:log).employee.should == nil 
    end
  end
end