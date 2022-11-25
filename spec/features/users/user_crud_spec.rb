require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  
feature 'user' do
    get_the_gritty   
  scenario "make new", js: true do
    sign_in_on_js   
    visit @users 
    page.should have_content("Create user")       
    find("#dialog_user").click
    page.should have_content("Create user")
    fill_in "user_name", with: "" 
    click_button "Save"
    page.should have_content("This field is required.")
    fill_in "user_name", with: "test_new user"
    fill_in "user_phone", with: "123456789"
    fill_in "user_email", with: "test@tes.no"
    fill_in "user_password", with: "password" 
    page.find('#new_user').find('.submit').click
    sleep 5
    page.should have_content("was successfully saved") 
    page.should have_content("test_new user")
  end 
  scenario "delete yourself", js: true do
    sign_in_on_js
    visit @users
    page.should have_content("Tiril Pharo")
    @user.name.should eq ("Tiril Pharo")
    id = @user.id.to_s
    
    li = "li#user_#{id}"
    within(:css, li) do
      first(".delete_user").trigger('click')
    end
    page.should have_content("You cannot delete yourself") 
  end
  scenario "Edit user", js: true do
    sign_in_on_js
    visit @users 
    page.should have_content("test_new user")  
    id = User.where(name:"test_new user").first.id.to_s
    li = "li#user_#{id}"
    within(:css, li) do
      first(".open_user_update").click  
    end 
    page.should have_content("Update user")
    fill_in "user_name", with: "test_new_edit user"
    fill_in "user_password", with: "test_new_edit user"
    page.find("#edit_user_#{id}").find(".submit").click
    page.should have_content("test_new_edit user") 
    page.should have_content("successfully saved") 
  end 
  scenario "delete user", js: true do
    sign_in_on_js
    visit @users
    id = User.where(name:"test_new_edit user").first.id.to_s
    li = "li#user_#{id}"
    within(:css, li) do
      first(".delete_user").trigger('click')
    end
    page.should have_content("test_new_edit user was deleted") 
  end
  

end