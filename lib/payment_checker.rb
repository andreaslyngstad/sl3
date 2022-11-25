class PaymentChecker
  def self.matches?(request)  
    case Firm.where(subdomain: request.subdomain).first.try(:closed)
    when true
      false
    else
      true
    end
  end
end