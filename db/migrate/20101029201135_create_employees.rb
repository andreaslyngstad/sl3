class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.text :name
      t.text :phone
      t.text :email
      t.integer :customer_id, :null => false
      t.integer :firm_id, :null => false
      t.timestamps
    end
     add_index :employees, :customer_id
     add_index :employees, :firm_id
  end
end
