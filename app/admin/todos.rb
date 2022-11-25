ActiveAdmin.register Todo do
  controller do
    def permitted_params
      params.permit todo: [:name,:user_id,:project_id,:customer_id,
   :due,:completed,:created_at,:updated_at,:project,:customer,:user,:done_by_user,:done_by_user_id,:prior,:firm]
    end
  end 
  menu :priority => 8
   config.batch_actions = true
  index do
    selectable_column
    column "Name", :sortable => :name do |todo|
      link_to todo.name, obeqaslksdssdfnfdfysdfxm_todo_path(todo)
    end
    column :due
    column :completed
    column :prior
   actions 
    
  end
  filter :name
  filter :project
  filter :firm
  filter :user
  filter :customer
end
