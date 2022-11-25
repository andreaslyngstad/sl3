require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe InvoicesController do 
  let(:customer){FactoryBot.create(:customer, firm:@user.firm)}
  login_user
 	before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
  end

  describe "GET #index" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    it "populates an array of invoices" do
      invoice = FactoryBot.create(:invoice, customer: customer, firm:@user.firm, date: Date.today - 1.day)
      # Invoice.should_receive(:order_by_number)
      get :index
      assigns[:invoices].should == [invoice] 
    end
    it "renders the :index view" do
      get :index
      response.should render_template("index")
    end
  end 
  describe "GET #new" do 
    it "assigns a new Invoice to @invoice" do
      xhr :get, :new, url: "index", :format => 'js'
      assigns(:invoice).firm_id.should eq @user.firm.invoices.new.firm_id
      assigns(:logs).should eq []
    end
    it "assigns an project to a invoice" do 
      project = FactoryBot.create(:project, firm: @user.firm)  
      log = FactoryBot.create(:log, project: project, :user => @user, :firm => @user.firm)
      xhr :get, :new, url: "Project", id: project.id.to_s, format: "js"
      assigns(:instance).should eq project
      assigns(:invoice).project.should eq project
      assigns(:logs).should eq project.logs.where("end_time IS NOT NULL").order("log_date DESC").includes(:project,:firm,:user)
    end
    it "assigns an customer to a invoice" do 
      customer = FactoryBot.create(:customer, firm: @user.firm)  
      log = FactoryBot.create(:log, customer: customer, :user => @user, :firm => @user.firm)
      xhr :get, :new, url: "Customer", id: customer.id.to_s, format: "js"
      assigns(:instance).should eq customer
      assigns(:invoice).customer.should eq customer
      assigns(:logs).should eq customer.logs.where("end_time IS NOT NULL").order("log_date DESC").includes(:project,:firm,:user)
    end
    it "renders the :new template" do
      xhr :get, :new, url: "index", :format => 'js'
      response.should render_template("new")
    end
  end 
  describe "GET customer_select" do 
    it "assigns customer to @customer" do
      customer = FactoryBot.create(:customer, firm: @user.firm)
      xhr :get, :customer_select, id: customer.id.to_s, format: "js"
      assigns(:customer).should eq customer
    end
    it "assigns customer logs to @logs" do 
      customer = FactoryBot.create(:customer, firm: @user.firm)
      log = FactoryBot.create(:log, customer: customer, :user => @user, firm:@user.firm, rate: 800)
      xhr :get, :customer_select, id: customer.id.to_s, format: "js"
      assigns(:logs).should eq [log]
    end
    it "assigns customer and projects logs to @logs" do 
      customer = FactoryBot.create(:customer, firm: @user.firm)
      project = FactoryBot.create(:project, firm:@user.firm)
      log = FactoryBot.create(:log, project: project, customer: customer, :user => @user, firm:@user.firm, rate: 800)
      log2 = FactoryBot.create(:log, customer: customer, :user => @user, firm:@user.firm, rate: 800 )
      xhr :get, :customer_select, id: customer.id.to_s, format: "js", other_object:project.id.to_s
      assigns(:logs).should eq [log]
      assigns(:logs).should_not eq [log2]
    end
  end
  # describe "GET project_select" do 
  #   it "assigns project to @project" do
  #     project = FactoryBot.create(:project, firm: @user.firm)
  #     xhr :get, :project_select, id: project.id.to_s, format: "js"
  #     assigns(:project).should eq project
  #   end
  #   it "assigns customer logs to @logs" do 
  #     project = FactoryBot.create(:project, firm:@user.firm)
  #     log = FactoryBot.create(:log, project: project, :user => @user, firm:@user.firm , rate: 800)
  #     xhr :get, :project_select, id: project.id.to_s, format: "js"
  #     assigns(:logs).should eq [log]
  #   end
  #   it "assigns customer and projects logs to @logs" do 
  #     customer = FactoryBot.create(:customer, firm: @user.firm)
  #     project = FactoryBot.create(:project, firm:@user.firm)
  #     log = FactoryBot.create(:log, project: project, customer: customer, :user => @user, firm:@user.firm, rate: 800)
  #     log2 = FactoryBot.create(:log, customer: customer, :user => @user, firm:@user.firm, rate: 800 )
  #     xhr :get, :project_select, id: project.id.to_s, format: "js", other_object:customer.id.to_s
  #     assigns(:logs).should eq [log]
  #     assigns(:logs).should_not eq [log2]
  #   end
  # end
  describe "GET #show" do
    it "assigns the requested invoice to @invoice" do
      invoice = FactoryBot.create(:invoice, customer:customer,:firm => @user.firm)
      get :show, :id => invoice
      assigns(:klass).should eq(invoice) 
    end
    it "renders the #show view" do
      @invoice = FactoryBot.create(:invoice, customer:customer, :firm => @user.firm)
      get :show, :id => @invoice
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign invoice to @invoice" do
      invoice = FactoryBot.create(:invoice, customer:customer, :firm => @user.firm)
      xhr :get, :edit, :id => invoice, :format => 'js'
      assigns(:invoice).should eq(invoice) 
    end 
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new contact" do
        expect{
          post :create, invoice: FactoryBot.attributes_for(:invoice, customer_id:customer.id ), :format => 'js'
        }.to change(Invoice,:count).by(1)
      end
      
      it "redirects to the new contact" do
        post :create, invoice: FactoryBot.attributes_for(:invoice, customer_id:customer.id), :format => 'js'
        flash[:notice].should == "Invoice was successfully saved" 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @invoice = FactoryBot.create(:invoice, customer:customer, :firm => @user.firm)
  end
  
  context "valid attributes" do
    it "located the requested @contact" do
      put :update, id: @invoice, invoice: FactoryBot.attributes_for(:invoice), :format => 'js'
      assigns(:klass).should eq(@invoice)      
    end
  
    it "changes @invoice's attributes" do
      put :update, id: @invoice, invoice: FactoryBot.attributes_for(:invoice, :content => "something else"), :format => 'js'
      @invoice.reload
      @invoice.content.should eq("something else")
    end
  end
  context "invalid attributes" do
    it "locates the requested @invoice" do
      put :update, id: @invoice, invoice: FactoryBot.attributes_for(:invoice, :content => nil), :format => 'js'
      assigns(:klass).should eq(@invoice)      
    end
    
    it "does not change @invoice's attributes" do
      number = @invoice.number
      put :update, id: @invoice, 
        invoice: FactoryBot.attributes_for(:invoice, :invoice_number => nil), :format => 'js'
      @invoice.reload
      @invoice.number.should eq(number)
    end
  end
  
