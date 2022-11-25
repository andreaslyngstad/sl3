require 'spec_helper'

describe ReportsController do
	login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
  
  end
  describe "reports" do
  	let(:firm) 					{@user.firm}
  	let(:external_user) {FactoryBot.create(:user, firm: firm, role: "external_user")}
	  it "get reports" do
	  	get :index
			expect(response).to render_template("reports/index")
			expect(assigns(:users)).to eq(firm.users)
			expect(assigns(:projects)).to eq(firm.projects)
			expect(assigns(:customers)).to eq(firm.customers)
	  end
	  it "get reports" do
	  	@user.role = "external_user"
	  	@user.save
	  	get :index
			expect(response).to render_template("access_denied")
	  end
  end
  describe "squadlink_report" do
  	let(:project)  	{FactoryBot.create(:project, firm: @user.firm)}
  	let(:log)				{FactoryBot.create(:log, project: project, firm: @user.firm, user: @user, log_date: Date.today - 2)}
  	it "gets the reports in html format" do
  		log
  		get :squadlink_report, from: Date.today - 30.day, to: Date.today, user_id: @user.id, project_id: project.id
  		expect(assigns(:logs)).to eq([log])
      expect(response).to render_template("squadlink_report")  
  	end
    it "gets the reports in cvs format" do
      log
      get :squadlink_report, from: Date.today - 30.day, to: Date.today, user_id: @user.id, project_id: project.id, format: :csv
      response.content_type.should eq("text/csv")
      response.headers["Content-Disposition"].should eq("attachment; filename=\"squadlink_report.csv\"")
      response.should render_template("squadlink_report")
    end
    it "gets the reports in cvs format" do
      log
      get :squadlink_report, from: Date.today - 30.day, to: Date.today, user_id: @user.id, project_id: project.id, format: :xls
      response.content_type.should eq("application/xls")
      response.headers["Content-Disposition"].should eq("attachment; filename=\"squadlink_report.xls\"")
      response.should render_template("squadlink_report")
    end
    
  end 
end      

