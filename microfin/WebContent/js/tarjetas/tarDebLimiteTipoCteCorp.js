$(document).ready(function() {
	esTab = true;
	//Definicion de Constantes y Enums
	var catTipoTransaccionTipoTarjetaCte = {
			'agrega'		: '1',
			'modifica'		: '2'
	};
	var catTipoConsultaTipoTarjetaCteLim = {
	  		'contTipoTarjetaCte':2,
	};
	var catTipoConsultaTipoTarjeta = {
	  		'tipoTarjetaCte':1
	};
	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	$('#limitectecorporativo').hide();
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
	    			  'funcionExitoLimitesTarjetasCte','funcionErrorLimitesTarjetasCte');
	      }
	});

	$('#agrega').click(function() {		
			$('#tipoTransaccion').val(catTipoTransaccionTipoTarjetaCte.agrega);
	});
	
	$('#modifica').click(function() {	
			$('#tipoTransaccion').val(catTipoTransaccionTipoTarjetaCte.modifica);
	});	

	$('#tipoTarjetaDebID').blur(function(){
		validaTipoTarjetaDebito(this.id);
	});	

	$('#clienteCorpID').blur(function() {
		validaCteCorporativo(this.id);
	});

	$('#tipoTarjetaDebID').bind('keyup',function(e){
		lista('tipoTarjetaDebID', '1', '4', 'tipoTarjetaDebID', $('#tipoTarjetaDebID').val(), 'tipoTarjetasDevLista.htm');
	});

	$('#clienteCorpID').bind('keyup',function(e){
		lista('clienteCorpID', '1', '3', 'nombreCompleto', $('#clienteCorpID').val(), 'listaCliente.htm');
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
				required: true,
				number: true,
			},
			montoComDia: {
				required: true,
				number: true,
			},
			montoComMes: {
				required: true,
				number: true,
			},
			bloqueoATM: {
				required : true
			},
			bloqueoPOS: {
				required : true
			},
			bloqueoCash: {
				required : true
			},
			operacionMoto: {
				required : true
			},
			numeroDia: {
				required: true,
				number: true,
			},
			numConsultaMes: {
				required: true,
				number: true,
			},
			clienteCorpID: {
				required : true
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
			},
			numConsultaMes: {
		    	required: 'Especificar el Número de Consultas Mensual.',
				number: 'Sólo Números'
			},
			clienteCorpID:{
				required: 'Especificar un Cliente Corporativo.'
			}
		}
	});
		
	// ------------ Validaciones de Controles-------------------------------------
	function validaTipoTarjetaDebito(control) {
	var tipoTarjetaDeb = $('#tipoTarjetaDebID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(tipoTarjetaDeb != ''  && !isNaN(tipoTarjetaDeb) && esTab){
		var tipoTarjetaBeanCon = {	
  			'tipoTarjetaDebID':$('#tipoTarjetaDebID').val(),
		};
		tipoTarjetaDebServicio.consulta(catTipoConsultaTipoTarjeta.tipoTarjetaCte,tipoTarjetaBeanCon,function(tipoTarDeb) {
			if(tipoTarDeb!=null){
				dwr.util.setValues(tipoTarDeb);	
				if(tipoTarDeb.identificacionSocio=='S'){
					alert('El Tipo de Tarjeta es de Identificación.');
					limpiaForm($('#formaGenerica'));	
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('agrega', 'submit');
					$('#limitectecorporativo').hide();   
					$('#tipoTarjetaDebID').focus();
					$('#tipoTarjetaDebID').select();
					$('#bloqueoATM').val('');
					$('#bloqueoPOS').val('');
					$('#bloqueoCash').val('');
					$('#operacionMoto').val('');
				}
			}else{		
				alert("El Tipo de Tarjeta No Existe");
				limpiaForm($('#formaGenerica'));	
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('agrega', 'submit');
				$('#limitectecorporativo').hide();   
				$('#tipoTarjetaDebID').focus();
				$('#tipoTarjetaDebID').select();
				$('#bloqueoATM').val('');
				$('#bloqueoPOS').val('');
				$('#bloqueoCash').val('');
				$('#operacionMoto').val('');
			}
		});	
	}else if (tipoTarjetaDeb == '') {
		$('#descripcion').val('');
		$('#limitectecorporativo').hide();
		$('#tipoTarjeta').val('');
	}
		
	}
	function validaTipoTarjetaDebitoLim(control) {
	esTab=true;
	var numTarjetaDeb = $('#tipoTarjetaDebID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if(numTarjetaDeb != '' && !isNaN(numTarjetaDeb) && esTab){
		var tipoTarjetaBeanCon = { 
	  	'tipoTarjetaDebID':$('#tipoTarjetaDebID').val(),
		'clienteCorpID':$('#clienteCorpID').val()
	  			};
		tarDebLimiteTipoCteCorpServicio.consulta(catTipoConsultaTipoTarjetaCteLim.contTipoTarjetaCte,tipoTarjetaBeanCon,function(tipoTarDebCte) {
				if(tipoTarDebCte!=null){
					dwr.util.setValues(tipoTarDebCte);	
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
					$('#limitectecorporativo').show();
					}else{
						deshabilitaBoton('modifica', 'submit');
						habilitaBoton('agrega', 'submit');
						$('#limitectecorporativo').show();
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

	function validaCteCorporativo(idControl) {
		var jqCoorpo = eval("'#" + idControl + "'");
		var coorporativo = $(jqCoorpo).val();
		var consulTarCoorpo = 12;
		setTimeout("$('#cajaLista').hide();", 200);
		if ( coorporativo != '' && !isNaN(coorporativo) && esTab) {
			clienteServicio.consulta(consulTarCoorpo, coorporativo,"",function(cliente) {
				if (cliente != null) {
					$('#clienteCorpID').val(cliente.numero);
					$('#nombreClienteCorp').val(cliente.nombreCompleto);
					validaTipoTarjetaDebitoLim('clienteCorpID');
				} else {
					alert("El Cliente Corporativo No Existe");
					deshabilitaBoton('modifica', 'submit');
					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('agrega', 'submit');
					$('#limitectecorporativo').hide();   
					$('#clienteCorpID').focus();limitectecorporativo
					$('#clienteCorpID').val('');
					$('#nombreClienteCorp').val('');
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
		}else if(coorporativo == '') {
			$('#nombreClienteCorp').val('');			
			$('#limitectecorporativo').hide();
 		}
	}
});//	FIN VALIDACIONES DE REPORTES

function funcionExitoLimitesTarjetasCte (){
	 $('#tipoTarjetaDebID').focus();
	 $('#clienteCorpID').val('');
	 $('#nombreClienteCorp').val('');
	 $('#limitectecorporativo').hide(); 
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
	 $('#tipoTarjeta').val(''); 
}
function funcionErrorLimitesTarjetasCte (){
	 $('#tipoTarjetaDebID').focus();
	 $('#limitectecorporativo').hide(); 
}