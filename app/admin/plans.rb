ActiveAdmin.register Plan do
  controller do
    def permitted_params
      params.permit plan: [:paymill_id,:name,:price,:customers,:logs, :projects, :invoices,:users, :currency]
    end
  end
  menu :priority => 3
 config.batch_actions = true
  index do
    selectable_column
    column "Name", :sortable => :name do |plan|
      link_to plan.name, obeqaslksdssdfnfdfysdfxm_plan_path(plan)
    end
    column "Firms", :sortable => :firms_count  do |plan|
      link_to plan.firms_count, firms_obeqaslksdssdfnfdfysdfxm_plan_path(plan)
    end
    column :price
    column :customers
    column :projects
    column :users
    column :invoices
    column :paymill_id
    column :currency
    actions 
  end
  filter :name
  
  member_action :firms do
    @plan = Plan.find(params[:id])
  end
  form do |f|
    f.inputs "Details" do
      f.input :name,:as => :string
      f.input :price 
      f.input :logs
      f.input :customers
      f.input :projects
      f.input :users
      f.input :invoices
      f.input :currency
      f.input :paymill_id,:as => :string
        end
      f.actions
    end
end