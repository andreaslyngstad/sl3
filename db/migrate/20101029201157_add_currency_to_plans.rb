class AddCurrencyToPlans < ActiveRecord::Migration[7.0]
  def change
  	add_column :plans, :currency, :string
  end
end
