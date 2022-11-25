
require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  
feature 'invoice' do
    get_the_gritty   
    Invoice.destroy_all

  scenario "invoice form", js:true do
    sign_in_on_js   
    visit @invoices  
    @customer.logs.count.should eq 2 
    page.should have_content("Create invoice")        
    find("#dialog_invoice").click
    page.should have_content("Create invoice")
    page.find('#invoice_customer_id_chosen').trigger("mousedown")
    page.execute_script %Q{ $("li:contains('test_customer')").trigger("mouseup")}   
    page.should have_content ("test_log")
    page.should have_content ("25 kr 200,00 kr 50,00 kr 250,00 Total kr 250,00")
    click_link("Add Line")
    within(:css, "tr.invoice_line") do 
        find(:css, "input.invoice_line_description").set("test_line")
        find(:css, "input.invoice_line_quantity").set("2")
        find(:css, "input.invoice_line_price").set("2")
    end
   
    page.should have_content ("25 kr 204,00 kr 51,00 kr 255,00 Total kr 255,00")
    page.find('#new_invoice').find('.submit').click
    page.should have_content("was successfully saved")
    page.should have_content ("No number test_customer")
  end
  scenario "Edit invoice", js: true  do
    sign_in_on_js
    visit @invoices 
    page.should have_content ("No number test_customer")
    page.find(".open_invoices_update").click  
    page.should have_content("Update invoice")
    within(:css, "tr.invoice_line") do
        find(:css, "input.invoice_line_description").set("test_line")
        find(:css, "input.invoice_line_quantity").set("5")
        find(:css, "input.invoice_line_price").set("2")
    end
    page.find("#new_invoice_submit").click
    page.should have_content("No number test_customer 255") 

  end 
  scenario "delete invoice", js: true do
    sign_in_on_js
    visit @invoices
    page.find(".delete_invoice").click 
    page.should have_content("Invoice was deleted") 
  end
  scenario "create credit_note", js: true do 
    sign_in_on_js
    visit @invoices 
    page.should have_content("Create invoice")        
    find("#dialog_invoice").click
    page.should have_content("Create invoice")
    page.find('#invoice_customer_id_chosen').trigger("mousedown")
    page.execute_script %Q{ $("li:contains('test_customer')").trigger("mouseup")}  
    find(:css, "input#invoice_due_").set((Date.today - 12.days).strftime("%d.%m.%y"))
    click_link("Add Line")
    within(:css, "tr.invoice_line") do
        find(:css, "input.invoice_line_description").set("test_line")
        find(:css, "input.invoice_line_quantity").set("2")
        find(:css, "input.invoice_line_price").set("2")
    end
    page.find('#new_invoice').find('.submit').click
    page.should have_content("was successfully saved")
    first(".quick_send_invoice").click  
    page.should have_content("Receivable Overdue")

    
  
    first(".credit_invoice").click 
    page.should have_content("Create new credit note")
    within(:css, ".new_invoice") do
        first("#new_invoice_submit").click
    end
    page.should have_content("-5,00 kr show download send Credited")
    page.should have_content("test_customer 0,00 kr")
    page.first('.invoice_buttons', :text => 'show').click
    page.should have_content("Credit note 2 -5,00 ")
    page.click_link("Invoice")
    page.should have_content("Emails Sent")
    page.should have_content("Credited test_customer test@test.com")
    page.first('.invoice_lost', :text => 'lost').click
    page.should have_content("Lost -0,00")
    page.first('.invoice_lost', :text => 'not lost').click

    page.should have_content("Credited test_customer test@test.com")
    page.first('.invoice_paid', :text => 'paid').click
    page.should have_content("0,00 kr Paid")
    page.first('.invoice_paid', :text => 'not paid').click
    page.should have_content("paid lost")
    within(:css, "#invoices_navi") do
        page.click_link("Invoices")
    end
    page.should have_content("Credited")
  end

  scenario "send reminder", js: true do
    sign_in_on_js
    visit @invoices 
    page.should have_content("Create invoice")        
    find("#dialog_invoice").click
    page.should have_content("Create invoice")
    page.find('#invoice_customer_id_chosen').trigger("mousedown")
    page.execute_script %Q{ $("li:contains('test_customer')").trigger("mouseup")}  
    find(:css, "input#invoice_due_").set((Date.today - 12.days).strftime("%d.%m.%y"))
    click_link("Add Line")
    within(:css, "tr.invoice_line") do
        find(:css, "input.invoice_line_description").set("test_line")
        find(:css, "input.invoice_line_quantity").set("2")
        find(:css, "input.invoice_line_price").set("2")
    end
    page.find('#new_invoice').find('.submit').click
    page.should have_content("was successfully saved")
    page.first(".quick_send_invoice").click  

    page.should have_content("Receivable Overdue")
    page.first('.remind_invoice', :text => 'reminder').click
    page.should have_content("Send reminder")

    within(:css, ".new_email") do
     find(:css, "input#email_reminder_reminder_fee").set("50")
     first(".submit").click
    end
    page.should have_content("Reminded")
    page.should have_content("test_customer 55")
    page.first('.invoice_buttons', :text => 'show').click
    page.should have_content("Reminder 50,00 kr Receivable 55,00 kr")
    page.click_link("Reminder")
    page.should have_content("Invoice 55,00 kr Receivable 55,00 kr")

  end 
end