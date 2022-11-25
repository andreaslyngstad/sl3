ActiveAdmin.register Guide do
	controller do
    def permitted_params
      params.permit guide: [:content , :guides_category_id, :title]
    end
  end
end