jQuery ->
  subscription.setupForm()

paymillErrorHandler = (error_message) -> 
    # Add elements to container if don't exist
    $('.error_input').removeClass('error_input')
    $('#paymill_error').text(error_message[0]).css('color', 'red')
    $(error_message[1]).addClass("error_input")

subscription =
  setupForm: ->
    $('#new_subscription').submit ->
      NProgress.start()
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        subscription.processCard()
        false
      else
        true
  
  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      exp_month: $('#card_month').val()
      exp_year: $('#card_year').val()
    paymill.createToken(card, subscription.handlePaymillResponse)

  handlePaymillResponse: (error, result) ->
    console.log(result)
    console.log(error)
    console.dir(result)
    NProgress.done()
    if error
      custom_message = switch       
        when error.apierror == "3ds_cancelled"                then [$.jsi18n.messages.user_cancelled_operation, ""]
        when error.apierror == "field_invalid_card_number"    then [$.jsi18n.messages.invalid_credit_card_number, "#card_number"]
        when error.apierror == "field_invalid_card_exp_year"  then [$.jsi18n.messages.invalid_year_cc, ".card_expiration_right"]
        when error.apierror == "field_invalid_card_exp_month" then [$.jsi18n.messages.invalid_month_cc, ".card_expiration_right"]
        when error.apierror == "field_invalid_card_exp"       then [$.jsi18n.messages.credit_card_expired, ".card_expiration_right"]
        when error.apierror == "field_invalid_card_cvc"       then [$.jsi18n.messages.invalid_security_code, "#card_code"]
        when error.apierror == "field_invalid_amount_int"     then [$.jsi18n.messages.invalid_amount, ""]
      $.jsi18n.messages.not_set
      # $('#paymill_error').text(custom_message)
      $('input[type=submit]').attr('disabled', false)
      return paymillErrorHandler(custom_message)
    else
      $('#subscription_paymill_card_token').val(result.token)
      $('#new_subscription')[0].submit()

  