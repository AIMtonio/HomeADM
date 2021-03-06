$(document).ready(function() {
	esTab = false;
	var catTipoTransaccion = {
		'actualizacionParametros' : 1
	};
	
	var tipoConsulta = 1;
	var paramBrokerBean = {
		"actualizacionDiaria":"",
		"horaActualizacion":"",
		"usuario":"",
		"contrasenia":"",
		"urlConexion":""
	};
	
	$(':button, :submit').focus(function() {
		esTab = false;
	});
	
	$(':button, :submit').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#btnGuardar').blur(function() {
		if (esTab) {
			$("#rbActualizacionDiariaS").focus();
		}
	});
	
	pslParamBrokerServicio.consulta(tipoConsulta, paramBrokerBean, function(paramBroker) {	
		$("#txtHoraActualizacion").val(paramBroker.horaActualizacion);		
		$("#txtUsuario").val(paramBroker.usuario);
		$("#txtContrasenia").val(paramBroker.contrasenia);
		$("#txtURLConexion").val(paramBroker.urlConexion);
		
		if(paramBroker.actualizacionDiaria == "S") {
			$("#rbActualizacionDiariaS").attr('checked', 'checked');
			$("#txtHoraActualizacion").removeAttr('disabled');
			$("#rbActualizacionDiariaS").focus();
		}
		else {
			$("#rbActualizacionDiariaN").attr('checked', 'checked');
			$("#txtHoraActualizacion").attr('disabled','disabled');
			$("#rbActualizacionDiariaN").focus();
		}		
	});
	
	$("#rbActualizacionDiariaN").click(function() {
		var txtHoraActualizacion = $("#txtHoraActualizacion");
		var hora = txtHoraActualizacion.val();
		if(!esHoraValida(hora)) {
			txtHoraActualizacion.val("00:00");
		}
		
		$("#formaGenerica").valid();
		deshabilitaComponente("txtHoraActualizacion");
		
	});
	
	$("#rbActualizacionDiariaS").click(function() {
		habilitaComponente("txtHoraActualizacion");
	});
	
	function deshabilitaComponente(componenteId) {
		$("#" + componenteId).attr('disabled', 'disabled');
	}

	function habilitaComponente(componenteId) {
		$("#" + componenteId).attr('disabled', '');
	}
	
	$('#btnGuardar').click(function(){
		$("#tipoTransaccion").val(catTipoTransaccion.actualizacionParametros);		
	});

	$("#btnActualizarServicios").click(function(){
		$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
		$('#contenedorForma').block({
			message: $('#mensaje'),
			css: {	border:		'none',
					background:	'none'}
		});
		var tipoLista = 2;
		var paramBroker = {
			'usuario': $('#txtUsuario').val(),
			'contrasenia': $('#txtContrasenia').val(),
			'urlConexion': $('#txtURLConexion').val()
		};
	
		pslParamBrokerServicio.lista(tipoLista, paramBroker, function(listaParamBrokerBean) {
			$('#contenedorForma').unblock();
			if(listaParamBrokerBean == null) {
				mensajeSis('Error de conexi??n. Verifique los par??metros.');
				return;
			}
			mensajeSis('Conexi??n exitosa');
		});
	});
	
	// ------------ Metodos -------------------------------------
	
	function esHoraValida(hora) {
		return hora.length == 5 && /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/.test(hora);
	}

	jQuery.validator.addMethod("formatoHora", function(value, element) {
		return esHoraValida(value);
	}, "Formato de hora no valido");
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			deshabilitaBoton('btnGuardar', 'submit');
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','txtHoraActualizacion', 'callBackParametrizacionBroker', 'callBackParametrizacionBroker');
			habilitaBoton('btnGuardar', 'submit');
			habilitaComponente("txtHoraActualizacion");
		}
    });
	
	
	$('#formaGenerica').validate({
		rules: {
			txtHoraActualizacion: {	'required':true,
									'formatoHora':true 
									},
			txtUsuario: {	'required':true,
							'maxlength':20 
							},
			txtContrasenia: {	'required':true,
								'maxlength':20
								},
			txtURLConexion: {'required':true,'maxlength':200
				}
		},
		
		messages: {
			txtHoraActualizacion: {'required':'Especifique la hora de actualizacion', 'formatoHora':'Formato no valido'},
			txtUsuario: {'required':'Especifique el campo usuario','maxlength':'Longitud m??xima 20 caracteres'},
			txtContrasenia: {'required':'Especifique la contrase??a','maxlength':'Longitud m??xima 20 caracteres'},
			txtURLConexion: {'required':'Especifique la URL del Broker de servicios', 'maxlength':'Longitud m??xima de 200 caracteres'}
		}		
	});
}); //Fin de JQuery



function callBackParametrizacionBroker() {
	document.getElementById("ligaCerrar").addEventListener("click", function() {
	    $("#rbActualizacionDiariaS").attr('checked')?$("#rbActualizacionDiariaS").focus():$("#rbActualizacionDiariaN").focus();
	}, false);
}

function ayudaActualizacionDiaria(){	
	var data;	       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Actualizaci??n diaria autom??tica:</legend>'+
				'<label>' +
				'Opci??n para habilitar y deshabilitar la actualizaci??n diaria autom??tica del cat??logo de productos del Proveedor de servicios.' +
				'</label>' +
				'<hr>' +
				'<label>' +
				'Ejemplo: Si se desea deshabilitar la actualizaci??n autom??tica seleccionar la opci??n "NO"' + 
				'</label>' +
			'</div>'+
	 '</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}

function ayudaHoraActualizacion(){	
	var data;	       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Hora de la actualizaci??n:</legend>'+
				'<label>' +
				'Hora en la que se actualizar?? de manera autom??tica el cat??logo de productos (Solo se efectuar?? si se encuentra habilitada la Actualizaci??n diaria).' +
				'</label>' +
				'<hr>' +
				'<label>' +
				'Ejemplo: Para actualizar el cat??logo de productos a las 02:30 p.m se debe capturar 14:30' + 
				'</label>' +
			'</div>'+
	 '</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}

function ayudaUsuario(){	
	var data;	       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Usuario:</legend>'+
				'<label>' +
				'Usuario proporcionado por el Proveedor de servicios para poder consultar productos y/o realizar pago de servicios.' +
				'</label>' +
			'</div>'+
	 '</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}

function ayudaContrasenia(){	
	var data;	       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Contrase??a:</legend>'+
				'<label>' +
				'Contrase??a proporcionada por el Proveedor de servicios para poder consultar productos y/o realizar pago de servicios.' +
				'</label>' +
			'</div>'+
	 '</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}

function ayudaURLConexion(){	
	var data;	       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Hora de la actualizaci??n:</legend>'+
				'<label>' +
				'Direcci??n URL del Proveedor de servicios para poder consultar productos y/o realizar pago de servicios.' +
				'</label>' +
				'<hr>' +
				'<label>' +
				'Ejemplo: http://dominio.servidor.com/serviciosbroker' + 
				'</label>' +
			'</div>'+
	 '</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}