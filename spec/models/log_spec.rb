require 'rails_helper'
describe Log do

  let(:firm)      {FactoryBot.create(:firm)}

  let(:user)      {FactoryBot.create(:user, :firm => firm)}
  let(:time_now)  {Time.zone.now}
  let(:log)       {FactoryBot.create(:log, :user => user, :firm => firm)}
  let(:customer)  {FactoryBot.create(:customer, :firm => firm)}
  let(:log2)      {FactoryBot.create(:log, rate: 100,
                                            tax: 25,
                                            log_date: Date.today.beginning_of_week + 1.day,
                                            begin_time: time_now,
                                            end_time: time_now + 1.hours,
                                            user: user,
                                            firm: firm,
                                            invoice_id: 1)}
  let(:log3)      {FactoryBot.create(:log, :log_date => Date.today.beginning_of_week - 1.day, :begin_time => time_now, :end_time => time_now + 1.hours, :user => user, :firm => firm)}
  let(:log4)       {FactoryBot.create(:log, event: 'new_log_without_credit_note',:user => user, :firm => firm,
                                            invoice_id: 1,
                                            credit_note_id: 1)}
  let(:log_uninvoiced) {FactoryBot.create(:log, invoice_id: 0, :user => user, :firm => firm, :rate => 889.0)}
  let(:log_uninvoiced_in_progress) {FactoryBot.create(:log, invoice_id: nil, :user => user, :firm => firm, end_time: nil, tracking: true)}
  let(:project)   {FactoryBot.create(:project, :firm => firm)}
  let(:range)     {Date.today.beginning_of_week..Date.today.end_of_week}
  # it 'Displays the total time' do
  #   log = FactoryBot.create(:log, :begin_time => time_now, :end_time => time_now + 30.hours, :user => user, :firm => firm)
  #   assert_equal '30:00', log.total_time
  #   log = FactoryBot.create(:log,:begin_time => time_now, :end_time => time_now + 3.hours, :user => user, :firm => firm)
  #   assert_equal '3:00', log.total_time
  #   log = FactoryBot.create(:log,:begin_time => time_now, :end_time => time_now + 3.minutes, :user => user, :firm => firm)
  #   assert_equal '0:03', log.total_time
  #   log = FactoryBot.create(:log,:begin_time => time_now, :end_time => time_now + 13.minutes, :user => user, :firm => firm)
  #   assert_equal '0:13', log.total_time
  # end

  it { should belong_to(:user).without_validating_presence }

  it { should belong_to(:customer).without_validating_presence }
  it { should belong_to(:firm).without_validating_presence }
  it { should belong_to(:project).without_validating_presence }
  it { should belong_to(:todo).without_validating_presence }
  it { should belong_to(:employee).without_validating_presence }
  it 'returns logs with invoice_id nil' do
    log_uninvoiced
    Log.uninvoiced.should include log_uninvoiced
    Log.uninvoiced.should_not include log_uninvoiced_in_progress
  end
  it 'does check plan limit' do
    plan = FactoryBot.create(:plan, logs: 1 )
    firm.plan = plan
    firm.logs_count = 30
    FactoryBot.build(:log, :begin_time => time_now, :end_time => time_now + 30.hours, :user => user, :firm => firm).should_not be_valid
  end
  it 'should be saved on correct firm' do
    firm2 = FactoryBot.create(:firm)
    FactoryBot.build(:log, :begin_time => time_now, :end_time => time_now + 30.hours, :user => user, :firm => firm2).should_not be_valid
  end
  it 'should demand project for external_users' do
    user = FactoryBot.create(:user, :firm => firm, role: 'external_user')
    FactoryBot.build(:log, :project => nil, :firm => firm, :user => user).should_not be_valid
  end
  it 'Should set hour spent in right format before save' do
    log.hours.should == log.end_time - log.begin_time
  end

  it 'returns a new log with nil in invoice_id and credit_note_id' do
    log4.duplicate_credit_note_log
    Log.where(event: 'new_log_without_credit_note').first.invoice_id.should eq 0
    Log.where(event: 'new_log_without_credit_note').first.credit_note_id.should eq nil
  end

  it 'returns a credited log' do
    id = log2.id
    log2.credit_note_log(4)
    l = Log.credit_noted.first
    l.credit_note_id.should == 4

  end

  it "returns true if invoiced" do
    log2.invoiced?.should eq true
  end
  # it 'Has a total_time' do
  #   time = time_now
  #   log = Log.create!(:event => 'test', :begin_time => time, :end_time => time + 3.hours, :user => user, :firm => firm)
  #   log.total_time.should == '3:00'
  # end

  it 'should have time' do
    log = FactoryBot.create(:log,:begin_time => time_now, :end_time => time_now + 3.hours, :user => user, :firm => firm)
    assert_equal 10800.0, log.time
  end
  it 'should_not save when end is before start' do
    FactoryBot.build(:log, :begin_time =>  time_now + 30.hours, :end_time => time_now, tracking: false, :user => user, :firm => firm).should_not be_valid
  end

  it 'should calculate hours for timesheet' do
     log2
     log3
     Log.logs_for_timesheet(user).should == {[nil, (Date.today.beginning_of_week + 1.day)]=>3600.0}
  end

  it 'should find hours by day and model' do
    log2
    log3
    model = :user
    logs = Log.hours_by_day_and_model(firm, range, model)
    logs.each do |l|
      l.total_hours.should == 3600.0
      l.user.should == user
      l.log_date.should == Date.today.beginning_of_week + 1.day
    end
  end
  it 'should get hours by model' do
    log2
    log3
    model = :user
    logs = Log.hours_by_model(firm, range, model)
    logs.each do |l|
      l.total_hours.should == 3600.0
      l.user.should == user
    end
  end
  it 'should find inbetween' do
    log2.placed_between?(range).should == true
    log3.placed_between?(range).should == false
  end
  it 'should find logs' do
    log4 = FactoryBot.create(:log, :user => user, :firm => firm, :project => project)

    log5 = FactoryBot.create(:log, :user => user, :firm => firm, :project => project)
    log6 = FactoryBot.create(:log, :user => user, :firm => firm, :project => project, customer:customer)
    Log.try_find_logs(user_id: user.id,project_id: project.id).should =~ [log4,log5, log6]
    Log.try_find_logs(user_id: user.id,project_id: project.id).should_not == [log]
    Log.try_find_logs(user_id: user.id,project_id: project.id, customer: customer.id).should == [log6]
  end

  it 'should return total price' do
    log2.total_price.should eq 125
  end
end
