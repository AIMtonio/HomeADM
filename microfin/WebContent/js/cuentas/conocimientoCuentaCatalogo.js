$(document).ready(function() {

	deshabilitaControl('defineUso');

	esTab = true;
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCta = {
  		'agrega':'1',
  		'modifica':'2'
	};
	
	var catTipoConsultaCta = {
  		'principal':1,
  		'foranea':2
	};

	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};
	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	consultaSPL = {
			'opeInusualID' : 0,
			'numRegistro' : 0,
			'permiteOperacion' : 'S',
			'fechaDeteccion' : '1900-01-01'
	};
	var esCliente 			='CTE';
	var esUsuario			='USS';
	$('#cuentaAhoID').focus();
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	deshabilitaBoton('modifica', 'submit');  
	deshabilitaBoton('agrega', 'submit');
   
	agregaFormatoControles('formaGenerica');
	
	if($('#flujoCliSolCue').val() != undefined){
		if(!isNaN($('#flujoCliSolCue').val())){
			var SolCuentaFlu = Number($('#flujoCliSolCue').val());
			if(SolCuentaFlu > 0){
				$('#cuentaAhoID').val($('#flujoCliSolCue').val());
				consultaCtaAho('cuentaAhoID');
		  		validaconocimientoCta('cuentaAhoID');
			}else{
				$('#cuentaAhoID').val();
				$('#cuentaAhoID').focus().select();
			}
		}
	}
	
   $(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
            submitHandler: function(event) { 
                    grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuentaAhoID', 'funcionExito', 'funcionError');
            }
   });		
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCta.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCta.modifica);
	});	
	
	//$('#agrega').attr('tipoTransaccion', '1');
	//$('#modifica').attr('tipoTransaccion', '2');
	
	$('#cuentaAhoID').blur(function() {
  		consultaCtaAho(this.id);
  		validaconocimientoCta(this.id);	
	});
	
	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
			
			parametrosLista[0] = $('#cuentaAhoID').val();
				
						
			lista('cuentaAhoID', '2', '3', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}				       
	});
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({				
		rules: {			
			cuentaAhoID: {
				required: true,			
			},
			depositoCred: {
				number:true,
				required: true,	
				maxlength:14
			},
			retirosCargo: {
				number:true,
				required: true,	
				maxlength:14
			},
			numDepositos : {
				number:true,
				required: true,	
				maxlength:14
			},
			frecDepositos : {
				number:true,
				required: true,	
				maxlength:3
			},
			numRetiros : {
				number:true,
				required: true,	
				maxlength:14
			},
			frecRetiros : {
				number:true,
				required: true,	
				maxlength:3
			}				
		},
		
		messages: {
			cuentaAhoID: {
				required: 'Especifique el Número de Cuenta'		
			},
			depositoCred: {
				number:'Sólo Números',
				required: 	'Especifique la Cantidad de Depósitos',
				maxlength:'Máximo 9 Carácteres'
			},		
			retirosCargo: {
				number:'Sólo Números',
				required:'Especifique la Cantidad de Retiros ',
				maxlength:'Máximo 9 Carácteres'
			},		
			numDepositos: {
				number:'Sólo Números',
				required:'Especifique el Número de Depósitos ',
				maxlength:'Máximo 9 Carácteres'
			},		
			frecDepositos: {
				number:'Sólo Números',
				required:'Especifique la Frecuencia de Depósitos ',
				maxlength:'Máximo 3 Carácteres'
			},		
			numRetiros: {
				number:'Sólo Números',
				required:'Especifique el Número de Retiros ',
				maxlength:'Máximo 9 Carácteres'
			},		
			frecRetiros: {
				number:'Sólo Números',
				required:'Especifique la Frecuencia de Retiros ',
				maxlength:'Máximo 3 Carácteres'
			}			
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	function validaconocimientoCta(idControl) {
		var jqnum  = eval("'#" + idControl + "'");
		var num = $(jqnum).val();
		var conPrincipal= 1;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(num != '' && !isNaN(num) && esTab){
			if(num=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','cuentaAhoID');
			} else {
				esTab=true;
					if(num != '' && !isNaN(num) && esTab){
						var numeroBeanCon = {
	  						'cuentaAhoID':num
						}; 
						conocimientoCtaServicio.consulta(conPrincipal,numeroBeanCon,function(conocimiento){
								if(conocimiento!=null){
									dwr.util.setValues(conocimiento);
									activarDesRadios(conocimiento.concentFondo, conocimiento.admonGtosIng,
										conocimiento.pagoNomina, conocimiento.ctaInversion, conocimiento.pagoCreditos,
										conocimiento.otroUso,conocimiento.recursoProv, conocimiento.recursoProvT,conocimiento.mediosElectronicos);		
										 habilitaBoton('modifica', 'submit');    
										 deshabilitaBoton('agrega', 'submit');
								}else{
									//mensajeSis("No hay Datos para este Numero");
									inicializaForma('formaGenerica','idControl'); 
									deshabilitaBoton('modifica', 'submit');  
									habilitaBoton('agrega', 'submit');	;
								}    						
						}); 
						
					}					
				}												
			}
	}


		function consultaCtaAho(control) {
		var numCta = $('#cuentaAhoID').val();
		var tipConCampos = 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCta != '' && !isNaN(numCta) && esTab) {
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, function(cuenta) {
				if (cuenta != null) {
					$('#tipoCuenta').val(cuenta.tipoCuentaID);
					$('#moneda').val(cuenta.monedaID);
					$('#cuentaAhoID').val(cuenta.cuentaAhoID);
					$('#numCliente').val(cuenta.clienteID);
					var cliente = $('#numCliente').asNumber();
					if (cliente > 0) {
						listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, cuenta.cuentaAhoID, 0);
						consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);
						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
							expedienteBean = consultaExpedienteCliente(cliente);
							if (expedienteBean.tiempo <= 1) {
								if (alertaCte(cliente) != 999) {
									consultaClientePantalla('numCliente');
									consultaTipoCuenta('tipoCuenta');
									consultaTipoMoneda('moneda');
								}
							} else {
								limpiaCampos();
								inicializaForma('formaGenerica', 'cuentaAhoID');
								$('#cuentaAhoID').focus();
								mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
								$('#cuentaAhoID').select();
							}
						} else {
							limpiaCampos();
							inicializaForma('formaGenerica', 'cuentaAhoID');
							$('#cuentaAhoID').focus();
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
							$('#cuentaAhoID').select();
						}
					}
				} else {
					mensajeSis("No Existe la cuenta de ahorro");
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').select();
				}
			});
		}
	}
	
	function consultaClientePantalla(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){		
							var tipo = (cliente.tipoPersona);
							if(tipo=="M"){
								$('#nombreCliente').val(cliente.razonSocial);
							}else{
								$('#nombreCliente').val(cliente.nombreCompleto);
							}			
																								
						}else{
							mensajeSis("No Existe el Cliente");
							$(jqCliente).focus();
						}    						
				});
			}
	}
	
	function consultaTipoCuenta(idControl) {
		var jqCuenta  = eval("'#" + idControl + "'");
		var numCuenta = $(jqCuenta).val();	
		var conCuenta =2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCuenta != '' && !isNaN(numCuenta)){
			var tiposCuentaBean = {					
					'tipoCuentaID' : numCuenta
				};
			tiposCuentaServicio.consulta(conCuenta,tiposCuentaBean,function(cuenta){
				
				if(cuenta!=null){	
					$('#tipoCuentaDescrip').val(cuenta.descripcion);
				}
			});

			}
	}
	
	function consultaTipoMoneda(idControl) {
		var jqMoneda  = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();	
		var conMoneda =2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda){
				if(moneda!=null){	
					$('#tipoMonedaDescrip').val(moneda.descripcion);
				}
			});

			}
	}
	
	
	
	function activarDesRadios(concentFond,admonGtos,pagoNom, 
						ctaInver, pagoCred,  otro, recursoProvP, recursoProvT, mediosElectronicos) { 
		if (concentFond == 'S'){
			$('#concentFondo').attr('checked', 'true');			
		}
		if (admonGtos == 'S'){
			$('#admonGtosIng').attr('checked', 'true');
		} 
		if (pagoNom == 'S'){
			$('#pagoNomina').attr('checked', 'true');
		}
		if (ctaInver == 'S'){
			$('#ctaInversion').attr('checked', 'true');
		} 
		if (pagoCred == 'S'){
			$('#pagoCreditos').attr('checked', 'true');
		}    
		if (otro == 'S'){
			$('#otroUso').attr('checked', 'true');
		} 
		if (recursoProvT == 'T'){
			$('#recursoProvT').attr('checked', 'true');
		}
		if (recursoProvP == 'P'){
			$('#recursoProvP').attr('checked', 'true');
		}
		
		if (mediosElectronicos == 'S'){
			$('#mediosElectronicos').attr('checked', 'true');
		}
	} 	
});
	function funcionExito(){
		inicializaForma('formaGenerica','cuentaAhoID');
		limpiaCampos();
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modifica', 'submit');	
	}
	function funcionError(){}
	function limpiaCampos(){
		$('#numCliente').val('');
		$('#nombreCliente').val('');
		$('#tipoCuenta').val('');
		$('#tipoCuentaDescrip').val('');
		$('#moneda').val('');
		$('#tipoMonedaDescrip').val('');
	}

	// Habilita imput otros usos 
	function habilitaImputConCheck(obj){
		if(obj.checked) 
			habilitaControl('defineUso');
		else 
			deshabilitaControl('defineUso'),
			$('#defineUso').val('');
	};
