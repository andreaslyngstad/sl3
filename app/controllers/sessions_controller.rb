class SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!, :user_at_current_firm
  # , :all_users
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end
  def create
    subdomain = request.subdomain
    resource = warden.authenticate!(auth_options)
    sign_out_and_redirect_with_token(resource, subdomain)
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(current_user))
    set_flash_message :notice, :signed_out if signed_out
    redirect_to root_url(:subdomain => nil)
  end

  def sign_in_at_subdomain
      token_user = User.valid_recover?(params[:token].to_s)
      debugger
      # cookies.delete(:token, :domain => :all)

    if token_user
       sign_in(token_user)
       token_user.firm.did_sign_in
       flash[:notice] = I18n.t("devise.sessions.signed_in")
      redirect_to root_url(:subdomain => token_user.firm.subdomain )
    else
      flash[:alert] = "Login could not be validated"

      redirect_to root_url(:subdomain => nil)
    end
  end

   def require_no_authentication
    assert_is_devise_resource!
    return unless is_navigational_format?
    no_input = devise_mapping.no_input_strategies

    authenticated = if no_input.present?
      args = no_input.dup.push :scope => resource_name
      warden.authenticate?(*args)
    else
      warden.authenticated?(resource_name)
    end

    if authenticated && resource = warden.user(resource_name)
      flash[:alert] = I18n.t("devise.failure.already_authenticated")
      redirect_to root_url(:subdomain => resource.firm.subdomain )
    end
  end
private
  def sign_out_and_redirect_with_token(resource, subdomain)
     unless subdomain.present? && resource.firm.subdomain == subdomain || subdomain == "www"
      sign_out(resource)
     end
     token =  Devise.friendly_token
     resource.loginable_token = token
     resource.save
     cookies[:token] = { :value => token, domain: :all }
     debugger
     redirect_to sign_in_at_subdomain_url( :subdomain => resource.firm.subdomain, token: token)
   #   if Rails.env.production?
   #   $customerio.track(
   #      resource.id, 'Signed in', date: Time.now.to_i
   #
   #     )
   # end
  end
end
