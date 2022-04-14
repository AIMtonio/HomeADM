function consultaArchivos(tipoOperacion, operacionInusual, operacionInterna) {
	if ((tipoOperacion == 1 && operacionInusual > 0) || (tipoOperacion == 2 && operacionInterna > 0)) {
		var params = {
		'tipoProceso' : tipoOperacion,
		'tipoLista' : tipoOperacion,
		'opeInusualID' : operacionInusual,
		'opeInterPreoID' : operacionInterna
		};

		$.post("gridArchOperacionesPLD.htm", params, function(data) {
			if (data.length > 0) {
				$('#gridArchivos').html(data);
				$('#gridArchivos').show();
			} else {
				$('#gridArchivos').html("");
				$('#gridArchivos').show();
			}
		});
	}
}

function eliminaArchivo(folioDocumento) {
	var opcion = confirm("¿Desea eliminar el archivo?");
	if (opcion == true) {
		var operacionInterna = $('#opeInterPreoID').asNumber();
		var operacionInusual = $('#opeInusualID').asNumber();
	
		var bean = {
			'adjuntoID' : folioDocumento
		};
		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
		$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
		border : 'none',
		background : 'none'
		}
		});
		archAdjuntosPLDServicio.baja(bean, function(mensajeTransaccion) {
			if (mensajeTransaccion != null) {
				mensajeSis(mensajeTransaccion.descripcion);
				consultaArchivos(tipoOperacion, operacionInusual, operacionInterna);
			} else {
				mensajeSis("Ocurrió un Error al Borrar el Documento.");
			}
		});
	}
}

function verArchivos(recurso) {
	var parametros = "?recurso=" + $("#" + recurso).val();

	var pagina = "archOperacionesPLDVer.htm" + parametros;
	var extensionArchivo = $("#" + recurso).val().substring($("#" + recurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	
		window.open(pagina, '_blank');
		$('#imagenCte').hide();
	
}