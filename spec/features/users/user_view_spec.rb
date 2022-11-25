require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures
feature 'User' do
	get_the_gritty
	scenario "visit home page", js: true do
	  sign_in_on_js   
	  visit @users 
	  page.should have_content(@user.name)
	  click_link(@user.name)
	  page.should have_content(@user.email)
	end
	

	scenario 'project task crud' , js: true do
		sign_in_on_js   
	  	visit @users 
	  	click_link(@user.name)
		click_link('Tasks')
    find("#dialog_todo").click
    page.should have_content("Create task")
    fill_in "todo_name", with: "This a task"
    page.find("#new_todo").find(".submit").click
    page.should have_content("Project must be selected") 
    find('#todoProjectId_chosen').trigger("mousedown")
    page.execute_script %Q{ $("li:contains('test_project')").trigger("mouseup")}
    find('#dialog_todo_date').click
    click_link('13')
    # date_str = Date.today.strptime('%m.%y')
    # fill_in 'dialog_todo_date', with: "30.02.2064"
    # page.execute_script %Q{ $("#dialog_todo_date").val("20.02.2064")}
    page.find("#new_todo").find(".submit").click

    # find('.task_info')['id'].should == 'todo_1'
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
	scenario 'customer log crud', js: true do
    sign_in_on_js   
	  	visit @users 
	  	click_link(@user.name)
		
    within(:css, ('#html_tabs')) do
      click_link('Logs')
    end
    find("#dialog_log").click
    page.should have_content("Create log")
    fill_in "log_event", with: "This a log special log"
    find('#logProjectId_chosen').trigger("mousedown")
    page.execute_script %Q{ $("li:contains('test_project')").trigger("mouseup")}
    # sleep 5
    # find('#logTodoId_chosen').trigger("mousedown")
    # page.should have_content("test_task")
    # page.execute_script %Q{ $("li:contains('test_task')").trigger("mouseup")}

    find('#log_date_new').click
    click_link('13')
    fill_in "log_times_from_", with: "10:00"
    fill_in "log_times_to_", with: "11:30"
    find('#new_log').find('.submit').click
    page.should have_content("This a log")
    page.should have_content("test_project")
    # page.should have_content("test_task")
    page.should have_content("13." + Date.today.strftime('%m.%y'))
    page.should have_content("1:30")   
    id = Log.where(event: "This a log special log").first.id.to_s
    within(:css, 'div#log_info_'+ id) do 
        find('.open_log_update').click
    end
   
    page.should have_content('Update log')
    fill_in "log_event", with: "This a log edit"
    find('#edit_log_' + id).find('#log_edit_submit').click
    page.should have_content("This a log edit")
    within(:css, 'div#log_info_'+ id) do 
        find('.delete_log').click
    end
    page.should have_content("log was deleted")
    page.should_not have_content("This a log edit")
  end
  scenario "edit on home page", js: true do
	  sign_in_on_js   
	  visit @users 
	  click_link(@user.name)
		find('#user_update').click
		page.should have_content('Update user')
		fill_in 'user_name', with: 'test testersen'
        fill_in "user_password", with: "test_new_edit user"
		find('.submit').click
		page.should have_content('successfully saved')
	end
end
