require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:plan)    {FactoryBot.create(:plan, users: 50)}
  let(:firm2)   {FactoryBot.create(:firm, users_count: 1, plan: plan)}
  let(:firm)    {FactoryBot.create(:firm, users_count: 49, plan: plan)}
  let(:firm1)   {FactoryBot.create(:firm, users_count: 51, plan: plan)}

  subject {FactoryBot.create(:user,firm:firm2) }
  it {should have_many(:logs).without_validating_presence}
  it {should have_many(:todos)}
  it {should have_many(:projects)}
  it { should belong_to(:firm) }
  it { should_not allow_value("blah").for(:email) }
  it { should allow_value("a@b.com").for(:email) }

  it { should validate_presence_of(:name) }


  it "validates uniqueness of email" do
    user1 = FactoryBot.create(:user, email: 'a@b.com', firm: firm2)
    user2 = FactoryBot.build(:user, email: 'a@b.com', firm: firm2).should_not be_valid
  end
  it "Can have a valid recovery" do
    user = FactoryBot.create(:user, :loginable_token => "secret")
    user.firm = firm
    user.save
    User.valid_recover?(user.loginable_token).should == user
  end

  it "should return true if user is admin" do
    user = FactoryBot.create(:user, role: 'Admin', firm: firm2)
    user.admin?.should eq true
  end


  it "should not save if over plan limit" do
    FactoryBot.build(:user, firm_id: firm1.id).should_not be_valid
  end
  it "should validate_presence_of name" do
    FactoryBot.build(:user, firm_id: firm.id, name: "").should_not be_valid
  end

end
