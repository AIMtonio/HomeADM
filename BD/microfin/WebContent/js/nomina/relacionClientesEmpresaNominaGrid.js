$(document).ready(function() {
	$(':button, :submit').focus(function() {
		esTab = false;
	});

	$(':button, :submit').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':button, :submit').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#clienteID').focus();
			}, 0);
		}
	});
});

function cambioPaginaGrid(valorPagina) {
	var params = {};
	params['clienteID'] = $('#clienteID').val();
	params['tipoLista'] = tipoLista.listaGridEmpleados;
	params['page'] = valorPagina;
	$.post("relacionClientesEmpresaNominaGridVista.htm", params, function(data) {
		if(data.length > 0) {
			$('#formaTabla').html(data);
			$('#formaTabla').show();
			if($('#numeroRegistros').val() <= 0) {
				mensajeSis('No se encontraron registros');
				$('#clienteID').focus();
			}
		} else {
			mensajeSis("Error al generar la lista");
			$('#formaTabla').hide();
		}
	}).fail(function() {
		mensajeSis("Error al generar el grid");
		$('#formaTabla').hide();
	});
}