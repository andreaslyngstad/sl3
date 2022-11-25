require 'spec_helper'

describe AdminUser do
  let(:valid_attributes) do
    {
      email: "test@test.com", 
      password: "password",
      password_confirmation: "password", 
      remember_me: true
    }
  end

  let (:admin_user) do
    AdminUser.new(valid_attributes)
  end

  describe "#initialize" do
    it "initializes all attributes correctly" do
      admin_user.email.should eql("test@test.com")
      admin_user.password.should eql("password")
      admin_user.password_confirmation.should eql("password")
      admin_user.remember_me.should eq(true)
    end
  end
end
