require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe TodosController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"   
    @project = FactoryBot.create(:project, :firm => @user.firm)
  end
  describe "POST create" do
    before(:each) do
      
    end
    context "with valid attributes" do
      it "creates a new contact" do
        expect{ 
          post :create, todo: FactoryBot.attributes_for(:todo, due: Date.current, :project_id => @project.id, :user_id => @user.id), :format => 'js'
        }.to change(Todo,:count).by(1)
        
      end
      
      it "Should show flash" do
        post :create, todo: FactoryBot.attributes_for(:todo, :project_id => @project.id, :user_id => @user.id), :format => 'js'
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @todo = FactoryBot.create(:todo, :firm => @user.firm, :project_id => @project.id, :user_id => @user.id)
  end
  
  context "valid attributes" do
    it "located the requested @contact" do
      put :update, id: @todo, todo: FactoryBot.attributes_for(:todo), :format => 'js'
      assigns(:todo).should eq(@todo)      
    end
  
    it "changes @todo's attributes" do
      put :update, id: @todo, todo: FactoryBot.attributes_for(:todo, :name => "something else", :user_id => @user.id), :format => 'js'
      @todo.reload
      @todo.name.should eq("something else")
    end
    it "set done_by_user to current_user when params [:completed]" do
      put :update, id: @todo, todo: FactoryBot.attributes_for(:todo, name: "something else", user_id: @user.id, completed: "1"), :format => 'js'
      @todo.reload
      @todo.done_by_user.should eq(@user)
    end
    it "set done_by_user to nil when params [:completed] == 0" do
     
      put :update, id: @todo, todo: FactoryBot.attributes_for(:todo, name: "something else", user_id: @user.id, completed: "0"), :format => 'js'
      @todo.reload
      @todo.done_by_user.should eq(nil)
    end
  end
  context "invalid attributes" do
    it "locates the requested @todo" do
      put :update, id: @todo, todo: FactoryBot.attributes_for(:todo, :name => nil, :user_id => @user.id), :format => 'js'
      assigns(:todo).should eq(@todo)      
    end
    
    it "does not change @todo's attributes" do
      put :update, id: @todo, 
        todo: FactoryBot.attributes_for(:todo, :name => nil, :user_id => @user.id), :format => 'js'
      @todo.reload
      @todo.name.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @todo = FactoryBot.create(:todo, :firm_id => @user.firm.id, :project_id => @project.id, :user_id => @user.id)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @todo, :format => 'js'        
      }.to change(Todo,:count).by(-1)
    end
      
    it "redirects to contacts#index" do
      delete :destroy, id: @todo, :format => 'js'
      flash[:notice].should_not be_nil
    end
  end
end