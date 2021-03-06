var fechaLimite =  '1900-01-01';
var tipoCta		="";
var montoMax;
var montoMin;
var montoMaximoLinea = 0.00;
var plazoLinea = 0;
var fechaAplicacion = '1900-01-01';
var tipoInstitucion = 0; // Para determinar si es SOFIPO o SOFOM, SOCAP
var tipoSOFIPO		= 3; // Clave del Tipo de Institucion SOFIPO

$(document).ready(function() {
	esTab = true;

	//Definicion de Constantes y Enums
	var catTipoTransaccion = {
		'agrega':'1',
		'modifica':'2',
	};

	var catListLinea = {
		'agropecuaria':'7'
	};

	var catConLinea = {
		'agropecuaria': 4
	};

	var catConTiposLineasAgro = {
		'principal': 1
	};

	var parametroBean = consultaParametrosSession();
	$('#sucursalID').val(parametroBean.sucursal);
	var fechaAplicacion = parametroBean.fechaAplicacion;

	listaTiposLineasAgro();
	agregaFormatoControles('formaGenerica');
	limpiarPantalla();
	deshabilitaPantalla();
	consultaTipoInstitucion();
	consultaParametros();

	$('#agrega').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');
	$('#lineaCreditoID').focus();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'lineaCreditoID', 'funcionExito', 'funcionError');
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);

		var fechaIniForm = $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimiento').val();
		if(fechaIniForm < fechaAplicacion){
			mensajeSis("Fecha es Menor a la del Sistema.");
			event.preventDefault();
		}
		if(fechaVenForm < fechaIniForm){
			mensajeSis("Fecha de Inicio es Inferior a la de Vencimiento.");
			event.preventDefault();
		}
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.modifica);
		var fechaIniForm = $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimiento').val();
		if(fechaIniForm < fechaAplicacion){
			mensajeSis("Fecha es menor a la del Sistema.");
			event.preventDefault();
		}
		if(fechaVenForm < fechaIniForm){
			mensajeSis("Fecha de Inicio es Inferior a la de Vencimiento.");
			event.preventDefault();
		}
	});

	$('#lineaCreditoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#lineaCreditoID').val();
		lista('lineaCreditoID', '3', catListLinea.agropecuaria, camposLista, parametrosLista, 'lineasCreditoLista.htm');
	});

	$('#lineaCreditoID').blur(function() {
		if (esTab) {
			validaLineaCredito(this.id);
		}

	});

	$('#clienteID').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('clienteID', '2', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		}
	});

	$('#clienteID').blur(function() {
		if (esTab) {
			consultaCliente(this.id);
		}
	});

	$('#tipoLineaAgroID').change(function(){
		consultarTipoLineaAgro(this.id);
	});

	$('#cuentaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		lista('cuentaID', '1', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
	});

	$('#cuentaID').blur(function() {
		if (esTab) {
			consultaCta(this.id);
		}
	});

	$('#monedaID').blur(function() {
		consultaMoneda(this.id);
	});

	$('#fechaInicio').blur(function() {
		var fechaInicio =  $('#fechaInicio').val();
		if(esFechaValida(fechaInicio, this.id)){
			if ( fechaInicio < fechaAplicacion ){
				mensajeSis('La Fecha de Inicio no puede ser inferior a la del sistema.');
				$('#fechaInicio').val(fechaAplicacion);
				$('#fechaInicio').focus();
				$('#fechaInicio').select();
				return ;
			}
		}
	});


	$('#fechaInicio').change(function() {
		var fechaInicio =  $('#fechaInicio').val();
		if(esFechaValida(fechaInicio, this.id)){
			if ( fechaInicio < fechaAplicacion ){
				mensajeSis('La Fecha de Inicio no puede ser inferior a la del sistema.');
				$('#fechaInicio').val(fechaAplicacion);
				$('#fechaInicio').focus();
				$('#fechaInicio').select();
				return ;
			}
		}
	});

	$('#fechaVencimiento').blur(function() {
		var fechaVencimiento =  $('#fechaVencimiento').val();
		var fechaInicio =  $('#fechaInicio').val();
		if( fechaVencimiento != '' ){
			if(esFechaValida(fechaVencimiento, this.id)){
				if( fechaInicio > fechaVencimiento ){
					mensajeSis('La Fecha de Vencimento no puede ser menor a la fecha de Inicio.');
					$('#fechaVencimiento').val(fechaInicio);
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').select();
					return ;
				}

				if( fechaVencimiento < fechaAplicacion ){
					mensajeSis('La Fecha de Vencimento no puede ser inferior a la del sistema.');
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').select();
					return ;
				}

				fechaLimite = new Date(fechaInicio);
				var meses = (parseInt(fechaLimite.getMonth()) +parseInt(plazoLinea)) ;
				fechaLimite.setMonth(meses);

				var mes = fechaLimite.getMonth()+ 1;
				if( mes < 10 ){
					mes = "0"+mes;
				}

				var dia = fechaLimite.getDate()+ 1;
				if( dia < 10 ){
					dia = "0"+dia;
				}

				var fechaMaxima = fechaLimite.getFullYear() +"-"+ mes +"-"+ dia;

				if( fechaVencimiento > fechaMaxima){
					mensajeSis('La Fecha de Vencimento supera la fecha M??xima parametrizada: ' + fechaMaxima);
					$('#fechaVencimiento').val(fechaMaxima);
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').select();
					return ;
				}
			}
		}
	});

	$('#fechaVencimiento').change(function() {
		var fechaVencimiento =  $('#fechaVencimiento').val();
		var fechaInicio =  $('#fechaInicio').val();
		if( fechaVencimiento != '' ){
			if(esFechaValida(fechaVencimiento, this.id)){
				if( fechaInicio > fechaVencimiento ){
					mensajeSis('La Fecha de Vencimento no puede ser menor a la fecha de Inicio.');
					$('#fechaVencimiento').val(fechaInicio);
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').select();
					return ;
				}

				if( fechaVencimiento < fechaAplicacion ){
					mensajeSis('La Fecha de Vencimento no puede ser inferior a la del sistema.');
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').select();
					return ;
				}

				fechaLimite = new Date(fechaInicio);
				var meses = (parseInt(fechaLimite.getMonth()) +parseInt(plazoLinea)) ;
				fechaLimite.setMonth(meses);

				var mes = fechaLimite.getMonth()+ 1;
				if( mes < 10 ){
					mes = "0"+mes;
				}

				var dia = fechaLimite.getDate()+ 1;
				if( dia < 10 ){
					dia = "0"+dia;
				}

				var fechaMaxima = fechaLimite.getFullYear() +"-"+ mes +"-"+ dia;

				if( fechaVencimiento > fechaMaxima){
					mensajeSis('La Fecha de Vencimento supera la fecha M??xima parametrizada: ' + fechaMaxima);
					$('#fechaVencimiento').val(fechaMaxima);
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').select();
					return ;
				}
			}
		}
	});

	$('#solicitado').blur(function() {
		validacionMontoSolicitado();
	});

	$('#manejaComAdmon').change(function() {
		if( $('#manejaComAdmon').val() == 'N' ){
			deshabilitaControl('forCobComAdmon');
			deshabilitaControl('porcentajeComAdmon');
			$("#forCobComAdmon").val('');
			$("#porcentajeComAdmon").val('0.00');
		} else {
			habilitaControl('forCobComAdmon');
			habilitaControl('porcentajeComAdmon');
			$("#forCobComAdmon").val('');
			$("#porcentajeComAdmon").val('');
		}
	});

	$('#manejaComGarantia').change(function() {
		if( $('#manejaComGarantia').val() == 'N' ){
			deshabilitaControl('forCobComGarantia');
			deshabilitaControl('porcentajeComGarantia');
			$("#forCobComGarantia").val('');
			$("#porcentajeComGarantia").val('0.00');
		} else {
			habilitaControl('forCobComGarantia');
			habilitaControl('porcentajeComGarantia');
			$("#forCobComGarantia").val('');
			$("#porcentajeComGarantia").val('');
		}
	});

	$('#porcentajeComAdmon').change(function() {
		var porcentajeComAdmon = $('#porcentajeComAdmon').asNumber();
		if( porcentajeComAdmon < 0.00 ){
			mensajeSis('El porcentaje de comisi??n por Administraci??n deber ser mayor a cero.');
			$('#porcentajeComAdmon').val(0.00);
			$('#porcentajeComAdmon').focus();
			return ;
		}

		if( porcentajeComAdmon > 100.00 ){
			mensajeSis('El porcentaje de comisi??n por Administraci??n deber ser menor al 100.00%.');
			$('#porcentajeComAdmon').val(100.00);
			$('#porcentajeComAdmon').focus();
			return ;
		}
	});

	$('#porcentajeComGarantia').change(function() {
		var porcentajeComGarantia = $('#porcentajeComGarantia').asNumber();
		if( porcentajeComGarantia < 0.00 ){
			mensajeSis('El porcentaje de comisi??n por Garant??a deber ser mayor a cero.');
			$('#porcentajeComGarantia').val(0.00);
			$('#porcentajeComGarantia').focus();
			return ;
		}

		if( porcentajeComGarantia > 100.00 ){
			mensajeSis('El porcentaje de comisi??n por Garant??a deber ser menor al 100.00%.');
			$('#porcentajeComGarantia').val(100.00);
			$('#porcentajeComGarantia').focus();
			return ;
		}
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		// quitaFormatoControles('formaGenerica');
		rules: {
			lineaCreditoID: {
				required: function() {
					if($("#lineaCreditoID").val() == '0' ) return false; else return true;
				}
			},
			clienteID: {
				required: true
			},
			tipoLineaAgroID: {
				required: true
			},
			cuentaID: {
				required: true
			},
			solicitado: {
				required: true
			},
			fechaInicio: {
				required: true,
				date: true
			},
			fechaVencimiento: {
				required: true,
				date: true
			},
			manejaComAdmon: {
				required: true
			},
			forCobComAdmon: {
				required: function() {
					if($("#manejaComAdmon").val() == 'N' ) return false; else return true;
				}
			},
			porcentajeComAdmon: {
				required: function() {
					if($("#manejaComAdmon").val() == 'N' ) return false; else return true;
				}
			},
			manejaComGarantia: {
				required: true
			},
			forCobComGarantia: {
				required: function() {
					if($("#manejaComGarantia").val() == 'N' ) return false; else return true;
				}
			},
			porcentajeComGarantia: {
				required: function() {
					if($("#manejaComGarantia").val() == 'N' ) return false; else return true;
				}
			},
			sucursalID: {
				required: true
			},
			productoCreditoID: {
				required: true
			}
		},
		messages: {
			lineaCreditoID: {
				required: 'Especificar L??nea de Cr??dito',
			},
			clienteID: {
				required: 'Especificar Cliente',
			},
			tipoLineaAgroID: {
				required: 'Especificar Tipo Linea',
			},
			cuentaID: {
				required: 'Especificar Cuenta',
			},
			solicitado: {
				required: 'Especificar monto'
			},
			fechaInicio: {
				required: 'Especificar Fecha ',
				date :'Fecha Incorrecta'
			},
			fechaVencimiento: {
				required: 'Especificar Fecha',
				date : 'Fecha Incorrecta'
			},
			manejaComAdmon: {
				required: 'Especificar Manejo Comisi??n Admon.'
			},
			forCobComAdmon: {
				required: 'Especificar Forma Cobro Comisi??n Admon.'
			},
			porcentajeComAdmon: {
				required: 'Especificar Porcentaje Comisi??n Admon.'
			},
			manejaComGarantia: {
				required: 'Especificar Manejo Comisi??n Garant??a.'
			},
			forCobComGarantia: {
				required: 'Especificar Forma Cobro Comisi??n Garant??a.'
			},
			porcentajeComGarantia: {
				required: 'Especificar Porcentaje Comisi??n Garant??a.'
			},
			sucursalID: {
				required: 'Especificar la Sucursal.',
			},
			productoCreditoID: {
				required: 'Especificar Producto de Cr??dito.',
			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------
	function validaLineaCredito(idControl) {
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCredito = $(jqLinea).val();

		var tipConPrincipal = catConLinea.agropecuaria;
		var lineaCreditoBeanCon = {
			'lineaCreditoID' : lineaCredito
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(lineaCredito != '' && !isNaN(lineaCredito)){

			if(lineaCredito=='0'){
				habilitaPantalla();
				limpiarPantalla();
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				$('#sucursalID').val(parametroBean.sucursal);
				$('#sucursal').val(parametroBean.nombreSucursal);
				consultaParametros();
				agregaFormatoControles('formaGenerica');
				$('#estatus').val('EN CAPTURA');
				$('#clienteID').focus();
			} else {

				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				lineasCreditoServicio.consulta(tipConPrincipal, lineaCreditoBeanCon,function(lineaCreditoBean) {
					if(lineaCreditoBean!=null){
						agregaFormatoControles('formaGenerica');
						dwr.util.setValues(lineaCreditoBean);

						$('#solicitado').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						consultaMoneda('monedaID');
						consultaCliente('clienteID');
						consultaCuenta(lineaCreditoBean.cuentaID);
						consultarTipoLineaAgro('tipoLineaAgroID');

						validaEstatus(lineaCreditoBean.estatus);
						if(lineaCreditoBean.estatus != 'I'){
							deshabilitaBoton('modifica', 'submit');
							deshabilitaPantalla();
						} else {
							habilitaControl('tipoLineaAgroID');
							habilitaControl('solicitado');
							habilitaControl('fechaVencimiento');
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
							deshabilitaControl('clienteID');
							deshabilitaControl('cuentaID');
							deshabilitaControl('monedaID');
							habilitaControl('fechaInicio');
							$('#tipoLineaAgroID').focus();

							if(lineaCreditoBean.manejaComAdmon == 'S'){
								habilitaControl('manejaComAdmon');
								habilitaControl('forCobComAdmon');
								habilitaControl('porcentajeComAdmon');
							} else {
								$("#manejaComAdmon").val('N');
								$("#forCobComAdmon").val('');
								$("#porcentajeComAdmon").val('0.00');
								deshabilitaControl('forCobComAdmon');
								deshabilitaControl('porcentajeComAdmon');
							}

							if(lineaCreditoBean.manejaComGarantia == 'S'){
								habilitaControl('manejaComGarantia');
								habilitaControl('forCobComGarantia');
								habilitaControl('porcentajeComGarantia');
							} else {
								$("#manejaComGarantia").val('N');
								$("#forCobComGarantia").val('');
								$("#porcentajeComGarantia").val('0.00');
								deshabilitaControl('forCobComGarantia');
								deshabilitaControl('porcentajeComGarantia');
							}
						}

					}else{
						mensajeSis("La L??nea de Cr??dito no Existe.");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						limpiarPantalla();
						$(jqLinea).focus();
						$(jqLinea).select();
					}
				});
			}
		} else {
			if(lineaCredito != '') {
				mensajeSis("El N??mero de L??nea de Cr??dito no es Valido.");
				$('#lineaCreditoID').focus();
				$('#lineaCreditoID').select();
			}
		}
	}

	function validaEstatus(estatus) {
		var estatusAutorizada = "A";
		var estatusBloqueado  = "B";
		var estatusCancelada  = "C";
		var estatusInactivo   = "I";
		var estatusRechazada  = "R";
		var estatusAutomatica = "S";
		var estatusNoAutomatica  = "N";
		var estatusVencida 		 = "E";

		if(estatus == estatusAutorizada){
			$('#estatus').val('AUTORIZADA');
		}
		if(estatus == estatusBloqueado){
			$('#estatus').val('BLOQUEADA');
		}
		if(estatus == estatusCancelada){
			$('#estatus').val('CANCELADA');
		}
		if(estatus == estatusInactivo){
			$('#estatus').val('INACTIVA');
		}
		if(estatus == estatusRechazada){
			$('#estatus').val('RECHAZADA');
		}
		if(estatus == estatusAutomatica){
			$('#estatus').val('AUTOM??TICA');
		}
		if(estatus == estatusNoAutomatica){
			$('#estatus').val('NO AUTOM??TICA');
		}
		if(estatus == estatusVencida){
			$('#estatus').val('VENCIDA');
		}
	}

	// Cosulta los datos del Cliente
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente =6;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){
					if(cliente.esMenorEdad != "S"){
						$('#clienteID').val(cliente.numero);
						$('#nombreCte').val(cliente.nombreCompleto);
						checkListCliente(cliente.numero);
					}else{
						mensajeSis("El Cliente es Menor de Edad.");
						$(jqCliente).focus();
						$(jqCliente).select();
						$("#nombreCte").val('');
					}
				}else{
					mensajeSis("No existe el Cliente.");
					$(jqCliente).focus();
					$(jqCliente).select();
					$("#nombreCte").val('');
				}
			});
		} else {
			if(numCliente != ''){
				mensajeSis("El N??mero de Cliente no es Valido.");
				$(jqCliente).focus();
				$(jqCliente).select();
				$("#nombreCte").val('');
			}
		}
	}

	// Cosulta los datos del Tipo Linea Agro
	function consultarTipoLineaAgro(idControl) {

		var jqTipoLineaAgroID  = eval("'#" + idControl + "'");
		var tipoLineaAgroID = $("#tipoLineaAgroID option:selected").val();
		var consulta = catConTiposLineasAgro.principal;
		var tiposLineasAgro = {
			'tipoLineaAgroID' : tipoLineaAgroID
		};

		if(tipoLineaAgroID != '' && !isNaN(tipoLineaAgroID)){
			tiposLineasAgroServicio.consulta(consulta, tiposLineasAgro, {
				async: false, callback: function(tiposLineasAgroBean){
					if(tiposLineasAgroBean!=null){
						var posicion = tiposLineasAgroBean.productosCredito.indexOf(",");
						var productoCreditoID = tiposLineasAgroBean.productosCredito;
						if(posicion > 0){
							productoCreditoID = tiposLineasAgroBean.productosCredito.substring(0,posicion);
						}
						$("#productoCreditoID").val(productoCreditoID);

						montoMaximoLinea = tiposLineasAgroBean.montoLimite;
						plazoLinea = tiposLineasAgroBean.plazoLimite;
						if(tiposLineasAgroBean.manejaComAdmon == 'S'){
							habilitaControl('manejaComAdmon');
							habilitaControl('forCobComAdmon');
							habilitaControl('porcentajeComAdmon');
						} else {
							$("#manejaComAdmon").val('N');
							$("#forCobComAdmon").val('');
							$("#porcentajeComAdmon").val('0.00');
							deshabilitaControl('manejaComAdmon');
							deshabilitaControl('forCobComAdmon');
							deshabilitaControl('porcentajeComAdmon');
						}

						if(tiposLineasAgroBean.manejaComGaran == 'S'){
							habilitaControl('manejaComGarantia');
							habilitaControl('forCobComGarantia');
							habilitaControl('porcentajeComGarantia');
						} else {
							$("#manejaComGarantia").val('N');
							$("#forCobComGarantia").val('');
							$("#porcentajeComGarantia").val('0.00');
							deshabilitaControl('manejaComGarantia');
							deshabilitaControl('forCobComGarantia');
							deshabilitaControl('porcentajeComGarantia');
						}
					}else{
						mensajeSis("El Tipo de L??nea no existe.");
						$(jqTipoLineaAgroID).focus();
						$(jqTipoLineaAgroID).select();
					}
				}
			});
		}
	}

	// Cosulta la descripcion del tipo de cuenta
	function consultaTipoCta() {
		var numTipoCta = tipoCta;
		var conTipoCta=2;
		var TipoCuentaBeanCon = {
			'tipoCuentaID':numTipoCta
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCta != '' && !isNaN(numTipoCta)){
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){
					$('#monedaID').val(tipoCuenta.monedaID);
					$('#desCuenta').val(tipoCuenta.descripcion);
					consultaMoneda('monedaID');
				}else{
					$(jqTipoCta).focus();
				}
			});
		}
	}

	// Cosulta la descripcion de la Moneda de la cuenta
	function consultaMoneda(idControl) {
		var jqMoneda = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){
					$('#moneda').val(moneda.descripcion);
				}else{
					mensajeSis("No existe el Tipo de Moneda.");
					$(jqMoneda).focus();
				}
			});
		}
	}

	// Cosulta los datos de la cuenta de ahorro del cliente
	function consultaCta(idControl) {
		var jqCta  = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		var CuentaAhoBeanCon = {
				'cuentaAhoID'	:numCta,
				'clienteID'		:$('#clienteID').val()
		};
		var conCta =3;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){
					if( $('#clienteID').val() != ''){
						if (cuenta.clienteID== $('#clienteID').val()){
							tipoCta = cuenta.tipoCuentaID;
							consultaTipoCta();
						}else{
							mensajeSis("Cuenta No Asociada al Cliente.");
							$('#cuentaID').val("");
							$('#desCuenta').val("");
							$('#cuentaID').focus();
						}
					}else{
						$('#desCuenta').val(cuenta.descripcionTipoCta);
						$('#cuentaID').val(cuenta.cuentaAhoID);
					}
				}else{
					mensajeSis("No existe la Cuenta.");
					$('#cuentaID').focus();
					$('#cuentaID').select();
				}
			});
		} else {
			if( numCta != '' ){
				mensajeSis("El n??mero de Cuenta de Ahorro no es Valido.");
				$('#cuentaID').focus();
				$('#cuentaID').select();
				$("#desCuenta").val('');
			}
		}
	}

	//consulta validacion
	function checkListCliente(clienteID) {
		var solicitudCreditoBean = {
			'clienteID' : clienteID
		};

		if (clienteID != '' && !isNaN(clienteID)) {
			consolidacionesServicio.consulta(2, solicitudCreditoBean, {
				async : false,
				callback : function(consolidacionResponse) {
					if (consolidacionResponse != null) {

						mensajePersonalizado = "El " + $('#alertSocio').val() + " No ha Completado correctamente los Siguientes Flujos:<br>" ;
						var numero = 0;
						var banderaCliente = 0;
						if( consolidacionResponse.dentificacion == 0 ){
							banderaCliente = 1;
							numero = numero + 1;
							mensajePersonalizado = mensajePersonalizado +'<p align="left">'+ numero +".- No Cuenta con una <b>Identificaci??n Oficial.</b><br>";
						}

						if( consolidacionResponse.direccion == 0 ){
							banderaCliente = 1;
							numero = numero + 1;
							mensajePersonalizado = mensajePersonalizado +  numero +".- No Cuenta con una <b>Direcci??n Oficial</b>.</br>";
						}

						if( consolidacionResponse.cuentaAhorro == 0 ){
							banderaCliente = 1;
							numero = numero + 1;
							mensajePersonalizado = mensajePersonalizado + numero +".- No Tiene con una <b>Cuenta de Ahorro Princial Activa.</b></br>";
						}

						if( banderaCliente > 0 ){
							mensajeSis(mensajePersonalizado = mensajePersonalizado + '</p>');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
							$('#clienteID').focus();
						} else {
							if( $('#lineaCreditoID').val() == 0){
								habilitaBoton('agrega', 'submit');
							}
						}

					} else {
						mensajeSis("El " + $('#alertSocio').val() + " especificado no Existe o no Cumple con el check list b??sico.");
						$('#clienteID').focus();
					}
				},
				errorHandler : function(message, exception) {
					mensajeSis("Error en Consulta del " + $('#alertSocio').val() + ".<br>" + message + ":" + exception);
				}
			});
		}
	}

	// Cosulta los datos de la cuenta de ahorro del cliente
	function consultaCuenta(cuentas) {
		var numCta = cuentas;

		var CuentaAhoBeanCon = {
				'cuentaAhoID'	:numCta,
				'clienteID'		:$('#clienteID').val()
		};
		var conCta =3;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){
					tipoCta = cuenta.tipoCuentaID;
					consultaTipoCta();
				}else{
					mensajeSis("No existe la cuenta.");

					$('#cuentaID').focus();
					$('#cuentaID').select();
				}
			});
		}
	}

	/* Validar Monto maximo Agro*/
	function validacionMontoSolicitado(){

		var montoSolicitado = $('#solicitado').asNumber();
		if( montoSolicitado < 0.00 ) {
			mensajeSis("El monto Solicitado debe ser mayor a Cero.");
			$('#solicitado').val(0.00);
			$('#solicitado').focus();
		}

		if( montoSolicitado > montoMaximoLinea) {
			mensajeSis("El monto Solicitado M??ximo para el Tipo de L??nea Solicitado es de "+ montoMaximoLinea+".");
			$('#solicitado').val(montoMaximoLinea);
			$('#solicitado').focus();
		}
	} //Termina Funcion validaMonto

	function consultaParametros(){
		var parametroBean = consultaParametrosSession();
		$('#sucursalID').val(parametroBean.sucursal);
		$('#fechaInicio').val(fechaAplicacion);
	}

	//funcion valida fecha formato (yyyy-MM-dd)
	function esFechaValida(fecha, idControl){
		var jqControl = eval("'#" + idControl + "'");

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no v??lido (aaaa-mm-dd)");
				$(jqControl).val(fechaAplicacion);
				$(jqControl).focus();
				return false;
			}

			var mes  = fecha.substring(5, 7)*1;
			var dia  = fecha.substring(8, 10)*1;
			var anio = fecha.substring(0,4)*1;

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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;}
				break;
			default:
				mensajeSis("Fecha introducida err??nea");
				$(jqControl).val(fechaAplicacion);
				$(jqControl).focus();
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida err??nea");
				$(jqControl).val(fechaAplicacion);
				$(jqControl).focus();
				return false;
			}
			return true;
		}
	}

	// funcion comprobar anio bisiesto
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
});

