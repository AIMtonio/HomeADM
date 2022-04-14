var tipoTransaccion = {
	'grabar': 1
};

$(document).ready(function(){
	$('#folioID').focus();
	esTab = true;
	
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});	
	
	/* Metodos y Manejo de Eventos */
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	
	$('#grabar').click(function() {
		if ($('#folioID').val() == '' || $('#folioID').asNumber() != 0) {
            $('#folioID').focus();
        } else if ($("#Descrip").val() == '') {
            $('#Descrip').focus();
        } else {
			$('#tipoTransaccion').val(tipoTransaccion.grabar);
		}
	});

	$('#folioID').blur(function (event) {
        if ($('#folioID').val() == 0 ) {
            limpiaCampos();
            habilitaBoton('grabar', 'button');
        }else {
			deshabilitaBoton('grabar', 'submit');
		}
	})
	/* Institucion Nomina */
	$('#institNominaID').blur(function(event) {
        if($("#institNominaID").val()!="" && $("#institNominaID").val()!=0){
            consultaNomInstit();
        }
    });
    $('#institNominaID').bind('keyup', function(e) {
        lista('institNominaID', '2', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
    });

	/* Convenio Nomina */
	$('#convenioNominaID').blur(function(event) {
        if($("#convenioNominaID").val()!="" && $("#convenioNominaID").val()!=0 && esTab){
            consultaConvenioNomina();
        }
    });
    $('#convenioNominaID').bind('keyup', function(e) {
        var camposLista = new Array();
        var parametrosLista = new Array();
        camposLista[0] = 'institNominaID';
        camposLista[1] = 'descripcion';
        parametrosLista[0] = $('#institNominaID').val();
        parametrosLista[1] = $('#convenioNominaID').val();
        if($('#institNominaID').asNumber()==0){
            lista('convenioNominaID', '2', 7, camposLista, parametrosLista, 'listaConveniosNomina.htm');
        }else{
            lista('convenioNominaID', '2', 1, camposLista, parametrosLista, 'listaConveniosNomina.htm');
        }
    });
	
	/* Validaciones de la forma */
	$.validator.setDefaults({
		submitHandler : function(event) {	
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica',
					'contenedorForma', 'mensaje', 'true',
					'folioID', 'funcionExito',
					'funcionError');				
		}
	});
	
	$('#formaGenerica').validate({

		rules: {
			folioID: {
				required: true,	
				number: true,
				minlength: 1
			},
			descripcion: {
				required: true,
				maxlength: 50
			},
			institNominaID: {
				required: true
			},
			convenioNominaID: {
				required: true
			}
		},		
		messages: {
			folioID: {
				required:'El folio es Requerido.',	
				number : 'Sólo Números',
				minlength : 'Al menos 1 Caracteres'
			},
			descripcion: {
				required:'Se Requiere Descripcion',
				maxlength : 'Máximo 50 Caracteres'
			},
			institNominaID: {
				required:'Se Requiere Institucion Nomina'
			},
			convenioNominaID: {
				required:'Se Requiere Convenio Nomina'
			}
		}		
	});
});

function consultaNomInstit() {
    var institNominaBean = {
            'institNominaID' : $("#institNominaID").val()
    };
    institucionNomServicio.consulta(1, institNominaBean, function(institucionNomina) {
        if(institucionNomina != null){
            $('#nombreInstit').val(institucionNomina.nombreInstit);
        }
    });
}

function consultaConvenioNomina() {
	var convenioBean = {
		'convenioNominaID': $("#convenioNominaID").val()
	};
	conveniosNominaServicio.consulta(1, convenioBean, function(resultado) {
		if(resultado != null) {
			if($('#institNominaID').val()==0 ||
					(resultado.institNominaID == $('#institNominaID').val())){
				$("#nombreConvenio").val(resultado.descripcion);
				if ($('#folioID').val() == 0 ) {
					habilitaBoton('grabar', 'submit');
				}
			}else{
                mensajeSis("El convenio "+$("#convenioNominaID").val()+" no corresponde con la Empresa de Nómina.");
                $('#convenioNominaID').val();
                $('#nombreConvenio').val();
			}
			
		}else{
			mensajeSis("El convenio no existe");
		}
	});
}

function validaCreditoArcInstal(params) {
	
}

function generaExcel() {
	var url = 'repBitacoraPagos.htm'+
	            `?claveUsuario=${parametroBean.claveUsuario}`+
                `&nombreUsuario=${parametroBean.nombreUsuario}`+
                `&tipoReporte=${1}`+
                `&folioID=${$("#folioID").val()}`+
                `&descipcion=${$("#Descrip").val()}`+
                `&institNominaID=${$("#institNominaID").val()}`+
                `&nombreInstitucion=${$("#nombreInstit").val()}`+
                `&convenioNominaID=${$("#convenioNominaID").val()}`+
                `&nombreConvenio=${$("#nombreConvenio").val()}`;

	window.open(url, '_blank');
}

function limpiaCampos(){
	inicializaForma('formaGenerica','folioID');
	$('#folioID').focus();
	$('#Descrip').val('');
	$('#institNominaID').val('');
	$('#nombreInstit').val('');
	$('#convenioNominaID').val('');
	$('#nombreConvenio').val('');
}

function funcionExito() {
	generaExcel();
	deshabilitaBoton('grabar', 'submit');
}

function funcionError() {
	agregaFormatoControles('formaGenerica');
}