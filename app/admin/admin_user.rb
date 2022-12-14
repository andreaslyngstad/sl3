ActiveAdmin.register AdminUser do 
  controller do
    def permitted_params
      params.permit admin_user: [:email,:password,:password_confirmation]
    end
  end   
   menu :priority => 10
  config.batch_actions = true
  index do
    selectable_column                           
    column :email                     
    column :current_sign_in_at        
    column :last_sign_in_at           
    column :sign_in_count             
    actions                   
  end                                 

  filter :email                       

  form do |f|                         
    f.inputs "Admin Details" do       
      f.input :email                  
      f.input :password               
      f.input :password_confirmation  
    end                               
    f.actions                         
  end                                 
end                                   
