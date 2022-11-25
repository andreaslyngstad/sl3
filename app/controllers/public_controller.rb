require "subdomain_login"
class PublicController < ApplicationController
  skip_before_action :authenticate_user!, :user_at_current_firm
  layout "registration"
  respond_to :html
  include SubdomainLogin

  def index
  end

  def register
    @firm = Firm.new
  end

  def first_user
    @firm = Firm.find(params[:firm_id])
    @user = @firm.users.build
  end

  def create_firm
    @firm = Firm.create(permitted_params.firm)
    @firm.subdomain = @firm.subdomain.downcase
    respond_to do |format|
      if @firm.save
        flash[:notice] = 'Firm was successfully created! Now create the first user.'
        format.html { redirect_to(register_user_path(@firm)) }
      else
        flash[:error] = 'Firm could not be created'
        format.html { render action:'register', :layout => "registration"}
        format.xml  { render :xml => @firm.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_first_user
    @firm = Firm.find(params[:firm_id])
    @user = @firm.users.new(permitted_params.first_user)
    @user.role = "Admin"

        if @user.save
          sign_in(@user)
          if Rails.env.production?
            # begin
            # $customerio.identify(
            #    id: current_user.id,
            #    email: current_user.email,
            #    created_at: current_user.created_at.to_i,
            #    name: current_user.name,
            #    firm: current_user.firm.name,
            #    firm_subdomain: current_user.firm.subdomain,
            #    firm_plan: current_user.firm.plan.name,
            #    first_user: true
            #  )
            # rescue Customerio::Client::InvalidResponse
            # end
          end
          flash[:notice] = "Registration successfull."
          # QC.enqueue "FirmMailer.sign_up_confirmation", @user.id
          sign_out_and_redirect_with_token(@user)
        else
        	flash[:error] = "Registration could not be saved."
          render :action => 'first_user'
      end
  end
  def validates_uniqe
    if !params[:subdomain].to_s.match(/^[a-z0-9]+$/i).nil?
  	 @firm = Firm.find_by_subdomain(params[:subdomain])
  	else
  	 @wrong_format = true
  	end
  end
  def termsofservice
  end
  def privacy_policy
  end

  def pricing
    if params[:currency] == "FULL_FREE"
      currency =  "$"
    else
      currency = params[:currency] || "$"
    end
    if ['$', '€'].include?  params[:currency]
      @plans = Plan.where(currency: currency).where.not(name: "SecretFREE").order("price")
    else
      @plans = Plan.where(currency: "$").where.not(name: "SecretFREE").order("price")
    end
  end

  def contact
  end
end
