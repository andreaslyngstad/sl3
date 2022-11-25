class AddAttachmentLogoToFirm < ActiveRecord::Migration[7.0]
  def change
    add_column :firms, :logo_file_name, :string
    add_column :firms, :logo_content_type, :string
    add_column :firms, :logo_file_size, :integer
    add_column :firms, :logo_updated_at, :datetime
    add_column :firms, :background, :string
    add_column :firms, :color, :string
  end
end
