class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.integer :plan_id
      t.text :email
      t.text :name
      t.integer :firm_id
      t.text :paymill_id
      t.text :paymill_client_id
      t.text  :card_zip
      t.text  :last_four
      t.text  :card_type
      t.date  :next_bill_on
      t.text  :card_expiration
      t.text  :card_holder
      t.boolean :active

      t.timestamps
    end
    add_index :subscriptions, [:plan_id, :firm_id]
  end
end
