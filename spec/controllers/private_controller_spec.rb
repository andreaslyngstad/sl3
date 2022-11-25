# require 'spec_helper'

# describe PrivateController do
# 	login_user
  
#   before(:each) do
#     @request.host = "#{@user.firm.subdomain}.example.com" 
  
#   end
#   describe "statistics" do
#   	let(:firm) 					{@user.firm}
#   	let(:external_user) {FactoryBot.create(:user, firm: firm, role: "external_user")}
# 	  it "get statistics" do
# 	  	get :statistics
# 			expect(response).to render_template("statistics")
# 	  end
# 	  it "get statistics" do
# 	  	@user.role = "external_user"
# 	  	@user.save
# 	  	get :statistics
# 			expect(response).to render_template("access_denied")
# 	  end
#   end
#   describe "reports" do
#   	let(:firm) 					{@user.firm}
#   	let(:external_user) {FactoryBot.create(:user, firm: firm, role: "external_user")}
# 	  it "get reports" do
# 	  	get :reports
# 			expect(response).to render_template("reports")
# 			expect(assigns(:users)).to eq(firm.users)
# 			expect(assigns(:projects)).to eq(firm.projects)
# 			expect(assigns(:customers)).to eq(firm.customers)
# 	  end
# 	  it "get reports" do
# 	  	@user.role = "external_user"
# 	  	@user.save
# 	  	get :reports
# 			expect(response).to render_template("access_denied")
# 	  end
#   end
# end