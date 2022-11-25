class SubscriptionsController < ApplicationController
  
  def new
    @plan = Plan.find(params[:plan_id])
    @subscription = @plan.subscriptions.build
  end

  def create
    @subscription = Subscription.new(permitted_params.subscription)
    @plan = @subscription.plan
    @subscription.firm_id = current_firm.id

    if @subscription.save_with_payment
      redirect_to plans_path, :notice => (t"subscription.thank_you_for_subscribing")
      # user = @subscription.firm.users.where(role: "Admin").first 
      # QC.enqueue "FirmMailer.new_plan", user.id
    else
      render :new
    end
  end
  # comment 06.06.13
  # def show
  #   @subscription = Subscription.find(params[:id])
  #   respond_to do |format|
  #     format.js
  #   end
  # end
  
  def destroy
    @subscription = Subscription.find(params[:id])
    plan = Plan.where(name: "Free").first
    current_firm.remove_associations_when_downgrading(plan.id)
    
    
      Paymill::Subscription.delete(@subscription.paymill_id)
      rescue Paymill::APIError
   
    @subscription.delete
    current_firm.plan = plan
    # s = Subscription.new(plan_id: plan.id, last_four: "0000", card_type: "NONE")
    # s.firm = current_firm
    # s.save!
    current_firm.save
    flash[:notice] = flash_helper(t'subscription.you_are_now_on_the_free_plan')  
    redirect_to plans_path
  end
end
