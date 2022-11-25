class MembershipsController < ApplicationController
	def index 
    # authorize! :manage, User    
  	@project = Project.find(params[:project_id])
    # authorize! :manage, @project
  	@user = User.find(params[:id])

  	if params[:membership] == "false"
  		@project.users.delete(@user)
  		flash[:notice] = flash_helper(@user.name + ' ' + t('general.is_not_on') + ' '  + @project.name)
  	else
  		@project.users << @user
  		flash[:notice] = flash_helper(@user.name +  ' ' + t('general.is_on') + ' ' + @project.name)
  	end
  	@members = @project.users
  	@not_members = current_firm.users - @members	
  end

end