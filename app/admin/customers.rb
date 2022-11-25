ActiveAdmin.register Customer do
  controller do
    def permitted_params
      params.permit customer: [:name,:phone,:email,:address,:created_at,:updated_at, :firm]
    end
    def scoped_collection
      Customer.includes(:firm)
    end
   end
  menu :priority => 5
  config.batch_actions = true
  index do
    selectable_column                            
    column "Firm", :sortable => :firm_id do |customer|
      link_to customer.firm.name, obeqaslksdssdfnfdfysdfxm_customer_path(customer.firm)
    end                     
    column :name                     
    column :email                     
            
    actions                   
  end                                 
  
  filter :email 
  filter :name 
end
