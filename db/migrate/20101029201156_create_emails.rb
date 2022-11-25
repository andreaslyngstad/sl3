class CreateEmails < ActiveRecord::Migration[7.0]
  def change
    create_table :emails do |t|
      t.string :address
      t.text :subject
      t.text :content
      t.integer :invoice_id
      t.integer :firm_id
      t.date :sent
      t.text :status
      t.timestamps
    end
  end
end
