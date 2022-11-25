ActiveAdmin.register Project do
  controller do
    def permitted_params
      params.permit project: [:name,:description,:active,:budget,:hour_price,:customer_id,:created_at,:updated_at,:customer]
    end
  end 
  menu :priority => 7
  config.batch_actions = true
  index do
    selectable_column
    column "Name", :sortable => :name do |todo|
      link_to todo.name, obeqaslksdssdfnfdfysdfxm_todo_path(todo)
    end
    column :active
    column :budget
    column :hour_price
    column :created_at
    actions
  end
  filter :name
  filter :firm
  filter :project
  filter :customer
  filter :due
  filter :budget
  filter :hour_price
  filter :created_at
end
