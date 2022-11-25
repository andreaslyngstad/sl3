require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  
feature 'project' do
     before(:all) do 
      date = Date.today == "Monday".to_date ? Date.today + 1.day : Date.today
      
      
      @user = FactoryBot.create(:user, hourly_rate: 2)
      @firm = @user.firm
      @firm.users.should include @user
      @firm.users.first.should eq @user
      @project = FactoryBot.create :project, name: "test_project", firm: @firm, budget:10  
      @customer = FactoryBot.create :customer, name: "test_customer", firm: @firm
      @task = Todo.create!(name: 'test_task', firm: @firm, project: @project, due: Date.today, user: @user)         
      @customers = "http://#{@firm.subdomain}.lvh.me:31234/customers"
      @projects = "http://#{@firm.subdomain}.lvh.me:31234/projects"
      @users = "http://#{@firm.subdomain}.lvh.me:31234/users"
      @invoices = "http://#{@firm.subdomain}.lvh.me:31234/invoices"
      @root_url ="http://#{@firm.subdomain}.lvh.me:31234/"
      @project.users << @user
      @log = FactoryBot.create(:log, event: "test_log", customer: @customer, project: @project, user: @user, firm: @firm, begin_time: Time.zone.now - 2.hours, end_time: Time.zone.now,:log_date => Time.zone.now.beginning_of_week)
      @log2 = FactoryBot.create(:log, project: @project, user: @user, firm: @firm, begin_time: Time.zone.now - 2.hours, end_time: Time.zone.now,:log_date => Time.zone.now.beginning_of_week + 1.day)
      Capybara.server_port = 31234 
      sub = @firm.subdomain
      Capybara.app_host = @root_url 
      if @user.projects.count == 0
        @projec2t = FactoryBot.create :project, name: "test_project", firm: @firm, budget:10 
        @user.projects << @projec2t
    end
    end 
  scenario "make new", js: true do
    sign_in_on_js   
    visit @projects 
    page.should have_content("Create project")       
    find("#dialog_project").click
    page.should have_content("Create project")
    fill_in "project_name", with: "" 
    click_button "Save"
    page.should have_content("This field is required.")
    fill_in "project_name", with: "test_new project"
    fill_in "project_description", with: "123456789"
    fill_in "project_budget", with: "test@tes.no"
    # fill_in "project_address", with: "new project address" 
    click_button "Save"
    page.should have_content("test_new project")
  end 
  scenario "Edit project", js: true do
    sign_in_on_js
    visit @projects 
    page.should have_content("test_new project")  
    id = page.evaluate_script("$('.tab_list').first().attr('id')")
    li = "li##{id}"
    within(:css, li) do
      first(".open_project_update").click  
    end 
    page.should have_content("Update project")
    fill_in "project_name", with: "test_new_edit project"
    page.find("#edit_#{id}").find(".submit").click
    page.should have_content("test_new_edit project") 
  end 
  
  scenario "reopen and delete project", js: true do
    sign_in_on_js
    id = Project.where(name:"test_new_edit project").first.id.to_s
    visit @projects
     page.should have_content("test_new_edit project")
    find("#archive").click
    page.should_not have_content("test_new_edit project")
    find("#active_projects").click
    page.should have_content("test_new_edit project")

   find("#archive_#{id}").click

    page.evaluate_script("window.confirm")
    find("#archive").click
    page.should have_content("test_new_edit project")
    find("#reopen_project_#{id}").click
    find("#active_projects").click
    page.should have_content("test_new_edit project")
    find("#archive_#{id}").click
    find("#archive").click
    page.should have_content("test_new_edit project")
    find("#delete_#{id}").click
	page.should have_content("Project was deleted")
  end
end
