var parametroBean = consultaParametrosSession();

var tipoTransaccion = {
		'alta' : 1,
		'modificacion' : 2
}

var tipoConsulta = {
		'consultaPrincipal' : 1
};

var tipoLista = {
		'listaAyuda' : 1
};

$(document).ready(function() {

	limpiaCampos();
	$('#tipoNotaCargoID').focus();

	$(':text, :button, :submit, select').focus(function() {
		esTab = false;
	});

	$(':text, :button, :submit, select').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text, :button, :submit, textarea, select').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#formaGenerica :input:enabled:visible:first').focus();
			}, 0);
		}
	});

    $('#guardar').click(function(){
    	$('#tipoTransaccion').val(tipoTransaccion.alta);
    });

    $('#modificar').click(function(){
    	$('#tipoTransaccion').val(tipoTransaccion.modificacion);
    });

	$('#tipoNotaCargoID').bind('keyup',function(e){
		lista('tipoNotaCargoID', '2', '1', 'nombreCorto', $('#tipoNotaCargoID').val(), 'listaTiposNotasCargo.htm');
	});

	$('#tipoNotaCargoID').blur(function() {
		limpiaCampos();
		var tipoNotaCargoID = $('#tipoNotaCargoID').val();
		if (tipoNotaCargoID == '0') {
			habilitaBoton('guardar', 'submit');
		} else {
			consultaTipoNotasCargo();
		}
	});

//------------ Validaciones de la Forma -------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'tipoNotaCargoID', 'funcionExito', 'funcionFallo');
		}
	});

	$('#formaGenerica').validate({
		rules: {
			tipoNotaCargoID : {
				required : true
			},
			nombreCorto : {
				required : true
			},
			descripcion : {
				required : true
			},
			estatus : {
				required : true
			},
			cobraIVA: {
				required : true
			}
		},
		messages: {
			tipoNotaCargoID : {
				required : 'Especifique el Tipo de Notas de Cargo'
			},
			nombreCorto : {
				required : 'Especifique el Nombre Corto'
			},
			descripcion : {
				required : 'Especifique la Descripcion'
			},
			estatus : {
				required : 'Especifique el Estatus'
			},
			cobraIVA: {
				required : 'Especifique si Cobra IVA'
			}
		}	
	});

}); // document ready

function consultaTipoNotasCargo() {
	var tipoNotaID = $('#tipoNotaCargoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(isNaN(tipoNotaID) || tipoNotaID == '') {
		$('#tipoNotaCargoID').val('');
	} else {
		var tipoNotaBean = {
			'tipoNotaCargoID': tipoNotaID
		};
		
		tiposNotasCargoServicio.consulta(tipoConsulta.consultaPrincipal, tipoNotaBean, function(objResultado) {
			if(objResultado != null){
				$('#tipoNotaCargoID').val(objResultado.tipoNotaCargoID);
				$('#nombre').val(objResultado.nombreCorto);
				$('#nombreCorto').val(objResultado.nombreCorto);
				$('#descripcion').val(objResultado.descripcion);
				$('#estatus').val(objResultado.estatus);
				$('#cobraIVA').val(objResultado.cobraIVA);
				if (objResultado.tipoNotaCargoID != "1") { // Registro con ID 1 no modificable
					habilitaBoton('modificar', 'submit');
				}
			}else{
				mensajeSis('El Tipo de Notas de Cargo no existe.');
				$('#tipoNotaCargoID').focus();
			}
		});
	}
}

function limpiaCampos(){
	$('#nombre').val('');
	$('#nombreCorto').val('');
	$('#descripcion').val('');
	$('#estatus').val('');
	$('#cobraIVA').val('');
	$('#tipoTransaccion').val('');
	deshabilitaBoton('guardar', 'submit');
	deshabilitaBoton('modificar', 'submit');
}

function funcionExito() {
	limpiaCampos()();
}

function funcionFallo() {}