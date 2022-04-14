var parametroBean = consultaParametrosSession();
var diasBase = parametroBean.diasBaseInversion;
var salarioMinimo = parametroBean.salMinDF; 
var reinversion ='';
var reinvertir='';
var provCompetencia = '';
var calificacion = '';
var relaciones = '';
var generarFormatoAnexo=true;
var productoInvercamex=1;
var varMontoOriginal = 0;
var varTotalOriginal = 0;
var varPlazoOriginal = 0;
 

$(document).ready(function() {
	
	var esTab = false;
	
  	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#lblTipoReinversion').hide();
	// Incializacion de la Pantalla
	ocultaTasaVariable();
	deshabilitaBotones();
	$('#tdCajaRetiro').hide();
	$('#cedeID').focus();
	
	// Eventos de Pantalla
	$('#cedeID').bind('keyup',function(e){		
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCliente";		
		parametrosLista[0] = $('#cedeID').val();			
		lista('cedeID', 2, 12, camposLista, parametrosLista, 'listaCedes.htm');		
	});

	$('#cedeID').blur(function(){
		if(esTab){
			validaCede(this.id);	
		}
		agregaFormatoControles('formaGenerica');
		
	});

	$('#tipoPagoInt').blur(function() {
		if(esTab==true){
		var tipoPagoInt =$('#tipoPagoInt').val();
		muestraCampoDias(tipoPagoInt);
		}
	});

	$('#plazoOriginal').blur(function(){
		if(esTab){
			calculaTasas();
		}
	});
	$.validator.setDefaults({
		
		submitHandler: function(event) {			
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cedeID','Exito','Error');
			}
	});
	
	$('#simular').click(function() {
		if($('#cedeID').val() != ''){
			consultaSimulador();
		}else{
			mensajeSis("Especificar CEDE.");
			$('#cedeID').focus(); 		
			$('#contenedorSim').hide();
			$('#contenedorSimulador').hide();	
		}
	});

	$('#reinvertirVenSi').click(function(){
		$('#tipoReinversion').show();
		$('#lblTipoReinversion').show();
	});


	$('#reinvertirVenNo').click(function(){
		$('#tipoReinversion').hide();
		$('#lblTipoReinversion').hide();
		$('#reinvertir').val('N');
	});	
	$('#cajaRetiro').bind('keyup',function(e) {
		lista('cajaRetiro', '2', '6', 'nombreSucurs', $('#cajaRetiro').val(), 'listaSucursales.htm');
	});
	
	$('#cajaRetiro').blur(function() {
		consultaSucursalCAJA();
	});
	
	$('#formaGenerica').validate({
		rules: {
			cajaRetiro: {
				required: function() {
				return generarFormatoAnexo;
				}
			},
			diasPeriodo: {
				required : function() {return $('#tipoPagoInt').val() == 'P';}
			}
		},
		messages: {
			cajaRetiro: 'Especifique la Caja de Retiro',
			diasPeriodo: {
				required : 'Especifique el Número de Días de Periodo.'
			}
			
		}
	});
	
	$('#reinvertirBoton').click(function() {		 
		$('#tipoTransaccion').val('5');
		
	});

	$('#cancelar').click(function(){
		$('#tipoTransaccion').val('6');
	});
	
	$('#monto').blur(function() {
		if($('#monto').asNumber() <= varTotalOriginal) {
			calculaCondicionesCede();
		} else {
			if(esTab && $('#monto').asNumber() > varTotalOriginal) {
				mensajeSis('El Monto no Puede ser Mayor al Monto Disponible por Renovar $' + varTotalOriginal);
				$('#monto').val(varMontoOriginal);
				$('#cedeID').focus();
				calculaCondicionesCede();
				deshabilitaBotones();
			}
		}
	});
	
	$('#plazoOriginal').click(function(){
		calculaTasas();
		calculaCondicionesCede();
		
	});	


});

	// Funciones
	function validaCede(idControl){
		var jqCede = eval("'#" + idControl + "'");
		var numCede = $(jqCede).val();
		setTimeout("$('#cajaLista').hide();", 200);	

		var cedeBean = {
			'cedeID' : numCede
		};	
		if(numCede != '' && numCede > 0 && numCede != 0 && !isNaN(numCede)){
			cedesServicio.consulta(5, cedeBean,{ async: false, callback:function(cede){
					if(cede != null){
						comboListaPlazos(cede.tipoCedeID);
						$('#plazoOriginal').val(cede.plazoOriginal);
						inicializaSimulador();
						validaReinvertirCede(cede);
						consultaCliente();
						consultaCtaAho();
						consultaTipoCede(cede.tipoPagoInt,cede.diasPeriodo);
						consultaDireccion(cede.clienteID);
						calculaTasas();
						
						consultaSucursalCAJA();
						var montoConjunto= cede.montosAnclados;
						var montosAncla=montoConjunto - Number(cede.monto);
						var madre=montosAncla>0?true:false;
						if(cede.reinvertir=="CI"){
							montoConjunto = Number(montoConjunto) + Number(cede.interesRecibir);
						}
						
						if(madre){
							mensajeSis("El CEDE presenta Anclajes, el monto conjunto podrá reinvertirse o vencer.\n" +
									"Monto conjunto: "+formatoMonedaVariable(montoConjunto));
						}
						varPlazoOriginal = cede.plazoOriginal;
					}
					else{
									
					inicializaForma('formaGenerica','cedeID');
					deshabilitaBotones();
					$('#cedeID').val('');
					$('#interesGenerado').val('');
					$('#interesRetener').val('');
					$('#interesRecibir').val('');
					$('#cuentaAhoID').val('');
					$('#tipoCedeID').val('');
					mensajeSis("El CEDE no Existe o es CEDE Anclada.");
					$('#cedeID').focus();	
					$('#cedeID').val('');
					borra();
					setTimeout("$('#cedeID').focus();", 100);

						}
				}
			});
			
		}
	}

	function validaReinvertirCede(cede){
		$('#interesRecibirOrginal').val(cede.interesRecibir);
		$('#monto').val(cede.montosAnclados);
		$('#plazo').val(cede.plazo);
		$('#plazoOriginal').val(cede.plazoOriginal);
		$('#cuentaAhoID').val(cede.cuentaAhoID);
		$('#clienteID').val(cede.clienteID);
		$('#tipoCedeID').val(cede.tipoCedeID);
		$('#tipoPagoInt').val(cede.tipoPagoInt);
		$('#pagoIntCal').val(cede.pagoIntCal);
		$('#diasPeriodo').val(cede.diasPeriodo);
		$('#fechaInicio').val(parametroBean.fechaSucursal);	
		$('#estatus').val(cede.estatus);
		$("#cajaRetiro").val(cede.cajaRetiro);
		reinversion = cede.reinversion;
		reinvertir = cede.reinvertir;
		relaciones= cede.relaciones;


		$('#tipoReinversion option[value='+reinvertir+']').attr('selected','selected');


		if(cede.fechaVencimiento == $('#fechaInicio').val()){
			if(cede.estatus == 'N'){
				habilitaBotones();
			}
			else{
				if(cede.estatus == 'C'){
					mensajeSis('El CEDE se Encuentra Cancelada.');
					deshabilitaBotones();
				
				}
				else{
					if(cede.estatus == 'P'){
						mensajeSis('El CEDE ya Fue Pagada.');
						deshabilitaBotones();

					}		
				}
			}		
		}
		else{
			mensajeSis('El CEDE no Vence el Dia de Hoy.');
			deshabilitaBotones();
		}
	}

	function consultaCtaAho() {
		var numCta=$('#cuentaAhoID').val();
		var CuentaAhoBeanCon = {
			'cuentaAhoID':numCta,
			'clienteID':$('#clienteID').val()
		};
		if(numCta != '' && !isNaN(numCta)){
          cuentasAhoServicio.consultaCuentasAho(5,CuentaAhoBeanCon, { async: false, callback:function(cuenta) {
	          	if(cuenta!=null){
	          			$('#cuentaAhoID').val(cuenta.cuentaAhoID);
	          			$('#totalCuenta').val(cuenta.saldoDispon);
	              		$('#totalCuenta').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	              		$('#tipoMoneda').html(cuenta.descripcionMoneda);
	              		$('#tipoMonedaCede').html(cuenta.descripcionMoneda);
	              		$('#monedaID').val(cuenta.monedaID);

				if (reinversion=='S'){
							$('#reinvertirVenSi').attr("checked",true);
							$('#lblTipoReinversion').show();	
							$('#tipoReinversion').show();	
							$('#tipoReinversion').val(reinvertir);
							

							}
						else {
						

							$('#reinvertirVenNo').attr("checked",true);
						
						}
	              		if(cuenta.estatus != 'A'){
	            			mensajeSis("La Cuenta no esta Activa");
			          		$('#cuentaAhoID').focus();
							$('#cuentaAhoID').select();

	              		}else{
	              			var totalInversion = 0;
	              			if(reinversion == 'S'){
	              				if(reinvertir == 'C'){
	              					totalInversion = $('#monto').asNumber();
	              				}
	              				if(reinvertir == 'CI'){
	              					totalInversion = $('#monto').asNumber() + $('#interesRecibirOrginal').asNumber();
	              				}
	              			}
	              			else{
	              				if(reinversion == 'N' || reinversion == null){
	              					totalInversion = $('#monto').asNumber() + $('#interesRecibirOrginal').asNumber();	
	              				}
	              			}
	              			varMontoOriginal = totalInversion;
							$('#monto').val(totalInversion.toFixed(2));
							$('#monto').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
							$('#plazo').change();
	              		}              		
	          	}else{
	          		mensajeSis("La Cuenta no Existe");
	          		$('#totalCuenta').val("");
	          		$('#cedeID').focus();
					$('#cedeID').select();
	          	}
	          }
			});
		}	
	}
	
	function consultaTipoCede(tipoPagoInt, diasPeriodo){
		var tipoCede = $('#tipoCedeID').val();
		var conPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		
		var tipoCedeBean = {
                'tipoCedeID':tipoCede,               
        };		
			if(tipoCedeBean != 0){
				tiposCedesServicio.consulta(2, tipoCedeBean,{ async: false, callback:function(tipoCede){
						if(tipoCede!=null){
							$('#tasaFV').val(tipoCede.tasaFV);
							$('#descripcion').val(tipoCede.descripcion);
							$('#diaInhabil').val(tipoCede.diaInhabil);
							validaSabadoDomingo();
							evaluaReinversion(tipoCede.reinvertir,tipoCede.reinversion);
							if($('#tasaFV').val() == 'F'){
								ocultaTasaVariable();
							}else if($('#tasaFV').val() == 'V'){
								muestraTasaVariable();				
							}
							consultaComboTipoPagoReinvCon(tipoCede.tipoPagoInt,tipoPagoInt,tipoCede.diasPeriodo,diasPeriodo);
						}		
					}		
				});
			}
		}
	
	/**
	 * Función para consultar el Estatus del Tipo de Cede
	 */
	function consultaEstatusTipoCede(){
		var tipoCede = $('#tipoCedeID').val();
		var conGeneral = 2;
		setTimeout("$('#cajaLista').hide();", 200);
	
		var tipoCedeBean = {
            'tipoCedeID':tipoCede,               
    	};		
		if(tipoCedeBean != 0){
			tiposCedesServicio.consulta(conGeneral, tipoCedeBean,{ async: false, callback:function(tipoCede){
				if(tipoCede!=null){
					if(tipoCede.estatus == "I"){
						mensajeSis("No se puede reinvertir debido a que el Producto "+ tipoCede.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						$('#cedeID').focus();
						$('#cedeID').select();
						deshabilitaBoton('reinvertirBoton', 'submit');
						deshabilitaBoton('simular','submit');
					}
				}		
			}});
		}
	}
	
	
	// funcion que llena el combo de tipos de interes cuando se consulta el cede
	function consultaComboTipoPagoReinvCon(tipoPagoInt,valorTipoPagoInt,diasPeriodo,valorDiasPeriodo) {
		if (tipoPagoInt != null) {
			// se eliminan los tipos de pago que se tenian
			$('#tipoPagoInt').each(function() {
				$('#tipoPagoInt option').remove();
			});
			// se agrega la opcion por default
			$('#tipoPagoInt').append(
					new Option('SELECCIONAR', '', true, true));

			var tipoPago = tipoPagoInt.split(',');
			var tamanio = tipoPago.length; 
			
			for ( var i = 0; i < tamanio; i++) {
				var tipoPagoDescrip = '';

				switch (tipoPago[i]) {
				case "V": // AL VENCIMIENTO
					tipoPagoDescrip = 'AL VENCIMIENTO';
					break;
				case "F": // FIN MES
					tipoPagoDescrip = 'FIN DE MES';
					break;
				case "P":// PERIODO
					tipoPagoDescrip = 'POR PERIODO';
					break;
				default:
					tipoPagoDescrip = 'POR PERIODO';
				}
				$('#tipoPagoInt').append(
						new Option(tipoPagoDescrip, tipoPago[i], true,
								true));
				$('#tipoPagoInt').val(valorTipoPagoInt).selected = true;
				
			}
			
		}muestraCampoDiasReinvCon(valorTipoPagoInt,diasPeriodo,valorDiasPeriodo);
	}
	
	function muestraCampoDiasReinvCon(valorTipoPagoInt,diasPeriodo,valorDiasPeriodo){
		var valortipoPago  = eval("'" + valorTipoPagoInt + "'");
		var Periodo ='P';	
		var valor= valortipoPago.split(",");
		for(var i=0; i< valor.length; i++){
			var vartipoPagInt = valor[i];
			if(vartipoPagInt == Periodo){	
				$('#diasPeriodo').show();
				$('#lbldiasPeriodo').show();
			}else{
				$('#diasPeriodo').hide();
				$('#lbldiasPeriodo').hide();
			}
		}consultaComboDiasPerReinvCon(diasPeriodo,valorDiasPeriodo);
	} 
	
	// funcion que llena el combo de tipos de interes cuando se consulta el cede
	function consultaComboDiasPerReinvCon(diasPeriodo,valorDiasPeriodo) {
		if (diasPeriodo != null) {
			// se eliminan los tipos de pago que se tenian
			$('#diasPeriodo').each(function() {
				$('#diasPeriodo option').remove();
			});
			// se agrega la opcion por default
			$('#diasPeriodo').append(
					new Option('SELECCIONAR', '', true, true));

			var diasPer = diasPeriodo.split(',');
			var tamanio = diasPer.length; 
			
			for ( var i = 0; i < tamanio; i++) {
				var diasPerDescrip = '';
				diasPerDescrip = diasPer[i].concat(" Días");
				
				$('#diasPeriodo').append(
						new Option(diasPerDescrip, diasPer[i], true,
								true));
				$('#diasPeriodo').val(valorDiasPeriodo).selected = true;
			}
		}
	}

	function muestraCampoDias(tipoPagoInt){
		var tipoPago  = eval("'" + tipoPagoInt + "'");
		var Periodo ='P';	
		var valor= tipoPago.split(",");
		for(var i=0; i< valor.length; i++){
			var tipoPagInt = valor[i];
			if(tipoPagInt == Periodo){	
				$('#diasPeriodo').show();
				$('#lbldiasPeriodo').show();
				$('#diasPeriodo').focus();
			}else{
				$('#diasPeriodo').hide();
				$('#lbldiasPeriodo').hide();
			}
		}
	} 
	/* Valida el tipo de CEDES cuando se encuentre parametrizado dia inhábil: Sabado y Domingo
     * para que no se reinviertan CEDES el día Sábado */
	function validaSabadoDomingo(){
		var fecha = parametroBean.fechaSucursal;
		var diaInhabil = $('#diaInhabil').val();
		var cede = $('#cedeID').val();
		var fechaInicio = $('#fechaInicio').val();
		var estatus = $('#estatus').val();
		var sabDom	='SD';
		var noEsFechaHabil = 'N';
		var autorizado = 'N';
		var tipoCedeID = $('#tipoCedeID').val();
		
		var diaInhabilBean = {
				'fecha': fecha,
				'numeroDias': 0,
				'salidaPantalla':'S',
		};
		if (diaInhabil == sabDom && cede > 0 && fechaInicio == fecha && estatus == autorizado){
			var sabado = 'Sábado y Domingo';	
			diaFestivoServicio.calculaDiaFestivo(3,diaInhabilBean,function(data){
				if(data!=null){
					$('#esDiaHabil').val(data.esFechaHabil);
					if($('#esDiaHabil').val() == noEsFechaHabil){
						mensajeSis("El Tipo de CEDE " +tipoCedeID +  " Tiene Parametrizado Día Inhábil: " + sabado + 
								" por tal Motivo No se Puede Reinvertir el CEDE.");
						$('#cedeID').focus();
						$('#cedeID').select();
						$('#diaInhabil').val('');
						$('#esDiaHabil').val('');
						deshabilitaBoton('reinvertirBoton', 'submit');	
						deshabilitaBoton('cancelar', 'submit');	
						deshabilitaBoton('imprime', 'submit');	
						deshabilitaBoton('simular', 'submit');	
					}
				}
			});
		}		
	}
	
	function evaluaReinversion(reinvertir2,reinversion){
		dwr.util.removeAllOptions('tipoReinversion');
		if(reinversion == 'I'){
			habilitaControl('reinvertirVenSi');
			habilitaControl('reinvertirVenNo');	
			dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL','CI':'CAPITAL MAS INTERES'});
			if(reinvertir == 'I'){
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL','CI':'CAPITAL MAS INTERES'});
			}	
			if(reinvertir == 'C'){
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL'});
			}
			if(reinvertir == 'CI'){
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'CI':'CAPITAL MAS INTERES'});
			}
		}

		if(reinversion == 'S'){
			habilitaControl('reinvertirVenSi');
			deshabilitaControl('reinvertirVenNo');
			$('#reinvertirVenSi').attr("checked",true);
			$('#lblTipoReinversion').show();	
			$('#tipoReinversion').show();	
			if(reinvertir == 'I'){
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL','CI':'CAPITAL MAS INTERES'});
			}	
			if(reinvertir == 'C'){
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL'});
			}
			if(reinvertir == 'CI'){
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'CI':'CAPITAL MAS INTERES'});
			}

		}

		if(reinversion == 'N'){
			dwr.util.removeAllOptions('tipoReinversion');
			deshabilitaControl('reinvertirVenSi');		
			habilitaControl('reinvertirVenNo');
			$('#lblTipoReinversion').hide();	
			$('#tipoReinversion').hide();
			$('#reinvertirVenNo').attr("checked",true);	
		}
	}

	function consultaCliente() {		
		var numCliente = $('#clienteID').val();		
		var rfc = ' ';
		var NOPagaISR = 'N';
		
		if(numCliente!='0'){
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numCliente != '' && !isNaN(numCliente)){
				clienteServicio.consulta(6,numCliente,rfc,{ async: false, callback:function(cliente){
							if(cliente!=null){
								provCompetencia=cliente.provCompetencia;
								calificacion=cliente.calificaCredito;
								$('#nombreCompleto').val(cliente.nombreCompleto);
								$('#telefono').val(cliente.telefonoCasa);
								$('#telefono').setMask('phone-us');
								if(cliente.pagaISR == NOPagaISR){
									$('#tasaISR').val(0);
								}else{
									$('#tasaISR').val(parametroBean.tasaISR);
								}									
								$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});
							}else{
								mensajeSis("No Existe el Cliente");
								$('#clienteID').focus();
								$('#clienteID').val('');
								$('#nombreCompleto').val('');
								$('#direccion').val('');
								$('#telefono').val('');
							} 
						}   						
					});
				}
		}
	}

	function consultaDireccion(numCliente) {		
		var conOficial = 3;
		var direccionCliente = {
  			'clienteID':numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente)){
				direccionesClienteServicio.consulta(conOficial,direccionCliente,{ async: false, callback:function(direccion) {
						if(direccion!=null){	
							$('#direccion').val(direccion.direccionCompleta);
						}
					}
				});
			}
	}

	function calculaTasas(){
	$('#plazo').val('0');
		$('#fechaVencimiento').val('');
		if($('#fechaInicio').val()!= ''){				
			if($('#plazoOriginal').val() != 0){
				var opeFechaBean = {
					'primerFecha':parametroBean.fechaSucursal,
					'numeroDias':$('#plazoOriginal').val()
				};
				operacionesFechasServicio.realizaOperacion(opeFechaBean,1,
																		  function(data) {
					if(data!=null){						
						$('#fechaVencimiento').val(data.fechaResultado);
						fechaHabil($('#fechaVencimiento').val(), 'plazoOriginal');					
					}else{
						mensajeSis("A ocurrido un error Interno al Consultar Fechas...");
					}
				});
			}			
		}else{
			mensajeSis("Error al Consultar la Fecha de la Sucursal");
			$('#inversionID').focus();
		}
	}

	function fechaHabil(fechaPosible, idControl){
		var diaInhabil = $('#diaInhabil').val();
		var domingo = 'D';
		var sabDom	='SD';
		
		var diaFestivoBean = {
				'fecha': fechaPosible,
				'numeroDias': $('#plazo').val(),
				'sigAnt':'S'
		};
		
		if (diaInhabil == domingo){
		diaFestivoServicio.calculaDiaFestivo(1,diaFestivoBean, { async: false, callback: function(data){
				if(data!=null){
					$('#fechaVencimiento').val(data.fecha);
					var opeFechaBean = {
						'primerFecha':$('#fechaVencimiento').val(),
						'segundaFecha': parametroBean.fechaSucursal
					};
					operacionesFechasServicio.realizaOperacion(opeFechaBean,2, { async: false, callback: function(data){
						if(data!=null){
							$('#plazo').val(data.diasEntreFechas);
							CalculaValorTasa('monto', false);
						}else{
							mensajeSis("A ocurrido un error Interno al Consultar Fechas...");
						}
					  }
					});
				}else{
					mensajeSis("A ocurrido un error al calcular Dias Festivos..."); 
				}
		    }
		});
	}

	if (diaInhabil == sabDom){
		diaFestivoServicio.calculaDiaFestivo(3,diaFestivoBean, { async: false, callback: function(data){
				if(data!=null){
					$('#fechaVencimiento').val(data.fecha);
					var opeFechaBean = {
						'primerFecha':$('#fechaVencimiento').val(),
						'segundaFecha': parametroBean.fechaSucursal
					};
					operacionesFechasServicio.realizaOperacion(opeFechaBean,2, { async: false, callback: function(data){
						if(data!=null){
							$('#plazo').val(data.diasEntreFechas);
							CalculaValorTasa('monto', false);
						}else{
							mensajeSis("A ocurrido un error Interno al Consultar Fechas...");
						}
					  }
					});
				}else{
					mensajeSis("A ocurrido un error al calcular Dias Festivos..."); 
				}
		    }
		});
	}
	}

	/**
	 * Funciones de validaciones y calculos
	 * @param idControl id del control monto.
	 * @param consultaCedes Valor boleano que indica que la función fue llamada al consultar un CEDE existente.
	 * @author avelasco
	 */
	function CalculaValorTasa(idControl, consultaCedes){
		
		var jqControl = eval("'#" + idControl + "'");		
		var tipoCon = 2;	
		var cantidad = creaBeanTasaCede();
		
			
				if($('#plazo').val() != '' && $('#plazo').val() != 0 && $('#monto').val() != '' && $('#monto').val() != 0){
					var variables = creaBeanTasaCede();
					
					tasasCedesServicio.consulta(tipoCon,variables, { async: false, callback: function(porcentaje){

						if(porcentaje.tasaAnualizada !=0 && porcentaje.tasaAnualizada != null  || porcentaje.tasaBase>0 && porcentaje.tasaBase != null && esTab){	
							if($('#tasaFV').val()=='F' && porcentaje.tasaAnualizada>0){
								$('#tasaFija').val(porcentaje.tasaAnualizada);
								$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});	
								$('#tasa').val(porcentaje.tasaAnualizada);
								$('#calculoInteres').val('1');
								$('#tasaBaseID').val('0');
								$('#sobreTasa').val('0.0');
								$('#pisoTasa').val('0.0');
								$('#techoTasa').val('0.0');
								$('#valorTasaBaseID').val('0.0');
							
							}
							if($('#tasaFV').val()=='V' && porcentaje.tasaBase>0){
								$('#tasa').val(porcentaje.tasaAnualizada);
								$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});	
								$('#calculoInteres').val(porcentaje.calculoInteres);
								$('#tasaBaseID').val(porcentaje.tasaBase);
								$('#sobreTasa').val(porcentaje.sobreTasa);
								$('#pisoTasa').val(porcentaje.pisoTasa);
								$('#techoTasa').val(porcentaje.techoTasa);
								$('#valorTasaBaseID').val(porcentaje.tasaAnualizada);
								
								
								
								switch(porcentaje.calculoInteres){
								case('2'):
										$('#desCalculoInteres').val('TASA DE INICIO DE MES + PUNTOS');
									break;
								case('3'):
										$('#desCalculoInteres').val('TASA APERTURA + PUNTOS');
									break;
								case('4'):
										$('#desCalculoInteres').val('TASA PROMEDIO DEL MES + PUNTOS');
									break;
								case('5'):
										$('#desCalculoInteres').val('TASA DE INICIO DE MES + PUNTOS CON PISO Y TECHO');
									break;
								case('6'):
										$('#desCalculoInteres').val('TASA APERTURA + PUNTOS CON PISO Y TECHO');
									break;
								case('7'):
										$('#desCalculoInteres').val('TASA PROMEDIO DEL MES + PUNTOS CON PISO Y TECHO');
									break;

							}
							validaTasaBase(porcentaje.tasaBase);
						}
						
							
							
							$('#valorGat').val(porcentaje.valorGat);
							$('#valorGatReal').val(porcentaje.valorGatReal);
			
							if(!isNaN($('#cedeID').val())){
								if ($('#cedeID').asNumber()==0 ||$('#cedeID').val()==''){
									habilitaBoton('agrega', 'submit');
									habilita();
								}
							}
							if(!consultaCedes){
								inicializaValoresCamposInteres();	
							}
							consultaEstatusTipoCede();
						}else{
							mensajeSis("No existe una Tasa Anualizada");
							$('#cedeID').focus();							
							$('#fechaVencimiento').val('');
							$('#plazo').val('');
							deshabilitaBotones();
							$('#monto').val(varMontoOriginal);
							$('#plazoOriginal').val(varPlazoOriginal);
							
						}
				      }
					});
				}

	}

	function validaTasaBase(tasaBase){			
		var TasaBaseBeanCon = {
  			'tasaBaseID':tasaBase
		};

		tasasBaseServicio.consulta(1,TasaBaseBeanCon , { async: false, callback: function(tasasBaseBean) {
			if(tasasBaseBean!=null){
				$('#destasaBaseID').val(tasasBaseBean.nombre);
			}else{
				mensajeSis("No Existe la tasa base");									
				}
			}
		});

	}

	function calculaCondicionesCede(){
		var interGenerado = 0;
		var interRetener = 0;
		var interRecibir = 0;
		var total = 0;
		var tasa = 0;


		if($('#tasaFV').val()=='V'){
			tasa=$('#valorTasaBaseID').asNumber();
			interGenerado = (($('#monto').asNumber() * $('#valorTasaBaseID').asNumber() * $('#plazo').asNumber()) / (diasBase*100)).toFixed(2);
		}
		if($('#tasaFV').val()=='F'){
			tasa=$('#tasa').asNumber();
			interGenerado = (($('#monto').asNumber() * $('#tasa').asNumber() * $('#plazo').asNumber()) / (diasBase*100)).toFixed(2);
		}
				
		if($('#tasaISR').asNumber()<=tasa){
			$('#tasaNeta').val( tasa - $('#tasaISR').asNumber());
			$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});
		}else{
			$('#tasaNeta').val(0.00);
		}

		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});
		$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});
		$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});

		$('#interesGenerado').val(interGenerado);
		$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	

			
		salarioMinimo = parametroBean.salMinDF; 
		var salarioMinimoGralAnu = parametroBean.salMinDF * 5 * parametroBean.diasBaseInversion; // Salario minimo General Anualizado
		// SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF), 
		//entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
		// si no es CERO
		var tipoPersona = '';	
		clienteServicio.consulta(1,$('#clienteID').val(),{ async: false, callback:function(cliente){
			if(cliente!=null){
				tipoPersona = cliente.tipoPersona;
			}
		}});
				
		if($('#monto').asNumber()> salarioMinimoGralAnu || tipoPersona == 'M'){
			if(tipoPersona == 'M'){
				interRetener = (($('#monto').asNumber() * $('#tasaISR').val() * $('#plazo').val()) / (diasBase*100)).toFixed(2);
			}else{
				interRetener = ((($('#monto').asNumber()-salarioMinimoGralAnu ) * $('#tasaISR').val() * $('#plazo').val()) / (diasBase*100)).toFixed(2);	
			}			
		}else{
			interRetener = 0.00;
		}

		$('#interesRetener').val(interRetener);
		$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		
		interRecibir = interGenerado - interRetener;
		$('#interesRecibir').val(interRecibir);
		$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		
		total = $('#monto').asNumber() + interRecibir; 
		
		$('#granTotal').val(total);
		$('#granTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

		if($('#monto').asNumber() == varMontoOriginal  && $('#plazoOriginal').asNumber() == varPlazoOriginal) {
			varTotalOriginal = $('#granTotal').asNumber();
		}
		
	}
	

	function creaBeanTasaCede(){
		var tasasCedeBean = {
				'tipoCedeID' 	  : $('#tipoCedeID').val(),
				'plazo' 		  : $('#plazoOriginal').val(),
				'monto' 		  : $('#monto').asNumber(),	
				'provCompetencia' :  provCompetencia,
				'calificacion' 	  :  calificacion,
				'relaciones'	  :  relaciones,
				'sucursalID'  	  :  parametroBean.sucursal  
		};
		return tasasCedeBean;
	}

	function muestraTasaVariable(){		
		$('#tdlblCalculoInteres').show();
		$('#tdcalculoInteres').show();
		$('#tdlblTasaBaseID').show();
		$('#tdDesTasaBase').show();
		$('#trVariable1').show();
	}

	function ocultaTasaVariable(){
		$('#tdlblCalculoInteres').hide();
		$('#tdcalculoInteres').hide();
		$('#tdlblTasaBaseID').hide();
		$('#tdDesTasaBase').hide();
		$('#trVariable1').hide();
	}

	function deshabilitaBotones(){
		deshabilitaBoton('simular','submit');
		deshabilitaBoton('reinvertirBoton','submit');
		deshabilitaBoton('cancelar','submit');
		deshabilitaBoton('imprime','submit');
	}

	function habilitaBotones(){
		habilitaBoton('simular','submit');
		habilitaBoton('reinvertirBoton','submit');
		habilitaBoton('cancelar','submit');
	}

	function borra(){
		$('#plazoOriginal').val("");
		$('#plazo').val("");
		$('#tipoPagoInt').val("");
		$('#pagoIntCal').val("");		
		$('#diasPeriodo').hide();
		$('#diasPeriodo').val('');
		$('#lbldiasPeriodo').hide();
		$('#tasaFija').val("");
		$('#fechaVencimiento').val("");
		$('#interesRetener').val("");
		$('#tasaNeta').val("");
		$('#interesRecibir').val("");
		$('#interesGenerado').val("");
	}

	function inicializaSimulador(){
		$('#contenedorSimulador').html("");
		$('#contenedorSimulador').hide();
	}
	
	// Carga Grid, funcion para consultar el calendario de pagos de CEDE */
	function consultaSimulador(){

		var params = {};
		params['tipoLista']		= 2;
		params['fechaInicio']	= $('#fechaInicio').val();
		params['fechaVencimiento'] = $('#fechaVencimiento').val();
		params['monto']			= $('#monto').asNumber();
		params['clienteID']		= $('#clienteID').val();
		params['tipoCedeID']	= $('#tipoCedeID').val();
		params['tasaFija']		= $('#tasa').val();
		params['tipoPagoInt']	= $('#tipoPagoInt').val();
		params['pagoIntCal']	= $('#pagoIntCal').val();
		params['diasPeriodo']	= $('#diasPeriodo').val();
		
		if($('#clienteID').asNumber()>0){
			$.post("simuladorPagosCedes.htm", params, function(simular){
				
				if(simular.length >0) {			
					$('#contenedorSimulador').show();
					$('#contenedorSim').show();
					$('#contenedorSimulador').html(simular);
					// SE ACTUALIZAN LOS VALORES EN PANTALLA
					var varTotalFinal = $('#varTotalFinal').text();
					var varTotalInteres = $('#varTotalInteres').text();
					var varTotalISR = $('#varTotalISR').text();
					var varTotalCapital = $('#varTotalCapital').text();
					var varTotalInteresRecibir = Number(varTotalInteres) - Number(varTotalISR);
					
					$("#granTotal").val(formatoMonedaVariable(varTotalFinal,false));
					$("#interesGenerado").val(formatoMonedaVariable(varTotalInteres,false));
					$("#interesRetener").val(formatoMonedaVariable(varTotalISR,false));
					$("#interesRecibir").val(formatoMonedaVariable(varTotalInteresRecibir,false));
					// TOTALES DEL SIMULADOR
					$("#varTotalFinal").text(formatoMonedaVariable(varTotalFinal,true));
					$("#varTotalInteres").text(formatoMonedaVariable(varTotalInteres,true));
					$("#varTotalISR").text(formatoMonedaVariable(varTotalISR,true));
					$("#varTotalCapital").text(formatoMonedaVariable(varTotalCapital,true));
					
					agregaFormatoControles('formaGenerica');
				}else{
					$('#contenedorSimulador').html("");
					$('#contenedorSim').hide();
					$('#contenedorSimulador').hide();
					
				}
			});
		} else {
			mensajeSis("No se puede realizar la simulación, el Cliente esta vacío.");
		}
	}

		$('#imprime').click(function() {
		var cedeID = $('#cedeID').val();
		var monedaID = $('#monedaID').val();
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var monto =  $('#monto').val();
		var dirInst = parametroBean.direccionInstitucion;
		var usuario	= parametroBean.nombreUsuario;
		var sucursalID = parametroBean.sucursal;
		var nombreSucursal = parametroBean.nombreSucursal;
		var nombreCliente = $('#nombreCompleto').val();
		var cuentaAhoID = $('#cuentaAhoID').val();
		var descripcionTipoCede = $('#descripcion').val();
		var plazo = $('#plazo').val();
		var calculoInteres = $('#desCalculoInteres').val();
		var tasaBase = $('#destasaBaseID').val();
		var tasaISR = $('#tasaISR').val();
		var totalRecibir = $('#monto').val();
		var fechaVencimiento = $('#fechaVencimiento').val();
		var fechaApertura = $('#fechaInicio').val();
		var sobreTasa = $('#sobreTasa').val();
		var pisoTasa = $('#pisoTasa').val();
		var techoTasa = $('#techoTasa').val();
		var tasaNeta = $('#tasaNeta').val();
		var tasaFija = $('#tasaFija').val();
		var interesRecibir = $('#interesRecibir').val();
		var totalRec = $('#monto').asNumber();
		var nombreCaja = $('#cajaRetiro').val()+" "+$('#nombreCaja').val();
		var tipoProducto= "CEDE";
		
		if($('#tasaFV').val() == 'V'){
		
			var liga = 'pagareCedeRep.htm?cedeID='+cedeID +
						  '&monedaID=' + monedaID + 
						  '&nombreInstitucion=' + nombreInstitucion  + 
						  '&monto=' + monto+
						  '&direccionInstit='+dirInst+
						  '&nombreUsuario='+usuario+
						  '&sucursalID='+sucursalID+
						  '&nombreSucursal='+nombreSucursal+
						  '&nombreCompleto='+nombreCliente + 
						  '&cuentaAhoID='+cuentaAhoID+
						  '&descripcion='+descripcionTipoCede+
						  '&plazo='+plazo+
						  '&calculoInteres='+calculoInteres+
						  '&tasaBase='+tasaBase+
						  '&tasaISR='+tasaISR+
						  '&totalRecibir='+totalRecibir+
						  '&fechaVencimiento='+fechaVencimiento+
						  '&fechaApertura='+fechaApertura+
						  '&sobreTasa='+sobreTasa+
						  '&pisoTasa='+pisoTasa+
						  '&techoTasa='+techoTasa+
						  '&valorGat='+$('#valorGat').val()+
						  '&total='+totalRec;
			$('#enlace').attr('href',liga);
			if(generarFormatoAnexo){
				window.open('reporteAnexoPagareInv.htm?inversionID='+cedeID +
						  '&nombreInstitucion=' + nombreInstitucion  
						  +'&direccionInstit='+dirInst
						  +'&fechaVencimiento='+$('#fechaVencimiento').val()
						  +'&nombreSucursal='+nombreCaja
						  +'&tipoProducto='+tipoProducto
						  +'&domicilioInst='+dirInst,'_blank');
			}

		}else{
			var liga = 'pagareFijoCedeRep.htm?cedeID='+cedeID +
			  '&monedaID=' + monedaID +
			  '&nombreInstitucion=' + nombreInstitucion  + 
			  '&monto=' + monto
			  +'&direccionInstit='+dirInst+
			  '&nombreUsuario='+usuario+
			  '&sucursalID='+sucursalID+
			  '&nombreSucursal='+nombreSucursal+
			  '&nombreCompleto='+nombreCliente + 
			  '&cuentaAhoID='+cuentaAhoID+
			  '&descripcion='+descripcionTipoCede+
			  '&plazo='+plazo+
			  '&tasaISR='+tasaISR+
			  '&totalRecibir='+totalRecibir+
			  '&fechaVencimiento='+fechaVencimiento+
			  '&fechaApertura='+fechaApertura +
			  '&tasaNeta='+$('#tasaNeta').val()+
			  '&tasaFija='+$('#tasa').val()+
			  '&valorGat='+$('#valorGat').val()+
			  '&interesRecibir='+interesRecibir+
			  '&total='+totalRec;
			$('#enlace').attr('href',liga);
			if(generarFormatoAnexo){
				window.open('reporteAnexoPagareInv.htm?inversionID='+cedeID +
						  '&nombreInstitucion=' + nombreInstitucion  
						  +'&direccionInstit='+dirInst
						  +'&fechaVencimiento='+$('#fechaVencimiento').val()
						  +'&nombreSucursal='+nombreCaja
						  +'&tipoProducto='+tipoProducto
						  +'&domicilioInst='+dirInst,'_blank');
			}

		}

		
	});
	



