require 'spec_helper'
require 'support/active_admin_spec_helper'

describe Obeqaslksdssdfnfdfysdfxm::ProjectsController do
  active_admin_signing_in
  before(:each) do
    @project = FactoryBot.create(:project)
    # Firm.should_receive(:find).at_least(:once).and_return(@firm)
  end

  after(:each) do
    @project.destroy
  end
describe "Get firms" do

  it "GET index" do

  	get :index
    assigns(:projects).should == [@project]
  end
end
describe "GET #show" do
    it "assigns the requested project to @project" do
  
      get :show, :id => @project
      assigns(:project).should eq(@project) 
    end
    it "renders the #show view" do
     
      get :show, :id => @project
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign project to @project" do
     
      get :edit, :id => @project
      assigns(:project).should eq(@project) 
    end 
  end

  describe 'DELETE destroy' do
    
    
    it "deletes the project" do
      expect{
        delete :destroy, id: @project     
      }.to change(Project,:count).by(-1)
    end
      
    it "redirects to project#index" do
      delete :destroy, id:  @project
      flash[:notice].should_not be_nil
    end
  end
end