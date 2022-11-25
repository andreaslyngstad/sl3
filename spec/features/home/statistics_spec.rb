require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  

feature 'home' do
    get_the_gritty
    scenario "Statistics select", js: true do  
      # sign_in_on_js
      # visit "http://#{@firm.subdomain}.lvh.me:31234/charts"
      # find('#from_stat').click
      # click_link('1')
      # find('#to_stat').click
      # click_link('25')
      # page.should have_content(@user.name)
      # find('#stats_chosen').trigger("mousedown")
      # page.execute_script %Q{ $("li:contains('Projects')").trigger("mouseup")}
      # page.should have_content(@project.name)
    end

    scenario 'Reports', js: true do 
      sign_in_on_js
      visit "http://#{@firm.subdomain}.lvh.me:31234/reports"
      page.should have_content("View in browser (HTML)")
      find('#user_id_chosen').trigger("mousedown")
      page.execute_script %Q{ $("li:contains('#{@user.name}')").trigger("mouseup")}
      find('.submit').click
      page.should have_content("2:00 Tiril Pharo")
    end

    

    scenario 'Account', js: true do 
      sign_in_on_js
      visit "http://#{@firm.subdomain}.lvh.me:31234/account"
      page.should have_content("Memeber since") 
      click_link('Upgrade')
      page.should have_content("Factories_test") 
      page.evaluate_script('window.history.back()')
      click_link('Payments')
      page.should have_content("Payment history") 
      page.evaluate_script('window.history.back()')
      find("#economic_link").click
      
      page.should have_content("Bank account") 
      find("#contact_link").click
      fill_in 'firm_name', with: "test_edit_firm"
      find('.submit').click
      page.should have_content("test_edit_firm") 
    end

end