function listaTiposLineasAgro() {
	var tipoLista = 2;
	dwr.util.removeAllOptions('tipoLineaAgroID');
	dwr.util.addOptions('tipoLineaAgroID', {'':'SELECCIONAR'});
	tiposLineasAgroServicio.listaCombo(tipoLista, function(tiposLineasAgroBean){
		dwr.util.addOptions('tipoLineaAgroID', tiposLineasAgroBean, 'tipoLineaAgroID', 'nombre');
	});
}

function deshabilitaPantalla(){
	deshabilitaControl('clienteID');
	deshabilitaControl('tipoLineaAgroID');
	deshabilitaControl('cuentaID');
	deshabilitaControl('monedaID');
	deshabilitaControl('solicitado');
	deshabilitaControl('fechaInicio');
	deshabilitaControl('fechaVencimiento');
	deshabilitaControl('manejaComAdmon');
	deshabilitaControl('forCobComAdmon');
	deshabilitaControl('porcentajeComAdmon');
	deshabilitaControl('manejaComGarantia');
	deshabilitaControl('forCobComGarantia');
	deshabilitaControl('porcentajeComGarantia');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$("#fechaInicio").attr('readonly', true);
	$("#fechaInicio").datepicker("destroy");
	$("#fechaVencimiento").attr('readonly', true);
	$("#fechaVencimiento").datepicker("destroy");
}

