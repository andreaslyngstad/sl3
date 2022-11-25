class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.text      :event
      t.integer   :customer_id
      t.integer   :user_id, :null => false
      t.integer   :firm_id, :null => false
      t.integer   :project_id
      t.integer   :employee_id
      t.integer   :invoice_id, :default => 0
      t.integer   :credit_note_id, :default => 0
      t.integer   :todo_id
      t.boolean   :tracking
      t.datetime  :begin_time
      t.datetime  :end_time
      t.date      :log_date
      t.float     :hours, default: 0
      t.float     :rate, default: 0
      t.float     :tax
      t.timestamps
    end
    add_index :logs, :firm_id
    add_index :logs, :invoice_id
    add_index :logs, :user_id
    add_index :logs, :project_id
    add_index :logs, :employee_id
    add_index :logs, :todo_id
    add_index :logs, :customer_id
  end

end
