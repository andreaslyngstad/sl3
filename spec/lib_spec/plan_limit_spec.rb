require "./lib/plan_limit.rb"
describe PlanLimit do
  let(:plan) {50}
  let(:firm) {50}
  let(:firm1) {49}
  let(:firm2) {51}
  
  it "should set true if under limit" do
    PlanLimit.new.over_limit?(firm, plan).should == true
  end
  it "should set true if on limit" do
    PlanLimit.new.over_limit?(firm1, plan).should == false
  end
  it "should set true if over limit" do
    PlanLimit.new.over_limit?(firm2, plan).should == true
  end
end