require 'spec_helper'
require 'support/active_admin_spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  

feature 'dashboard' do
	get_the_gritty
	let!(:admin_user){FactoryBot.create(:admin_user)}
	let!(:firm){FactoryBot.create(:firm)}
	let!(:user){FactoryBot.create(:user, firm: firm, role: "Admin")}
	let!(:log){FactoryBot.create(:log, user: user, firm: firm)}
	let!(:project){FactoryBot.create(:project, firm: firm)}
	let!(:todo){FactoryBot.create(:todo, project: project, user:user, firm: firm)}
	let!(:customer){FactoryBot.create(:customer, firm: firm)}
	let!(:user){FactoryBot.create(:user, firm: firm, role: "Admin")}
	let!(:guides_category){FactoryBot.create(:guides_category)}
	# scenario 'sign in' do 	
	# 	signing_in
	# end 
	# def signing_in
	# 	visit '/obeqaslksdssdfnfdfysdfxm'
	# 	fill_in "admin_user_email", :with => admin_user.email
	#   fill_in "admin_user_password", :with => admin_user.password
	#   click_button "Login"
	# 	page.should have_content("Dashboard")
 # end
	scenario 'go trough the links' do 
		sign_in_on_js 
		visit '/obeqaslksdssdfnfdfysdfxm'
		fill_in "admin_user_email", :with => admin_user.email
	  fill_in "admin_user_password", :with => admin_user.password
	  click_button "Login"
		page.should have_content("Dashboard")  
		click_link 'Firms'
		page.should have_content(firm.name)
		click_link 'Dashboard' 
		click_link 'users'
		page.should have_content(user.name)
		click_link 'customers'
		page.should have_content(customer.name)
		click_link 'logs'
		page.should have_content(log.event)
		click_link 'projects'
		page.should have_content(project.name)
		click_link 'subscriptions'
		page.should have_content(firm.name)
	end
	# scenario 'Guide crud' do 
	# 	visit '/obeqaslksdssdfnfdfysdfxm'
	# 	fill_in "admin_user_email", :with => admin_user.email
	#   fill_in "admin_user_password", :with => admin_user.password
	#   click_button "Login"
	# 	page.should have_content("Dashboard")	
	# 	click_link 'Guides'
	# 	page.should have_content('There are no Guides yet. Create one')
	# 	click_link 'New Guide'
	# 	select 	guides_category.title, from:'guide_guides_category_id'
	# 	fill_in 'guide_title', with: 'What does..'
	# 	fill_in 'guide_content', with: '..the fox say'
	# 	click_button "Create Guide"
	# 	page.should have_content('What does..')
	# 	page.should have_content(guides_category.title)
	# 	click_link "Edit Guide"
	# 	fill_in 'guide_content', with: '..the fox say? Hatti hatti'
	# 	click_button "Update Guide"
	# 	page.should have_content('Hatti hatti')
	# 	click_link 'Dashboard'
	# 	click_link 'Guides'
	# 	page.should have_content('What does..')
	# 	click_link 'Delete'
	# 	page.should have_content('Guide was successfully destroyed.')
	# 	page.should_not have_content('What does..')
	# end
	# scenario 'guides_category crud' do 
	# 	visit '/obeqaslksdssdfnfdfysdfxm'
	# 	fill_in "admin_user_email", :with => admin_user.email
	#   fill_in "admin_user_password", :with => admin_user.password
	#   click_button "Login"
	# 	page.should have_content("Dashboard")	
	# 	click_link 'Guides Categories'	
	# 	click_link 'New Guides Category'	
	# 	fill_in 'guides_category_title', with: 'Animals'	
	# 	click_button "Create Guides category"
	# 	page.should have_content('Animals')
	# 	click_link "Edit Guides Category"
	# 	fill_in 'guides_category_title', with: 'Animals the fox'
	# 	click_button "Update Guides category"
	# 	page.should have_content('Animals the fox')
	# 	click_link 'Dashboard'
	# 	click_link 'Guides Categories'
	# 	page.should have_content('Animals the fox')
	# 	first(:link, 'Delete').click
	# 	page.should have_content('Guides category was successfully destroyed.')
	# 	page.should_not have_content('Animals the fox')
	# end
	# scenario 'Blog crud' do 
	# 	visit '/obeqaslksdssdfnfdfysdfxm'
	# 	fill_in "admin_user_email", :with => admin_user.email
	#   fill_in "admin_user_password", :with => admin_user.password
	#   click_button "Login"
	# 	page.should have_content("Dashboard")	
	# 	click_link 'Blogs'
	# 	page.should have_content('There are no Blogs yet. Create one')
	# 	click_link 'New Blog'
		
	# 	fill_in 'blog_title', with: 'What does..'
	# 	fill_in 'blog_content', with: '..the fox say'
	# 	click_button "Create Blog"
	# 	page.should have_content('What does..')
		
	# 	click_link "Edit Blog"
	# 	fill_in 'blog_content', with: '..the fox say? Hatti hatti'
	# 	click_button "Update Blog"
	# 	page.should have_content('Hatti hatti')
	# 	click_link 'Dashboard'
	# 	click_link 'Blogs'
	# 	page.should have_content('What does..')
	# 	click_link 'Delete'
	# 	page.should have_content('Blog was successfully destroyed.')
	# 	page.should_not have_content('What does..')
	# end
	#scenario 'subscription crud' do 
		# signing_in	
		# click_link 'Subscriptions'
		# page.should have_content(firm.name)
		# click_link 'New Subscription'
		# select firm.plan.name, from:'subscription[plan_id]'
		# select firm.name, from:'subscription[firm_id]'
		# fill_in 'subscription_email', with: user.email
		# click_button "Create Subscription"
		
		# click_link "Edit Subscription"
		# fill_in 'subscription_name', with: "test"
		# click_button "Update Blog"
		# page.should have_content('test')
		# click_link 'Dashboard'
		# click_link 'Subscriptions'
		# page.should have_content('test')
		# click_link 'Delete'
		# page.should have_content('Subscriptions was successfully destroyed.')
		# page.should_not have_content('test')
	#end
end
