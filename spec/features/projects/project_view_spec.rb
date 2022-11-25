require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures
feature 'Project' do
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
    end
    
  def visit_the_project
    sign_in_on_js

    visit @projects
    id = @project.id

    page.should have_content("test_project")
    id = page.evaluate_script("$('.tab_list').first().attr('id')")
    li = "li#project_#{id.gsub(/project_/, '')}"
    within(:css, li) do
      find(".tab_list_text").find('a').trigger('click')
    end
  end
   
  scenario "cycle trough links project", js: true do
    visit_the_project
    @user.firm.users.count.should == 1
    @project.should_not be nil
    page.should have_content("test_project", visible: true)
    page.find('#html_tabs').click_link('Logs')
    page.should have_content('Create log', visible: true)
    page.find('#html_tabs').click_link('Users')
    page.should have_content('Users on this project', visible: true)
    click_link('Milestones')
    page.should have_content("Create milestone", visible: true)
    # click_link('Statistics')
    # click_link('Spendings')
    # page.should have_content("Hourly rate", visible: true)
    click_link('Tasks')
    page.should have_content("Task", visible: true)
  end  

  scenario 'project task crud' , js: true do
    visit_the_project
    click_link('Tasks')
    page.find("#dialog_todo", visible: true).trigger('click')
    page.should have_content("Create task")
    fill_in "todo_name", with: "This a task"
    find('#dialog_todo_date').click
    click_link('13')
    # date_str = Date.today.strptime('%m.%y')
    # fill_in 'dialog_todo_date', with: "30.02.2064"
    # page.execute_script %Q{ $("#dialog_todo_date").val("20.02.2064")}
    page.find("#new_todo").find(".submit").click
    id = find('.task_info')['id'].gsub('todo_', '')
    page.should have_content("This a task")  
    page.should have_content("13." + Date.today.strftime('%m.%y'))  
    page.should have_content("Task was successfully saved")
    page.find("div#not_done_tasks").first('div')[:id].should eql('todo_' + id )
    within(:css, "#todo_" + id) do 
      find(".done_box").click
    end
    
    page.should have_content("Task was successfully saved")
    page.find("div#done_tasks").should have_content('This a task')
    
    within(:css, "#todo_" + id) do 
      find(".done_box").click
    end
  
    page.should have_content("Task was successfully saved")
    page.find("div#not_done_tasks").should have_content('This a task')
    within(:css, "#todo_" + id) do 
      find("#todo_update").click
    end
  
    page.should have_content("Update task")
    find('#date_todo_' + id).click
    click_link('14')
    find('#edit_todo_' + id).find('.submit').click
    page.should have_content("14." + Date.today.strftime('%m.%y')) 
    find("#todo_" + id).find(".delete_todo").click
    page.should have_content("Task was deleted")
    page.should_not have_content("This a task")
  end
  scenario 'project log crud', js: true do

    visit_the_project 
    within(:css, ('#html_tabs')) do
      click_link('Logs')
    end 
    page.find('#html_tabs').click_link('Logs') 
    page.should have_content('Create log', visible: true)
   
    find("#dialog_log").click
    page.should have_content("Create log")
    fill_in "log_event", with: "This a log"
    find('#log_date_new').click
    click_link('13')
    fill_in "log_times_from_", with: "10:00"
    fill_in "log_times_to_", with: "11:30"
    find('#new_log').find('.submit').click
    page.should have_content("This a log")
    page.should have_content("13." + Date.today.strftime('%m.%y'))
    page.should have_content("1:30")
    first('.open_log_update').click
    
    page.should have_content('Update log')
    fill_in "log_event", with: "This a log edit"
    find('#log_edit_submit').click
    page.should have_content("This a log edit")
    first('.delete_log').click
    page.should have_content("log was deleted")
    page.should_not have_content("This a log edit")
  end

  scenario 'project milestone crud', js: true do
    visit_the_project
    within(:css, ('#html_tabs')) do
      click_link('Milestones') 
    end
    find("#dialog_milestone", visible: true).click
    page.should have_content("Create milestone")
    fill_in "milestone_goal", with: "This a milestone"
    find('#dialog_milestone_date').click
    click_link('13')
    
    find('#new_milestone').find('#new_milestone_submit').click

    page.should have_content("This a milestone")
    page.should have_content("13." + Date.today.strftime('%m.%y'))
    id = find('.info')['id'].gsub('milestone_', '')

    within(:css, '#milestone_' + id) do 
      find('.open_milestone_update').click
    end
   
    page.should have_content('Update milestone')
    within(:css, '#edit_milestone_' + id) do 
      fill_in "milestone_goal", with: "This a edit"
      find('.submit').click
    end
    page.should have_content("This a edit")
    within(:css, '#milestone_' + id) do  
      find('.delete_milestone').click
    end
    page.should have_content("Milestone was deleted") 
end
  # scenario 'project users', js: true do
  #   visit_the_project
  #   within(:css, ('#html_tabs')) do
  #     click_link('Users')
  #   end
  #   drop1 = find('#members')
  #   drop2 = find('#not_members')
  #   drag = find('#user_1')
  #   drag.drag_to(drop2)
  #   page.should have_content("NOT a member of the")
  # end
  # scenario 'project Spendings',:focus, js: true do
  #   visit_the_project
    
  #   within(:css, ('#html_tabs')) do
  #     click_link('Logs')
  #   end
  #   page.should have_content("New log")
  #   find("#dialog_log").click
  #   page.should have_content("Create new log")
  #   fill_in "log_event", with: "This a log"
  #   find('#log_date_new').click
  #   click_link('13')
  #   fill_in "log_times_from_", with: "10:00"
  #   fill_in "log_times_to_", with: "11:30"
  #   find('#new_log').find('.submit').click
  #   # @user.logs.where(event: "gunnar har røde baller").sum(:hours).should == 2
  #   within(:css, ('#html_tabs')) do
  #     click_link('Spendings')
  #   end
  #   page.should have_content(@user.name)
  # end
end