function Exito(){
	$('#contenedorSimulador').html("");
	$('#contenedorSim').hide();
	$('#contenedorSimulador').hide();	
	$('#plazoOriginal').val('');
	$('#destasaBaseID').val('');
	$('#interesGenerado').val('');
	$('#interesRetener').val('');
	$('#interesRecibir').val('');
	$('#cuentaAhoID').val('');
	$('#tipoCedeID').val('');
	$('#tipoPagoInt').val('');
	$('#pagoIntCal').val("");
	$('#diasPeriodo').hide();
	$('#diasPeriodo').val('');
	$('#lbldiasPeriodo').hide();
	
	inicializaForma('formaGenerica', 'cedeID');
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('reinvertirBoton','submit');
	deshabilitaBoton('cancelar','submit');
	borra();
	if($('#tipoTransaccion').asNumber()==6){
		deshabilitaBoton('simular','submit');
		$('#cedeID').focus();
	} else {
		deshabilitaBoton('simular','submit');
		habilitaBoton('imprime','submit');
		$('#imprime').focus();
	}

	
}		

function Error(){
	agregaFormatoControles('formaGenerica');
	$('#cedeID').focus();
}


function consultaSucursalCAJA() {
	if(!ocultarCajaRetiro()){
		var numSucursal = $('#cajaRetiro').val();
		var tipoConsulta = 8;
		setTimeout("$('#cajaLista').hide();", 200);
		if (generarFormatoAnexo && numSucursal != '' && !isNaN(numSucursal)) {			
			sucursalesServicio.consultaSucursal(tipoConsulta,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#nombreCaja').val(sucursal.nombreSucurs);
					$('#cajaRetiro').val(numSucursal);
					
				} else {
					mensajeSis("La Sucursal No Cuenta con Ventanillas para el Retiro.");
					$('#nombreCaja').val('');
					$('#cajaRetiro').val('');
					$('#cajaRetiro').focus();
				}
			});
		}
	}
}

