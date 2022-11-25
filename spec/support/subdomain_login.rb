module SubdomainLogin
  def login_at_subdomain
  
    before(:all) do
      @firm = FactoryBot.create(:firm)
      @user = FactoryBot.create(:user, firm: @firm)
    
      @project = FactoryBot.create(:project, firm: @firm, active: true, name: "test_project")  
      @project.users << @user
      @driver = Selenium::WebDriver.for :chrome
      @base_url = "http://#{@firm.subdomain}.lvh.me:3001"   
      @driver.get(@base_url + "/")
      @accept_next_alert = true
      @driver.manage.timeouts.implicit_wait = 30
      @verification_errors = []
      @driver.find_element(:id, "user_email2").send_keys @user.email
      @driver.find_element(:id, "user_password2").send_keys @user.password 
      @driver.find_element(:id, "sign_in2").click 
      @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Signed in[\s\S]*$/
    end
  
     after(:each) do
       @driver.quit
       @verification_errors.should == []
     end
  end
end