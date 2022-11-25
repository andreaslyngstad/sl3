class ApplicationController < ActionController::Base

  # rescue_from Customerio::Client::InvalidResponse, :with => :do_nothing
  before_action :authenticate_user!
  around_action :user_time_zone

  include ApplicationHelper
  #rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  # require "./lib/timehelp"
	include UrlHelper
	# before_filter :miniprofiler

	before_action :user_at_current_firm, :set_locale



  before_action :set_mailer_url_options,
                :authenticate_user!,
                :exept => [
                  :after_sign_in_path_for,
                  :sign_in_and_redirect,
                  :check_firm_id,
                  :current_subdomain]

  helper :layout
  helper_method :is_root_domain?,

                :current_subdomain,
                :time_zone_now,
                :time_range_to_day,
                :permitted_params
                #:can_sign_up?,

  # skip_before_action:find_firm, :only => [:sign_up_and_redirect]

  def permitted_params
    @permitted_params ||= PermittedParams.new(params, current_user)
  end

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # rescue_from CanCan::AccessDenied do |exception|
  #    if request.format == "text/javascript"
  #      flash[:notice] = flash_helper("Access denied.")
  #      render :template => "shared/access_denied"
  #    else
  #      render :template => "shared/access_denied"
  #    end
  # end


  #def can_sign_up?
    # return true if config.allow_account_sign_up is set to true
  	# Used in conjection with is_root_domain? for root domain.
   # is_root_domain? ? true :Account::CAN_SIGN_UP
  #end


  def all_users
    @all_users ||= current_firm.users.order("name")
  end
  # def customerio
  #   if current_user
  #     $customerio.track(current_user.id, request.original_url)
  #   end
  # end
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def flash_helper(message)
  	return (message).html_safe
  end

  def user_at_current_firm
    if current_user && !current_firm.users.include?(current_user)
      sign_out(current_user)

    end
  end
  private
  # def miniprofiler
  #   Rack::MiniProfiler.authorize_request # if current_user.email == 'andreas@lizz.no'
  # end
  def current_subdomain
      if request.subdomains.first.present? && request.subdomains.first != "www"
        current_subdomain = Firm.find_by_subdomain(request.subdomains.first)
      else
        current_subdomain = nil
      end
      return current_subdomain
  end
  def check_firm_id
    return current_subdomain ? current_user.firm.id == current_subdomain.id : false
  end
  def time_range_to_day
  	Time.zone.today
  end

  def set_locale
    if @current_firm
      I18n.locale = current_firm.language[/\A.+?(?=-)/mi]
    end
  end
  def record_not_found
    flash[:notice] = "No record found"
    redirect_to action: :index
  end



  def user_time_zone(&block)
    if current_user
      Time.use_zone(current_user.firm.time_zone, &block)
    else
      Time.use_zone('UTC', &block)
    end
  end
end
