ActiveAdmin.register Blog do
  controller do
    def permitted_params
      params.permit blog: [:content , :author, :title]
    end
  end
  index do
    selectable_column
    column :title 
    column :author
    column :created_at
    column :updated_at
    actions 
  end
  form do |f|
    f.inputs "Details" do
	      f.input :author,:as => :string
	      f.input :title,:as => :string
	      f.input :content 
	    end
      f.actions
    end
end