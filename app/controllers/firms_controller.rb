class FirmsController < ApplicationController
  def firm_show
    # authorize! :read, Firm
  end

  def firm_update
    @firm = current_firm
    respond_to do |format|
      if @firm.update(permitted_params.firm)
        flash[:notice] = flash_helper( (t'general.your_firm') + ' ' + (t'activerecord.flash.saved'))
        format.html { redirect_to firm_show_path }
      else
        flash[:error] = (t'general.your_firm') + ' ' + (t'activerecord.flash.could_not_save')
        format.html { render :action => "firm_show" }
      end
    end
  end

  def destroy
    # authorize! :manage, Firm
    @firm = Firm.find(params[:id])
    @firm.destroy
    flash[:notice] = "Your firm and all data are deleted from our servers. You are always welcome back. Thanks!"
    redirect_to(root_url(:subdomain => nil))
  end
end
