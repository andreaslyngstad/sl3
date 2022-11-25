function currency_converter(value){

    var value_pretty = value.toFixed(2)
    var currency = $(".current_firm_data").attr("data-currency");

    switch(currency)
    {
      case "NOK":
      case "DKK":
      case "SEK":
      case "ISK":
      return localeString(value_pretty, ' ', 3, ',', 'kr ')
      break;
      case "USD":
      case "AUD":
      case "NZD":
      case "CAD":
      return localeString(value_pretty, ',', 3, '.', '$')
      break;
      case "EUR":
      return localeString(value_pretty, '.', 3, ',', '€')
      break;
      case "JPY":
      return localeString(value_pretty, ',', 3, '.', '¥')
      break;
      default:
      return localeString(value_pretty, ' ', 3, ',', '')
    }

    var language = $(".current_firm_data").attr("data-language");

    return localeString(value, '.', 3, ',')
    // return value.toLocaleString(language, {style: "currency", currency: currency, minimumFractionDigits: 2, maximumFractionDigits: 2})
}
function localeString(x, sep, grp, cent_seperator, currency) {
    y = ''
    if (x[0] == "-"){
      x = x.split("-")[1];
      y = '-'
    }
    var sx = (''+x).split('.'), s = '', i, j;
    sep || (sep = ' '); // default seperator
    grp || grp === 0 || (grp = 3); // default grouping
    i = sx[0].length;
    while (i > grp) {
        j = i - grp;
        s = sep + sx[0].slice(j, i) + s;
        i = j;
    }
    s = sx[0].slice(0, i) + s;
    sx[0] = s;
    var sum = sx.join(cent_seperator)
    
    // console.log(currency + y + sum)
    return currency + y + sum
}

jQuery.fn.convert_money_field = function(){
  $(this).each(function(i, e){
    $(e).text(currency_converter(parseFloat($(e).attr("data-value"))))
  })
}