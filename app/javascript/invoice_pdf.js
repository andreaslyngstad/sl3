//= require jquery

jQuery.fn.prepare_invoice_template = function(page_count){
  $(this).find('.page_counting_placeholder')
         .addClass('page_counting')
         .removeClass('page_counting_placeholder')
  $(this).addClass('invoice_wrapper')
         .removeClass('invoice_template')
         .attr('id', 'invoice_wrapper' + page_count)
  $(this).find('.checking_height').addClass('active_height')
  $(this).show()
}
jQuery.fn.append_lines_and_logs = function(){
  if ($(this).hasClass('line')){
    $('.active_height').find('.free_lines_table_print_container').show()
    $('.active_height').find('.free_lines_table tbody').prepend(this)
  }else{
    // listing_logs_invoice_container
    $('.active_height').find('.listing_logs_invoice_container').show().append(this)
  }
}
function make_new_page(){
   if ($('.active_height').height() + $('.active_height').find('.invoice_table').height() > $('.invoice_wrapper').height()){

    $('.old_height').removeClass('old_height')
    $('.invoice_wrapper').find('.active_height').filter(':visible').removeClass('active_height').addClass('old_height');
    $('.invoice_template').clone().appendTo('#tabs-1')
    $('.invoice_template').first().prepare_invoice_template($('.invoice_wrapper').length)
    }  
}
function move_last_line(){
  var page_count =  $('.invoice_wrapper').length
  make_new_page()

    while ($('.old_height').height() + $('.old_height').find('.invoice_table').height() > $('.invoice_wrapper').height()){
      $('.old_height').find('.invoice_line').last().append_lines_and_logs()
      if ($('.old_height').height() + $('.old_height').find('.invoice_table').height() < $('.invoice_wrapper').height()){
        make_new_page()
      }
      if($('.old_height').find('.log').length == 0){$('.old_height').find('.listing_logs_invoice_container').remove()}
      if($('.old_height').find('.line').length == 0){$('.old_height').find('.free_lines_table_print_container').hide()}
    }
}


function find_last_invoice_line(page_count) {
  $('#invoice_wrapper'  + (page_count - 1)).find('.invoice_line').last();
};

jQuery.fn.count_pages = function(){
  total_pages = $(this).length
  $(this).each(function(i, e){
    j = i + 1
    $(e).text(j + '/' + total_pages)
  })

}
jQuery.fn.put_total_at_bottom = function(){
 
  $('.invoice_table').first().css('top', 
    ($('#invoice_wrapper0').outerHeight() - 
    ($('.invoice_table').first().height() + 
    parseFloat($('#invoice_wrapper0').css('padding')))) + "px");  
  move_last_line()
}

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
    
    console.log(currency + y + sum)
    return currency + y + sum
}

jQuery.fn.convert_money_field = function(){
  $(this).each(function(i, e){
    $(e).text(currency_converter(parseFloat($(e).attr("data-value"))))
  })
}
function ready_invoice(){
  
  $('.invoice_table').put_total_at_bottom();

  $('.invoice_wrapper').find('.page_counting').count_pages()

}
$(document).ready(function() {
  ready_invoice()
});