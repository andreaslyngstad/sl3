class Membership < ActiveRecord::Base
  # attr_accessible :project_id,:user_id,:created_at,:updated_at
	belongs_to :user
	belongs_to :project
end
