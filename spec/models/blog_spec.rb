require "rails_helper"

describe Blog do
  it "has a valid factory" do
    FactoryBot.create(:blog).should be_valid   
  end
end