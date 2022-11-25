require 'spec_helper'

describe PermittedParams do
  context "project" do
    let(:user) {create(:user)}
    it "allows user to set project" do
      params = ActionController::Parameters.new(project: 
      	{'name'=> 'project', 
      		'description'=>'',
      		'active'=>'',
      		'budget'=>'',
      		'hour_price'=>'',
      		'created_at'=>'',
      		'customer_id'=>'',
      		'updated_at'=>'',
      		'customer'=>'',
      	'eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.project.should include('name','description','active','budget','hour_price','customer_id','created_at','updated_at','customer')
      permitted_params.project.should_not include("eddabæedda")
    end
  end
  context "todo" do
    let(:user) {create(:user)}
    it "allows user to set todo" do
      params = ActionController::Parameters.new(todo: 
      	{'name'=>'','user_id'=>'','project_id'=>'','customer_id'=>'',
   'due'=>'','completed'=>'','created_at'=>'','updated_at'=>'','project'=>'','customer'=>'','user'=>'',
   'done_by_user'=>'','done_by_user_id'=>'','prior'=>'','firm'=>'', "eddabæedda" => ''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.todo.should include('name','user_id','project_id','customer_id',
   		'due','completed','created_at','updated_at','project','customer','user','done_by_user','done_by_user_id','prior','firm')
      permitted_params.todo.should_not include("eddabæedda")
    end
  end
  context "milestone" do
    let(:user) {create(:user)}
    it "allows user to set milestone" do
      params = ActionController::Parameters.new(milestone: 
      	{'goal'=>'','due'=>'','completed'=>'','project_id'=>'','created_at'=>'','updated_at'=>'', 'project'=>'','firm'=>'',
      	'eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.milestone.should include('goal','due','completed','project_id','created_at','updated_at', 'project','firm')
      permitted_params.milestone.should_not include("eddabæedda")
    end
  end
  context "customer" do
    let(:user) {create(:user)}
    it "allows user to customer" do
      params = ActionController::Parameters.new(customer: 
      	{'name'=>'','phone'=>'','email'=>'','address'=>'','created_at'=>'','updated_at'=>'', 'firm'=>'',
      	'eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.customer.should include('name','phone','email','address','created_at','updated_at', 'firm')
      permitted_params.customer.should_not include("eddabæedda")
    end
  end
  context "employee" do
    let(:user) {create(:user)}
    it "allows user to set employee" do
      params = ActionController::Parameters.new(employee: 
      	{'name'=>'','phone'=>'','email'=>'','customer_id'=>'','created_at'=>'','updated_at'=>'', 'customer'=>'','firm'=>'',
      	'eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.employee.should include('name','phone','email','customer_id','created_at','updated_at','customer','firm')
      permitted_params.employee.should_not include("eddabæedda")
    end
  end
  context "firm" do
    
    it "allows user to set firm" do
      params = ActionController::Parameters.new(firm: 
      	{'name'=>'','subdomain'=>'','address'=>'','phone'=>'', 'currency'=>'', 'time_zone'=>'', 'language'=>'','time_format'=>'','date_format'=>'','clock_format'=>'',
      	'eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, nil)
      permitted_params.firm.should include(	'name','subdomain','address','phone', 'currency', 'time_zone', 'language','time_format','date_format','clock_format')
      permitted_params.firm.should_not include("eddabæedda")
    end
  end
  context "plan" do
    let(:user) {create(:user)}
    it "allows user to set plan" do
      params = ActionController::Parameters.new(plan: 
      	{'name'=>'', 'price'=>'','customers'=>'', 'logs'=>'', 'projects'=>'', 'users'=>'', 'paymill_id'=>'',
      	'eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.plan.should include(	'name', 'price','customers', 'logs', 'projects', 'users', 'paymill_id')
      permitted_params.plan.should_not include("eddabæedda")
    end
  end
  context "user" do
    let(:user) {create(:user)}
    it "allows user to set user" do
      params = ActionController::Parameters.new(user: 
      	{'role'=>'','phone'=>'','name'=>'','hourly_rate'=>'','avatar'=>'', 'email'=>'','password'=>'', 'password_confirmation'=>'', 'remember_me'=>'','eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.user.should include(	'role','phone','name','hourly_rate','avatar', 'email','password', 'password_confirmation', 'remember_me')
      permitted_params.user.should_not include("eddabæedda")
    end
  end
  context "log" do
    let(:user) {create(:user)}
    it "allows user to set log" do
      params = ActionController::Parameters.new(log: 
      	{'event'=>'','customer_id'=>'','user_id'=>'','project_id'=>'','employee_id'=>'','todo_id'=>'','tracking'=>'','begin_time'=>'','end_time'=>'','log_date'=>'',
	 'hours'=>'','project'=>'','customer'=>'','user'=>'','todo'=>'', 'firm'=>'','eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.log.should include('event','customer_id','user_id','project_id','employee_id','todo_id','tracking','begin_time','end_time','log_date',
	 'hours','project','customer','user','todo', 'firm')
      permitted_params.log.should_not include("eddabæedda")
    end
  end
  context "subscription" do
    let(:user) {create(:user)}
    it "allows user to set subscription" do
      params = ActionController::Parameters.new(subscription: 
      	{'name'=>'', 'email'=>'', 'paymill_id'=>'', 'paymill_card_token'=>'', 'plan_id'=>'','firm_id'=>'', 'plan'=>'', 'firm'=>'', 'next_bill_on'=>'', 'card_holder'=>'','eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.subscription.should include('name', 'email', 'paymill_id', 'paymill_card_token', 'plan_id','firm_id', 'plan', 'firm', 'next_bill_on', 'card_holder')
      permitted_params.subscription.should_not include("eddabæedda")
    end
  end
  context "payment" do
    let(:user) {create(:user)}
    it "allows user to set payment" do
      params = ActionController::Parameters.new(payment: 
      	{'card_type'=>'', 'firm_id'=>'', 'amount'=>'', 'plan_name'=>'', 'last_four'=>'','eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.payment.should include('card_type', 'firm_id', 'amount', 'plan_name', 'last_four')
      permitted_params.payment.should_not include("eddabæedda")
    end
  end
  context "guides_category" do
    let(:user) {create(:user)}
    it "allows user to guides_category payment" do
      params = ActionController::Parameters.new(guides_category: 
      	{'title'=>'','eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.guides_category.should include('title')
      permitted_params.guides_category.should_not include("eddabæedda")
    end
  end
  context "guides" do
    let(:user) {create(:user)}
    it "allows user to guides payment" do
      params = ActionController::Parameters.new(guides: 
      	{'content'=>'', 'title'=>'','guides_category_id'=>'','eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.guides.should include('content', 'title','guides_category_id')
      permitted_params.guides.should_not include("eddabæedda")
    end
  end
  context "blog" do
    let(:user) {create(:user)}
    it "allows user to blog payment" do
      params = ActionController::Parameters.new(blog: 
      	{'content'=>'', 'title'=>'','author'=>'','eddabæedda'=>''})
      permitted_params = PermittedParams.new(params, user)
      permitted_params.blog.should include('content', 'title', 'author')
      permitted_params.blog.should_not include("eddabæedda")
    end
  end
end