function ocultarCajaRetiro(){
	var tipoProducto=$('#tipoCedeID').asNumber();
	generarFormatoAnexo = true;
	if(tipoProducto == productoInvercamex){
		$('#tdCajaRetiro').hide();
		$('#nombreCaja').val('');
		$('#cajaRetiro').val('0');
		generarFormatoAnexo = false;
		return true;
	} else {
		$('#tdCajaRetiro').show();
	}
	return false;
}

function formatoMonedaVariable(numero){
	numero = Number(numero);
	return '$'+(numero.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
}

function comboListaPlazos(tipoCedeID){
	var varTipolista=1;		
	dwr.util.removeAllOptions('plazoOriginal');		
	dwr.util.addOptions( "plazoOriginal", {'':'SELECCIONAR'});
	if(tipoCedeID!='' ){
		var varBean = {
				'tipoInstrumentoID':28,
				'tipoProductoID' : tipoCedeID
		};
		plazosPorProductosServicio.lista(varTipolista, varBean ,{async: false, callback:function(plazosPorProductosConCaja){
			if(plazosPorProductosConCaja != null || plazosPorProductosConCaja != undefined){
				if (plazosPorProductosConCaja.length>0){	
					dwr.util.addOptions('plazoOriginal', plazosPorProductosConCaja,'plazo','plazo');					
				}else{
					mensajeSis('No Hay Plazos Registrados para este Tipo de CEDE');					
				}
			}else{
				mensajeSis('No Hay Plazos Registrados para este Tipo de CEDE');	
			}							  					  					  
		}});
	}else{
		mensajeSis('No se Establecio un Tipo de CEDE');
	}
}

/**
 * Inicializa los valores para el interés generado, a retener, recibido y el total a recibir.
 * Éstos campos se actualizan después de realizar la simulación.
 * @author avelasco
 */
function inicializaValoresCamposInteres(){
	$("#granTotal").val('0.00');
	$("#interesGenerado").val('0.00');
	$("#interesRetener").val('0.00');
	$("#interesRecibir").val('0.00');
}