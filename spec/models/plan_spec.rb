require 'spec_helper'

describe Plan do
  it {should have_many(:subscriptions)}
  it {should have_many(:firms)}
  it {should validate_presence_of(:paymill_id) }
end
