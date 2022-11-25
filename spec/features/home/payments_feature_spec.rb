require 'spec_helper'
feature 'home' do
  extend SubdomainHelpers
  let(:user)        {FactoryBot.create(:user)}
  let!(:firm)       {user.firm} 
  # let(:sign_in_url) {"http://#{firm.subdomain}.example.com/users/sign_in"} 
  # let(:root_url)    {"http://#{firm.subdomain}.example.com/"}
  # let(:root_path)    {"http://example.com/"}
  let(:project)     {FactoryBot.create(:project, firm:firm)}
  let(:firm_show)     {"http://#{firm.subdomain}.example.com/account"}
  let(:payment_url)     {"http://#{firm.subdomain}.example.com/payments"} 
  let(:payment1)     {FactoryBot.create(:payment, firm: firm)}
	let(:payment2)     {FactoryBot.create(:payment, firm: firm)}
	let(:payment_url)     {"http://#{firm.subdomain}.example.com/payments"} 
	let(:payment_show_url)     {"http://#{firm.subdomain}.example.com/payments/#{payment1.id}"} 
    before(:each) do  
      login_as(user, :scope => :user)  
    end  
    
     
    scenario 'firm_show' do  
     visit firm_show
     page.current_url.should == firm_show
     page.should have_content("Memeber since")  
     page.should have_content("Payments") 
  end
    scenario "payments index" do  
    	firm.payments << [payment1, payment2]
      visit payment_url
      page.should have_content(payment1.plan_name) 
      page.should have_content(payment2.plan_name) 
      # click_link "show"
      # page.current_url.should == statistics
      # page.select("Stats for projects", :from => "stats")
      # page.should have_content(project.name)
    end
    scenario "payments show" do  
    	firm.payments << [payment1, payment2]
      visit payment_show_url
      page.should have_content(payment1.plan_name) 
  
      # page.current_url.should == statistics
      # page.select("Stats for projects", :from => "stats")
      # page.should have_content(project.name)
    end
    # end
     
    # scenario 'timesheets' do 
    #  visit timesheet 
    #   page.should have_content("Timesheet for #{user.name}")
    # end
    
end
