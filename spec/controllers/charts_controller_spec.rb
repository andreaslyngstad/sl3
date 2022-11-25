require 'spec_helper'

describe ChartsController do
	login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
    
  end
	describe "Private methods " do
		let(:project) 	{FactoryBot.create(:project)}
		let(:customer)	{FactoryBot.create(:customer)}	
		let(:range)   	{Date.today - 5.days..Date.today}
		it "users_logs" do 
			get :users_logs, id: @user.firm.id, from:Date.today - 5.days, to: Date.today, klass: "User"
			assigns(:stacked).should == ChartData.new(@user.firm,range,:user).stacked
			assigns(:pie).should == ChartData.new(@user.firm,range,:user).pie
		end

		it "projects_logs" do
			get :projects_logs, id: @user.firm.id, from:Date.today - 5.days, to: Date.today, klass: "Project"
			assigns(:stacked).should == ChartData.new(@user.firm,range,:project).stacked
			assigns(:pie).should == ChartData.new(@user.firm,range,:project).pie
		end 
		
		it "customers_logs" do
			get :customers_logs, id: @user.firm.id, from:Date.today - 5.days, to: Date.today, klass: "Customer"
			assigns(:stacked).should == ChartData.new(@user.firm,range,:customer).stacked
			assigns(:pie).should == ChartData.new(@user.firm,range,:customer).pie
		end 

		it "project_users_logs" do 
			get :project_users_logs, id: project.id, from:Date.today - 5.days, to: Date.today, klass: "Project"
			assigns(:stacked).should == ChartData.new(project,range,:user).stacked
			assigns(:pie).should == ChartData.new(project,range,:user).pie
		end 
		it "project_todos_logs" do
			get :project_todos_logs, id: project.id, from:Date.today - 5.days, to: Date.today, klass: "Project"
			assigns(:stacked).should == ChartData.new(project,range,:todo).stacked
			assigns(:pie).should == ChartData.new(project,range,:todo).pie
		end 
		# it "customer_users_logs" do
		# 	get :customer_users_logs, id: customer.id, from:Date.today - 5.days, to: Date.today, klass: "Customer"
		# 	assigns(:stacked).should == ChartData.new(customer,range,:user).stacked
		# 	assigns(:pie).should == ChartData.new(customer,range,:user).pie
		# end 
		# it "customer_todos_logs" do
		# 	get :customer_todos_logs, id: customer.id, from:Date.today - 5.days, to: Date.today, klass: "Customer"
		# 	assigns(:stacked).should == ChartData.new(customer,range,:todo).stacked
		# 	assigns(:pie).should == ChartData.new(customer,range,:todo).pie
		# end 
		

	end
	
end
# 	def admin_firms_chart
#     @firm = Firm.count_by_subscription
#   end
  
#   def users_logs  
#     var_setter(params,:user)
#   end
  
#   def projects_logs
#     var_setter(params,:project)
#   end
  
#   def customers_logs   
#     var_setter(params,:customer)
#   end
  
#   def project_users_logs
#     tabs_var_setter(params,:user)
#   end
#   def project_todos_logs
#     tabs_var_setter(params,:todo) 
#   end
#   def customer_users_logs
#     tabs_var_setter(params,:project) 
#   end

#   private
#   def tabs_var_setter(params,model)
#     range = params[:from].to_date..params[:to].to_date
#     instance = params[:klass].constantize.find(params[:id])
#     @stacked = ChartData.new(instance,range,model).stacked
#     @pie = ChartData.new(instance,range,model).pie
#     render :formats => [:json] 
#   end
  
#   def var_setter(params,model)
#     range = params[:from].to_date..params[:to].to_date
#     @stacked = ChartData.new(current_firm,range,model).stacked
#     @pie = ChartData.new(current_firm,range,model).pie
#     render :formats => [:json] 
#   end
# end