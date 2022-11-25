class CreateTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.text :name
      t.integer :user_id
      t.integer :firm_id, :null => false
      t.integer :project_id
      t.integer :customer_id
      t.integer :done_by_user_id
      t.integer :prior
      t.date :due
      t.boolean :completed
      t.timestamps
    end

    add_index :todos, :firm_id
    add_index :todos, :user_id
    add_index :todos, :project_id
    add_index :todos, :customer_id
    add_index :todos, :done_by_user_id
  end

end
