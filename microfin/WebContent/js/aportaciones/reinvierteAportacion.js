var parametroBean = consultaParametrosSession();
var diasBase = parametroBean.diasBaseInversion;
var salarioMinimo = parametroBean.salMinDF;
var reinversion ='';
var reinvertir='';
var provCompetencia = '';
var calificacion = '';
var relaciones = '';
var generarFormatoAnexo=true;
var productoInvercamex=99999;
var varMontoOriginal = 0;
var varTotalOriginal = 0;
var varPlazoOriginal = 0;
var montoGlobal = 0;
var tasafijaOrig=0;
var perfilUsuario=parametroBean.perfilUsuario;
var perfilAutEspAport=0;
var banderaCometario=false;
var espTasa=false;

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
	$('#aportacionID').focus();

	// Eventos de Pantalla
	$('#aportacionID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCliente";
		parametrosLista[0] = $('#aportacionID').val();
		lista('aportacionID', 2, 12, camposLista, parametrosLista, 'listaAportaciones.htm');
	});

	$('#aportacionID').blur(function(){
		if(esTab){
			validaAportacion(this.id);
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
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','aportacionID','Exito','Error');
			}
	});

	$('#simular').click(function() {
		if($('#aportacionID').val() != ''){
			consultaSimulador();
		}else{
			mensajeSis("Especifique el Número de Aportación.");
			$('#aportacionID').focus();
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

	$('#tasa').blur(function(){
		if($('#tasa').val() != "" ){
			$('#tasa').val(truncaDosDecimales($('#tasa').val()));

		}
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
			},
			tasa:{
				required : function() {return $('#espTasa').val() == 'S';}
			}
		},
		messages: {
			cajaRetiro: 'Especifique la Caja de Retiro.',
			diasPeriodo: {
				required : 'Especifique el Número de Días de Periodo.'
			},
			tasa:{
				required : 'Especifique Tasa Bruta.'
			}

		}
	});

	$('#reinvertirBoton').click(function() {
		$('#tipoTransaccion').val('5');
		//si la tasa ingresada esta fuera de los limites especificados
		if(espTasa){
			var tasaMax=parseFloat(tasafijaOrig)+$('#maxPuntos').asNumber();
			var tasaMin=parseFloat(tasafijaOrig)-$('#minPuntos').asNumber();
			if($('#tasaFija').asNumber() > parseFloat(Number(tasaMax).toFixed(2)) ||
			   $('#tasaFija').asNumber() < parseFloat(Number(tasaMin).toFixed(2))){
				if(parseInt(perfilUsuario) != parseInt(perfilAutEspAport)){
					mensajeSis("Tasa fuera de los límites permitidos, la reinversión requiere Perfil Especial.");
					return false;
				}
			}

		}

	});

	$('#cancelar').click(function(){
		$('#tipoTransaccion').val('6');
	});

	$('#monto').blur(function() {
		if($('#monto').asNumber() <= varTotalOriginal) {
			consultaMontoGlobal();
			$('#montoGlobal').val(($('#monto').asNumber()+Number(montoGlobal)).toFixed(2));
			mostrarElementoPorClase('trMontoGlobal',Number(montoGlobal)>0);
			agregaFormatoControles('formaGenerica');
			calculaCondicionesAportacion();
		} else {
			if(esTab && $('#monto').asNumber() > varTotalOriginal) {
				mensajeSis('El Monto no Puede ser Mayor al Monto Disponible por Renovar $' + varTotalOriginal);
				$('#monto').val(varMontoOriginal);
				$('#aportacionID').focus();
				calculaCondicionesAportacion();
				deshabilitaBotones();
			}
		}
	});

	$('#plazoOriginal').click(function(){
		calculaTasas();
		calculaCondicionesAportacion();

	});


});

	// Funciones
	function validaAportacion(idControl){
		var jqAportacion = eval("'#" + idControl + "'");
		var numAportacion = $(jqAportacion).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var AportaBean = {
			'aportacionID' : numAportacion
		};
		if(numAportacion != '' && numAportacion > 0 && numAportacion != 0 && !isNaN(numAportacion)){
			aportacionesServicio.consulta(5, AportaBean,{ async: false, callback:function(aportacion){
					if(aportacion != null){
						comboListaPlazos(aportacion.tipoAportacionID);
						$('#plazoOriginal').val(aportacion.plazoOriginal);
						inicializaSimulador();
						validaReinvertirAportacion(aportacion);
						consultaCliente();
						consultaCtaAho();
						consultaTipoAportacion(aportacion.tipoPagoInt,aportacion.diasPeriodo);
						consultaDireccion(aportacion.clienteID);
						calculaTasas();
						mostrarElementoPorClase('trMontoGlobal',aportacion.tasaMontoGlobal);
						$('#montoGlobal').val(aportacion.montoGlobal);
						agregaFormatoControles('formaGenerica');

						consultaSucursalCAJA();
						var montoConjunto= aportacion.montosAnclados;
						var montosAncla=montoConjunto - Number(aportacion.monto);
						var madre=montosAncla>0?true:false;
						if(aportacion.reinvertir=="CI"){
							montoConjunto = Number(montoConjunto) + Number(aportacion.interesRecibir);
						}

						if(madre){
							mensajeSis("La Aportación presenta Anclajes, el monto conjunto podrá reinvertirse o vencer.\n" +
									"Monto conjunto: "+formatoMonedaVariable(montoConjunto));
						}
						varPlazoOriginal = aportacion.plazoOriginal;

						perfilAutEspAport=aportacion.perfilAutoriza;

						if(parseInt(aportacion.aportRenovada) > 0 ){
							// comentarios de la reinversión
							$('#comentAport').val('');
							aportacionesServicio.lista(16,AportaBean,function(comentarios){
								if(comentarios != null){
									comentarios.forEach(function(coment) {
										var aux=$('#comentAport').val();
										$('#comentAport').val(aux +""+ coment.desComentarios.toString()+"\n");
									});
									$('#tablaComentario').show();
								}else{
									$('#tablaComentario').hide();
								}
							});

						}else {
							$('#tablaComentario').hide();
							$('#comentAport').val('');
						}

					}
					else{

					inicializaForma('formaGenerica','aportacionID');
					deshabilitaBotones();
					$('#aportacionID').val('');
					$('#interesGenerado').val('');
					$('#interesRetener').val('');
					$('#interesRecibir').val('');
					$('#cuentaAhoID').val('');
					$('#tipoAportacionID').val('');
					mensajeSis("La Aportación no Existe o es Aportación Anclada.");
					$('#aportacionID').focus();
					$('#aportacionID').val('');
					borra();
					setTimeout("$('#aportacionID').focus();", 100);

						}
				}
			});

		}
	}

	function validaReinvertirAportacion(aportacion){
		$('#interesRecibirOrginal').val(aportacion.interesRecibir);
		$('#monto').val(aportacion.montosAnclados);
		$('#plazo').val(aportacion.plazo);
		$('#plazoOriginal').val(aportacion.plazoOriginal);
		$('#cuentaAhoID').val(aportacion.cuentaAhoID);
		$('#clienteID').val(aportacion.clienteID);
		$('#tipoAportacionID').val(aportacion.tipoAportacionID);
		$('#tipoPagoInt').val(aportacion.tipoPagoInt);
		$('#pagoIntCal').val(aportacion.pagoIntCal);
		$('#diasPeriodo').val(aportacion.diasPeriodo);
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		$('#estatus').val(aportacion.estatus);
		$("#cajaRetiro").val(aportacion.cajaRetiro);
		reinversion = aportacion.reinversion;
		reinvertir = aportacion.reinvertir;
		relaciones= aportacion.relaciones;


		$('#tipoReinversion option[value='+reinvertir+']').attr('selected','selected');


		if(aportacion.fechaVencimiento == $('#fechaInicio').val()){
			if(aportacion.estatus == 'N'){
				habilitaBotones();
			}
			else{
				if(aportacion.estatus == 'C'){
					mensajeSis('La Aportación se Encuentra Cancelada.');
					deshabilitaBotones();
					deshabilitaControl('tasa');
				}
				else{
					if(aportacion.estatus == 'P'){
						mensajeSis('La Aportación ya Fue Pagada.');
						deshabilitaBotones();
						deshabilitaControl('tasa');
					}
				}
			}
		}
		else{
			mensajeSis('La Aportación no Vence el Día de Hoy.');
			deshabilitaBotones();
			deshabilitaControl('tasa');
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
	              		$('#tipoMonedaAportacion').html(cuenta.descripcionMoneda);
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
	            			mensajeSis("La Cuenta no esta Activa.");
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
	          		mensajeSis("La Cuenta no Existe.");
	          		$('#totalCuenta').val("");
	          		$('#aportacionID').focus();
					$('#aportacionID').select();
	          	}
	          }
			});
		}
	}

	function consultaTipoAportacion(tipoPagoInt, diasPeriodo){
		var tipoAportacion = $('#tipoAportacionID').val();
		var conPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		var tipoAportaBean = {
                'tipoAportacionID':tipoAportacion,
        };
			if(tipoAportaBean != 0){
				tiposAportacionesServicio.consulta(2, tipoAportaBean,{ async: false, callback:function(tipoAportacion){
						if(tipoAportacion!=null){
							$('#tasaFV').val(tipoAportacion.tasaFV);
							$('#descripcion').val(tipoAportacion.descripcion);
							$('#diaInhabil').val(tipoAportacion.diaInhabil);
							validaSabadoDomingo();
							evaluaReinversion(tipoAportacion.reinvertir,tipoAportacion.reinversion);
							if($('#tasaFV').val() == 'F'){
								ocultaTasaVariable();
							}else if($('#tasaFV').val() == 'V'){
								muestraTasaVariable();
							}
							consultaComboTipoPagoReinvCon(tipoAportacion.tipoPagoInt,tipoPagoInt,tipoAportacion.diasPeriodo,diasPeriodo);
							$('#espTasa').val(tipoAportacion.especificaTasa);
							$('#maxPuntos').val(tipoAportacion.maxPuntos);
							$('#minPuntos').val(tipoAportacion.minPuntos);
							if (tipoAportacion.especificaTasa=='S') {
								espTasa=true;
							}else {
								espTasa=false;
							}
						}
					}
				});
			}
		}

	// funcion que llena el combo de tipos de interes cuando se consulta el aportacion
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

	// funcion que llena el combo de tipos de interes cuando se consulta el aportacion
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
	/* Valida el tipo de Aportaciones cuando se encuentre parametrizado dia inhábil: Sabado y Domingo
     * para que no se reinviertan Aportaciones el día Sábado */
	function validaSabadoDomingo(){
		var fecha = parametroBean.fechaSucursal;
		var diaInhabil = $('#diaInhabil').val();
		var aportacion = $('#aportacionID').val();
		var fechaInicio = $('#fechaInicio').val();
		var estatus = $('#estatus').val();
		var sabDom	='SD';
		var noEsFechaHabil = 'N';
		var autorizado = 'N';
		var tipoAportacionID = $('#tipoAportacionID').val();

		var diaInhabilBean = {
				'fecha': fecha,
				'numeroDias': 0,
				'salidaPantalla':'S',
		};
		if (diaInhabil == sabDom && aportacion > 0 && fechaInicio == fecha && estatus == autorizado){
			var sabado = 'Sábado y Domingo';
			diaFestivoServicio.calculaDiaFestivo(3,diaInhabilBean,function(data){
				if(data!=null){
					$('#esDiaHabil').val(data.esFechaHabil);
					if($('#esDiaHabil').val() == noEsFechaHabil){
						mensajeSis("El Tipo de Aportación " +tipoAportacionID +  " Tiene Parametrizado Día Inhábil: " + sabado +
								" por tal Motivo No se Puede Reinvertir la Aportación.");
						$('#aportacionID').focus();
						$('#aportacionID').select();
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
								mensajeSis("No Existe el Cliente.");
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
						mensajeSis("Ha ocurrido un error Interno al Consultar Fechas.");
					}
				});
			}
		}else{
			mensajeSis("Error al Consultar la Fecha de la Sucursal.");
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
							mensajeSis("Ha ocurrido un error Interno al Consultar Fechas.");
						}
					  }
					});
				}else{
					mensajeSis("Ha ocurrido un error al calcular Días Festivos.");
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
							mensajeSis("Ha ocurrido un error Interno al Consultar Fechas.");
						}
					  }
					});
				}else{
					mensajeSis("Ha ocurrido un error al calcular Días Festivos.");
				}
		    }
		});
	}
	}

	/**
	 * Funciones de validaciones y calculos
	 * @param idControl id del control monto.
	 * @param consultaAportaciones Valor boleano que indica que la función fue llamada al consultar un Aportación existente.
	 * @author avelasco
	 */
	function CalculaValorTasa(idControl, consultaAportaciones){
		var jqControl = eval("'#" + idControl + "'");
		var tipoCon = 2;
				if($('#plazo').val() != '' && $('#plazo').val() != 0 && $(jqControl).val() != '' && $(jqControl).val() != 0){
					var variables = creaBeanTasaAportacion();

					tasasAportacionesServicio.consulta(tipoCon,variables, { async: false, callback: function(porcentaje){
						if(porcentaje.tasaAnualizada !=0 && porcentaje.tasaAnualizada != null  || porcentaje.tasaBase>0 && porcentaje.tasaBase != null && esTab){
							if($('#tasaFV').val()=='F' && porcentaje.tasaAnualizada>0){
								$('#tasaFija').val(porcentaje.tasaAnualizada);
								$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
								$('#tasa').val(porcentaje.tasaAnualizada);
								$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
								$('#calculoInteres').val('1');
								$('#tasaBaseID').val('0');
								$('#sobreTasa').val('0.0');
								$('#pisoTasa').val('0.0');
								$('#techoTasa').val('0.0');
								$('#valorTasaBaseID').val('0.0');
								tasafijaOrig=$('#tasa').val();
								if($('#espTasa').val()=='S'){
									habilitaControl('tasa');
								}
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

							if(!isNaN($('#aportacionID').val())){
								if ($('#aportacionID').asNumber()==0 ||$('#aportacionID').val()==''){
									habilitaBoton('agrega', 'submit');
									habilita();
								}
							}
							if(!consultaAportaciones){
								inicializaValoresCamposInteres();
							}
						}else{
							mensajeSis("No existe una Tasa Anualizada.");
							$('#aportacionID').focus();
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
				mensajeSis("No Existe la tasa base.");
				}
			}
		});

	}

	function calculaCondicionesAportacion(){
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
		$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});

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


	function creaBeanTasaAportacion(){
		var tasasAportaBean = {
				'tipoAportacionID': $('#tipoAportacionID').val(),
				'plazo' 		  : $('#plazoOriginal').val(),
				'monto' 		  : (Number(montoGlobal)>0?$('#montoGlobal').asNumber():$('#monto').asNumber()),
				'provCompetencia' :  provCompetencia,
				'calificacion' 	  :  calificacion,
				'relaciones'	  :  relaciones,
				'sucursalID'  	  :  parametroBean.sucursal
		};
		return tasasAportaBean;
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
		ocultaMontoGlobal(true);
	}

	function inicializaSimulador(){
		$('#contenedorSimulador').html("");
		$('#contenedorSimulador').hide();
	}

	// Carga Grid, funcion para consultar el calendario de pagos de Aportación */
	function consultaSimulador(){

		var params = {};
		params['tipoLista']		= 2;
		params['fechaInicio']	= $('#fechaInicio').val();
		params['fechaVencimiento'] = $('#fechaVencimiento').val();
		params['monto']			= $('#monto').asNumber();
		params['clienteID']		= $('#clienteID').val();
		params['tipoAportacionID']	= $('#tipoAportacionID').val();
		params['tasaFija']		= $('#tasa').val();
		params['tipoPagoInt']	= $('#tipoPagoInt').val();
		params['pagoIntCal']	= $('#pagoIntCal').val();
		params['diasPeriodo']	= $('#diasPeriodo').val();

		if($('#clienteID').asNumber()>0){
			$.post("simuladorPagosAportaciones.htm", params, function(simular){

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
		var aportacionID		= $('#aportacionID').val();
		var monedaID			= $('#monedaID').val();
		var nombreInstitucion	= parametroBean.nombreInstitucion;
		var monto				= $('#monto').val();
		var dirInst				= parametroBean.direccionInstitucion;
		var usuario				= parametroBean.nombreUsuario;
		var sucursalID			= parametroBean.sucursal;
		var nombreSucursal		= parametroBean.nombreSucursal;
		var nombreCliente		= $('#nombreCompleto').val();
		var cuentaAhoID			= $('#cuentaAhoID').val();
		var descTipoAportacion	= $('#descripcion').val();
		var plazo				= $('#plazo').val();
		var calculoInteres		= $('#desCalculoInteres').val();
		var tasaBase			= $('#destasaBaseID').val();
		var tasaISR				= $('#tasaISR').val();
		var totalRecibir		= $('#monto').val();
		var fechaVencimiento	= $('#fechaVencimiento').val();
		var fechaApertura		= $('#fechaInicio').val();
		var sobreTasa			= $('#sobreTasa').val();
		var pisoTasa			= $('#pisoTasa').val();
		var techoTasa			= $('#techoTasa').val();
		var tasaNeta			= $('#tasaNeta').val();
		var tasaFija			= $('#tasaFija').val();
		var interesRecibir		= $('#interesRecibir').val();
		var totalRec			= $('#monto').asNumber();
		var nombreCaja			= $('#cajaRetiro').val()+" "+$('#nombreCaja').val();
		var tipoProducto		= "Aportación";

		var pagina = '';
		if($('#tipoTasa').val() == 'V'){
			pagina = 'pagareVarAportRep.htm?';
		} else {
			pagina = 'pagareFijoAportRep.htm?';
		}

		pagina = pagina +
			'aportacionID='			+ aportacionID +
			'&monedaID='			+ monedaID +
			'&nombreInstitucion='	+ nombreInstitucion +
			'&monto='				+ monto +
			'&direccionInstit='		+ dirInst +
			'&nombreUsuario='		+ usuario +
			'&sucursalID='			+ sucursalID +
			'&nombreSucursal='		+ nombreSucursal +
			'&nombreCompleto='		+ nombreCliente +
			'&cuentaAhoID='			+ cuentaAhoID +
			'&descripcion='			+ descTipoAportacion +
			'&plazo='				+ plazo +
			'&calculoInteres='		+ calculoInteres +
			'&tasaBase='			+ tasaBase +
			'&tasaISR='				+ tasaISR +
			'&totalRecibir='		+ totalRecibir +
			'&fechaVencimiento='	+ fechaVencimiento +
			'&fechaApertura='		+ fechaApertura +
			'&sobreTasa='			+ sobreTasa +
			'&pisoTasa='			+ pisoTasa +
			'&techoTasa='			+ techoTasa +
			'&valorGat='			+ $('#valorGat').val() +
			'&tasaNeta='			+ tasaNeta +
			'&tasaFija='			+ tasaFija +
			'&interesRecibir='		+ interesRecibir +
			'&total='				+ totalRec;

		window.open(pagina,'_blank');
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
	$('#tipoAportacionID').val('');
	$('#tipoPagoInt').val('');
	$('#pagoIntCal').val("");
	$('#diasPeriodo').hide();
	$('#diasPeriodo').val('');
	$('#lbldiasPeriodo').hide();

	inicializaForma('formaGenerica', 'aportacionID');
	ocultaMontoGlobal(true);
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('reinvertirBoton','submit');
	deshabilitaBoton('cancelar','submit');
	borra();

	if($('#tipoTransaccion').asNumber()==6){
		deshabilitaBoton('simular','submit');
		$('#aportacionID').focus();

	} else {
		deshabilitaBoton('simular','submit');
		habilitaBoton('imprime','submit');
		$('#imprime').focus();
	}

}

function Error(){
	agregaFormatoControles('formaGenerica');
	$('#aportacionID').focus();
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
	$('#tdCajaRetiro').hide();
	$('#nombreCaja').val('');
	$('#cajaRetiro').val('0');
	generarFormatoAnexo = false;
	return true;
}

function formatoMonedaVariable(numero){
	numero = Number(numero);
	return '$'+(numero.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
}

function comboListaPlazos(tipoAportacionID){
	var varTipolista=1;
	dwr.util.removeAllOptions('plazoOriginal');
	dwr.util.addOptions( "plazoOriginal", {'':'SELECCIONAR'});
	if(tipoAportacionID!='' ){
		var varBean = {
				'tipoInstrumentoID':31,
				'tipoProductoID' : tipoAportacionID
		};
		plazosPorProductosServicio.lista(varTipolista, varBean ,{async: false, callback:function(plazosPorProductosConCaja){
			if(plazosPorProductosConCaja != null || plazosPorProductosConCaja != undefined){
				if (plazosPorProductosConCaja.length>0){
					dwr.util.addOptions('plazoOriginal', plazosPorProductosConCaja,'plazo','plazo');
				}else{
					mensajeSis('No Hay Plazos Registrados para este Tipo de Aportación.');
				}
			}else{
				mensajeSis('No Hay Plazos Registrados para este Tipo de Aportación.');
			}
		}});
	}else{
		mensajeSis('El Tipo de Aportación esta vacío.');
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

// función que valida número decimal y solo permita dos digitos
function validaDigitos(e, idControl){
	  // Backspace = 8, Enter = 13, ’0′ = 48, ’9′ = 57, ‘.’ = 46

        key = e.keyCode ? e.keyCode : e.which;

        if (key == 8) return true;

        if (key > 47 && key < 58) {
          if (document.getElementById(idControl).value === "") return true;
          var existePto = (/[.]/).test(document.getElementById(idControl).value);
          if (existePto === false){
              regexp = /.[0-9]{9}$/;
          }
          else {
            regexp = /.[0-9]{2}$/;
          }

          return !(regexp.test(document.getElementById(idControl).value));
        }

        if (key == 46) {
          if (document.getElementById(idControl).value === "") return false;
          regexp = /^[0-9]+$/;
          return regexp.test(document.getElementById(idControl).value);
        }

        return false;
}

function truncaDosDecimales (valor) {
	var posPunto=valor.indexOf('.');
	return valor.substring(0, posPunto+3);
}
/**
 * Consulta 10: Consulta el monto total de los productos vigentes del cliente y/o de su
 * grupo familiar.
 * @author avelasco
 */
function consultaMontoGlobal(){
	var tipoAportacionID = $('#tipoAportacionID').val();
	var clienteID = $('#clienteID').val();
	var AportacionBean = {
		'aportacionID' : tipoAportacionID,
		'clienteID' : clienteID
	};
	aportacionesServicio.consulta(10, AportacionBean, { async: false, callback: function(aportacion){
		if(aportacion!=null){
			montoGlobal = aportacion.montoGlobal;
		} else {
			montoGlobal = 0;
		}
	}});
}
/**
 * Oculta el renglon de monto global y limpia el monto.
 * @param limpia indica si limpia o no el campo monto global.
 * @author avelasco
 */
function ocultaMontoGlobal(limpia){
	if(limpia){
		$('#montoGlobal').val('');
	}
	mostrarElementoPorClase('trMontoGlobal',false);
}
