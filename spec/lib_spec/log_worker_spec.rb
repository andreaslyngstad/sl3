require "./lib/log_worker.rb"
describe LogWorker do
	let(:todo) { double("Todo", save!: true) }
  let(:user){ double("User", name: "test", hourly_rate: 2)}
  let(:firm){double("Firm")}
  let(:log) {double("log", todo: todo, user: "user", firm: "firm", tracking: false) }
	
  class FakeLog; attr_accessor :firm, :user, :tracking, :begin_time, :log_date, :todo end
	it 'should create log based on args' do
		# log = FakeLog.new
		log.should_receive(:firm=).with(firm)
		log.should_receive(:tracking=).with(false)
		todo.should_receive(:done_by_user=).with(user)
		todo.should_receive(:completed=).with(true)
		# log.stub!(:user).and_return(user)
		# log.stub!(:firm).and_return(firm)
		# log.stubs(:user).returns(user)
		# log.stubs(:firm).returns(firm)
		# log.stubs(:tracking).returns(false)
		LogWorker.create(log, true, user, firm) 
		# LogWorker.create(log, true, user, firm).firm.should == firm  
	end
	it 'should start tracking' do
		@time_now = Time.parse("Feb 24 1981")
  	Time.stub(:now).and_return(@time_now)

		log.should_receive(:firm=).with(firm)
		log.should_receive(:tracking=).with(false)
		log.should_receive(:tracking=).with(true)
		# log.should_receive(:user=).with(user)
		log.should_receive(:log_date=).with(Date.current)
		log.should_receive(:begin_time=).with(Time.zone.now)
		log.should_receive(:rate=).with(2)
		todo.should_receive(:done_by_user=).with(user)
		todo.should_receive(:completed=).with(true)
		user.should_receive(:hourly_rate)
		LogWorker.start_tracking(log, true, user, firm)
	end
	
	it 'should check_todo_on_log'do
		done = true
		todo.should_receive(:completed=).with(true)
		todo.should_receive(:done_by_user=).with(user)
    LogWorker.check_todo_on_log(log, user, done)
	end
	it 'unchecks todo when done is nil'do
	 	done = false
    todo.should_receive(:completed=).with(false)
    todo.should_receive(:done_by_user=).with(user)
    LogWorker.check_todo_on_log(log, user, done)
  end
  
end