ActiveAdmin.register Subscription do
  controller do
    def permitted_params
      params.permit subscription: [:plan_id,:email,:firm,:paymill_id,:users, :name, :last_four, :card_type, :next_bill_on, :card_expiration, :card_holder, :active]
    end
  end
  config.batch_actions = true
  index do
    selectable_column
    # column "Name", :sortable => :name do |todo|
    #   link_to firm.name, obeqaslksdssdfnfdfysdfxm_firm_path(firm)
    # end
    column :firm
    column :plan
    column :email
    column :name
    column :last_four
    column :card_type
    column :next_bill_on
    column :card_expiration
    column :card_holder
    column :active
    column :created_at
    column :updated_at
    actions

  end
  filter :name
  filter :email
  filter :next_bill_on
  
end
