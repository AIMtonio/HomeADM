$(document).ready(function() {

	/* == Métodos y manejo de eventos ====  */
	esTab = false;
	var tipoTransaccion = {
		'actualizacion': 1
	};
	
	$('#clienteID').select();
	$('#clienteID').focus();
	
	setTimeout(function() {$('#clienteID').focus();}, 0);
	
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
	
	
	$("#buscarPorCliente").show();
	$("#tipoLista").val(6);
	$("#buscar").show();
	$('#anioMes').val('');
	$('#clienteID').val('');
	$('#nombreCliente').val('');
	$('#formaTabla').hide();
	
	$('#buscar').click(function() {
		if($('#clienteID').val()!="" && $('#clienteID').val()>0){
			listaGridEdoCtaEnvioCorreo();
		}
		else{
			mensajeSis("El cliente esta vacio");
			$('#clienteID').val('');
			$('#clienteID').focus();
		}
			
		
	});
	
	$('#clienteID').blur(function() {
		$('#formaTabla').html("");
		$('#formaTabla').hide();
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
				habilitaBoton('buscar', 'button');
			}else{
				mensajeSis('El ' + $('#tipoUsuario').val() + ' no existe');
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				setTimeout(function() {$('#clienteID').focus();}, 0);
				deshabilitaBoton('buscar', 'button');
			}
		});
	}
}

function listaGridEdoCtaEnvioCorreo(){
	var params = {};
	params['anioMes'] = $('#anioMes').val();
	params['clienteID'] = $('#clienteID').val();
	params['tipoLista'] = $('#tipoLista').val();
	$.post("consultaEdoCtacliGrid.htm", params, function(data){
			if(data.length > 0) {
				$('#formaTabla').html(data);
				$('#formaTabla').show();
				$('#enviar').show();
				if($('#numeroRegistros').val() <= 0) {
					mensajeSis('No se encontro informacion');
					$('#anioMes').focus();
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

function limpiaFormaGridPantalla() {
	$('#buscar').click();
}
