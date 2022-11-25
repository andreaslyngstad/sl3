require 'spec_helper'
describe TimesheetsHelper do
	before(:each) do
		@request.env["devise.mapping"] = Devise.mappings[:user] 
	    @user = FactoryBot.create(:user) 
	    sign_in @user
  	end 
	let(:firm)          {@user.firm}
	let(:project)       {FactoryBot.create(:project, firm:firm)} 
	let(:external_user) {FactoryBot.create(:user, firm: firm, role: "external_user")}
	let(:todo)          {FactoryBot.create(:todo, completed: false, project: project, user: @user, firm: firm)}    
	let(:log)           {FactoryBot.create(:log, project: project, user: @user, firm: firm, begin_time: Time.zone.now - 2.hours, end_time: Time.zone.now,:log_date => Date.today)}
	let(:log1)           {FactoryBot.create(:log, project: project, user: @user, firm: firm, begin_time: Time.zone.now - 1.hours, end_time: Time.zone.now,:log_date => Date.today )}
	let(:log2)           {FactoryBot.create(:log, project: nil, user: @user, firm: firm, begin_time: Time.zone.now - 0.5.hours, end_time: Time.zone.now,:log_date => Date.today )}
	
	it 'every_day_log_hour' do
		helper.every_day_log_hour(@user.logs.where(:log_date => Date.today).group("project_id").group("date(log_date)").sum(:hours), Date.today, project).should == 0
		@user.logs << [log, log1,log2]
		helper.every_day_log_hour(@user.logs.where(:log_date => Date.today).group("project_id").group("date(log_date)").sum(:hours), Date.today, project).should == 10800
	end	 
	it 'every_day_log_hour_no_project' do
		helper.every_day_log_hour_no_project(@user.logs.where(:log_date => Date.today, :project_id => nil).group("date(log_date)").sum(:hours), Date.today).should == 0
		@user.logs << [log, log1, log2]
		helper.every_day_log_hour_no_project(@user.logs.where(:log_date => Date.today, :project_id => nil).group("date(log_date)").sum(:hours), Date.today).should == 1800
	end
	it 'every_day_log_hour_total' do
		helper.every_day_log_hour_total(@user.logs.where(:log_date => Date.today).group("date(log_date)").sum(:hours), Date.today).should == 0
		@user.logs << [log, log1, log2]
		helper.every_day_log_hour_total(@user.logs.where(:log_date => Date.today).group("date(log_date)").sum(:hours), Date.today).should == 12600
	end
	it 'project_week_log_hour_total' do
		helper.project_week_log_hour_total( @user.logs.where(:log_date => Date.today).group("project_id").sum(:hours), project).should == "<span style='color:grey;'>0:00</span>"
		@user.logs << [log, log1, log2]
		helper.project_week_log_hour_total( @user.logs.where(:log_date => Date.today).group("project_id").sum(:hours), project).should == '3:00'
	end
	it 'logs_day_of_mounth_hours' do
		helper.logs_day_of_mounth_hours( @user.logs.group("date(log_date)").sum(:hours), Date.today).should == "<span id='#{Date.today}' class='calendar_span' data-hours='0' style='color:grey;'>0:00</span>"
		@user.logs << [log, log1, log2]
		helper.logs_day_of_mounth_hours( @user.logs.group("date(log_date)").sum(:hours), Date.today).should == "<span id='#{Date.today}' style='font-size:20px;' class='calendar_span' data-hours='12600'>3:30</span>"
	end
	
end