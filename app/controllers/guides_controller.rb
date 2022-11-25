class GuidesController < ApplicationController
	skip_before_action :authenticate_user!, :all_users, :user_at_current_firm
	 layout "registration"
	def index
		@guidescat = GuidesCategory.order(:created_at).includes(:guides)
		@guides = Guide.all
	end
	def show
		@guidescat = GuidesCategory.order(:created_at).includes(:guides)
		@guides = Guide.all
		@guide = Guide.find(params[:id])
	end
end
