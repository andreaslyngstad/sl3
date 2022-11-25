
describe ProjectPrice do

		let(:time)		{Time.zone.now}
		let(:firm)		{FactoryBot.create :firm}
		let(:project) {FactoryBot.create :project, firm: firm, budget:1000 }
		let(:bob)			{FactoryBot.create :user, name: "bob", hourly_rate: 2, firm: firm }
		let(:alice) 	{FactoryBot.create :user, name: "alice", hourly_rate: 1, firm: firm }
		let(:joice) 	{FactoryBot.create :user, name: "joice", hourly_rate: nil, firm: firm }
		let(:log1)		{FactoryBot.create :log, event: "test", project: p,begin_time: time, end_time: time + 2.hours, rate: 100, user: bob, firm: firm }
		let(:log2)		{FactoryBot.create :log, event: "test2", project: p, begin_time: time, end_time: time + 1.hours,user: alice, firm: firm }
		let(:log3)		{FactoryBot.create :log, event: "test2", project: p, begin_time: time, end_time: time + 3.hours,user: joice, firm: firm }

	it "Should get all hours on project grouped by user" do	
		project.users << [alice, bob, joice]
		project.logs << [log1, log2, log3]	
		expect(ProjectPrice.get_hours(project)).to eq(200)  
	end
	# it "Should set the procentage of budget spent" do
	# 	project.users << [alice, bob, joice]
	# 	project.logs << [log1, log2, log3]
	# 	ProjectPrice.get_cost_per_user(project).should =~ [["joice", nil, 10800.0, nil], ["bob", 2.0, 7200.0, 4.0], ["alice", 1.0, 3600.0, 1.0]]
	# end
	it "Should set the procentage of budget spent" do
		project.users << [alice, bob, joice]
		project.logs << [log1, log2, log3]
		ProjectPrice.set_procentage(project).should == 0.2 
	end
end   