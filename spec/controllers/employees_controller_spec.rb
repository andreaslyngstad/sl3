require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe EmployeesController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
    @customer = FactoryBot.create(:customer, :firm => @user.firm)
  end
  
  
  describe "POST create" do
   
    context "with valid attributes" do
      it "creates a new contact" do
        expect{
          post :create, employee: FactoryBot.attributes_for(:employee, :customer_id => @customer.id), :format => 'js'
        }.to change(Employee,:count).by(1)
      end
      
      it "Should show flash" do
        post :create, employee: FactoryBot.attributes_for(:employee, :customer_id => @customer.id), :format => 'js'
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @employee = FactoryBot.create(:employee, :customer_id => @customer.id, :firm => @user.firm)
  end
  
  context "valid attributes" do
    it "located the requested @employee" do
      put :update, id: @employee, employee: FactoryBot.attributes_for(:employee), :format => 'js'
      assigns(:klass).should eq(@employee)      
    end

    it "changes @employee's attributes" do
      put :update, id: @employee, employee: FactoryBot.attributes_for(:employee, :name => "something else"), :format => 'js'
      @employee.reload
      @employee.name.should eq("something else")
    end
  end
  context "invalid attributes" do
    it "locates the requested @employee" do
      put :update, id: @employee, employee: FactoryBot.attributes_for(:employee, :name => nil), :format => 'js'
      assigns(:klass).should eq(@employee)      
    end
    
    it "does not change @employee's attributes" do
      put :update, id: @employee, 
        employee: FactoryBot.attributes_for(:employee, :name => nil), :format => 'js'
      @employee.reload
      @employee.name.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @employee = FactoryBot.create(:employee, :customer_id => @customer.id, :firm => @user.firm)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @employee, :format => 'js'        
      }.to change(Employee,:count).by(-1)
    end
      
    it "redirects to contacts#index" do
      delete :destroy, id: @employee, :format => 'js'
      flash[:notice].should_not be_nil
    end
  end
end