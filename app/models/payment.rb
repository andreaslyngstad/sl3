class Payment < ActiveRecord::Base
  # attr_accessible :card_type, :firm_id, :amount, :plan_name, :last_four
  belongs_to :firm
  validates_presence_of :card_type, :firm_id, :amount, :plan_name, :last_four
  scope :order_by_date, -> {order("created_at ASC")}

  def self.make(sub, currency)
  	create!(
  		firm_id: sub.firm.id, amount: sub.plan.price, plan_name: sub.plan.name, card_type: sub.card_type, last_four: sub.last_four, currency: currency
      )
  end
end
 