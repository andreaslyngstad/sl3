class Email < ActiveRecord::Base
	include ActiveModel::Validations
	validates_with Validator
	belongs_to :invoice
	belongs_to :firm
	validates_presence_of :address
	validates_format_of :address, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create, :message => I18n.t("errors.messages.invalid")
	accepts_nested_attributes_for :invoice
	def status_string
		case status
			when "1" then ["green", I18n.translate('economic.email_sent')]
	  	when "2" then	['orange', I18n.translate('economic.email_reminder')]
		end
	end
end
