$(document).ready(function() {
    consultaParametrosRiesgo();
    agregaFormatoControles('formaGenerica');

    var parametroBean = consultaParametrosSession();
    //------------ Metodos y Manejo de Eventos -----------------------------------------
    $.validator.setDefaults({
        submitHandler: function(event) {
            grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'pepNacional');
        }
    });

    $('#formaGenerica').validate({
        rules: {

            pepNacional: {
                required: true,
                number: true
            },
            pepaExtranjero: {
                required: true,
                number: true
            },
            localidad: {
                required: true
            },
            actEconomica: {
                required: true,
                number: true
            },
            origenRecursos: {
                required: true,
                number: true
            },
            prodCredito: {
                required: true,
                number: true
            },
            destCredito: {
                required: true,
                number: true
            },
            liAlertInusualesMesLimite: {
                required: true,
                number: true
            },
            liAlertInusualesMesVal: {
                required: true,
                number: true
            },
            liOperRelevMesLimite: {
                required: true,
                number: true
            },
            liOperRelevMesVal: {
                required: true,
                number: true
            },

        },
        messages: {
            pepNacional: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            pepExtranjero: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            localidad: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            actEconomica: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            origenRecursos: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            prodCredito: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            destCredito: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            liAlertInusualesMesLimite: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            liAlertInusualesMesVal: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            liOperRelevMesLimite: {
                required: 'Especifique una cantidad',
                number: 'Solo números'
            },
            pepNacional: {
                liOperRelevMesVal: 'Especifique una cantidad',
                number: 'Solo números'
            }
        }
    });

    //------------ Validaciones de Controles -------------------------------------

});

function consultaParametrosRiesgo() {
    var params = {};
    $.post("matrizRiesgosGridPLD.htm", params, function(data) {
        $('#parametrosGrid').html(data);
        $('#parametrosGrid').show();
        agregaFormatoControles('formaGenerica');
        agregaFormatoNumero('formaGenerica');
        $("#pepNacional").focus();
    });

}


function agregaFormatoNumero(idForma) {
    var jqForma = eval("'#" + idForma + "'");
    $(jqForma).find('input[esNumero="true"]').each(
        function() {
            var child = $(this);
            var jControl = eval("'#" + child.attr('id') + "'");
            $(jControl).bind('keyup', function() {
                $(jControl).formatCurrency({
                    colorize: true,
                    positiveFormat: '%n',
                    roundToDecimalPlace: -2
                });
            });
            $(jControl).blur(function() {
                $(jControl).formatCurrency({
                    positiveFormat: '%n',
                    roundToDecimalPlace: -2
                });
            });
            $(jControl).formatCurrency({
                positiveFormat: '%n',
                roundToDecimalPlace: -2
            });
        }
    );

}