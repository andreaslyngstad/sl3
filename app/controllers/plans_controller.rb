class PlansController < ApplicationController
  def index
  	# # authorize! :manage, Firm
  	if params[:currency] == "&"
  		currency =  "$"
  	else
  		currency = params[:currency] || current_firm.plan.currency
	end
    @plans = Plan.where(currency: currency).order("price").where.not(name: "SecretFREE")
  end
  def cancel
  	# authorize! :manage, Firm
    @plan = current_firm.plan
  end
end
