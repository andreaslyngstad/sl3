class Firm < ActiveRecord::Base
	 # attr_accessible :logo_file_name, :name,:subdomain,:address,:phone, :currency, :time_zone,
	 #
	 #      :language,
	 #  	  :logo,
	 #  	  :logo_content_type,
	 #      :logo_file_size,
	 #      :logo_updated_at,
	 #   	  :background,
	 #   	  :color,
	 #   	  :subscription_id,
	 #   	  :plan,
	 #   	  :time_format,
	 #   	  :date_format,
	 #   	  :clock_format,
	 #   	  :closed


  before_create :add_free_subscription
  has_many :customers, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :todos, :dependent => :destroy
  has_many :logs, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :milestones, :dependent => :destroy
  has_many :emails, :dependent => :destroy
  has_many :payments
  has_many :employees
  has_many :invoices, :dependent => :destroy
  has_one :subscription, :dependent => :destroy
  belongs_to :plan, counter_cache: true


  # has_attached_file :logo, :styles => { :original => "200x100#", :small => "150x75#"},
  #                 :url  => "/system/logos/:id/:style/:basename.:extension",
  #                 :path => ":rails_root/public/system/logos/:id/:style/:basename.:extension"
  # validates_attachment_size :logo, :less_than => 1.megabytes
  # validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/png']

  validates_presence_of :name
  validates_presence_of :tax
  validates_numericality_of :tax
  validates_format_of :subdomain, :with => /\A[a-z0-9]+\z/i
  validates :subdomain, :presence => true, :uniqueness => true,  :subdomain_exclutions => :true

  scope :recent, -> {order('created_at DESC').limit(10)}

  def add_free_subscription
    free_plan = Plan.where(name:"Free").first
    if free_plan
      self.subscription = Subscription.create(plan_id: free_plan.id)
      self.plan = free_plan
    else
      free_plan2 = Plan.create name: "Free", price: 0, customers: 2, logs: 100, projects: 2, users:2, currency: "$", paymill_id: "free"
      self.subscription = Subscription.create(plan_id: free_plan2.id)
      self.plan = free_plan2
    end
  end

  def update_plan(sub)
    self.plan_id = sub
    save
  end

  def did_sign_in
    self.last_sign_in_at = Date.current
    save
  end

  def remove_associations_when_downgrading(plan_id)
    plan = Plan.find(plan_id)
    subscription.plan = plan
    plan_ass = {users: plan.users, projects: plan.projects, customers: plan.customers}
    firm_ass = {users: users_count, projects: projects_count, customers: customers_count}
    diff_hash = HashHandeling.new.values_difference(firm_ass, plan_ass)
    remove_associations(diff_hash)
    update_firm_counters
  end

  def remove_associations(diff_hash)
    diff_hash.each do |k,v|
      if v < 0
       send(k).order('created_at DESC').limit(v.abs).destroy_all
      end
    end
  end

  def delete_old_subscription
    self.subscription.delete
  end

  def update_firm_counters
    self.users_count = users.count
    self.customers_count = customers.count
    self.projects_count = projects.count
    self.invoices_count = invoices.count
    save
  end

  def payment_check?
    self.subscription.next_bill_on < DateTime.now
  end
  def revert_to_free_no_payment
    free_plan = Plan.where(name: "Free").first
    remove_associations_when_downgrading(free_plan.id)
    # subscription.plan_id = free_plan.id
    # subscription.save
  end
  def self.count_by_plan
    group(:plan).count
  end
  def close!
    self.closed = true
    save
  end
  def open!
    self.closed = false
    save
  end
end
