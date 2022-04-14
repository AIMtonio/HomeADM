var esTab;
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
	$('#tipoListaID').bind('keyup', function(e) {
		lista('tipoListaID', '1', '1', 'descripcion', $('#tipoListaID').val(), 'catTipoListaPLDLista.htm');
	});
	$('#tipoListaID').blur(function() {
		var tipoLista = $('#tipoListaID').val().length;
		if (tipoLista > 0) {
			consultaLista(this.id);
		} else {
			deshabilitaBoton('grabar', 'submit');
			$('#descripcion').val("");
		}
	});
	$('#formaGenerica').validate({
		rules : {
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
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'tipoListaID', 'exito', 'error');
		}
	});
	$('#grabar').click(function() {
		$('#tipoTransaccion').val("1");
		if ($("#formaGenerica").valid()) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'tipoListaID', 'exito', 'error');
		}
	});
	$('#modificar').click(function() {
		$('#tipoTransaccion').val("2");
		if ($("#formaGenerica").valid()) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'tipoListaID', 'exito', 'error');
		}
	});
});
function consultaLista(idControl) {
	var jqLista = eval("'#" + idControl + "'");
	var tipoLista = $(jqLista).val();
	var principal = 1;
	var catTipoListaPLDBean = {
		'tipoListaID' : tipoLista
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (tipoLista != '' && esTab) {
		catTipoListaPLDServicio.consulta(principal, catTipoListaPLDBean, function(bean) {
			if (bean != null) {
				dwr.util.setValues(bean);
				deshabilitaBoton('grabar', 'submit');
				habilitaBoton('modificar', 'submit');
			} else {
				habilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				limpiaFormaCompleta('formaGenerica', true, [ 'tipoListaID' ]);
			}
		});
	}
}
function inicializar() {
	$("#tipoListaID").focus();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	limpiaFormaCompleta('formaGenerica', true, [ 'tipoListaID' ]);
}
function exito() {
	inicializar();}
function error() {
}
function ayuda() {
	$.blockUI({
	message : $('#ContenedorAyuda'),
	css : {
	top : ($(window).height() - 400) / 2 + 'px',
	left : ($(window).width() - 400) / 2 + 'px',
	width : '400px'
	}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click(function() {
		$.unblockUI();
	});
}