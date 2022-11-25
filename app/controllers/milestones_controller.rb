class MilestonesController < ApplicationController
  def create
    @milestone = current_firm.milestones.new(permitted_params.milestone)
    respond_to do |format|
      if @milestone.save
        flash[:notice] = flash_helper((t'activerecord.models.milestone.one').capitalize + ' ' + (t'activerecord.flash.saved'))
        format.js { render :action => "create_success"}
        else
        format.js { render :action => "failure"}
      end
     end
  end
  
  def update
    @milestone = current_firm.milestones.find(params[:id])
    if @milestone.update_attributes(permitted_params.milestone)
      flash[:notice] = flash_helper((t'activerecord.models.milestone.one').capitalize + ' ' + (t'activerecord.flash.saved'))
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @milestone = current_firm.milestones.find(params[:id])
    @milestone.destroy   
    respond_to do |format|
      flash[:notice] = flash_helper((t'activerecord.models.milestone.one').capitalize + ' ' + (t'activerecord.flash.deleted'))
      format.js
    end
  end
end
