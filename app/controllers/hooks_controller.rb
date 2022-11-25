class HooksController < ApplicationController
  skip_before_action:authenticate_user!, :all_users, :user_at_current_firm
 require 'json'
 
  def receiver
    data_json = JSON.parse( request.body.read)
    if data_json["event"]["event_type"] == 'subscription.succeeded'
        paymill_id = data_json["event"]["event_resource"]["subscription"]["id"]
        currency = data_json["event"]["event_resource"]["transaction"]["currency"]
        s = Subscription.where(paymill_id: paymill_id).first 
        next_capture_at = (Time.at(Paymill::Subscription.find(paymill_id).next_capture_at)).to_date   
        s.next_bill_on = next_capture_at 
        s.active = true
        s.save 
        user = s.firm.users.where(role: "Admin").first 
        # QC.enqueue "FirmMailer.payment_received", user.id
        Payment.make(s, currency)  
    end
   render nothing: true, status: 200 
  end
end
