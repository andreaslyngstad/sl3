class Guide < ActiveRecord::Base
  # attr_accessible :content, :title, :guides_category_id
  belongs_to :guides_category
end
