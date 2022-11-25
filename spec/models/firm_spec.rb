require "rails_helper"

describe Firm do
   it {should have_many(:logs)}
   it {should have_many(:todos)}
   it {should have_many(:customers)}
   it {should have_many(:users)}
   it {should have_many(:projects)}
   it {should_not allow_value("#_").for(:subdomain) }
   it {should allow_value("test").for(:subdomain) }
   it {should validate_uniqueness_of(:subdomain) }
   it {should validate_presence_of(:subdomain) }
   it {should validate_presence_of(:name) }



  let(:f_no_plan)       {FactoryBot.create(:firm_no_plan)}
  let(:f2)              {FactoryBot.create(:firm)}
  let(:p)               {FactoryBot.create(:plan, name: "costly", price: 1200, customers: 30,  projects:30 , users: 30)}

  let(:f)               {FactoryBot.create(:firm_no_plan, plan_id: p.id)}

  let(:p1)              {FactoryBot.create(:plan, name: "cheep", price: 12, customers: nil)}
  let(:customer_list)   {FactoryBot.create_list(:customer,20, firm: f)}
  let(:user_list)       {FactoryBot.create_list(:user,20, firm: f)}
  let(:project_list)    {FactoryBot.create_list(:project,20, firm: f)}
  let(:invoice_list)    {FactoryBot.create_list(:invoice,20, firm: f, customer: f.customers.first)}

  it "should be created with a plan" do
    f_no_plan.subscription.should_not == nil
    f_no_plan.plan.name.should == "Free"
  end

  it "should update firm_plan" do
   f.update_plan(f.subscription.plan_id)
   f.plan.name.should == "Free"
  end

  it "should update counters" do
    f.plan = p
    customer_list
    user_list
    project_list

    f.update_firm_counters
    f.customers_count.should == 20
    f.projects_count.should == 20
    f.users_count.should == 20
  end

  it "should remove associations when downgrading" do
    f.plan = p
    customer_list
    user_list
    project_list
    invoice_list
    f.update_firm_counters
    f.invoices.count.should == 20
    p2 = Plan.where(name: "Free").first
    f.remove_associations_when_downgrading(p2.id)
    f.customers.count.should == 2
    f.projects_count.should == 2
    f.users_count.should == 2
    f.invoices_count.should == 20
  end

   it "should remove associations when downgrading" do
    f.plan = p
    customer_list
    user_list
    project_list
    invoice_list
    f.update_firm_counters
    f.invoices.count.should == 20

    f.remove_associations_when_downgrading(p1.id)
    f.customers.count.should == 20
    f.projects_count.should == 20
    f.users_count.should == 20
    f.invoices_count.should == 20
  end

  it "should check payment" do
    f.subscription = FactoryBot.create(:subscription, card_type: "visa", last_four: "1111", active: true, next_bill_on: Time.zone.now.to_date - 1.day )
    f2.subscription = FactoryBot.create(:subscription, card_type: "visa", last_four: "1111", active: true,  next_bill_on: Time.zone.now.to_date + 1.days)
    f.payment_check?.should == true
    f2.payment_check?.should == false
  end
  it 'did_sign_in' do
    f.did_sign_in
    f.last_sign_in_at.to_date.should == Date.current
  end
  it "closes down" do
    f.close!
    f.closed.should == true
  end
  it "opens up" do
    f.open!
    f.closed.should == false
  end

  it "reverts to free plan" do
    f.subscription = FactoryBot.create(:subscription, card_type: "visa", last_four: "1111", paymill_id: "test", plan: p)
    f.plan = p
    customer_list
    user_list
    project_list
    f.update_firm_counters
    f.users.count.should == 20
    f.subscription.plan.name.should == "costly"
    f.revert_to_free_no_payment
    f.subscription.plan.name.should == "Free"
    f.subscription.plan.customers.should == 2
    f.subscription.plan.users.should == 2
    f.subscription.plan.projects.should == 2
    f.users.count.should == 2
    f.users_count.should == 2
  end
  it "generates a hash of firms per subscription" do
    # Plan.destroy_all
    # f
    # Firm.count_by_plan.should == {Plan.last => 1}
  end
end
