require 'subdomain'
Rails.application.routes.draw do
  # devise_for :admin_users, ActiveAdmin::Devise.config
  resources :blogs
  get "/termsofservice" => "public#termsofservice",  :as => :termsofservice
  get "/privacy_policy" => "public#privacy_policy",  :as => :privacy_policy
  get "/pricing" => "public#pricing",  :as => :pricing
  get "/index" => "public#index",  :as => :index

  resources :guides
  post "hooks/receiver"
    resources :firms
    post "public/create_firm" => "public#create_firm", :as => :create_firm
    resources :public do
      member do
        get "first_user"
        post "create_first_user"
     end
  end
  ActiveAdmin.routes(self)
  get '/obeqaslksdssdfnfdfysdfxm/dashboard/subscription_chart_data' =>  'obeqaslksdssdfnfdfysdfxm/dashboard#subscription_chart_data'
  get '/obeqaslksdssdfnfdfysdfxm/dashboard/firms_chart_data' =>  'obeqaslksdssdfnfdfysdfxm/dashboard#firms_chart_data'
  get '/obeqaslksdssdfnfdfysdfxm/dashboard/firms_resources_chart_data' =>  'obeqaslksdssdfnfdfysdfxm/dashboard#firms_resources_chart_data'
  get '/obeqaslksdssdfnfdfysdfxm/dashboard/new_firms_count_chart_data' =>  'obeqaslksdssdfnfdfysdfxm/dashboard#new_firms_count_chart_data'


  devise_for  :users,
              :path_names => { :sign_up => "register" },
              :controllers => {
              :sessions => "sessions",
              :passwords => "passwords",
              :registrations => "users"
             }

  devise_scope :user do
  	get "/sign_in", :to => "sessions#new"
    delete "/sign_out", :to => "sessions#destroy"
    get "register", :to => "public#register"
  	get "contact", :to => "public#contact"
    get "/sign_in_at_subdomain" =>  "sessions#sign_in_at_subdomain", :as => :sign_in_at_subdomain
  	get "/register/:firm_id/user" => "public#first_user",  :as => :register_user
  	post "/register/:firm_id/user" => "public#create_first_user",  :as => :create_first_user
  	get "/validates_uniqe/:subdomain" => "public#validates_uniqe", :as => :validates_uniqe
    get '/users/password/edit' =>  'devise/passwords#edit', :as => :edit_password
  end




  constraints(Subdomain) do
    post 'emails/create/:id' => 'emails#create', as: :emails
    get 'emails/:id/new' => 'emails#new', as: :new_email
    get 'emails/:id/reminder' => 'emails#reminder', as: :reminder_email
    post 'emails/reminder_create/:id' => 'emails#reminder_create', as: :reminder_create
    get "/emails/quick_send/:id" => "emails#quick_send", :as => :quick_send
    get "plans" => 'plans#index', :as => :plans
    # delete "plans/index", :as => :plans_delete
    get "plans/cancel", :as => :plans_cancel
    resources :subscriptions
    get "payments" => 'payments#index', :as => :payments
    get "payments/:id" => 'payments#show', :as => :payment
    get "payments/download_pdf/:id" => 'payments#download_pdf', :as => :download_pdf
    constraints(PaymentChecker) do
      # devise_for  :users
      resources :users, :only => [:index, :show, :edit, :create, :update, :destroy] do
        member do
         get :valid
        end
      end
      #chart_controller
      get "charts" => "charts#index", :as => :charts
      get "users_logs" => "charts#users_logs",  :as => :users_logs
      get "project_users_logs" => "charts#project_users_logs",  :as => :project_users_logs
      get "project_todos_logs" => "charts#project_todos_logs",  :as => :project_todos_logs
      # get "customer_users_logs" => "charts#customer_users_logs",  :as => :customer_users_logs
      # get "customer_todos_logs" => "charts#customer_todos_logs",  :as => :customer_todos_logs
      get "projects_logs" => "charts#projects_logs",  :as => :projects_logs
      get "customers_logs" => "charts#customers_logs",  :as => :customers_logs
      get "dashboard_json" => "charts#dashboard_json",  :as => :dashboard_json
      get "statistics" => "charts#statistics",  :as => :statistics
      get "economicstatistics_json" => "charts#economicstatistics_json",  :as => :economicstatistics_json
      #projects_controller
      get "/archive" => "projects#archive",  :as => :archive
      put "projects/update_index/:id" => "projects#update_index",  :as => :update_index
      post "projects/create_index/" => "projects#create_index",  :as => :create_index
      post "/activate_projects/:id" => "projects#activate_projects", :as => :activate_projects
      #tabs_controller
      get "/:class/:id/state"       => "tabs#state", :as => :tabs_state
      get "/:class/:id/tasks"       => "tabs#todos", :as => :tabs_todos
      get "/:class/:id/milestones"  => "tabs#milestones", :as => :tabs_milestones
      get "/:class/:id/projects"    => "tabs#projects", :as => :tabs_projects
      get "/:class/:id/employees/"  => "tabs#employees", :as => :tabs_employees
      get "/:class/:id/logs"        => "tabs#logs", :as => :tabs_logs
      get "/:class/:id/users"       => "tabs#users", :as => :tabs_users
      get "/:class/:id/statistics"  => "tabs#statistics", :as => :tabs_statistics
      get "/:class/:id/spendings"   => "tabs#spendings", :as => :tabs_spendings
      get "/:class/:id/invoices"    => "tabs#invoices", :as => :tabs_invoices
      #logs_controller
      post "logs/start_tracking" => "logs#start_tracking",  :as => :start_tracking
      patch "logs/stop_tracking/:id" => "logs#stop_tracking",  :as => :stop_tracking
      get "/get_logs_todo/:todo_id" => "logs#get_logs_todo", :as => :get_logs_todo
      #select_controller
      get "/project_select/:project_id/:log_id" => "select#project_select"
      get "/project_select/:project_id/" => "select#project_select"

      get "/customer_select/:customer_id/:log_id" => "select#customer_select"
      get "/customer_select/:customer_id/" => "select#customer_select"
      get "/todo_select/:todo_id/:log_id" => "select#todo_select"
      get "/todo_select/:todo_id/" => "select#todo_select"
      post "/customer_select_tracking/:customer_id/:log_id" => "select#customer_select_tracking"
      post "/customer_select_tracking/:customer_id/" => "select#customer_select_tracking"

      post "/employee_select_tracking/:employee_id/:log_id" => "select#employee_select_tracking"
      post "/employee_select_tracking/:employee_id/" => "select#employee_select_tracking"

      post "/project_select_tracking/:project_id/:log_id" => "select#project_select_tracking"
      post "/project_select_tracking/:project_id/" => "select#project_select_tracking"

      post "/todo_select_tracking/:todo_id/:log_id" => "select#todo_select_tracking"
      post "/todo_select_tracking/:todo_id/" => "select#todo_select_tracking"

      #timesheets_controller
      get "/timesheetWeek"   => "timesheets#timesheet_week"
      get "/timesheetMonth"  => "timesheets#timesheet_month"

      get "/:class/:id/timesheet_day/:date"   => 'timesheets#timesheet_day',   :as => :timesheet_day
      get "/:class/:id/timesheet_week/:date"   => 'timesheets#timesheet_week',   :as => :timesheet_week
      get "/:class/:id/timesheet_month/:date"  => "timesheets#timesheet_month",  :as => :timesheet_month

      post "/add_hour_to_project/" => 'timesheets#add_hour_to_project', :as => :add_hour_to_projects
      post "/add_log_timesheet" => 'timesheets#add_log_timesheet', :as => :add_log_timesheet
      #reports_controller
      get "/reports" => 'reports#index', :as => :reports
      get "/squadlink_report" => 'reports#squadlink_report', :as => :squadlink_report
      get "/dashboard" => 'reports#dashboard', as: :dashboard
      #memberships_controller
      post "/membership/:id/:project_id" => "memberships#index", :as => :membership
      #firms_controller
      put "/firm_update" => "firms#firm_update",  :as => :firm_update
      get "/account" => "firms#firm_show",  :as => :firm_show
      #roster
      get "/roster_milestone" => "roster#get_milestones", :as => :roster_milestone
      get "/roster_task" => "roster#get_tasks", :as => :roster_task
      #timerange
      # get "/logs_pr_date/:time/:url" => "timerange#logs_pr_date", :as => :logs_pr_date
      # match "/logs_pr_date" => "timerange#logs_pr_date", :as => :logs_pr_date
      get "/log_range/" => "timerange#log_range", :as => :log_range
      get "/todo_range/" => "timerange#todo_range", :as => :todo_range
      get "/invoice_range/" => "timerange#invoice_range", :as => :invoice_range
      # get "/todos_pr_date/:time/:url/:id" => "timerange#todos_pr_date", :as => :todos_pr_date
      #invoices
      get "/invoices/customer_select/" => "invoices#customer_select"
      get "/invoices/project_select/" => "invoices#project_select"
      post "/invoices/customers_create/" => "invoices#customers_create"
      post "/invoices/projects_create/" => "invoices#projects_create"
      get "/invoices/:id/slow_sending/" => "invoices#slow_sending"
      get "/invoices/:id/credit_note/" => "invoices#credit_note"
      post "/invoices/:id/credit_note_create/" => "invoices#credit_note_create", :as => :credit_note_create

      # post "/jobs/sending_invoice/" => "jobs#sending_invoice", :as => :sending_invoice
      post "/jobs/handeling_invoice/" => "jobs#handeling_invoice", :as => :handeling_invoice

      get "/jobs/download/:id" => "jobs#download", :as => :download
      post "/jobs/invoice_paid/:id" => "jobs#invoice_paid", :as => :invoice_paid
      post "/jobs/invoice_lost/:id" => "jobs#invoice_lost", :as => :invoice_lost
      patch "/jobs/create_slow_sending/:id" => "jobs#create_slow_sending", :as => :create_slow_sending
      get "/jobs/fetch_job/" => "jobs#fetch_job", :as => :fetch_job
      get "/jobs/ajax_download/" => "jobs#ajax_download", :as => :ajax_download
      get "/jobs/ajax_sending/" => "jobs#ajax_sending", :as => :ajax_sending
      get "/jobs/time_out/" => "jobs#time_out", :as => :time_out
      get "jobs/download_invoice/:id" => "jobs#download_invoice", :as => :download_invoice
      get "jobs/show_pdf/:id" => "jobs#show_pdf", :as => :show_pdf
      get "/invoice_pdf/:id" => "pdf#invoice", :as => :invoice_pdf
      resources :invoices
      resources :customers
      resources :employees
      resources :projects
      resources :milestones
      resources :todos
      resources :logs
      get "*/", :to  => "logs#index"
    end
    get "/", :to  => "plans#index"
	end
  root :to => "public#index"
end
