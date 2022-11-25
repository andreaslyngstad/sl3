require "rails_helper"
describe Guide do
	it { should belong_to(:guides_category) } 
end