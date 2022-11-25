class Employee < ActiveRecord::Base
  # attr_accessible :name,:phone,:email,:customer_id,:created_at,:updated_at,:customer,:firm
  include ActiveModel::Validations
  validates_with Validator

  belongs_to :customer
  belongs_to :firm
  has_many :logs
  validates_presence_of :name
  
end
