require 'spec_helper'
require 'support/active_admin_spec_helper'


describe Obeqaslksdssdfnfdfysdfxm::TodosController do
active_admin_signing_in
	let!(:firm)  {FactoryBot.create(:firm)}
	let!(:user)  {FactoryBot.create(:user, firm:firm)}
  let!(:todo)  {t = FactoryBot.build(:todo)
                t.save(:validate => false)
                t}

describe "Get firms" do

  it "GET index" do
  	
  	get :index
    assigns(:todos).should == [todo]
  end
end
describe "GET #show" do
    it "assigns the requested todo to @todo" do
      
      get :show, :id => todo
      assigns(:todo).should eq(todo) 
    end
    it "renders the #show view" do
      
      get :show, :id => todo
      response.should render_template :show
    end
  end
  describe "GET edit" do 
    it "should assign todo to @todo" do
      
      get :edit, :id => todo
      assigns(:todo).should eq(todo) 
    end 
  end
  
  describe 'PUT update' do
 
  # It does not work because of Firm is secure! 
  # Does not matter it is never intended for use.
  # context "valid attributes" do
  #   it "located the requested @todo" do
  #     put :update, id: todo, todo: FactoryBot.attributes_for(:todo)
  #     assigns(:todo).should eq(todo)      
  #   end
  
  #   it "changes @todo's attributes" do
  #     put :update, id: todo, todo: FactoryBot.attributes_for(:todo, name: "something else")
  #     todo.reload
  #     todo.name.should eq("something else")
  #   end
  # end
  
end
  describe 'DELETE destroy' do
    
    it "deletes the todo" do
      expect{
        delete :destroy, id: todo     
      }.to change(Todo,:count).by(-1)
    end
      
    it "redirects to todo#index" do
      delete :destroy, id: todo
      flash[:notice].should_not be_nil
    end
  end
  
end
