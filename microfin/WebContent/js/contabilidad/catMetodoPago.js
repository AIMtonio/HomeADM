var esTab;
var tab2 = false;

var cat_MetodosPago = {
		'alta' 		: 1,
		'modifica'	: 2
	};
$(document).ready(function() {
	inicializar();
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$(':text').focus(function() {
		esTab = false;
	});
	$('#metodoPagoID').bind('keyup', function(e) {
		lista('metodoPagoID', '1', '1', 'descripcion', $('#metodoPagoID').val(), 'catMetodosPagoLista.htm');
	});	

	$('#metodoPagoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
				
		if (isNaN($('#metodoPagoID').val())) { 			
			$('#metodoPagoID').val("");
			$('#metodoPagoID').focus();
			tab2 = false;
		} else {
			if ($('#metodoPagoID').asNumber()==0 && esTab) {		
				habilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				$("#descripcion").val("");
				$("#estatus").val("");
						
			}else{
				if (tab2 == false && esTab) { 
					esTab = true;
					consultaLista(this.id);
					
				}

			}
		}
	});

	$('#formaGenerica').validate({
		rules : {
		metodoPagoID : {
			required : true
		},
		tipoListaID : {
			required : true
		},
		descripcion : {
			required : true
		},
		estatus : {
			required : true
		}
	},
	messages : {
		metodoPagoID : {
			required : 'Especifique el Número.'
		},
		tipoListaID : {
			required : 'Especifique el Tipo de Lista.'
		},
		descripcion : {
			required : 'La Descripción es Requerida.'
		},
		estatus : {
			required : 'El Estatus es Requerido.'
		}
	}
	});

	$('#grabar').click(function(event) {
		$('#tipoTransaccion').val(cat_MetodosPago.alta);
		if ($("#formaGenerica").valid()) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'metodoPagoID', 'exito', 'error');
		}
	});
	$('#modificar').click(function(event) {
		$('#tipoTransaccion').val(cat_MetodosPago.modifica);
		if ($("#formaGenerica").valid()) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'metodoPagoID', 'exito', 'error');
		}
	});
});
function consultaLista(idControl) {
	var jqLista = eval("'#" + idControl + "'");
	var metodoPago = $(jqLista).val();
	var principal = 1;	

	var catIngresoEgresoBean = {
		'metodoPagoID' : metodoPago
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (metodoPago != '' && esTab) {
		catMetodosPagoServicio.consulta(principal, catIngresoEgresoBean, function(bean) {
			if (bean != null) {
				dwr.util.setValues(bean);
				deshabilitaBoton('grabar', 'submit');
				habilitaBoton('modificar', 'submit');
			} else {
				mensajeSis("El Método de Pago no Existe");
				$('#metodoPagoID').focus();

				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				limpiaFormaCompleta('formaGenerica', true, [ 'metodoPagoID' ]);
			}
		});
	}
}
function inicializar() {
	$('#metodoPagoID').focus();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	limpiaFormaCompleta('formaGenerica', true, [ 'tipoListaID' ]);
}
function exito() {
	inicializar();
	$('#metodoPagoID').val($('#consecutivo').val());
}
function error() {
}
