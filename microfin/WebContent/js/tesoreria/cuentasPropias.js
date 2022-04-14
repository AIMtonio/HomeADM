var sobreGirado='';

$(document).ready(function (){
	esTab = true;
	parametros = consultaParametrosSession();
	$('#institucionEnvioID').focus();
	
	var catTipoConsultaInstituciones = {
	  		'principal':1, 
	  		'foranea':2
	};
	var catTipoTransCuentas = {
	  		'alta':1
	};
	
	var catTipoConsultaCentroCostos = {
			'foranea':2,			
		};
	
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$.validator.setDefaults({
        submitHandler: function(event) {
        	if ($('#monto').val() == 0){
        		mensajeSis('Inserte un monto a transferir');
        		$('#monto').focus();
        	}else{
        		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','polizaID','funcionExito','funcionError');
//        		$('#saldo').val('');
//        		$('#institucionEnvioID').val('');
        	}
        }
	});	
	
	agregaFormatoControles('formaGenerica');
	
	//------------ Metodos y Manejo de Eventos ----------
	// se consulta la lista de Instituciones al escribir en la caja
	$('#institucionEnvioID').bind('keyup',function(e){
    	lista('institucionEnvioID', '1', '1', 'nombre', $('#institucionEnvioID').val(), 'listaInstituciones.htm');
    });
    
	// si pierde el foco se consulta el nombre de la institucion
    $('#institucionEnvioID').blur(function() {
    	$('#numCtaInstitEnvio').val('');
		$('#saldo').val('');
		$('#monto').val('');
		$('#referencia').val('');
		$('#cCostosEnvio').val('');
		$('#nombCCostosEnvio').val('');
		$('#institucionRecibeID').val('');
		$('#institucionRecibeID').val('');
		$('#nombreinstitucionRecibeID').val('');
		$('#cCostosRecibe').val('');
		$('#nombCCostosRecibe').val('');
		$('#numCtaInstitRecibe').val('');
		habilitaBoton('grabar','submit');
    	consultaInstitucion(this.id);    
    	$('#impPoliza').hide();	 
    });
    
    
	$('#institucionRecibeID').bind('keyup',function(e){
    	lista('institucionRecibeID', '1', '1', 'nombre', $('#institucionRecibeID').val(), 'listaInstituciones.htm');
    });
	// si pierde el foco se consulta el nombre de la institucion
    $('#institucionRecibeID').blur(function() {
    	$('#numCtaInstitRecibe').val('');
    	$('#cCostosRecibe').val('');
    	$('#nombCCostosRecibe').val(''); 
    	consultaInstitucion(this.id);
    });
    
    // se obtiene la lista de las cuentas bancarias
    $('#numCtaInstitEnvio').bind('keyup',function(e){
    	var camposLista = new Array();
		var parametrosLista = new Array();
			camposLista[0] = "institucionID";
            parametrosLista[0] = $('#institucionEnvioID').val();
            camposLista[1] = "cuentaAhoID";
            parametrosLista[1] = $('#numCtaInstitEnvio').val();
                    
		lista('numCtaInstitEnvio', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');	       
    });
    // se consulta 
    $('#numCtaInstitEnvio').blur(function() {
		$('#monto').val('');
		$('#referencia').val('');
    	consultaCuentaBan(this.id);	
    });
    //Imprimir la poliza
	$('#impPoliza').click(function(){
		var poliza = $('#polizaID').val();	 
		var fecha = parametroBean.fechaSucursal;	
		window.open('RepPoliza.htm?polizaID='+poliza+'&fechaInicial='+fecha+
				'&fechaFinal='+fecha+'&nombreUsuario='+parametroBean.nombreUsuario);
	});	
    
    // se obtiene la lista de las cuentas bancarias
    $('#numCtaInstitRecibe').bind('keyup',function(e){
    	var camposLista = new Array();
		var parametrosLista = new Array();
			camposLista[0] = "institucionID";
            parametrosLista[0] = $('#institucionRecibeID').val();
            camposLista[1] = "cuentaAhoID";
            parametrosLista[1] = $('#numCtaInstitRecibe').val();
                    
		lista('numCtaInstitRecibe', '2', '2', camposLista,parametrosLista, 'tesoCargaMovLista.htm');	       
    });
    // se consulta 
    $('#numCtaInstitRecibe').blur(function() {    	
    	consultaCuentaBan(this.id);
    		
    });
    // Lista de centro de costos
	$('#cCostosEnvio').bind('keyup',function(e){
		lista('cCostosEnvio', '2', '1', 'descripcion', $('#cCostosEnvio').val(), 'listaCentroCostos.htm');
	});
	
	$('#cCostosRecibe').bind('keyup',function(e){
		lista('cCostosRecibe', '2', '1', 'descripcion', $('#cCostosRecibe').val(), 'listaCentroCostos.htm');
	});
    
	
	$('#monto').blur(function(){
		quitaFormatoMoneda('formaGenerica');
		var monto = parseFloat(this.value);
		var saldo = parseFloat($('#saldo').val());
		var cuenta = $('#numCtaInstitEnvio').val();
		var instEnvio = $('#institucionEnvioID').val();
		
		if (saldo != ''){
			var tipoConsulta = 9;
			var DispersionBeanCta = {
				'institucionID': instEnvio,
				'numCtaInstit': cuenta
			};
			if (cuenta != "" && !isNaN(cuenta) ){
				operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
					if(data!=null){
							sobreGirado = data.sobregirarSaldo;
							if(data.sobregirarSaldo=='N'){
								if (monto > saldo ) {
									mensajeSis('El Monto a Enviar Excede el Saldo Disponible');
									$('#monto').focus();
									$('#monto').val('');
									$('#saldo').formatCurrency({
										positiveFormat: '%n',
										roundToDecimalPlace: 2
										});
										$('#monto').formatCurrency({
														positiveFormat: '%n',
														roundToDecimalPlace: 2
										});
								}else if (monto == 0){
									$('#saldo').formatCurrency({
										positiveFormat: '%n',
										roundToDecimalPlace: 2
										});
									$('#monto').val('');
								}else{
									$('#saldo').formatCurrency({
													positiveFormat: '%n',
													roundToDecimalPlace: 2
									});
									$('#monto').formatCurrency({
													positiveFormat: '%n',
													roundToDecimalPlace: 2
									});
								}

							}
							
							else if (monto == 0){
								$('#saldo').formatCurrency({
									positiveFormat: '%n',
									roundToDecimalPlace: 2
									});
								$('#monto').val('');
								
							}else{
								$('#saldo').formatCurrency({
												positiveFormat: '%n',
												roundToDecimalPlace: 2
								});
								$('#monto').formatCurrency({
												positiveFormat: '%n',
												roundToDecimalPlace: 2
								});
							}
						
					}
				});
			}

		}
	});
	
    
	$('#grabar').click(function() {
			$('#tipoTransaccion').val(catTipoTransCuentas.alta);
	});
	
	 $('#cCostosEnvio').blur(function(){
	    	consultaCentroCostos('cCostosEnvio');
	   });
	 $('#cCostosRecibe').blur(function(){
	    	consultaCentroCostos2('cCostosRecibe');
	   });
		
	$('#formaGenerica').validate({
		rules: {
			institucionEnvioID: {
				required: true
			},
			institucionRecibeID: {
				required: true
			},
			numCtaInstitEnvio: {
				required: true
			},
			numCtaInstitRecibe: {
				required: true
			},			
			monto: {
				required: true
			},
			referencia: {
				required: true,
				maxlength: 150
			},
			cCostosEnvio:{
				required: true,
			},
			cCostosRecibe: {
				required: true,
			}
		},		
		messages: {
			institucionEnvioID: {
				required: 'Especifique el No. Institución Envío'
			},
			institucionRecibeID: {
				required: 'Especifique el No. Institución Recibe'
			},
			numCtaInstitEnvio: {
				required: 'Especifique el No. Cuenta '
			},
			numCtaInstitRecibe: {
				required: 'Especifique el No. Cuenta '
			},			
			monto: {
				required: 'Especifique el Monto'
			},
			referencia: {
				required: 'Especifique la Referencia',
				maxlength: 'Máximo 150 Caracteres'
			},			
			cCostosEnvio:{
				required: 'Especifique Centro de Costos'
			},
			cCostosRecibe: {
				required: 'Especifique Centro de Costos'
			}
		}		
	});
	
	
    //Método de consulta de Institución
    function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
				'institucionID':numInstituto
		};
 
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea, InstitutoBeanCon, function(instituto){
				if(instituto!=null){
					$('#nombre'+idControl).val(instituto.nombre);
					$('#nombreCortoInstitucion').val(instituto.nombreCorto);
					habilitaBoton('grabar','submit');
				}else{
					mensajeSis("No Existe la Institución");
					$(jqInstituto).focus();
					$(jqInstituto).val('');
					$('#nombre'+idControl).val('');
					deshabilitaBoton('grabar','submit');
				}
			});
		}else{
			$(jqInstituto).val('');
			
			$('#nombre'+idControl).val('');
			deshabilitaBoton('grabar','submit');
		}
	}
    
    // se consulta el nombre del banco de la cuenta bancaria 
    function consultaCuentaBan(idControl) {
		var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
		var jqInstitucion;
		setTimeout("$('#cajaLista').hide();", 200);
		if (idControl == 'numCtaInstitEnvio'){
			jqInstitucion = eval("'#institucionEnvioID'");
		}else{
			jqInstitucion = eval("'#institucionRecibeID'");
		}
		var tipoConsulta = 9;
		var DispersionBeanCta = {
			'institucionID': $(jqInstitucion).val(),
			'numCtaInstit': numCuenta
		};
		
		
		if (numCuenta != "" && !isNaN(numCuenta) ){
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#nombreBanco').val(data.nombreCuentaInst);
					if(idControl != 'numCtaInstitRecibe'){
						sobreGirado = data.sobregirarSaldo;
						if(data.sobregirarSaldo=='N'){
							if (data.saldoCuenta <= 0){
								mensajeSis('La Cuenta Seleccionada No Cuenta con Saldo Suficiente para realizar la Transferencia');
								$(jqCuentaBan).val('');
								$('#saldo').val('');
								$(jqCuentaBan).focus();
							}else{
								$('#saldo').val(data.saldoCuenta);
								$('#saldo').formatCurrency({
									positiveFormat: '%n',
									roundToDecimalPlace: 2
								});
							}
						}else {
							$('#saldo').val(data.saldoCuenta);
							$('#saldo').formatCurrency({
								
								roundToDecimalPlace: 2
							});
						}
					}
				}else{
					mensajeSis("No existe la cuenta indicada ");
					$(jqCuentaBan).val('');
				 	$(jqCuentaBan).focus();
				}
			});
		}else{
			$(jqCuentaBan).val('');
		}
		
	}
    
    
    function es_negativo(saldo) {
		if(sobreGirado=='S'){
    	  return (!isNaN(saldo) && saldo > 0) ? saldo : (saldo *(-1));
			}
		else{
		return saldo;
		}
    	}

       
    //funcion de consulta para obtener el nombre del centro de costos.
	function consultaCentroCostos(idControl) {
		var jqCentro = eval("'#" + idControl + "'");
		var numCentro = $(jqCentro).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var centroBeanCon = {
			'centroCostoID' : $('#cCostosEnvio').val()
		};
		if(numCentro != '' && !isNaN(numCentro)){
			centroServicio.consulta(catTipoConsultaCentroCostos.foranea,centroBeanCon,function(centro) {
				if(centro!=null){
					$('#nombCCostosEnvio').val(centro.descripcion);					
				}else{
					mensajeSis("No Existe el Centro de Costos");
					$('#cCostosEnvio').val('');
					$('#cCostosEnvio').focus();
					$('#nombCCostosEnvio').val("");
				}
			});
		}else{			
			$('#cCostosEnvio').val('');
			$('#nombCCostosEnvio').val('');
		}
	}	
	
	
	function consultaCentroCostos2(idControl) {
		var jqCentro = eval("'#" + idControl + "'");
		var numCentro = $(jqCentro).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var centroBeanCon = {
			'centroCostoID' : $('#cCostosRecibe').val()
		};
		if(numCentro != '' && !isNaN(numCentro)){
			centroServicio.consulta(catTipoConsultaCentroCostos.foranea,centroBeanCon,function(centro) {
				if(centro!=null){
					$('#nombCCostosRecibe').val(centro.descripcion);					
				}else{
					mensajeSis("No Existe el Centro de Costos");
					$('#cCostosRecibe').val('');
					$('#nombCCostosRecibe').val("");
				}
			});
		}else{		
			$('#cCostosRecibe').val('');
			$('#nombCCostosRecibe').val('');
		}
	}	
	
    
    
    
    
});


function funcionExito(){
	$('#impPoliza').show();
	$('#saldo').formatCurrency({
		positiveFormat: '%n',
		roundToDecimalPlace: 2
	});
	$('#monto').formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 2
	});
	 deshabilitaBoton('grabar','submit');
}

function funcionError(){
	$('#saldo').formatCurrency({
		positiveFormat: '%n',
		roundToDecimalPlace: 2
	});
	$('#monto').formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 2
	});
	$('#impPoliza').hide();
}

	
	var nav4 = window.Event ? true : false;
	function IsNumber(evt){
	
		// Backspace = 8, Enter = 13, ’0′ = 48, ’9′ = 57, ‘.’ = 46
		var key = nav4 ? evt.which : evt.keyCode;		
		return (key <= 13 || (key >= 48 && key <= 57) || key == 46 || key == 37);
	}