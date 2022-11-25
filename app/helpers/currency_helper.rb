module CurrencyHelper
  def currency_converter(value)
    value_pretty = value
    case current_firm.currency
    when "NOK", "DKK", "SEK", "ISK"
      number_to_currency(value_pretty, locale: "nb")
    when "USD", "AUD", "NZD", "CAD"
      number_to_currency(value_pretty, locale: "en")
    when "EUR"
      number_to_currency(value_pretty, locale: "de")
    	# localeString(value_pretty, '.', 3, ',', '€')
    when "JPY"
      localeString(value_pretty, ',', 3, '.', '¥')
    when "GBP"
    	localeString(value_pretty, ',', 3, '.', '£')
    else
      localeString(value_pretty, ' ', 3, ',', '')
    end
  end
  def localeString(x, sep, grp, cent_seperator, currency)
    if x.nil?
      x = "0.0"
    end
    after_cent = after_cent(x.split(".")[1])
    s = x.split(".")[0]
    p = s.split(//, s.length).reverse.each_slice(grp).to_a.map{|o| o << sep}.join.reverse
    p[0] = ''
    currency + p + cent_seperator + after_cent
  end

  def payment_currency(payment)
    if payment.currency == "USD"
      number_to_currency(payment.amount, unit: "$", format: "%u %n")
    else
      number_to_currency(payment.amount, unit: "€", format: "%n %u")
    end
  end
  def after_cent(cent)
    if cent 
      if cent == "0"
        "00"
      else
        cent  
      end  
    else
        "00"
    end
  end
# jQuery.fn.convert_money_field = function(){
#   $(this).each(function(i, e){
#     $(e).text(currency_converter(parseFloat($(e).attr("data-value"))))
#   })
# }
  def currency_symbol
    case current_firm.currency
    when "NOK", "DKK", "SEK", "ISK"
      current_firm.currency.downcase.capitalize
    when "USD", "AUD", "NZD", "CAD"
      "$"
    when "EUR"
      '€'
    when "JPY"
      '¥'
    when "GBP"
      '£'
    else
      current_firm.currency
    end
  end
end