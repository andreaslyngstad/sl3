require 'spec_helper'
describe GuidesController do 
  describe "GET #index" do
      it "populates an array of logs" do
        guide = FactoryBot.create(:guide)
        get :index 
        assigns(:guides).should eq([guide])
      end
      it "renders the :index view" do
        get :index
        response.should render_template("index")
      end
  end 
  describe "get #show" do
    it "assigns the requested guide to @guide" do
      guide = FactoryBot.create(:guide)
      get :show, id: guide
      assigns(:guide).should eq(guide)
    end
    
    it "renders the #show view" do
      guide = FactoryBot.create(:guide)
      get :show, id: guide
      response.should render_template :show
    end
  end
end