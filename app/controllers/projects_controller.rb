class ProjectsController < ApplicationController

  def index
      @project = current_firm.projects.new
    if current_user.role == "external_user"
      @projects = current_user.projects.includes(:firm)
    else
      @projects = current_firm.projects.where(:active => true).includes(:firm).order_by_name
    end
  end
  
  def edit
    @project = Project.find(params[:id]) 
    # authorize! :manage, @project
    @customers = current_firm.customers
    respond_to do |format|
        format.js
    end
  end
  

  def show
    @klass = current_firm.projects.find(params[:id]) 
    # authorize! :manage, @klass
    redirect_to(tabs_state_path(string_for_klass(@klass),@klass.id))
  end

  def create
    
    @klass = current_firm.projects.new(permitted_params.project)
    @project = current_firm.projects.new
    @klass.active = true
    @klass.users << current_user
    # authorize! :manage, @klass
    respond_to do |format|
      if @klass.save
        flash[:notice] = flash_helper((t'activerecord.models.project.one').capitalize + ' ' + (t'activerecord.flash.saved'))
        format.js
      else
        format.js { render "shared/validate_create" }
      end
    end
    
  end
  
  def update
    @klass = Project.find(params[:id])
    @klass.firm = current_firm
    respond_to do |format|
      if @klass.update_attributes(permitted_params.project)
        flash[:notice] = flash_helper("#{@klass.name}" + ' ' + (t'activerecord.flash.saved'))
        format.js
      else
        format.js { render "shared/validate_update" }
       
      end
    end
    
  end
  
  def destroy
    # authorize! :archive, Firm
   @klass = Project.find(params[:id])
   
   @klass.destroy
    respond_to do |format|
      flash[:notice] = flash_helper((t'activerecord.models.project.one').capitalize + ' ' + (t'activerecord.flash.deleted'))
      format.js
    end
  end
  
  def archive 
    @projects = current_firm.projects.where(:active => false).order("name ASC")  
  end
  
  def activate_projects
    @project = Project.find(params[:id])
    # authorize! :archive,  @project
      if @project.active == true
        @project.active = false
        flash[:notice] = flash_helper("#{@project.name}" + ' ' + (t'general.is_not_active'))
      else
        @project.active = true
        flash[:notice] = flash_helper("#{@project.name}" +' ' + (t'general.is_active'))
      end  
    
    respond_to do |format|
      if @project.save
      format.js
      end
      end
  end
 
end
