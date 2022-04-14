$(document).ready(function() {

	/* == Métodos y manejo de eventos ====  */
	esTab = false;
	var tipoTransaccion = {
		'actualizacion': 1
	};
	
	$('#radioBuscarPor').focus();
	
	deshabilitaBoton('enviar', 'submit');
	deshabilitaBoton('buscar', 'button');
	
	$(':text').focus(function() {
		esTab = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$(':button, :submit').focus(function() {
		esTab = false;
	});
	
	$(':button, :submit').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('input:checkbox').focus(function() {
		esTab = false;
	});
	
	$('input:checkbox').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('input:radio').focus(function() {
		esTab = false;
	});
	
	$('input:radio').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('input:radio[name="buscarPor"]').click(function() {
		if($('input:radio[name="buscarPor"]:checked').val() == "P") {
			$("#buscarPorPeriodo").show();
			$("#buscarPorCliente").hide();
			$("#tipoLista").val(2);
		}
		if($('input:radio[name="buscarPor"]:checked').val() == "C") {
			$("#buscarPorCliente").show();
			$("#buscarPorPeriodo").hide();
			$("#tipoLista").val(4);
		}
		$("#buscar").show();
		$('#anioMes').val('');
		$('#clienteID').val('');
		$('#nombreCliente').val('');
		deshabilitaBoton('buscar', 'button');
		deshabilitaBoton('enviar', 'submit');
		$('#formaTabla').hide();
		$('#enviar').hide();
	});
	
	$('#buscar').click(function() {
		listaGridEdoCtaEnvioCorreo();
		deshabilitaBoton('enviar', 'submit');
	});
	
	$('#anioMes').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(isNaN($('#anioMes').val()) || $('#anioMes').val() == '') {
			$('#anioMes').val("");
			deshabilitaBoton('enviar', 'submit');
			deshabilitaBoton('buscar', 'button');
			$('#formaTabla').hide();
			$('#enviar').hide();
		}
		if((isNaN($('#anioMes').val()) || $('#anioMes').val() == '') && esTab) {
			$('#anioMes').val("");
			setTimeout( function() {
				$('#anioMes').focus();
			}, 0);
			deshabilitaBoton('enviar', 'submit');
			deshabilitaBoton('buscar', 'button');
			$('#formaTabla').hide();
			$('#enviar').hide();
		}
		if(($('#anioMes').val().substring(0, 4) < 1990 || $('#anioMes').val().substring(0, 4) > 2100) && $('#anioMes').val() != '' && esTab) {
			mensajeSis('Periodo incorrecto');
			deshabilitaBoton('enviar', 'submit');
			deshabilitaBoton('buscar', 'button');
			$('#formaTabla').hide();
			$('#enviar').hide();
			setTimeout( function() {
				$('#anioMes').focus();
			}, 0);
		}
	});
	
	$('#anioMes').bind('keyup',function(e) {
		if ($(this).val().length > 0) {
			habilitaBoton('buscar', 'button');
		} else {
			deshabilitaBoton('buscar', 'button');
		}
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'anioMes';
		parametrosLista[0] = $('#anioMes').val();
		listaAlfanumerica('anioMes', '2', '5', camposLista, parametrosLista, 'listaPeriodos.htm');
	});
	
	$('#clienteID').blur(function() {
		if((isNaN($('#clienteID').val()) || $('#clienteID').val() == '') && esTab) {
			$('#clienteID').val("");
			setTimeout( function() {
				$('#clienteID').focus();
			}, 0);
			deshabilitaBoton('enviar', 'submit');
			deshabilitaBoton('buscar', 'button');
			$('#formaTabla').hide();
			$('#enviar').hide();
		} else {
			funcionConsultaCliente(this.id);
		}
	});
	
	$('#clienteID').bind('keyup',function(e) {
		if ($(this).val().length > 0) {
			habilitaBoton('buscar', 'button');
		} else {
			deshabilitaBoton('buscar', 'button');
		}
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'nombreCompleto';
		parametrosLista[0] = $('#clienteID').val();
		lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
	});
	
	$('#buscar, #enviar, :input:radio').blur(function() {
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#radioBuscarPor').focus();
			}, 0);
		}
	});
	
	// ---------------Metodos y Manejo de Eventos---------
	$.validator.setDefaults({
		submitHandler: function(event) {
			deshabilitaBoton('enviar', 'submit');
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','anioMes', 'limpiaFormaGridPantalla', '');
		}
	});
	
	$('#enviar').click(function(event) {
		event.preventDefault();
		$('#tipoTransaccion').val(tipoTransaccion.actualizacion);
		if($("#seleccionTodos").is(':checked')) {
			$('#seleccionTodos').val('S');
		} else {
			$('#seleccionTodos').val('');
		}
		if($("#seleccionTodos").is(':checked') && $('#numeroRegistros').val() > 25) {
			if (confirm('Esta a punto de enviar ' + $('#numeroRegistros').val() + ' estados de cuenta. Este proceso puede demorar varios minutos. ¿Desea continuar?')) {
				$('#formaGenerica').submit();
			}
		} else {
			$('#formaGenerica').submit();
		}
	});
	
	$('#formaGenerica').validate({
		rules:{
			listaPeriodos: {
				required: true
			},
			listaSucursales: {
				required: true
			},
			listaClientes: {
				required: true
			},
			listaPDF: {
				required: true
			},
			listaXML: {
				required: true
			},
			listaCorreos: {
				required: true
			}
		},messages:{
			listaPeriodos: {
				required:'Especifique periodos'
			},
			listaSucursales: {
				required:'Especifique sucursales'
			},
			listaClientes: {
				required:'Especifique clientes'
			},
			listaPDF: {
				required:'Especifique PDF'
			},
			listaXML: {
				required:'Especifique XML'
			},
			listaCorreos: {
				required:'Especifique correos'
			}
		}
	});
});

