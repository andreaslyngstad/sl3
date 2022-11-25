/*
 * Locale: en-US (english; us)
 */

if (lang == "en-US"){

(function ($) {
    $.extend($.jsi18n.messages,{
    invoice_number: "Invoice number",
		    invoice_page: "Page",
		    crunching: "Crunching data just for you....", 
		    no_data: "Sorry, no data available.",
		    left: "left",
		    spent: "spent",
		    nothing_used: "Nothing used",
		    not_set: "Not set",
		    user_cancelled_operation:	"User cancelled operation",
				invalid_credit_card_number:	"Invalid credit card number",
				invalid_year_cc:	"Invalid year in your credit card",
				invalid_month_cc:	"Invalid month in your credit card",
				credit_card_expired:	"Credit card expired",
				invalid_security_code:	"Invalid security code (cvc)",
				invalid_amount:	"Invalid amount for transaction",
				generating_file: "Generating file..."
    });
}(jQuery));
}
