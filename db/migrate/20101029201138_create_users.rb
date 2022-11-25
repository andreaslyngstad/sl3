class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
	    t.text  :role
      t.text 	:phone
      t.text 	:name
      t.integer :firm_id, :null => false
      t.float   :hourly_rate, default: 0
      t.string :loginable_type, :limit => 40
      t.integer :loginable_id
      t.text :loginable_token
      t.timestamps
    end
    add_index :users, :firm_id
  end
end
