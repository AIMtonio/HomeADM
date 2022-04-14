var parametroBean = consultaParametrosSession();   
$(document).ready(function() {
	esTab = true;
	
	//Definicion de Constantes y Enums
	
	var catTipoTransaccionTipoTarjeta = {
			'agrega'		: '1',
			'modifica'		: '2'
	};

	var catTipoConsultaTipoTarjetaLim = {
	  		'contTipoTarjeta':2
	};
	var catTipoConsultaTipoTarjeta = {
	  		'tipoTarjeta':1
	};

	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------

	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	$('#tipoTarjetaDebID').focus();
	agregaFormatoControles('formaGenerica');
	
	//validacion

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});


	$.validator.setDefaults({
	      submitHandler: function(event) { 
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoTarjetaDebID', 
	    			  'funcionExitoLimitesTarjetas','funcionErrorLimitesTarjetas');
	      }
	});

	$('#agrega').click(function() {		
			$('#tipoTransaccion').val(catTipoTransaccionTipoTarjeta.agrega);
	});
	
	$('#modifica').click(function() {	
			$('#tipoTransaccion').val(catTipoTransaccionTipoTarjeta.modifica);
	});	

	$('#tipoTarjetaDebID').blur(function(){
		validaTipoTarjetaDebito(this.id);	
	});	
	
	$('#tipoTarjetaDebID').bind('keyup',function(e){
		lista('tipoTarjetaDebID', '1', '4', 'tipoTarjetaDebID', $('#tipoTarjetaDebID').val(), 'tipoTarjetasDevLista.htm');
	});   


	// ------------ Validaciones de la Forma
	
	$('#formaGenerica').validate({
		rules : {
			tipoTarjetaDebID: {
				required : true
			},
			montoDisDia: {
				required: true,
				number: true,
			},
			montoDisMes: {
				required: function() {return $('#txtMontoMaxDisp').is(":visible");},
				number: function() {return $('#txtMontoMaxDisp').is(":visible");},
			},
			montoComDia: {
				required: true,
				number: true,
			},
			montoComMes: {
				required: function() {return $('#txtMontoMaxCom').is(":visible");},
				number: function() {return $('#txtMontoMaxCom').is(":visible");},
			},
			bloqueoATM: {
				required: true
			},
			bloqueoPOS: {
				required: true
			},
			bloqueoCash: {
				required: true
			},
			operacionMoto: {
				required: true
			},
			numeroDia: {
				required: true,
				number: true,
			}

		},
		messages : {
			tipoTarjetaDebID:{
				required: 'Especificar el Tipo de Tarjeta.'
			},
			montoDisDia: {
		    	required: 'Especificar el Monto Max. Disp. Diario.',
				number: 'Sólo Números'
		    },
		    montoDisMes: {
		    	required: 'Especificar el Monto Max. Disp. Mensual.',
				number: 'Sólo Números'
			},
			montoComDia: {
		    	required: 'Especificar el Monto Max. Compra Diario.',
				number: 'Sólo Números'
			},
			montoComMes: {
		    	required: 'Especificar el Monto Max. Compra. Mensual.',
				number: 'Sólo Números'
			},
			bloqueoATM: {
				required: "Especificar el Tipo de Bloqueo ATM",
			},
			bloqueoPOS: {
				required: "Especificar el Tipo de Bloqueo POS",
			},
			bloqueoCash: {
				required: "Especificar el Tipo de Bloqueo",
			},
			operacionMoto: {
				required: "Especificar la Operacion",
			},
			numeroDia: {
		    	required: 'Especificar el Número de Disposiciones.',
				number: 'Sólo Números'
			}
		}
	});
	

	
	// ------------ Validaciones de Controles-------------------------------------
    function validaTipoTarjetaDebito(control) {
	var tipoTarjetaDeb = $('#tipoTarjetaDebID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(tipoTarjetaDeb != '' && !isNaN(tipoTarjetaDeb) && esTab){
		var tipoTarjetaBeanCon = { 
		'tipoTarjetaDebID':$('#tipoTarjetaDebID').val()
		};
		tipoTarjetaDebServicio.consulta(catTipoConsultaTipoTarjeta.tipoTarjeta,tipoTarjetaBeanCon,function(tipoTarDeb) {
				if(tipoTarDeb!=null){
					dwr.util.setValues(tipoTarDeb);	
					if(tipoTarDeb.identificacionSocio=='S'){
						alert('El Tipo de Tarjeta es de Identificación.');
						limpiaForm($('#formaGenerica'));	
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#tipoTarjetaDebID').focus();
						$('#tipoTarjetaDebID').select();
						$('#bloqueoATM').val('');
						$('#bloqueoPOS').val('');
						$('#bloqueoCash').val('');
						$('#operacionMoto').val('');
					}
					console.log("tipoCore "+tipoTarDeb.tipoCore);
					if(tipoTarDeb.tipoCore != 3){
						$('#lblMontoMaxDisp').hide();
						$('#txtMontoMaxDisp').hide();
						$('#lblMontoMaxCom').hide();
						$('#txtMontoMaxCom').hide();
						$('#lblNumConsMens').hide();
						$('#txtNumConsMens').hide();
					}else {
						$('#lblMontoMaxDisp').show();
						$('#txtMontoMaxDisp').show();
						$('#lblMontoMaxCom').show();
						$('#txtMontoMaxCom').show();
						$('#lblNumConsMens').show();
						$('#txtNumConsMens').show();
					}
					validaTipoTarjetaDebitoLim('tipoTarjetaDebID');
				}else{
					
					alert("El Tipo de Tarjeta No Existe");
					limpiaForm($('#formaGenerica'));	
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('agrega', 'submit');
					$('#tipoTarjetaDebID').focus();
					$('#tipoTarjetaDebID').select();
					$('#bloqueoATM').val('');
					$('#bloqueoPOS').val('');
					$('#bloqueoCash').val('');
					$('#operacionMoto').val('');
					}
				});	
		}else{
			 
			 $('#descripcion').val('');
			 $('#montoDisDia').val('');
			 $('#montoDisMes').val('');
			 $('#montoComDia').val('');
			 $('#montoComMes').val('');
			 $('#bloqueoATM').val('');
			 $('#bloqueoPOS').val('');
			 $('#bloqueoCash').val('');
			 $('#operacionMoto').val('');
			 $('#numeroDia').val('');
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('agrega', 'submit');
		}
    }
	function validaTipoTarjetaDebitoLim(control) {
	esTab=true;
    var numTarjetaDeb = $('#tipoTarjetaDebID').val();
    setTimeout("$('#cajaLista').hide();", 200);
    if(numTarjetaDeb != '' && !isNaN(numTarjetaDeb) && esTab){
		var tipoTarjetaBeanCon = { 
		'tipoTarjetaDebID':$('#tipoTarjetaDebID').val()	
		};
		tarDebLimiteTipoServicio.consulta(catTipoConsultaTipoTarjetaLim.contTipoTarjeta,tipoTarjetaBeanCon,function(tipoTarDeb) {
				if(tipoTarDeb!=null){
					dwr.util.setValues(tipoTarDeb);	
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
					$('#montoDisDia').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#montoDisMes').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#montoComDia').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#montoComMes').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					
				}else{	
					deshabilitaBoton('modifica', 'submit');
					habilitaBoton('agrega', 'submit');
					$('#montoDisDia').focus();
					$('#montoDisDia').val('');
					$('#montoDisMes').val('');
					$('#montoComDia').val('');
					$('#montoComMes').val('');
					$('#bloqueoATM').val('');
					$('#bloqueoPOS').val('');
					$('#bloqueoCash').val('');
					$('#operacionMoto').val('');
					$('#numeroDia').val('');
					}
				});		
		}										
    } 	
});//	FIN VALIDACIONES DE REPORTES


 function funcionExitoLimitesTarjetas (){
	 $('#tipoTarjetaDebID').focus();
	 $('#descripcion').val('');
	 $('#montoDisDia').val('');
	 $('#montoDisMes').val('');
	 $('#montoComDia').val('');
	 $('#montoComMes').val('');
	 $('#bloqueoATM').val('');
	 $('#bloqueoPOS').val('');
	 $('#bloqueoCash').val('');
	 $('#operacionMoto').val('');
	 $('#numeroDia').val('');
	 $('#numConsultaMes').val('');
}
 function funcionErrorLimitesTarjetas (){
	 $('#descripcion').val('');
	 $('#montoDisDia').val('');
	 $('#montoDisMes').val('');
	 $('#montoComDia').val('');
	 $('#montoComMes').val('');
	 $('#bloqueoATM').val('');
	 $('#bloqueoPOS').val('');
	 $('#bloqueoCash').val('');
	 $('#operacionMoto').val('');
	 $('#numeroDia').val('');
	 $('#numConsultaMes').val('');
 }