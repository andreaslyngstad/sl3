require "validator"
class Invoice < ActiveRecord::Base
	include ActiveModel::Validations

	include ActionView::Helpers::TagHelper
	validates_with Validator
  validates_with MadeWithInLimit, on: :create
  # validates_with Validator
	belongs_to :project, :counter_cache => true
	belongs_to :customer, :counter_cache => true
	belongs_to :firm, :counter_cache => true
	has_many 	 :credit_notes, class_name: "Invoice", foreign_key: "invoice_id"
	has_many 	 :reminders, class_name: "Invoice", foreign_key: "reminder_on_id"
	belongs_to :reminder_on, class_name: "Invoice"
	belongs_to :invoice, class_name: "Invoice"
	has_many 	 :logs
	has_many 	 :credit_logs, class_name: "Log", foreign_key: 'credit_note_id'
	has_many	 :invoice_lines, dependent: :destroy
	has_many	 :emails

	before_create :total_to_receivable
	before_create :due_to_last_due
	before_update :due_to_last_due
	validates_presence_of :customer_id
	accepts_nested_attributes_for :invoice_lines, allow_destroy: true

	scope :order_by_number, -> {order("number DESC")}
	scope :order_by_date, -> {order('date DESC')}
	scope :with_number, -> (firm) {firm.invoices.where('number IS NOT NULL').order("number ASC")}

	validate :validates_presence_of_legal_attributes
	validate :credit_note_less_than_invoice

	def create_reminder(params)

		reminder 							= reminders.new
		reminder.reminder_fee = params[:reminder_fee]
		reminder.date 				= params[:date]
		reminder.due 					= params[:due]
		reminder.content 			= firm.on_reminder_message
		reminder.customer 		= customer
		reminder.firm 				= firm
		reminder.status 			= 10
		reminder.total 				= receivable + reminder.reminder_fee
		set_status_to_reminded(params[:reminder_fee])
		reminder.save
		reminder
	end

	def set_status_to_reminded(reminder_fee)
		self.receivable = self.receivable + reminder_fee.to_f
		self.reminder_sent = Date.current
		self.status = 5
		save
	end

	def self.last_with_number(firm)
		with_number(firm).last
	end
	def validates_presence_of_legal_attributes
    errors.add(:base, (I18n.translate"errors.messages.validates_presence_of_legal_attributes")) if
    if !number.blank?
      firm.bank_account.blank? or firm.vat_number.blank?
    end
  end

  def credit_note_less_than_invoice
  	if status != 8 or status != 5
	  	errors.add(:base, (I18n.translate"errors.messages.credit_note_less_than_invoice")) if
	  		if invoice
	  		invoice.receivable.abs < total.abs
	  	end
  	end
  end
  def due_today_or_overdue
  	if status == 2
  		if due.to_date == Date.current and status != 3
		  	self.status = 3
		  	self.save
	  	end
	  	if due.to_date < Date.current and status != 4
	  		self.status = 4
	  		self.save
	  	end
  	end
  end

  def paid!
  	if self.paid.nil?
  		self.paid_amount = self.receivable
  		self.paid = Date.current
  		self.status = 6
  		self.receivable = 0.0
  	else
	  	self.paid = nil
	  	self.paid_amount = nil
	  	if !reminders.empty? and credit_notes.empty?
	  		self.status = 5
	  	elsif !credit_notes.empty?
	  		self.status = 7
	  	else
	  		self.status = 2
	  	end
	  	self.receivable = sum_credit_notes_and_reminders + self.total
  	end
  	save
  end

  def lost!
  	if self.lost.nil?
  		self.lost = self.receivable
  		self.status = 11
  		self.receivable = 0.0
  	else
	  	self.lost = nil
	  	if !reminders.empty? and credit_notes.empty?
	  		self.status = 5
	  	elsif !credit_notes.empty?
	  		self.status = 7
	  	else
	  		self.status = 2
	  	end
	  	self.receivable = sum_credit_notes_and_reminders + self.total
  	end
  	save
  end
  def sum_credit_notes_and_reminders
  	self.credit_notes.sum(:total) + self.reminders.sum(:reminder_fee) || 0
  end

	def set_status_and_currency(current_firm)
		self.status = 1
		self.currency = current_firm.currency
	end

	def customer_all
		firm.customers.unscoped.where(id: customer_id).first
	end

	def status_string
		case status
			when 1
				["black", I18n.translate('economic.invoice_draft')]
	  	when 2
	  		["black", I18n.translate('economic.invoice_sent')]
	  	when 3
	  		["orange", I18n.translate('economic.invoice_due')]
	  	when 4
	  		["red", I18n.translate('economic.invoice_overdue')]
	  	when 5
	  		["orange", I18n.translate('economic.invoice_reminded')]
	  	when 6
	  		["green", I18n.translate('economic.invoice_paid')]
	  	when 7
	  	  ["grey", I18n.translate('economic.invoice_credit')]
	  	when 8
	  		["grey", I18n.translate('economic.credit_note').capitalize]
	  	when 9
	  		["red", I18n.translate('economic.send_error').capitalize]
	  	when 10
	  		['black', I18n.translate('economic.email_reminder')]
	  	when 11
	  		['red', I18n.translate('economic.invoice_lost').capitalize]

		end
	end

	def set_status_when_sending
		if status == 1 or status == 9
			self.status = 2
		end
	end

	def number_string
		if number.nil?
			I18n.translate('economic.invoice_no_number')
		else
			number
		end
	end
	def to_pdf
	  host        = Rails.env.production? ? 'squadlink.com' : 'lvh.me:3000'
	  protocol		= Rails.env.production? ? 'https' : 'http'
	  url         = Rails.application.routes.url_helpers.show_pdf_url(:id => id, :host => host, :subdomain => firm.subdomain, :protocol => protocol)
	  cookie      = { SECRETS_CONFIG[Rails.env][:phantomjs_secret_token] => firm.users.first.id } # must be admin user

	  if status == 10
	  	res = Shrimp::Phantom.new(url, {}, cookie)
	  	res.to_pdf("#{Rails.root}/tmp/shrimp/#{I18n.translate('economic.email_reminder').downcase}_#{firm.subdomain}_#{self.reminder_on.number}.pdf")
	  	error = res.error
	  else
	  	res = Shrimp::Phantom.new(url, {}, cookie)
			res.to_pdf("#{Rails.root}/tmp/shrimp/#{firm.subdomain}_#{self.number}.pdf")
	  	error = res.error
	  end

	  puts(url)
	  puts('=============================================================================')
	  puts(error)
	  puts('=============================================================================')
	end


  # def invoice(id)
  #   # @invoice = current_firm.invoices.find(id)
  #   # @user = User.find(id)
  #   phantom = Shrimp::Phantom.new('http://lizz.lvh.me:3000/show_pdf/1', {}, {user_session:id})
  #   puts("test " + phantom.source.to_s)
  #   pdf = phantom.to_pdf
  #   puts(phantom.error)
  #   attachments['faktura.pdf'] = File.read(pdf)
  #   invoice_mail = mail to:"andreaslyngstad@gmail.com", subject: 'Squadlink sign up confirmation.'
  #   invoice_mail.deliver

  #   File.delete(pdf)
  # end
	def tax_lines
		tax_hash = Hash.new{ |tax_hash,k| tax_hash[k]=[] }
		logs.map{ |l| [l.tax,  l.total_price] }.concat(invoice_lines.map{ |l| [l.tax, l.total_price]}).each{ |k,v| tax_hash[k] << v }
		tax_hash.each{|k,v| tax_hash[k] = v.inject(:+)}
	end
	def subtotal
		a = []
		tax_lines.each do |k,v|
			a << v/(1 + (k/100))
		end
		a.inject(:+)
	end

	private

	def total_to_receivable
		if status == 8
			self.receivable = 0
		else
  		self.receivable = self.total
  	end
  end

  def due_to_last_due

  	self.last_due = self.due
  end
end
