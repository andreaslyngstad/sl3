class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.integer   :number
      t.text      :content
      t.integer   :project_id
      t.integer   :customer_id, :null => false
      t.integer   :invoice_id
      t.integer   :reminder_on_id
      t.integer   :firm_id, :null => false
      t.integer   :status
      t.datetime  :reminder_sent
      t.float     :reminder_fee
      t.datetime  :sent
      t.datetime  :paid
      t.datetime  :due
      t.datetime  :last_due
      t.float     :total
      t.float     :receivable
      t.float     :invoice_receivable
      t.datetime  :date
      t.float     :lost
      t.text      :currency
      t.timestamps
    end
      add_index :invoices, :firm_id
      add_index :invoices, :project_id
      add_index :invoices, :invoice_id
      add_index :invoices, :reminder_on_id
      add_index :invoices, :customer_id
  end
end
