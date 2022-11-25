class AddPaidAmountToinvoices < ActiveRecord::Migration[7.0]
  def change
  	add_column :invoices, :paid_amount, :float
  end
end
