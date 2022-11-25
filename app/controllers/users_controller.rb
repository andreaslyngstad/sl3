class UsersController < ApplicationController

  skip_before_action:authenticate_user!, :only => [:valid]
  respond_to :html, :js, :json
  def index
    # # authorize! :read, User
    @users = current_firm.users.order(:name).includes(:firm)
    @user = current_firm.users.new
    respond_with(@users)
  end

  def show
    @klass = current_firm.users.find(params[:id])
    # authorize! :read, @klass
    redirect_to(tabs_state_path(string_for_klass(@klass),@klass.id))
  end

  def edit
    # # authorize! :manage, User
    @user = current_firm.users.find(params[:id])
  end

  def create
    @klass = current_firm.users.new(permitted_params.user)
    # # authorize! :manage, @klass
    @klass.firm = current_firm
     respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper("#{@klass.name}" + ' ' + (t'activerecord.flash.saved'))
        format.js

      else
        format.js { render "shared/validate_create" }
    end
    end
  end

  def update
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
     @klass = current_firm.users.find(params[:id])
     # # authorize! :update, @klass
      respond_to do |format|
    if @klass.update_attributes(permitted_params.user)
      sign_in(current_user)
      flash[:notice] = flash_helper("#{@klass.name}" + ' ' + (t'activerecord.flash.saved'))
      format.js
      format.html { redirect_to user_path(@klass) }
    else

      format.html
      format.js { render "shared/validate_update" }

    end
    end
  end

  def destroy

    @user = current_firm.users.find(params[:id])
    # authorize! :manage, @user
     respond_to do |format|
    if @user == current_user
    flash[:notice] = flash_helper((t'activerecord.flash.you_are_logged_in_as') + ' ' + @user.name + (t'activerecord.flash.you_cannot_delete_yourself'))
      format.js
    else
    @user.destroy
   		flash[:notice] = flash_helper(@user.name + ' ' + (t'activerecord.flash.deleted'))
      format.html { redirect_to(users_url()) }
      format.xml  { head :ok }
      format.js
    end
    end
  end
end
