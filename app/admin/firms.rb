ActiveAdmin.register Firm do
   controller do
    def permitted_params
      params.permit firm: [:subscription_id,:plan_id, :name,:subdomain,:address,:phone, :currency, :time_zone, :language,:time_format,:date_format,:clock_format,:closed]
    end
     def scoped_collection
       Firm.includes(:subscription, {:subscription => :plan})
     end
   end
  menu :priority => 2
  
  scope :all, :default => true
  # scope :free
  # scope :bronze
  # scope :silver
  # scope :gold
  # scope :platinum

  config.batch_actions = true
  index do
    selectable_column
    
    column "Name", :sortable => :name do |firm|
      link_to firm.name, obeqaslksdssdfnfdfysdfxm_firm_path(firm)
    end
    column "Plan", :sortable => :plan_id do |firm|
      firm.plan.name
    end
    column "Subscription", :sortable => :plan_id do |firm|
      link_to firm.subscription.id, obeqaslksdssdfnfdfysdfxm_subscription_path(firm.subscription)
    end
    column "Customers", :sortable => :customers_count  do |firm|
      link_to firm.customers_count, customers_obeqaslksdssdfnfdfysdfxm_firm_path(firm)
    end
    column "Projects", :sortable => :projects_count do |firm|
      link_to firm.projects_count, projects_obeqaslksdssdfnfdfysdfxm_firm_path(firm)
    end
    column "Users", :sortable => :users_count  do |firm|
      link_to firm.users_count, users_obeqaslksdssdfnfdfysdfxm_firm_path(firm)
    end
    
    column "Logs", :sortable => :logs_count do |firm|
      link_to firm.logs_count, logs_obeqaslksdssdfnfdfysdfxm_firm_path(firm)
    end
  
    column "created_at", :sortable => :created_at do |firm|
      firm.created_at.try(:strftime, "%d.%m.%Y")
    end
     column "Last sign in", :sortable => :last_sign_in_at do |firm|
      firm.last_sign_in_at.try(:strftime, "%d.%m.%Y")
    end
    actions 
  end
  filter :name 
  filter :subdomain
  filter :plan
  filter :created_at
  
  
  
  member_action :customers do
    @firm = Firm.find(params[:id])
  end
  member_action :users do
    @firm = Firm.find(params[:id])
  end
  member_action :projects do
    @firm = Firm.find(params[:id])
  end
  member_action :logs do
    @firm = Firm.find(params[:id])
  end
  form do |f|
    f.inputs "Details" do
      f.input :plan,:as => :select, :collection => Plan.all
      f.input :name,:as => :string
      f.input :subdomain ,:as => :string
      f.input :address,:as => :string
      f.input :phone,:as => :string
      f.input :currency,:as => :string
      f.input :time_zone,:as => :string
      f.input :language,:as => :string
      f.input :closed, :as => :boolean
        end
       f.actions
    end

end
