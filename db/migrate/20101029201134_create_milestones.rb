class CreateMilestones < ActiveRecord::Migration[7.0]
  def change
    create_table :milestones do |t|
      t.text :goal
      t.date :due
      t.integer :firm_id, :null => false
      t.boolean :completed
      t.integer :project_id

      t.timestamps
    end
    add_index :milestones, :firm_id
    add_index :milestones, :project_id
  end
end
