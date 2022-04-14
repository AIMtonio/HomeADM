var huellaProductos = '';
var estatus ='';
var estatusISR ='';
var Var_TipoBeneficiario ='';

consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};



$(document).ready(function() {
	
	$("#inversionID").focus();
	
	
	// Definicion de Constantes y Enums	
	var esTab = true;
	var parametroBean = consultaParametrosSession();
	var diasBase = parametroBean.diasBaseInversion;
	var salarioMinimo = parametroBean.salMinDF; 
	var diaHabilSiguiente = '1'; // indica dia habil Siguiente
	var pusoFecha=0;

	//Validacion para mostrarar boton de calcular CURP Y RFC
	permiteCalcularCURPyRFC('generarc','generar',3);
	
	var catTipoTransaccionInversion = {
	  		'agrega'  :1,
	  		'modifica': 5
	};
	
	var catOperacFechas = {
  		'sumaDias'		:1,
  		'restaFechas'	:2
	};
	
	var catStatusInversion = {
	  		'alta':		'A',
	  		'cargada': 	'N',
	  		'pagada': 	'P',
			'cancelada':'C'
	};
		
	var catStatusCuenta = {
		'activa':	'A'
	};
	
	var catTipoConsultaInversion = {
			'principal' : 1
	};
	var catTipoConsultaTipoInversion = {
		'principal':1
	};
	var catTipoListaTipoInversion = {
		'tiposInverAct':5
	};	
		
	var catTipoListaCliente = {
			'principal': '1'
	};
	var catTipoListaCuentas = {
			'foranea': '2'
	};
	var catTipoConsultaCuentas = {
			'conSaldo': 5
	};
	var catTipoConsultaCliente = {
		'paraInversiones': 6
	};
	var catTipoListaInversion = {
		'principal': 1
	};			
	$(':text').focus(function() {	
	 	esTab = false;
	});	
	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};
	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	var esCliente 			='CTE';
	var esUsuario			='USS';
	$('#personasRelacionadas').hide();
	$('#inversionID').focus();
	$('#direccion').val('');	
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modificar', 'submit');
	validaEmpresaID();
	$('#fecha').html(parametroBean.fechaSucursal);
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	$.validator.setDefaults({
		
		submitHandler: function(event) {			
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','inversionID','exito','error');
			}
	});
	
	$('#fechaV').hide();	
	$('#agrega').click(function() {		 
		$('#tipoTransaccion').val(catTipoTransaccionInversion.agrega);
		$('#tipoTransaccion1').val("");
		
		
	});
	
	$('#modificar').click(function() {		 
		$('#tipoTransaccion').val(catTipoTransaccionInversion.modifica);
	
	});

	
	$('#inversionID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(!isNaN($('#inversionID').val())){
			validaInversion(this.id);			
		}
			
	
		if ($('#inversionID').val() == '0' ){			
			habilitaBoton('agrega', 'submit');
			habilita();
			$('#fechaV').hide();
			$('#fechaVenc').show();
			$('#beneficiarioSocio').attr('checked',true);
			$('#personasRelacionadas').hide();
		}
		else{
			deshabilitaBoton('agrega', 'submit');
		}
	});
		
	$('#inversionID').bind('keyup',function(e){		
			var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "nombreCliente";
			 camposLista[1] = "estatus";
			 parametrosLista[0] = $('#inversionID').val();			
			 parametrosLista[1] = catStatusInversion.alta;
			
			lista('inversionID', 2, catTipoListaInversion.principal, camposLista,
					 parametrosLista, 'listaInversiones.htm');
	});
	
	
	$('#clienteID').bind('keyup',function(e){ 
		lista('clienteID', '2', '14', 'nombreCompleto',
										$('#clienteID').val(), 'listaCliente.htm');
	});
		
	$('#clienteID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		var cliente = $('#clienteID').asNumber();
		if(cliente>0){
			listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
			consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);
			if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
				expedienteBean = consultaExpedienteCliente($('#clienteID').val());
				if(expedienteBean.tiempo<=1){
					if(alertaCte(cliente)!=999){
						consultaCliente($('#clienteID').val());
					}
				} else {
					mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
					exito();// para limpiar la forma
					$('#clienteID').focus();
				}
			} else {
				mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				exito();// para limpiar la forma
				$('#clienteID').focus();
			}
		}	
	});
	
	
	$('#cuentaAhoID').blur(function(){
		consultaCtaAho();
	});
	
	$('#cuentaAhoID').bind('keyup',function(e){
		
        var camposLista = new Array();
        var parametrosLista = new Array();
        camposLista[0] = "clienteID";
        parametrosLista[0] = $('#clienteID').val();
        
        lista('cuentaAhoID', 1, catTipoListaCuentas.foranea, camposLista,
        			parametrosLista, 'cuentasAhoListaVista.htm');
	});	
	$('#tipoInversionID').blur(function() {
		if(esTab){
			validaTipoInversion($('#tipoInversionID').val(),'',false);
		}
	});
			
	$('#tipoInversionID').bind('keyup',function(e){
		
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "monedaId";
		 camposLista[1] = "descripcion";
		 parametrosLista[0] = $('#monedaID').val();
		 parametrosLista[1] = $('#tipoInversionID').val();
		
		lista('tipoInversionID', 2, catTipoListaTipoInversion.tiposInverAct, camposLista,
				 parametrosLista, 'listaTipoInversiones.htm');
	});
		

