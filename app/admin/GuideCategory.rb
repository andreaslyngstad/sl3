ActiveAdmin.register GuidesCategory do
  controller do
    def permitted_params
      params.permit guides_category: [:title]
    end
  end
end