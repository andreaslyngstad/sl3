class PermittedParams < Struct.new(:params, :current_user)
  def project
    params.require(:project).permit(*project_attributes)
  end
  def project_attributes
    if current_user
      [:name,:description,:active,:budget,:hour_price,:customer_id,:created_at,:updated_at,:customer]
    end
  end

  def todo
    params.require(:todo).permit(*todo_attributes)
  end
  def todo_attributes
    if current_user
      [:name,:user_id,:project_id,:customer_id,
   :due,:completed,:created_at,:updated_at,:project,:customer,:user,:done_by_user,:done_by_user_id,:prior,:firm]
    end
  end

  def milestone
    params.require(:milestone).permit(*milestone_attributes)
  end
  def milestone_attributes
    if current_user
      [:goal,:due,:completed,:project_id,:created_at,:updated_at, :project,:firm]
    end
  end
  def email
    params.require(:email).permit(*email_attributes)
  end
  def email_attributes
    if current_user
      [ :address,:subject, :content,:invoice_id, :firm_id, :sent,:status, 
      invoice_attributes: [:date, :due, :reminder_fee, :status, :id]]
    end
  end
  def customer
    params.require(:customer).permit(*customer_attributes)
  end
  def customer_attributes
    if current_user
      [:name,:phone,:email,:address,:created_at,:updated_at, :firm]
    end
  end
  def employee
    params.require(:employee).permit(*employee_attributes)
  end
  def employee_attributes
    if current_user
      [:name,:phone,:email,:customer_id,:created_at,:updated_at,:customer,:firm]
    end
  end
  def firm
    params.require(:firm).permit(*firm_attributes)
  end
  def firm_attributes
  	  
    if current_user
      [:subscription_id,
        :plan, 
        :tax, 
        :name,
        :subdomain,
        :address,
        :phone, 
        :currency, 
        :time_zone, 
        :language,
        :time_format,
        :date_format,
        :days_to_due,
        :clock_format,
        :closed,
        :invoice_email, 
        :invoice_email_subject, 
        :invoice_email_message,
        :reminder_email_subject, 
        :reminder_email_message, 
        :on_reminder_message,
        :reminder_fee,
        :starting_invoice_number,
        :logo,
        :bank_account,
        :vat_number,
        :on_invoice_message
      ]
    else
      [:name,:subdomain,:address, :tax, :phone, :currency, :bank_account,
        :vat_number,:time_zone, :language,:time_format,:date_format,:clock_format,:closed]
    end
  end
  def plan
    params.require(:plan).permit(*plan_attributes)
  end
  def plan_attributes
    if current_user
      [:name, :price,:customers, :logs, :projects, :users, :invoices, :paymill_id, :currency]
    end
  end
  def user
    params.require(:user).permit(*user_attributes)
  end
  def user_attributes
    if current_user
      [:role,:phone,:name,:hourly_rate,:avatar, :email,:password, :password_confirmation, :remember_me]
    else
      [:phone, :name, :email, :remember_me,:password, :password_confirmation, :role, :firm_id, :firm]
    end
  end
  def first_user
    params.require(:user).permit(*first_user_attributes)
  end
  def first_user_attributes
      [:phone, :name, :email, :remember_me,:password, :hourly_rate, :password_confirmation, :role, :firm_id, :firm, :user]
  end
  def log
    params.require(:log).permit(*log_attributes)
  end
  def log_attributes
    if current_user
      [:event,:customer_id,:user_id,:project_id,:employee_id,:todo_id,:tracking,:begin_time,:end_time,:log_date,:invoice_id,:credit_note_id,
	 :hours,:project,:customer,:user,:todo, :rate, :firm, :log_attributes]
    end
  end
  def subscription
    params.require(:subscription).permit(*subscription_attributes)
  end
  
  def subscription_attributes
    if current_user
      [:name, :email, :card_type, :paymill_id, :active,:paymill_card_token, :plan_id,:firm_id, :plan,:card_expiration , :card_zip,:firm, :last_four, :next_bill_on, :card_holder]
    end
  end
  def payment
    params.require(:payment).permit(*payment_attributes)
  end
  def payment_attributes
    if current_user
      [:card_type, :firm_id, :amount, :plan_name, :last_four]
    end
  end 

  def guides_category
    params.require(:guides_category).permit(*guides_category_attributes)
  end
  def guides_category_attributes
    if current_user
      [:title]
    end
  end
  
  def guides
    params.require(:guides).permit(*guides_attributes)
  end
  def guides_attributes
    if current_user
      [:content, :title, :guides_category_id]
    end
  end
  def blog
    params.require(:blog).permit(*blog_attributes)
  end
  def blog_attributes
    if current_user
      [:content, :title, :author]
    end
  end
  def invoice
    params.require(:invoice).permit(*invoice_attributes)
  end
  def invoice_attributes
    if current_user
      [:number,:content,:project_id, :invoice_receivable, :mail_to, :mail_subject, :mail_content, :customer_id,:firm_id, :paid, :reminder_sent, :reminder_fee, :due, :status, :date, :total, :invoice_id,
        logs_attributes: [:tax],
      invoice_lines_attributes: [:_destroy, :description, :quantity, :price, :tax, :id]
      ]
    end
  end
  def invoice_send
    params.require(:invoice).permit(*invoice_send_attributes)
  end
  def invoice_send_attributes
    if current_user
      [ :mail_to, :mail_subject, :mail_content,  :due, :status
      
      ]
    end
  end
end

 