require 'spec_helper'

describe ProjectsController, :type => :controller do 

  login_user 
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
  end 
  
  describe "activate_projects and deactivate_projects" do
    it "deactivate_projects" do 
      @project = FactoryBot.create(:project) 
      @project.users << @user
      
      expect{
          post :activate_projects, :id => @project.id, :format => 'js'
        }.to change(Project.where(:active => true),:count).by(-1)
        
    end
    it "activate_projects" do 
      @project = FactoryBot.create(:project, :active => false)
      expect{
          post :activate_projects, :id => @project.id, :format => 'js'
        }.to change(Project.where(:active => true),:count).by(1)
    end
  end
  describe "GET #index" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    it "populates an array of projects" do 
      projects = double
      Project.should_receive(:order_by_name){projects} 
      get :index
      assigns[:projects].should be projects 
        
    end
    it "renders the :index view" do
      get :index
      response.should render_template("index")
    end
  end 
  describe "GET #archive" do
    it "renders the :archive view" do
      get :archive
      assigns(:projects) == [@project]
    end
  end
  
  describe "GET #show" do
    it "assigns the requested project to @project" do
      @project = FactoryBot.create(:project, :firm => @user.firm)
      get :show, :id => @project
      assigns(:project) == [@project] 
    end
    it "renders the #show view" do
      @project = FactoryBot.create(:project, :firm => @user.firm)
      get :show, :id => @project
      response.should redirect_to tabs_state_path(@project.class.to_s.downcase.pluralize, @project.id)
    end
  end
  describe "GET edit" do
    it "should assign project to @project" do
      project = FactoryBot.create(:project, :firm => @user.firm)
      xhr :get, :edit, :id => project, :format => 'js'
      assigns(:project).should eq(project) 
      assigns(:customers).should eq(@user.firm.customers)
    end 
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new contact" do
        expect{
          post :create, project: FactoryBot.attributes_for(:project), :format => 'js'
        }.to change(Project,:count).by(1)
      end
      
      it "redirects to the new project" do
        post :create, project: FactoryBot.attributes_for(:project), :format => 'js'
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @project = FactoryBot.create(:project, :firm => @user.firm)
  end
  
  context "valid attributes" do
    it "located the requested project" do
      put :update, id: @project, project: FactoryBot.attributes_for(:project), :format => 'js'
      assigns(:klass).should eq(@project)      
    end
  
    it "changes @project's attributes" do
      put :update, id: @project, project: FactoryBot.attributes_for(:project, :name => "something else"), :format => 'js'
      @project.reload
      @project.name.should eq("something else")
    end
  end
  context "invalid attributes" do
    it "locates the requested @project" do 
      put :update, id: @project, project: FactoryBot.attributes_for(:project, :name => nil), :format => 'js'
      assigns(:klass).should eq(@project)      
    end
    
    it "does not change @project's attributes" do
      put :update, id: @project, 
        project: FactoryBot.attributes_for(:project, :name => nil), :format => 'js'
      @project.reload
      @project.name.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @project = FactoryBot.create(:project, :firm => @user.firm)
    end
    
    it "deletes the project" do
      expect{
        delete :destroy, id: @project, :format => 'js'        
      }.to change(Project,:count).by(-1)
    end
      
    # it "redirects to project#index" do
    #   delete :destroy, id: @project, :format => 'js'
    #   response.should redirect_to projects_url
    # end
  end
end