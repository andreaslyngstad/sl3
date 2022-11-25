require "./lib/hash_handeling.rb"
describe HashHandeling do
  let(:plan) {{users: 10, projects: 50, customers: nil} }
  let(:firm) {{users: 4, projects: 200, customers: 50} }
  
  it "Should find the difference between plan and firm" do
    h = HashHandeling.new.values_difference(firm, plan)
    h[:users].should == 6
    h[:projects].should == -150  
  end
end
