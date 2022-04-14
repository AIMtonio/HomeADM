esTab = false;
$(document).ready(function() {
	var clavePDFBeanAnt = {};
	var tipoUsuario = $('#tipoUsuario').val();

	var catTipoTransaccion = {
		'actualizacionContrasenia' : 1
	};
	
	function init() {
		inicializaCampos();
	}
	init();
	
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

	$('#clienteID').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = 'nombreCompleto';
		parametrosLista[0] = $('#clienteID').val();
		lista('clienteID', '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
	});


	$('#clienteID').blur(function() {
		var clienteID = $("#clienteID").val();	
		consultaInformacionCliente(clienteID);		
	});

	
	$('#txtContrasenia').blur(function() {
		if ($("#btnGuardar").is(":disabled") && esTab) {
 			setTimeout( function() {
				$("#clienteID").focus();
			}, 0);
 		}
		var contrasenia = $("#txtContrasenia").val();
		$("#contrasenia").val(window.btoa(unescape(encodeURIComponent(contrasenia))));
	});
	
	$('#btnGuardar').blur(function() {
		if (esTab) {
			setTimeout( function() {
				$("#clienteID").focus();
			}, 0);
 		}
	});

	function consultaInformacionCliente(clienteID) {
		var conCliente =1;
		var rfc = ' ';
		clavePDFBeanAnt = {};
		deshabilitaBoton('btnGuardar', 'submit');

		if(clienteID != '' && !isNaN(clienteID) && clienteID!=0) {
			clienteServicio.consulta(conCliente, clienteID, rfc, function(cliente){
				if(cliente!=null) {
					if(cliente.estatus=="I"){
						mensajeSis("El " + tipoUsuario + " se encuentra inactivo");
						setTimeout(function() {$('#clienteID').focus();}, 0);
					}
					else{
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
						
						consultaInformacionCuenta(clienteID);
						habilitaBoton('btnGuardar', 'submit');
					}

					setTimeout("$('#cajaLista').hide();", 200);	
				}
				else{
					mensajeSis('El ' + tipoUsuario + ' no existe');
					setTimeout(
						function() { 
							$("#nombreCliente").val("");
							$('#clienteID').focus();
						}, 0
					);
				}
			});
		}
		else {
			$('#nombreCliente').val("");
		}
	}

	function consultaInformacionCuenta(clienteID) {
		$("#txtContrasenia").val("");
		
		if(clienteID != '' && !isNaN(clienteID) && clienteID!=0) {
			var tipoConsulta = 1;
			var edoCtaClavePDFBean = {
				'clienteID': clienteID,
				'constrasenia':''
			};
			
			edoCtaClavePDFServicio.consulta(tipoConsulta, edoCtaClavePDFBean, function(clavePDFBean) {
				if(clavePDFBean == null) {
					clavePDFBean = {};
				}
				
				clavePDFBeanAnt = clavePDFBean;
				if(clavePDFBeanAnt.contrasenia != null) {
					$("#siContrasenia").attr('checked', true);				
				}
				else {
					$("#noContrasenia").attr('checked', true);
				}
			});
		}
	}
	
	
	$('#btnGuardar').click(function(){
		$("#tipoTransaccion").val(catTipoTransaccion.actualizacionContrasenia);
	});

	jQuery.validator.addMethod("contraseniaDiferente", function(value, element) {
		return window.btoa(unescape(encodeURIComponent(value))) != clavePDFBeanAnt.contrasenia;
	}, "La contraseña debe ser diferente a la actual.");
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			deshabilitaBoton('btnGuardar', 'submit');
			//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','');
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','', 'callBackExitoGuardar','callBackErrorGuardar');
		}
    });
	
	$('#formaGenerica').validate({
		rules: {
			clienteID: {'required':true, 'digits': true },
			txtContrasenia: {'required':true, 'contraseniaDiferente':true }
		},
		
		messages: {
			clienteID: {'required':'Especifique el ' + tipoUsuario, 'digits':'Número de cliente no valido'},
			txtContrasenia: {'required':'Especifique nueva contraseña', 'contraseniaDiferente':'La contraseña debe ser diferente a la actual.'}
		}		
	});
	// ------------ Metodos -------------------------------------
	
});

function callBackExitoGuardar() {
	document.getElementById("ligaCerrar").addEventListener("click", function() {
	    inicializaCampos();
	    $("#clienteID").focus();
	}, false);
}

function callBackErrorGuardar() {
	document.getElementById("ligaCerrar").addEventListener("click", function() {
	    $("#txtContrasenia").focus();
	}, false);
}

function inicializaCampos() {
	$("#clienteID").val('');
	$("#nombreCliente").val('');
	$("#txtContrasenia").val('');
	$("#siContrasenia").attr('checked', false);
	$("#noContrasenia").attr('checked', false);
	
	$("#clienteID").focus();
}