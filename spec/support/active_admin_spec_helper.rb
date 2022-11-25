def active_admin_signing_in
	# include Devise::TestHelpers
	
	before(:each) do
		# request.env["devise.mapping"] = Devise.mappings[:admin_user]
	  @admin_user = FactoryBot.create(:admin_user)
	  sign_in(@admin_user)
	end
	
end

def active_admin_signing_in_features
	include Devise::TestHelpers
	before(:each) do
	  @admin_user = FactoryBot.create(:admin_user)
	  sign_in(@admin_user)
	end
end