end
describe "POST customers_create" do
    context "with valid attributes" do
      it "creates a new customer" do
        expect{
          post :customers_create, customer: FactoryBot.attributes_for(:customer), :format => 'js'
        }.to change(Customer,:count).by(1)
      end
      
      it "redirects to the new contact" do
        post :customers_create, customer: FactoryBot.attributes_for(:customer), :format => 'js'
        flash[:notice].should_not be_nil 
      end
    end 
end
# describe "POST create" do
#     context "with valid attributes" do
#       it "creates a new customer" do
#         expect{
#           post :projects_create, project: FactoryBot.attributes_for(:project), :format => 'js'
#         }.to change(Project,:count).by(1)
#       end
      
#       it "redirects to the new contact" do
#         post :projects_create, project: FactoryBot.attributes_for(:project), :format => 'js'
#         flash[:notice].should_not be_nil 
#       end
#     end 
# end
#   describe 'DELETE destroy' do
#     before :each do
#       @invoice = FactoryBot.create(:invoice, :firm => @user.firm)
#     end
    
#     it "deletes the contact" do
#       expect{
#         delete :destroy, id: @invoice, :format => 'js'       
#       }.to change(Invoice,:count).by(-1)
#     end
      
#     it "redirects to contacts#index" do
#       delete :destroy, id: @invoice, :format => 'js'
#       flash[:notice].should_not be_nil
#     end
#   end
  # describe "activate_invoices and deactivate_invoices" do
    # it "deactivate_invoices" do 
      # @invoice = FactoryBot.create(:invoice)
      # expect{
          # get :activate_invoices, :id => @invoice.id
        # }.to change(Invoice.where(:active => true),:count).by(-1)
    # end
    # it "activate_invoices" do 
      # @invoice = FactoryBot.create(:invoice, :active => false)
      # expect{
          # get :activate_invoices, :id => @invoice.id
        # }.to change(Invoice.where(:active => true),:count).by(1)
    # end
  # end
end