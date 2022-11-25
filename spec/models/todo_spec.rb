require "rails_helper"

describe Todo do
  let(:firm)    {FactoryBot.create(:firm)}
  let(:project) {FactoryBot.create(:project, firm: firm)}
  let(:user)    {FactoryBot.create(:user, firm: firm)}
  it { should belong_to(:customer) }
  it { should belong_to(:project) }
  it { should belong_to(:user) }
  it { should belong_to(:firm) }
  it {should have_many(:logs)}

  it 'should be saved on correct firm' do
    firm2 = FactoryBot.create(:firm)
    test = FactoryBot.build(:todo,:project => project, :firm => firm2)
    test.should_not be_valid
    test.errors[:base].should be_present
  end
  it "Can be due to day" do
    todo = Todo.create!(:name => "Test", :due => Time.zone.now, :completed => false, :firm => firm, :project => project, :user => user)
    todo.due_to_day.should == true
  end
  it "Can be not due to day" do
    todo = Todo.create!(:name => "Test", :due => Time.zone.now + 1.day, :completed => false, :firm => firm, :project => project, :user => user)
    todo.due_to_day.should == false
  end

  it "Can be overdue" do
    todo = Todo.create!(:name => "Test", :due => Time.zone.now - 2.day, :completed => false, :firm => firm, :project => project, :user => user)
    todo.overdue.should == true
  end
  it "Can be not overdue" do
    todo = Todo.create!(:name => "Test", :due => Time.zone.now + 1.day, :completed => false, :firm => firm, :project => project, :user => user)
    todo.overdue.should == false
  end
  it "should not save without user" do
    FactoryBot.build(:todo, :name => "Test", :due => Time.zone.now + 1.day, :firm => firm, :project => project).should_not be_valid
  end
  it "should not save without project" do
    FactoryBot.build(:todo, :name => "Test", :due => Time.zone.now + 1.day, :firm => firm, :user => user).should_not be_valid
  end
end
