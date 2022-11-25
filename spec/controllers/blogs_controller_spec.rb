require 'spec_helper'
describe BlogsController do 
  describe "GET #index" do
      it "populates an array of blogs" do
        blog = FactoryBot.create(:blog)
        get :index 
        assigns(:blogs).should eq([blog])
      end
      it "renders the :index view" do
        get :index
        response.should render_template("index")
      end
  end 
  describe "get #show" do
    it "assigns the requested blog to @blog" do
      blog = FactoryBot.create(:blog)
      get :show, id: blog
      assigns(:blog).should eq(blog)
    end
    
    it "renders the #show view" do
      blog = FactoryBot.create(:blog)
      get :show, id: blog
      response.should render_template :show
    end
  end
end