/****** Controles principales *****************/
	$('#monto').blur(function(){	
		if($('#monto').asNumber() <= $('#totalCuenta').asNumber()){
			pusoFecha=2;
			CalculaValorTasa('monto');	
			$('#valorGat').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		}else{ 
			mensajeSis("El Monto de Inversión es superior al Saldo en la Cuenta.");
			$('#monto').focus();							
			$('#monto').val('');
		}
	});
	$('#plazo').blur(function(){
		if($('#plazo').asNumber()>0){
			if($('#monto').asNumber() <= $('#totalCuenta').asNumber()){
				CalculaValorTasa('monto');	
			}
		}
	});

	$('#plazo').change(function(){
		if($('#fechaInicio').val()!= ''){				
			if($('#plazo').val() != 0){
				var opeFechaBean = {
					'primerFecha':parametroBean.fechaSucursal,
					'numeroDias':$('#plazo').val()
				};
				operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.sumaDias,
																		  function(data) {
					if(data!=null){						
						$('#fechaVencimiento').val(data.fechaResultado);
						pusoFecha=1;
						//Calcula la Fecha Habil y la Tasa de Inversion
						fechaHabil($('#fechaVencimiento').val(), 'plazo');				
					}else{
						mensajeSis("A ocurrido un error Interno al Consultar Fechas...");
					}
				});
			}			
		}else{
			mensajeSis("Error al Consultar la Fecha de la Sucursal.");
			$('#inversionID').focus();
		}
		
	});	
		
	$('#fechaVencimiento').change(function(){
		if($('#fechaInicio').val()!= ''){				
			if($('#fechaVencimiento').val() != ''){
				var fechax=parametroBean.fechaSucursal;
				if(esFechaValida($('#fechaVencimiento').val())){
					if($('#fechaVencimiento').val()< fechax){
						mensajeSis('La Fecha de Vencimiento no puede ser Menor a la fecha Actual.');
						$('#fechaVencimiento').val("");
						$('#fechaVencimiento').focus();
						$('#plazo').val("");
					}else{
						fechaHabil($('#fechaVencimiento').val(), 'fechaVencimiento');
					}
				}else{
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').val('');
					$('#plazo').val('');					
				}
			}
		}else{
			mensajeSis("Error al Consultar la Fecha de la Sucursal.");
			$('#inversionID').focus();
			$('#inversionID').select();
		}
	});
	$('#beneficiarioSocio').click(function() {
		$('#personasRelacionadas').hide();
	});
	$('#beneficiarioInver').click(function() {
		if($('#inversionID').val()>0){
			inicializaForma('formaGenerica2','');
			$('#personasRelacionadas').show();					
		}else{
			$('#personasRelacionadas').hide();
		}
			consultaBeneficiariosGrid();
	});
	
	
	
	$('#tasaISR').blur(function() {		
		$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		});
		
		$('#tasaNeta').blur(function() {		
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		});
		
		$('#tasa').blur(function() {		
		$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		});
		
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required',
			cuentaAhoID: 'required',
			tipoInversionID: 'required',
			monto: {
					required: true,
					number:true
			},
			plazo: 'required',
			fechaVencimiento: 'required'
				
		},
		
		messages: {
			clienteID: 'Especifique número de '+$('#socioCliente').val()+'',
			cuentaAhoID: 'Especifique la cuenta del '+$('#socioCliente').val()+'',
			tipoInversionID:'Especifique el tipo de Inversión',
			monto: {
				required: 'Especifique la cantidad a invertir',
				number:'Sólo Números'
			},
			plazo:'Especifique el plazo de la inversión',
			fechaVencimiento:'Especifique la fecha de vencimiento'
		}
		
	});
	
	//funciones controles
	function fechaHabil(fechaPosible, idControl){
		var diaFestivoBean = {
				'fecha':fechaPosible,
				'numeroDias':0,
				'salidaPantalla':'S'
		};
		diaFestivoServicio.calculaDiaFestivo(1,diaFestivoBean, function(data){
				if(data!=null){
					$('#fechaVencimiento').val(data.fecha);
					var opeFechaBean = {
						'primerFecha':$('#fechaVencimiento').val(),
						'segundaFecha': parametroBean.fechaSucursal
					};
					operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.restaFechas, function(data){
						if(data!=null){
							$('#plazo').val(data.diasEntreFechas);
							CalculaValorTasa(idControl);
						}else{
							mensajeSis("A ocurrido un error Interno al Consultar Fechas...");
						}
					});
				}else{
					mensajeSis("A ocurrido un error al calcular Dias Festivos..."); 
				}
		});
		
	}
		
	function validaInversion(idControl){
		var jqInversion = eval("'#" + idControl + "'");
		var numInversion = $(jqInversion).val();
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modificar', 'submit');
		if(numInversion == '0'){
			habilitaBoton('agrega', 'submit');
			inicializaForma('formaGenerica','inversionID');			
			$('#fechaInicio').val(obtenDia());
		}else{
				if(numInversion != 0 && numInversion != ''){
				
					if(esTab){
					var InversionBean = {
							'inversionID' : numInversion
					};
					inversionServicioScript.consulta(catTipoConsultaInversion.principal, InversionBean, function(inversionCon){
						if(inversionCon!=null){
							estatus = inversionCon.estatus;
							$('#estatusInversion').val(inversionCon.estatus);
							dwr.util.setValues(inversionCon);							
							Var_TipoBeneficiario	=inversionCon.beneficiario;
							if(estatus == catStatusInversion.cargada){														
								mensajeSis("La Inversión ha sido cargada a cuenta y no puede ser Modificada.");
								$('#fechaV').show();
								$('#fechaVenc').hide();
								$('#fechaVenci').val($('#fechaVencimiento').val());
								deshabilita();
								$('#inversionID').focus();
								$('#inversionID').select();
								$('#personasRelacionadas').hide();
							}else if(estatus == catStatusInversion.cancelada){														
								mensajeSis("La Inversión ha sido cancelada y no puede ser Modificada.");
								$('#fechaV').show();
								$('#fechaVenc').hide();
								$('#fechaVenci').val($('#fechaVencimiento').val());
								deshabilita();
								$('#inversionID').focus();
								$('#inversionID').select();
								$('#personasRelacionadas').hide();
							}else if(estatus == catStatusInversion.pagada){														
								mensajeSis("La Inversión ya fue Pagada (Abonada a Cuenta).");							
								$('#fechaV').show();
								$('#fechaVenc').hide();
								$('#fechaVenci').val($('#fechaVencimiento').val());
								deshabilita();								
								$('#inversionID').focus();
								$('#inversionID').select();
								$('#personasRelacionadas').hide();
							}
		
							consultaCtaAho();
							consultaCliente(inversionCon.clienteID);
							
  							validaTipoInversion(inversionCon.tipoInversionID, inversionCon.reinvertir, true);
  							$('#telefono').setMask('phone-us');
							if(estatus == catStatusInversion.alta){
								if(inversionCon.fechaInicio != parametroBean.fechaSucursal){														
									mensajeSis("La Inversión no es del Día de Hoy.");
									$('#fechaV').show();
									$('#fechaVenc').hide();
									$('#fechaVenci').val($('#fechaVencimiento').val());
									$('#inversionID').focus();
									$('#inversionID').select();
									deshabilita();
									deshabilitaBoton('modificar','submit');	
									$('#personasRelacionadas').hide();
								}else{
									varError = 0;					
									habilitaBoton('modificar', 'submit');
									habilita();
									$('#fechaV').hide();
									$('#fechaVenc').show();	
									
									if(inversionCon.beneficiario == 'I'){ // se muestra si los beneficiarios son propios de la inversion
										$('#personasRelacionadas').show();
										consultaBeneficiariosGrid();									
									}else{
										$('#personasRelacionadas').hide();
									}
								}
								
								
							}// alta																					
							estatusISR = inversionCon.estatusISR; //AVELASCO
							inicializaForma('formaGenerica2','');	
							deshabilitaBoton('guardarBen','submit');
							deshabilitaBoton('modificarBen','submit');
							deshabilitaBoton('eliminarBen','submit');
							$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							$("#inversionIDBen").val($("#inversionID").val());
							$("#clienteIDBen").val(inversionCon.clienteID);
							$('#telefono').setMask('phone-us');
							agregaFormatoControles('formaGenerica');
						}else{
							mensajeSis("No Existe la Inversión Seleccionada.");
							$('#inversionID').focus();
							$('#inversionID').val('');								
						}						
					});
				}
			}	
		}		
	}
	
	function consultaCliente(numCliente) {				
		setTimeout("$('#cajaLista').hide();", 200);	
		var rfc = ' ';
		var NOPagaISR = 'N';
		if(numCliente!='0'){
			if(numCliente != '' && !isNaN(numCliente)){
				clienteServicio.consulta(catTipoConsultaCliente.paraInversiones,numCliente,rfc,function(cliente){
							if(cliente!=null){
								$('#clienteID').val(cliente.numero);
								$('#nombreCompleto').val(cliente.nombreCompleto);
										if(cliente.esMenorEdad == "N"){
											$('#telefono').val(cliente.telefonoCasa);
											$('#telefono').setMask('phone-us');
											if(cliente.pagaISR == NOPagaISR){
												$('#tasaISR').val(0);
												$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});

											}else{
												$('#tasaISR').val(parametroBean.tasaISR);
												$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});

											}		
										
											consultaDireccion(cliente.numero);
											consultaHuellaCliente();
										}else{
											mensajeSis("El "+$('#socioCliente').val()+" es Menor de Edad.");
											$('#clienteID').focus();
											$('#clienteID').val('');
											$('#nombreCompleto').val('');
											$('#direccion').val('');
											$('#telefono').val('');
										}
								}else{
									mensajeSis("El "+$('#socioCliente').val()+" No Existe.");
									$('#clienteID').focus();
									$('#clienteID').val('');
									$('#nombreCompleto').val('');
									$('#direccion').val('');
									$('#telefono').val('');
								}
					});
				}
		}
	}
	
	function consultaDireccion(numCliente) {		
		setTimeout("$('#cajaLista').hide();", 200);
		var conOficial = 3;
		var direccionCliente = {
  			'clienteID':numCliente
		};
		
			if(numCliente != '' && !isNaN(numCliente)){
				direccionesClienteServicio.consulta(conOficial,direccionCliente,function(direccion) {
						if(direccion!=null){	
							$('#direccion').val(direccion.direccionCompleta);
								consultaEstatusCliente('clienteID');
							
						}else{
							$('#direccion').val('');
						}			
				});
			}
	}
	
		
	function consultaCtaAho() {
		setTimeout("$('#cajaLista').hide();", 200);
		var numCta = $('#cuentaAhoID').val();
		var CuentaAhoBeanCon = {
			'cuentaAhoID':numCta,
			'clienteID':$('#clienteID').val()
		};
		
     if(numCta != '' && !isNaN(numCta)){
          cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuentas.conSaldo,
          													CuentaAhoBeanCon, function(cuenta) {
        	  if(cuenta!=null){
        		  
        			var cte = $('#clienteID').asNumber();
					var client = parseFloat(cuenta.clienteID);

        			if (client != cte) {
							mensajeSis("La Cuenta no Corresponde con el Cliente.");
							$('#cuentaAhoID').focus();
							$('#cuentaAhoID').val("");
							$('#totalCuenta').val("");
						}else{
							
        		  if(cuenta.saldoDispon!=null){
            			$('#cuentaAhoID').val(cuenta.cuentaAhoID);
            			$('#totalCuenta').val(cuenta.saldoDispon);
                		$('#tipoMoneda').html(cuenta.descripcionMoneda);
                		$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
                		$('#monedaID').val(cuenta.monedaID); 
                		if(cuenta.estatus == catStatusCuenta.activa){
                			calculaCondicionesInversion();
                		}else{
	              			mensajeSis("La Cuenta no esta Activa.");
	              			$('#cuentaAhoID').focus();
	  		          		$('#cuentaAhoID').val('');	  
                		}   
                				
            	}else{
            		mensajeSis("La Cuenta no Existe.");
            		$('#totalCuenta').val("");
            		$('#cuentaAhoID').focus();
  					$('#cuentaAhoID').select();
            	}
            	
        	 }
    	  }else{
      		mensajeSis("La Cuenta no Existe.");
    		$('#totalCuenta').val("");
    		$('#cuentaAhoID').focus();
			$('#cuentaAhoID').val('');
    	  }
        });                                                                                                                        
     }
}	
	
	
	
	function validaTipoInversion(tipoInver, tipoReinvertir, esConsulta){
		setTimeout("$('#cajaLista').hide();", 200);
		var TipoInversionBean ={
			'tipoInvercionID' :tipoInver,
			'monedaId': $('#monedaID').val()
		};
		if(tipoInver != '' && !isNaN(tipoInver)){
			if(tipoInver != 0){
		
				tipoInversionesServicio.consultaPrincipal(catTipoConsultaTipoInversion.principal,
																		TipoInversionBean, function(tipoInversion){
			
					if(tipoInversion!=null){
						if((tipoInversion.estatus == 'I' && $('#estatusInversion').val() == 'A' && !esConsulta)
							|| (tipoInversion.estatus == 'I' && $('#inversionID').val() == 0 && !esConsulta)){
							$('#descripcion').val('');
							$('#tipoReinversion').val('');
							$('#tipoInversionID').val('');
							$('#tipoInversionID').focus();
							seleccionaTipoReinversion('');	
							mensajeSis("El Producto "+tipoInversion.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						}else{
							seleccionaTipoReinversion(tipoInversion.reinvertir);
							$('#descripcion').val(tipoInversion.descripcion);
							$('#tipoReinversion').val(tipoReinvertir);
							$('#tipoInversionID').val(tipoInversion.tipoInvercionID);
						}	
					}else{
						seleccionaTipoReinversion('');
						$('#descripcion').val('');
						mensajeSis("El Tipo de Inversión no Existe o no Corresponde con la Moneda de la Cuenta.");
						$('#tipoInversionID').focus();
						$('#tipoInversionID').val('');
					}
				});
			}
		}				
	}
	
	function seleccionaTipoReinversion(opcion){
		
		switch(opcion){
			case('C'):
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL' });
				break;
			case('CI'):
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions( "tipoReinversion", {'CI':'CAPITAL MAS INTERESES'});
				break;
			case('I'):
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL','CI':'CAPITAL MAS INTERESES'});
				break;
			case('N'):
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions( "tipoReinversion", {'N':'NO SE REALIZARÁ REINVERSIÓN'});
				break;
			default:
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions( "tipoReinversion", {'':'SELECCIONAR'});
		}
	}
		
		
	/* Funciones de validaciones y calculos*/
		
	function CalculaValorTasa(idControl){
		var jqControl = eval("'#" + idControl + "'");		
		var tipoCon = 4;	
		var cantidad = creaBeanTasaInversion();
		if(cantidad.monto <= $('#totalCuenta').asNumber()){
				if($('#plazo').val() != '' && $('#plazo').val() != 0
					 && $('#monto').val() != '' && $('#monto').val() != 0){
					var variables = creaBeanTasaInversion();
					tasasInversionServicio.consultaPrincipal(tipoCon,variables, function(porcentaje){
						if(porcentaje.conceptoInversion!=0){							
							$('#tasa').val(porcentaje.conceptoInversion);
							$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
							$('#valorGat').val(porcentaje.valorGat);
							$('#valorGatReal').val(porcentaje.valorGatReal);
							if(pusoFecha==0 && esTab==false){									
								$('#fechaVencimiento').focus();	
							}else if(pusoFecha==1 && esTab==false){
								$('#fechaVencimiento').focus();
							}else if(pusoFecha==2){
								$('#plazo').focus();
							}				
							pusoFecha=0;
							//Habilita los Botones de Grabar o Modificar
							if(!isNaN($('#inversionID').val())){
								if ($('#inversionID').asNumber()==0 && $('#inversionID').val() != ''){
									habilitaBoton('agrega', 'submit');
									habilita();
								}
							}							
							calculaCondicionesInversion();	
						}else{
							mensajeSis("No Existe una Tasa Anualizada.");
							$(jqControl).focus();							
							$('#fechaVencimiento').val('');
							$('#plazo').val('');
						}
					});
				}
		}else{
			mensajeSis("El Monto de Inversión es Superior al Saldo en la Cuenta.");
			$('#monto').focus();							
			$('#monto').select();
		}
	}
	
	
		
	function creaBeanTasaInversion(){
		var tasasInversionBean = {
				'tipoInvercionID' : $('#tipoInversionID').val(),
				'diaInversionID' : $('#plazo').val(),
				'monto' : $('#monto').asNumber()
		};
		return tasasInversionBean;
	}
	
	function calculaCondicionesInversion(){
		if(estatusISR != 'A'){
			var interGenerado;
			var interRetener;
			var interRecibir;
			var total;
			var tasa;
			tasa = $('#tasa').asNumber();
			if($('#tasaISR').asNumber() <= tasa) {
				$('#tasaNeta').val(tasa - $('#tasaISR').asNumber());
				$('#tasaISR').formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
			} else {
				$('#tasaNeta').val(0.00);
			}

			$('#tasaNeta').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});
			$('#tasaISR').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});
			$('#tasa').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});


			if(!isNaN(tasa) && tasa != '') {
				interGenerado = (($('#monto').asNumber() * tasa * $('#plazo').asNumber()) / (diasBase * 100)).toFixed(2);
			}

			interGenerado = (($('#monto').asNumber() * $('#tasa').asNumber() * $('#plazo').asNumber()) / (diasBase * 100)).toFixed(2);
			$('#interesGenerado').val(interGenerado);
			$('#interesGenerado').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});


			diasBase = parametroBean.diasBaseInversion;
			salarioMinimo = parametroBean.salMinDF;
			var salarioMinimoGralAnu = parametroBean.salMinDF * 5 * parametroBean.diasBaseInversion; // Salario minimo General Anualizado
			// SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF), 
			//entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
			// si no es CERO
			if($('#monto').asNumber() > salarioMinimoGralAnu || $('#tipoPersona').val() == 'M') {
				if($('#tipoPersona').val() == 'M'){
					interRetener = (($('#monto').asNumber() * $('#tasaISR').val() * $('#plazo').val()) / (diasBase * 100)).toFixed(2);
				}else{
					interRetener = ((($('#monto').asNumber() - salarioMinimoGralAnu) * $('#tasaISR').val() * $('#plazo').val()) / (diasBase * 100)).toFixed(2);
				}
				
			} else {
				interRetener = 0.00;
			}

			$('#interesRetener').val(interRetener);
			$('#interesRetener').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});

			interRecibir = interGenerado - interRetener;
			$('#interesRecibir').val(interRecibir);
			$('#interesRecibir').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});

			total = $('#monto').asNumber() + interRecibir;
			$('#granTotal').val(total);
			$('#granTotal').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});
		}
}
	
	
	function borra(){
		$('#plazo').val("0.00");
		$('#monto').val("0.00");
		$('#tasa').val("0.00");
		$('#fechaVencimiento').val("");
		$('#interesRetener').val("0.00");
		$('#tasaNeta').val("0.00");
		$('#interesRecibir').val("0.00");
		$('#interesGenerado').val("0.00");
	}
			
	function obtenDia(){
	    return parametroBean.fechaSucursal;	    	    
	}
	
	
	function deshabilita(){
		soloLecturaControl('clienteID');
		soloLecturaControl('cuentaAhoID');
		soloLecturaControl('tipoInversionID');
		soloLecturaControl('etiqueta');
		soloLecturaControl('monto');
		soloLecturaControl('plazo');
		soloLecturaControl('tipoReinversion');
	}
	
	
	function habilita(){
		$('#clienteID').attr('readOnly',false); 
		$('#cuentaAhoID').attr('readOnly',false); 
		$('#tipoInversionID').attr('readOnly',false); 
		$('#etiqueta').attr('readOnly',false); 
		$('#monto').attr('readOnly',false); 
		$('#plazo').attr('readOnly',false); 
		$('#tipoReinversion').attr('readOnly',false); 
		
	}
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea.");
				return false;
			}
			return true;
		}
	}
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
	// funcion que consuta el estatus del cliente
	function consultaEstatusCliente(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);	
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 1;

		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){
					$('#tipoPersona').val(cliente.tipoPersona);
					if($('#inversionID').val()==''||$('#inversionID').val()=='0'){
					  if (cliente.estatus=="I"){
							deshabilitaBoton('modificar','submit');
							deshabilitaBoton('agrega','submit');
							mensajeSis("El "+$('#socioCliente').val()+" se encuentra Inactivo.");
							deshabilitaControl('beneficiarioInver');
							deshabilitaControl('beneficiarioSocio');
							$('#clienteID').focus();
							$('#telefono').val('');
							$('#direccion').val('');
							$('#nombreCompleto').val('');
							$('#clienteID').val('');
							$('#tasaISR').val('');
//							inicializaForma('formaGenerica');
						}else{
							habilitaControl('beneficiarioInver');
							habilitaControl('beneficiarioSocio');
						}		
					}else{
						if (cliente.estatus=="I"){
							deshabilitaBoton('modificar','submit');
							deshabilitaBoton('agrega','submit');
							mensajeSis("El "+$('#socioCliente').val()+" se encuentra Inactivo.");
							deshabilitaControl('beneficiarioInver');
							deshabilitaControl('beneficiarioSocio');
							$('#inversionID').focus();
						}else{
							habilitaControl('beneficiarioInver');
							habilitaControl('beneficiarioSocio');
						}		
					}
				}else{
					mensajeSis("No Existe el "+$('#socioCliente').val()+".");
					$('#clienteID').val('');
					$('#nombreCliente').val('');
				}    	 						
			});
		}
	}	
	// función para consultar si el cliente ya tiene huella digital registrada
	function consultaHuellaCliente(){
		var numCliente=$('#clienteID').val();
		if(numCliente != '' && !isNaN(numCliente )){
			var clienteIDBean = { 
				'personaID':$('#clienteID').val()								
				};   			   	
			huellaDigitalServicio.consulta(1,clienteIDBean,function(cliente) {
				if (cliente==null){
					var huella=parametroBean.funcionHuella;
					if(huella =="S" && huellaProductos=="S"){
						mensajeSis("El Cliente no tiene Huella Registrada.\nFavor de Verificar.");
						$('#clienteID').focus();
						deshabilitaBoton('agrega','submit');
							}else{
								if($("#inversionID").val() == 0 && $("#inversionID").val() != ''){
									habilitaBoton('agrega','submit');
									}	else {
										deshabilitaBoton('agrega','submit');
										}
								}
						}else{
							if($("#inversionID").val() == 0 && $("#inversionID").val() != ''){
								habilitaBoton('agrega','submit');
							}else {
						deshabilitaBoton('agrega','submit');
					}
				}
			});
		}
	}

	//Consulta para ver si se requiere que el cliente tenga registrada su huella Digital
	function validaEmpresaID() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				if(parametrosSisBean.reqhuellaProductos !=null){
						huellaProductos=parametrosSisBean.reqhuellaProductos;
				}else{
					huellaProductos="N";
				}
			}
		});
	}

	/***********************************/
	//FUNCION PARA MOSTRAR O OCULTAR BOTONES CALCULAR CURP o RFC
	//PRIMER PARAMETRO ID BOTON CURP
	//SEGUNDO PARAMETRO ID BOTON RFC
	//TERCER PARAMETRO 1= SOLO CURP, 2= SOLO RFC, 3= AMBOS
	function permiteCalcularCURPyRFC(idBotonCURP,idBotonRFC,tipo) {
		var jqBotonCURP = eval("'#" + idBotonCURP + "'");
		var jqBotonRFC = eval("'#" + idBotonRFC + "'");
		var numEmpresaID = 1;
		var tipoCon = 17;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				//Validacion para mostrarar boton de calcular CURP Y RFC
				if(parametrosSisBean.calculaCURPyRFC == 'S'){
					if(tipo == 3){
						$(jqBotonCURP).show();
						$(jqBotonRFC).show();						
					}else{
						if(tipo == 1){
							$(jqBotonCURP).show();					
						}else{
							if(tipo == 2){
								$(jqBotonRFC).show();						
							}
						}
					}
				}else{
					if(tipo == 3){
						$(jqBotonCURP).hide();
						$(jqBotonRFC).hide();						
					}else{
						if(tipo == 1){
							$(jqBotonCURP).hide();					
						}else{
							if(tipo == 2){
								$(jqBotonRFC).hide();						
							}
						}
					}
				}
			}
		});
	}	
	
}); //fin document ready

function exito(){
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modificar', 'submit');
	inicializaForma('formaGenerica','inversionID');
	}
function error(){
	
}