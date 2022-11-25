class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.integer :project_id
      t.integer :user_id
      t.timestamps
    end
    add_index :memberships, [:project_id, :user_id], :unique => true
  end
end
