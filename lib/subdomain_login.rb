module SubdomainLogin
  def sign_out_and_redirect_with_token(resource)
     sign_out(resource)
     token =  Devise.friendly_token
     resource.loginable_token = token
     resource.save
     cookies[:token] = { :value => token, :domain => :all }
     redirect_to sign_in_at_subdomain_url( :subdomain => resource.firm.subdomain)
  end
end