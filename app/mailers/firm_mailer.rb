class FirmMailer < ActionMailer::Base
  default from: "no_reply@squadlink.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.firm_mailer.sign_up_confirmation.subject
  #
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

  def sign_up_confirmation(id)
    @user = User.find(id)
    @firm = @user.firm
    sign_up_confirmation_mail = mail to: @user.email, subject: 'Squadlink sign up confirmation.'
    sign_up_confirmation_mail.deliver
  end
  def new_plan(id)
    @user = User.find(id)
    @firm = @user.firm
    new_plan = mail to: @user.email, subject: 'Squadlink new plan confirmation.'
    new_plan.deliver
  end
 
  # def payment_received(id)
  #   @user = User.find(id)
  #   @firm = @user.firm
  #   @subscription = @firm.subscription 
  #   mail to: @user.email, subject: 'Squadlink payment received confirmation.'
  # end

  def overdue(subscription)
    @subscription = subscription
    @firm = subscription.firm
    @user = @firm.users.where(email: subscription.email).first
    mail to: subscription.email, subject: 'Squadlink payment is overdue.'
  end  

  def two_weeks_overdue(subscription)
    @subscription = subscription
    @firm = subscription.firm
    @user = @firm.users.where(email: subscription.email).first
    mail to: subscription.email, subject: 'Squadlink payment is two weeks overdue.'
  end

  def reverting_to_free(subscription)
    @subscription = subscription
    @firm = subscription.firm
    @user = @firm.users.where(email: subscription.email).first
    mail to: subscription.email, subject: 'Squadlink account revertet to free due to missing payment.'
  end
end
