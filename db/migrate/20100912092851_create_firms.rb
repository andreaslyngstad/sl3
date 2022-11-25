class CreateFirms < ActiveRecord::Migration[7.0]
  def change
    create_table :firms do |t|
           t.text :name
           t.text :subdomain
           t.text :address
           t.text :phone
           t.text :currency
           t.text :language, default: "en"
           t.text :time_zone
           t.float :tax
           t.float :reminder_fee
           t.integer :days_to_due, default: 14
           t.text :invoice_email
           t.text :invoice_email_subject
           t.text :invoice_email_message
           t.text :on_invoice_message
           t.text :reminder_email_subject
           t.text :reminder_email_message
           t.text :on_reminder_message
           t.text :bank_account
           t.text :vat_number
           t.datetime :last_sign_in_at
           t.boolean :closed
           t.integer :time_format
           t.integer :date_format
           t.integer :clock_format
           t.integer :plan_id
           t.integer :starting_invoice_number, default: 1
           t.integer :customers_count, :default => 0
           t.integer :users_count, :default => 0
           t.integer :projects_count, :default => 0
           t.integer :logs_count, :default => 0
           t.integer :invoices_count, :default => 0

      t.timestamps
    end
     add_index :firms, :plan_id
     add_index :firms, :subdomain
  end
end