function habilitaPantalla(){
	habilitaControl('clienteID');
	habilitaControl('tipoLineaAgroID');
	habilitaControl('cuentaID');
	habilitaControl('solicitado');
	habilitaControl('fechaInicio');
	habilitaControl('fechaVencimiento');
	habilitaControl('manejaComAdmon');
	habilitaControl('forCobComAdmon');
	habilitaControl('porcentajeComAdmon');
	habilitaControl('manejaComGarantia');
	habilitaControl('forCobComGarantia');
	habilitaControl('porcentajeComGarantia');
}

function limpiarPantalla(){
	var parametroBean = consultaParametrosSession();
	$("#clienteID").val('');
	$("#nombreCte").val('');
	$("#tipoLineaAgroID").val('');
	$("#cuentaID").val('');
	$("#desCuenta").val('');
	$("#monedaID").val('');
	$("#moneda").val('');
	$("#solicitado").val('');
	$('#fechaInicio').val(parametroBean.fechaAplicacion);
	$("#fechaVencimiento").val('');
	$("#estatus").val('');
	$("#manejaComAdmon").val('');
	$("#forCobComAdmon").val('');
	$("#porcentajeComAdmon").val('');
	$("#manejaComGarantia").val('');
	$("#forCobComGarantia").val('');
	$("#porcentajeComGarantia").val('');
	$("#montoMinimo").val('');
	$("#montoMaximo").val('');
	$("#folioContrato").val('');
	$("#productoCreditoID").val('');
	$('#sucursalID').val(parametroBean.sucursal);
}

// Consulta el tipo de institucion
function consultaTipoInstitucion() {
	var parametrosSisCon ={
			'empresaID' : 1
	};
	parametrosSisServicio.consulta(15,parametrosSisCon, function(institucion) {
		if (institucion != null) {
			tipoInstitucion = institucion.tipoInstitID;

			if(tipoInstitucion == tipoSOFIPO){
				$('.tipoSofipo').show();
			}else{
				$('.tipoSofipo').hide();
			}
		}
	});
}

//funcion que se ejecuta cuando surgio un error en la transaccion
function funcionError() {
	agregaFormatoControles('formaGenerica');
}

//funcion que se ejecuta cuando es exitosa la transaccion
function funcionExito() {
	limpiarPantalla();
	deshabilitaPantalla();
	agregaFormatoControles('formaGenerica');
}