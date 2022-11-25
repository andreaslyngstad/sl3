class CreateGuides < ActiveRecord::Migration[7.0]
  def change
    create_table :guides do |t|
      t.text :title
      t.text :content
      t.integer :guides_category_id
      t.timestamps
    end
  end
end