function funcionConsultaCliente(idControl) {
	var jqCliente  = eval("'#" + idControl + "'");
	var varclienteID = $(jqCliente).val();	
	var conCliente =1;
	var rfc = ' ';
	setTimeout("$('#cajaLista').hide();", 200);	

		if(varclienteID != '' && !isNaN(varclienteID) && varclienteID!=0){
		clienteServicio.consulta(conCliente,varclienteID,rfc,function(cliente){
			if(cliente!=null){
				$('#clienteID').val(cliente.numero);
				var tipo = (cliente.tipoPersona);
				if(tipo=='A'){
					$('#nombreCliente').val(cliente.nombreCompleto);
				}
				if(tipo=='F'){
					$('#nombreCliente').val(cliente.nombreCompleto);
				}
				if(tipo=='M'){
					$('#nombreCliente').val(cliente.razonSocial);
				}
			}else{
				mensajeSis('El ' + $('#tipoUsuario').val() + ' no existe');
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				setTimeout(function() {$('#clienteID').focus();}, 0);
			}
		});
	}
}

function listaGridEdoCtaEnvioCorreo(){
	var params = {};
	params['anioMes'] = $('#anioMes').val();
	params['clienteID'] = $('#clienteID').val();
	params['tipoLista'] = $('#tipoLista').val();
	$.post("edoCtaEnvioCorreoGridVista.htm", params, function(data){
			if(data.length > 0) {
				$('#formaTabla').html(data);
				$('#formaTabla').show();
				$('#enviar').show();
				if($('#numeroRegistros').val() <= 0) {
					mensajeSis('No se encontraron estados de cuenta pendientes por enviar');
					$('#enviar').hide();
					$('#anioMes').focus();
				}
			} else {
				mensajeSis("Error al generar la lista");
				$('#formaTabla').hide();
				$('#enviar').hide();
			}
	}).fail(function() {
		mensajeSis("Error al generar el grid");
		$('#formaTabla').hide();
		$('#enviar').hide();
	});
}

function limpiaFormaGridPantalla() {
	$('#buscar').click();
}
