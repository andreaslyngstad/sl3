class CreateGuidesCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :guides_categories do |t|
      t.string :title
      t.timestamps
    end
  end
end
