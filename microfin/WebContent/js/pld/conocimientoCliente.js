var parametroBean = consultaParametrosSession();
var catTipoRepVencimientos = {
	'PDF' : 1
};
var esTab = true;
$(document).ready(function() {
	// Definicion de Constantes y Enums
	deshabilitaBoton('generar', 'submit');

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$('#pdf').attr("checked", true);

	$(':text').focus(function() {
		esTab = false;
	});
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$('#pdf').click(function() {
		if ($('#pdf').is(':checked')) {
			$('#tdPresenacion').show('slow');
		}
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);

	});

	$('#generar').click(function() {
		if ($('#pdf').is(":checked")) {
			generaPDF();
		}
	});

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var varclienteID = $(jqCliente).val();
		var conCliente = 5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if (varclienteID != '' && !isNaN(varclienteID)) {
			clienteServicio.consulta(conCliente, varclienteID, rfc, function(cliente) {
				if (cliente != null) {
					if (cliente.esMenorEdad != 'S') {
						$('#clienteID').val(cliente.numero);
						$('#nombreCliente').val(cliente.nombreCompleto);
						habilitaBoton('generar', 'submit');
					} else {
						alert("El " + $('#alertSocio').val() + " Es Menor de Edad.");
						$(jqCliente).focus();
						$(jqCliente).val('');
						deshabilitaBoton('generar', 'submit');
					}

				} else {
					alert("No Existe el " + $('#alertSocio').val() + ".");
					$(jqCliente).focus();
					$(jqCliente).val('');
					deshabilitaBoton('generar', 'submit');
				}
			});
		}
	}

	$('#clienteID').bind('keyup', function(e) {
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

});
function generaPDF() {
	if ($('#pdf').is(':checked')) {

		var tr = catTipoRepVencimientos.PDF;

		var clienteID = $('#clienteID').val();
		var fechaEmision = parametroBean.fechaSucursal;
		var usuario = parametroBean.claveUsuario;

		/// VALORES TEXTO
		var nombreCliente = $('#nombreCliente').val();

		var nombreUsuario = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;

		if (nombreCliente == '0') {
			nombreCliente = '';

		} else {
			nombreCliente = $("#clienteID option:selected").html();
		}

		$('#ligaGenerar').attr('href', 'conocimientoCliente.htm?' + '&clienteID=' + clienteID + '&nombreCliente=' + nombreCliente + '&parFechaEmision=' + fechaEmision + '&usuario=' + usuario + '&nombreUsuario=' + nombreUsuario + '&nombreInstitucion=' + nombreInstitucion);
		$('#nombreCliente').val('');
		$('#clienteID').val('');
		$('#clienteID').focus();
		deshabilitaBoton('generar', 'submit');

	}
}