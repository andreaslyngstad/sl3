/*
 * Locale: NO (Norwegian; Norsk)
 */

if (lang == "nb-NO"){
// validation
(function ($) {
        $.extend($.validator.messages, {
                required: "Dette feltet er obligatorisk.",
                maxlength: $.validator.format("Maksimalt {0} tegn."),
                minlength: $.validator.format("Minimum {0} tegn."),
                rangelength: $.validator.format("Angi minimum {0} og maksimum {1} tegn."),
                email: "Oppgi en gyldig epostadresse.",
                url: "Angi en gyldig URL.",
                date: "Angi en gyldig dato.",
                dateISO: "Angi en gyldig dato (&ARING;&ARING;&ARING;&ARING;-MM-DD).",
                dateSE: "Angi en gyldig dato.",
                number: "Angi et gyldig nummer.",
                numberSE: "Angi et gyldig nummer.",
                digits: "Skriv kun tall.",
                equalTo: "Skriv samme verdi igjen.",
                range: $.validator.format("Angi en verdi mellom {0} og {1}."),
                max: $.validator.format("Angi en verdi som er mindre eller lik {0}."),
                min: $.validator.format("Angi en verdi som er st&oslash;rre eller lik {0}."),
                creditcard: "Angi et gyldig kredittkortnummer."
        });
}(jQuery));
// datepicker
jQuery(function($){
        $.datepicker.regional['no'] = {
                closeText: 'Lukk',
                prevText: '&#xAB;Forrige',
                nextText: 'Neste&#xBB;',
                currentText: 'I dag',
                monthNames: ['januar','februar','mars','april','mai','juni','juli','august','september','oktober','november','desember'],
                monthNamesShort: ['jan','feb','mar','apr','mai','jun','jul','aug','sep','okt','nov','des'],
                dayNamesShort: ['søn','man','tir','ons','tor','fre','lør'],
                dayNames: ['søndag','mandag','tirsdag','onsdag','torsdag','fredag','lørdag'],
                dayNamesMin: ['sø','ma','ti','on','to','fr','lø'],
                weekHeader: 'Uke',
                dateFormat: 'dd.mm.yy',
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''
        };
        $.datepicker.setDefaults($.datepicker.regional['no']);
});
(function ($) {
    $.extend($.jsi18n.messages,{
    invoice_number: "Fakturanummer",
    invoice_page: "Side",
    crunching: "Vent litt. Knuser data for deg....",
    no_data: "Beklager, mangler data.",
    left: "Igjen",
    spent: "Brukt",
    nothing_used: "Ingenting er brukt",
    not_set: "Ikke satt opp",
    user_cancelled_operation: "Brukeren avbrøt transaksjonen",
    invalid_credit_card_number: "Ugyldig kort nummer",
    invalid_year_cc:    "Ugyldig år på kortet",
    invalid_monthcc:    "Ugyldig måned på kortet",
    credit_card_expired:    "Kortet har utløpt",
    invalid_security_code:  "Ugyldig sikkerhetskode (cvc)",
    invalid_amount: "Ugyldig beløp for transaksjoen",
    generating_file: "Genererer fil...."

    });
}(jQuery));
}