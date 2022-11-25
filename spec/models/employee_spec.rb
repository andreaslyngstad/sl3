require "rails_helper"

describe Employee do
  it {should have_many(:logs)}
  it { should belong_to(:customer) }

  let(:firm)      {FactoryBot.create(:firm)}
  let(:firm1)     {FactoryBot.create(:firm)}
  let(:customer)  {FactoryBot.create(:customer, firm: firm)}

  it 'should not save on different firm' do
    test = FactoryBot.build(:employee, customer: customer,firm_id: firm1.id)
    test.should_not be_valid
    test.errors[:base].should be_present
  end
end