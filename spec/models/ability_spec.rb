require 'spec_helper'
 
describe Ability do
	let(:firm)					{ FactoryBot.create(:firm)}
  let(:admin_user) 		{ FactoryBot.create(:user, role: "Admin", firm: firm) }
  let(:member_user) 	{ FactoryBot.create(:user, role: "Member", firm: firm) }
  let(:external_user) { FactoryBot.create(:user, role: 'external_user', firm: firm) }
  let!(:project)       { FactoryBot.create(:project, firm: firm)}

  it { Ability.should include(CanCan::Ability) }
  it { Ability.should respond_to(:new).with(1).argument }
 
  context "admin" do
  
    it "can manage all" do
      Ability.any_instance.should_receive(:can).with(:manage, Firm)
      Ability.any_instance.should_receive(:can).with(:manage, User, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Customer, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Project, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:create, Project )
      Ability.any_instance.should_receive(:can).with(:archive, Project)
      Ability.any_instance.should_receive(:can).with(:activate_projects, Project)
      Ability.any_instance.should_receive(:can).with(:manage, Log, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Todo, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Invoice, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Email, :firm => {:id => admin_user.firm_id})
      Ability.new admin_user
    end
  end
 
  context "Member" do
   
    it "can not manage all" do
    	Ability.any_instance.should_receive(:can).with(:read, Firm, :firm => {:id => member_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, User )
      Ability.any_instance.should_receive(:can).with(:read, Customer, :firm => {:id => member_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:read, Project, :firm => {:id => member_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Todo )
      Ability.any_instance.should_receive(:can).with(:manage, Project)
      Ability.any_instance.should_receive(:can).with(:create, Project )
      Ability.any_instance.should_receive(:can).with(:manage, Log )
      Ability.any_instance.should_receive(:can).with(:read, Log, :firm => {:id => member_user.firm_id})
      Ability.any_instance.should_receive(:cannot).with(:create, User)
      Ability.any_instance.should_receive(:cannot).with(:archive, Project)
      Ability.any_instance.should_receive(:cannot).with( :activate_projects, Project)
      Ability.new member_user
    end
  end
 	context "Member" do
    it "can create and edit models" do
      Ability.any_instance.should_receive(:can).with(:manage, Project )
      Ability.any_instance.should_receive(:can).with(:manage, Todo)
      Ability.any_instance.should_receive(:cannot).with(:create, Project)
      Ability.any_instance.should_receive(:cannot).with(:archive, Project)
      Ability.any_instance.should_receive(:can).with(:manage, Log )
      Ability.any_instance.should_receive(:can).with( :read, Log )
      Ability.any_instance.should_receive(:cannot).with(:read, Invoice)
      Ability.any_instance.should_receive(:cannot).with(:manage, Invoice)
      Ability.new external_user
   end
  end
end