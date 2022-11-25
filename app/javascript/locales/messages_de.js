/*
 * Locale: DE (German, Deutsch)
 */
 if (lang == "de-DE"){
 // validation
 (function ($) {
 	$.extend($.validator.messages, {
 		required: "Dieses Feld ist ein Pflichtfeld.",
 		maxlength: $.validator.format("Geben Sie bitte maximal {0} Zeichen ein."),
 		minlength: $.validator.format("Geben Sie bitte mindestens {0} Zeichen ein."),
 		rangelength: $.validator.format("Geben Sie bitte mindestens {0} und maximal {1} Zeichen ein."),
 		email: "Geben Sie bitte eine gültige E-Mail Adresse ein.",
 		url: "Geben Sie bitte eine gültige URL ein.",
 		date: "Bitte geben Sie ein gültiges Datum ein.",
 		number: "Geben Sie bitte eine Nummer ein.",
 		digits: "Geben Sie bitte nur Ziffern ein.",
 		equalTo: "Bitte denselben Wert wiederholen.",
 		range: $.validator.format("Geben Sie bitte einen Wert zwischen {0} und {1} ein."),
 		max: $.validator.format("Geben Sie bitte einen Wert kleiner oder gleich {0} ein."),
 		min: $.validator.format("Geben Sie bitte einen Wert größer oder gleich {0} ein."),
 		creditcard: "Geben Sie bitte eine gültige Kreditkarten-Nummer ein."
 	});
 }(jQuery));
// datepicker
jQuery(function($){
        $.datepicker.regional['de'] = {
                closeText: 'Schließen',
                prevText: '&#x3C;Zurück',
                nextText: 'Vor&#x3E;',
                currentText: 'Heute',
                monthNames: ['Januar','Februar','März','April','Mai','Juni',
                'Juli','August','September','Oktober','November','Dezember'],
                monthNamesShort: ['Jan','Feb','Mär','Apr','Mai','Jun',
                'Jul','Aug','Sep','Okt','Nov','Dez'],
                dayNames: ['Sonntag','Montag','Dienstag','Mittwoch','Donnerstag','Freitag','Samstag'],
                dayNamesShort: ['So','Mo','Di','Mi','Do','Fr','Sa'],
                dayNamesMin: ['So','Mo','Di','Mi','Do','Fr','Sa'],
                weekHeader: 'KW',
                dateFormat: 'dd.mm.yy',
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''};
        $.datepicker.setDefaults($.datepicker.regional['de']);
});
(function ($) {
    $.extend($.jsi18n.messages,{
    invoice_number: "Rechnungsnummer",
    invoice_page: "Seite",
    crunching: "Einen Moment bitte.",
    no_data: "Keine data."
    });
}(jQuery));
}