require 'active_record'
ActiveRecord::Base.establish_connection adapter: "postgresql", 
                                        database: "squadlink_test",
                                        username: "andreas",
                                        password: ""
load "./db/schema.rb"

 
require 'rspec/rails/extensions/active_record/base'
RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end