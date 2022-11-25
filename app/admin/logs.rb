ActiveAdmin.register Log do
  controller do
    def permitted_params
      params.permit log: [:event,:customer_id,:user_id,:project_id,:employee_id,:todo_id,:tracking,:begin_time,:end_time,:log_date,
      :hours,:project,:customer,:user,:todo, :firm]
    end
  end 
  menu :priority => 6
  config.batch_actions = true
  index do
    selectable_column
    column :event 
    column "Firm", :sortable => :firm_id do |log|
      link_to log.firm.name, obeqaslksdssdfnfdfysdfxm_firm_path(log.firm)
    end
    column "Project", :sortable => :project_id do |log|
      if log.project
        link_to log.project.name, obeqaslksdssdfnfdfysdfxm_project_path(log.project)
      end
    end
    column "User", :sortable => :user_id do |log|
      link_to log.user.name, obeqaslksdssdfnfdfysdfxm_user_path(log.user)
    end
    column "Customer", :sortable => :customer_id do |log|
      if log.customer
        link_to log.customer.name, obeqaslksdssdfnfdfysdfxm_customer_path(log.customer)
      end
    end
    actions 
  end
  filter :event
  filter :project
  filter :firm
  filter :user
  filter :customer
  form do |f|
      f.inputs "Details" do
        f.input :firm
        f.input :user
        f.input :customer
        f.input :project
        f.input :todo
        f.input :event 
        f.input :log_date
        f.input :hours
      end
      f.actions
    end
  
end
