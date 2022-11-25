require "rails_helper"

describe Payment do
	it { should belong_to(:firm) }
  it { should validate_presence_of(:firm_id) }
  it { should validate_presence_of(:card_type) }
  it { should validate_presence_of(:last_four) }
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:plan_name) }
end      