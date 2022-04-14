	var fechaLimite =  '1900-01-01';
var tipoCta		="";
var montoMaximoTipoLinea = 0.00;
var montoAutorizadoLinea = 0.00;
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
		'actualiza':'3',
	};
	var catTipoActualizacion = {
		'condiciones':'8',
		'reactivar':'9',
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
	fechaAplicacion = parametroBean.fechaAplicacion;
	$('#fechaNuevoVenci').val(fechaAplicacion);

	listaTiposLineasAgro();
	agregaFormatoControles('formaGenerica');
	limpiarPantalla();
	deshabilitaPantalla();
	consultaTipoInstitucion();

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

	$('#reactiva').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.actualiza);
		$('#tipoActualizacion').val(catTipoActualizacion.reactivar);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.actualiza);
		$('#tipoActualizacion').val(catTipoActualizacion.condiciones);
	});

	$('#lineaCreditoID').bind('keyup',function(e){
		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('activa', 'submit');

		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#lineaCreditoID').val();
		lista('lineaCreditoID', '3', catListLinea.agropecuaria, camposLista, parametrosLista, 'lineasCreditoLista.htm');
	});

	$('#lineaCreditoID').blur(function() {
		validaLineaCredito(this.id);
	});

	$('#clienteID').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('clienteID', '2', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		}
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
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
		consultaCta(this.id);
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

	$('#fechaVencimiento').blur(function() {
		var fechaVencimiento =  $('#fechaVencimiento').val();
		var fechaInicio =  $('#fechaInicio').val();
		if( fechaVencimiento != '' ){
			if(esFechaValida(fechaVencimiento, this.id)){
				if( fechaInicio > fechaVencimiento ){
					mensajeSis('La Fecha de Vencimento no puede ser menor a la fecha de Inicio.');
					$('#fechaVencimiento').val(fechaAplicacion);
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').select();
					return ;
				}

				if( fechaVencimiento < fechaAplicacion ){
					mensajeSis('La Fecha de Vencimento no puede ser inferior a la del sistema.');
					$('#fechaVencimiento').val(fechaAplicacion);
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
					mensajeSis('La Fecha de Vencimento supera la fecha Máxima parametrizada: ' + fechaMaxima);
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
					$('#fechaVencimiento').val(fechaAplicacion);
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').select();
					return ;
				}

				if( fechaVencimiento < fechaAplicacion ){
					mensajeSis('La Fecha de Vencimento no puede ser inferior a la del sistema.');
					$('#fechaVencimiento').val(fechaAplicacion);
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
					mensajeSis('La Fecha de Vencimento supera la fecha Máxima parametrizada: ' + fechaMaxima);
					$('#fechaVencimiento').val(fechaMaxima);
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').select();
					return ;
				}
			}
		}
	});

	$('#fechaNuevoVenci').blur(function() {
		var fechaVencimiento =  $('#fechaNuevoVenci').val();
		var fechaInicio =  $('#fechaInicio').val();
		if( fechaVencimiento != '' ){
			if(esFechaValida(fechaVencimiento, this.id)){
				if( fechaInicio > fechaVencimiento ){
					mensajeSis('La Nueva de Fecha de Vencimento no puede ser menor a la fecha de Inicio.');
					$('#fechaNuevoVenci').val(fechaAplicacion);
					$('#fechaNuevoVenci').focus();
					$('#fechaNuevoVenci').select();
					return ;
				}

				if( fechaVencimiento < fechaAplicacion ){
					mensajeSis('La Fecha Nueva de Vencimento no puede ser inferior a la del sistema.');
					$('#fechaNuevoVenci').val(fechaAplicacion);
					$('#fechaNuevoVenci').focus();
					$('#fechaNuevoVenci').select();
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
					mensajeSis('La Fecha Nueva de Vencimento supera la fecha Máxima parametrizada: ' + fechaMaxima);
					$('#fechaNuevoVenci').val(fechaMaxima);
					$('#fechaNuevoVenci').focus();
					$('#fechaNuevoVenci').select();
					return ;
				}
			}
		}
	});

	$('#fechaNuevoVenci').change(function() {
		var fechaVencimiento =  $('#fechaNuevoVenci').val();
		var fechaInicio =  $('#fechaInicio').val();
		if( fechaVencimiento != '' ){
			if(esFechaValida(fechaVencimiento, this.id)){
				if( fechaInicio > fechaVencimiento ){
					mensajeSis('La Nueva de Fecha de Vencimento no puede ser menor a la fecha de Inicio.');
					$('#fechaNuevoVenci').val(fechaAplicacion);
					$('#fechaNuevoVenci').focus();
					$('#fechaNuevoVenci').select();
					return ;
				}

				if( fechaVencimiento < fechaAplicacion ){
					mensajeSis('La Fecha de Vencimento no puede ser inferior a la del sistema.');
					$('#fechaNuevoVenci').val(fechaAplicacion);
					$('#fechaNuevoVenci').focus();
					$('#fechaNuevoVenci').select();
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
					mensajeSis('La Fecha Nueva de Vencimento supera la fecha Máxima parametrizada: ' + fechaMaxima);
					$('#fechaNuevoVenci').val(fechaMaxima);
					$('#fechaNuevoVenci').focus();
					$('#fechaNuevoVenci').select();
					return ;
				}
			}
		}
	});

	$('#manejaComAdmon').change(function() {
		if( $("#manejaComAdmon option:selected").val() == 'N' ){
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
		if( $("#manejaComGarantia option:selected").val() == 'N' ){
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
			mensajeSis('El porcentaje de comisión por Administración deber ser mayor a cero.');
			$('#porcentajeComAdmon').val(0.00);
			$('#porcentajeComAdmon').focus();
			return ;
		}

		if( porcentajeComAdmon > 100.00 ){
			mensajeSis('El porcentaje de comisión por Administración deber ser menor al 100.00%.');
			$('#porcentajeComAdmon').val(100.00);
			$('#porcentajeComAdmon').focus();
			return ;
		}
	});

	$('#porcentajeComGarantia').change(function() {
		var porcentajeComGarantia = $('#porcentajeComGarantia').asNumber();
		if( porcentajeComGarantia < 0.00 ){
			mensajeSis('El porcentaje de comisión por Garantía deber ser mayor a cero.');
			$('#porcentajeComGarantia').val(0.00);
			$('#porcentajeComGarantia').focus();
			return ;
		}

		if( porcentajeComGarantia > 100.00 ){
			mensajeSis('El porcentaje de comisión por Garantía deber ser menor al 100.00%.');
			$('#porcentajeComGarantia').val(100.00);
			$('#porcentajeComGarantia').focus();
			return ;
		}
	});

	$('#montoUltimoIncremento').blur(function() {
		var MontoTemp = $("#montoUltimoIncremento").asNumber();
		if(MontoTemp > 100000000){
			mensajeSis("El Monto Incremento no puede ser superior a 100,000,000.00 ");
			$('#montoUltimoIncremento').val('100,000,000.00');
			$('#montoUltimoIncremento').focus();
			return ;
		}

		validacionMontoSolicitado();
		$('#fechaNuevoVenci').focus();
		$('#fechaNuevoVenci').select();

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
			tipoLineaAgroID: {
				required: true
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
			fechaNuevoVenci: {
				required: true
			},
			montoUltimoIncremento: {
				required: function() {
					if($("#tipoActualizacion").val() == '9' ) return false; else return true;
				}
			}
		},
		messages: {
			lineaCreditoID: {
				required: 'Especificar Línea de Crédito.',
			},
			tipoLineaAgroID: {
				required: 'Especificar Tipo Linea.',
			},
			manejaComAdmon: {
				required: 'Especificar Manejo Comisión Admon.'
			},
			forCobComAdmon: {
				required: 'Especificar Forma Cobro Comisión Admon.'
			},
			porcentajeComAdmon: {
				required: 'Especificar Porcentaje Comisión Admon.'
			},
			manejaComGarantia: {
				required: 'Especificar Manejo Comisión Garantía.'
			},
			forCobComGarantia: {
				required: 'Especificar Forma Cobro Comisión Garantía.'
			},
			porcentajeComGarantia: {
				required: 'Especificar Porcentaje Comisión Garantía.'
			},
			fechaNuevoVenci: {
				required: 'Especificar Fecha de Vencimento.',
			},
			montoUltimoIncremento: {
				required: 'Especificar Incremento de LInea.',
			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------
	function validaLineaCredito(idControl) {
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCredito = $(jqLinea).val().trim();

		var tipConPrincipal = catConLinea.agropecuaria;
		var lineaCreditoBeanCon = {
			'lineaCreditoID' : lineaCredito
		};
		$('#modifica').show();
		setTimeout("$('#cajaLista').hide();", 200);
		if(lineaCredito != '' && !isNaN(lineaCredito) && esTab){
				lineasCreditoServicio.consulta(tipConPrincipal, lineaCreditoBeanCon,function(lineaCreditoBean) {
					if(lineaCreditoBean!=null){

						agregaFormatoControles('formaGenerica');
						dwr.util.setValues(lineaCreditoBean);
						$('#solicitado').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						if( lineaCreditoBean.estatus == 'I' || lineaCreditoBean.estatus == 'R' ){
							var estatusLinea = "Rechazada";
							if( lineaCreditoBean.estatus == 'I' ){
								estatusLinea = "Inactiva";
							}
							mensajeSis("La Línea de Crédito esta en estatus "+ estatusLinea+". Por tal motivo no puede realizarse operaciones en esta pantalla.");
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('activa', 'submit');
							deshabilitaDetalles();
							deshabilitaComisiones();
							limpiarPantalla();
							$(jqLinea).select();
							$(jqLinea).focus();
							return ;
						}

						consultaMoneda('monedaID');
						consultaCliente('clienteID');
						consultaCuenta(lineaCreditoBean.cuentaID);
						habilitaControl('fechaNuevoVenci');
						validaEstatus(lineaCreditoBean.estatus);
						$('#fechaNuevoVenci').val(fechaAplicacion);

						$('#saldoDisponible').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						$('#pagado').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						$('#ultMontoDisposicion').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						$('#saldoComAnual').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						$('#saldoDeudor').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						$('#dispuesto').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						if(lineaCreditoBean.estatus === 'E'){
							$('#modifica').hide();
							$('#reactiva').show();
							habilitaBoton('reactiva', 'submit');
							deshabilitaComisiones();
							deshabilitaControl('montoUltimoIncremento');
							$('#fechaNuevoVenci').focus();
							$('#fechaNuevoVenci').select();
						} else {
							$('#reactiva').hide();
							$('#modifica').show();
							habilitaBoton('modifica', 'submit');
							habilitaComisiones();
							habilitaControl('montoUltimoIncremento');
						}

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

						$('#manejaComGarantia').focus();
						$('#manejaComGarantia').select();
						if( lineaCreditoBean.manejaComAdmon == 'S'){
							$('#manejaComAdmon').focus();
							$('#manejaComAdmon').select();
						}

						$("#fechaNuevoVenci").attr('readonly', false);
						$("#fechaNuevoVenci").datepicker({
							showOn : "button",
							buttonImage : "images/calendar.png",
							buttonImageOnly : true,
							changeMonth : true,
							changeYear : true,
							dateFormat : 'yy-mm-dd',
							yearRange : '-100:+10'
						});

						consultarTipoLineaAgro('tipoLineaAgroID');
						montoAutorizadoLinea = parseFloat(lineaCreditoBean.autorizado);

						if(lineaCreditoBean.estatus == 'E'){
							$('#modifica').hide();
							$('#reactiva').show();
							habilitaBoton('reactiva', 'submit');
							deshabilitaComisiones();
							deshabilitaControl('montoUltimoIncremento');
							$('#fechaNuevoVenci').focus();
							$('#fechaNuevoVenci').select();
						}

					}else{
						montoAutorizadoLinea = 0.00;
						mensajeSis("La Línea de Crédito no Existe.");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('activa', 'submit');
						deshabilitaDetalles();
						deshabilitaComisiones();
						limpiarPantalla();
						$(jqLinea).select();
						$(jqLinea).focus();
					}
				});

		}else{
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('activa', 'submit');
			deshabilitaDetalles();
			deshabilitaComisiones();
			limpiarPantalla();
			$(jqLinea).select();
			$(jqLinea).focus();
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
			$('#estatus').val('AUTOMÁTICA');
		}
		if(estatus == estatusNoAutomatica){
			$('#estatus').val('NO AUTOMÁTICA');
		}
		if(estatus == estatusVencida){
			$('#estatus').val('VENCIDA');
		}
	}

	function ocultaBotones(estatus) {
		$('#modifica').hide();
		$('#reactiva').hide();
	}

	// Cosulta los datos del Cliente
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente =6;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,{
				async: false, callback: function(cliente){
					if(cliente!=null){
						if(cliente.esMenorEdad != "S"){
							$('#clienteID').val(cliente.numero);
							$('#nombreCte').val(cliente.nombreCompleto);
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
				}
			});
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

						if( tiposLineasAgroBean.estatus == 'I'){
							mensajeSis("El Tipo de Línea de Crédito Agro esta Inactiva, por lo cual la Línea de Crédito: "+$('#lineaCreditoID').val()+" no puede Condicionarse.");
							deshabilitaPantalla();
							return ;
						}

						montoMaximoTipoLinea = parseFloat(tiposLineasAgroBean.montoLimite);
						plazoLinea = tiposLineasAgroBean.plazoLimite;
					}else{
						montoMaximoTipoLinea = 0.00;
						plazoLinea = 0;
						mensajeSis("El Tipo de Línea no existe.");
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
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,{
				async: false, callback: function(tipoCuenta) {
					if(tipoCuenta!=null){
						$('#monedaID').val(tipoCuenta.monedaID);
						$('#desCuenta').val(tipoCuenta.descripcion);
						consultaMoneda('monedaID');
					}else{
						$(jqTipoCta).focus();
					}
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
			monedasServicio.consultaMoneda(conMoneda,numMoneda,{
				async: false, callback: function(moneda) {
					if(moneda!=null){
						$('#moneda').val(moneda.descripcion);
					}else{
						mensajeSis("No existe el Tipo de Moneda.");
						$(jqMoneda).focus();
					}
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
		if(numCta != '' && !isNaN(numCta) && esTab){
			cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,{
				async: false, callback: function(cuenta) {
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
			cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,{
				async: false, callback: function(cuenta) {
					if(cuenta!=null){
						tipoCta = cuenta.tipoCuentaID;
						consultaTipoCta();
					}else{
						mensajeSis("No existe la cuenta.");

						$('#cuentaID').focus();
						$('#cuentaID').select();
					}
				}
			});
		}
	}

	/* Validar Monto maximo Agro*/
	function validacionMontoSolicitado(){

		var montoSolicitado = $('#montoUltimoIncremento').asNumber();
		if( montoSolicitado <= 0.00 ) {
			mensajeSis("El monto Solicitado debe ser mayor a Cero.");
			$('#montoUltimoIncremento').val(0.00);
			$('#montoUltimoIncremento').focus();
			return ;
		}

		if( montoAutorizadoLinea == montoMaximoTipoLinea ){

			mensajeSis("El Monto Autorizado de la Línea de Crédito es igual al monto Máximo parametrizado para el Tipo de Línea de Crédito. <br>"+
					   "Monto Máximo del Tipo de Línea: "+ montoMaximoTipoLinea.toFixed(2) +"<br>"+
					   "Monto Autorizado de la Línea: "+ montoAutorizadoLinea.toFixed(2));
			$('#montoUltimoIncremento').val("0.00");
			$('#estatus').focus();
			$('#estatus').select();
			deshabilitaBoton('modifica', 'submit');
			return ;
		}


		var nuevoMontoSolicitado = parseFloat(montoSolicitado + montoAutorizadoLinea);

		if( nuevoMontoSolicitado > montoMaximoTipoLinea) {

			var montoSugerencia = montoMaximoTipoLinea - montoAutorizadoLinea;
			mensajeSis("La suma del Monto a Incrementar y el Monto Autorizado de la Línea de Crédito exceden al monto Máximo parametrizado para el Tipo de Línea de Crédito.<br>"+
					   "Monto Máximo del Tipo de Línea: "+ montoMaximoTipoLinea.toFixed(2) +"<br>"+
					   "Monto Autorizado de la Línea: "+ montoAutorizadoLinea.toFixed(2) +"<br>"+
					   "Monto Incremento Sugerido: "+ montoSugerencia.toFixed(2));

			$('#montoUltimoIncremento').val(montoSugerencia);
			$('#montoUltimoIncremento').focus();
			$('#montoUltimoIncremento').select();
			return ;
		}
	} //Termina Funcion validaMonto

	//funcion valida fecha formato (yyyy-MM-dd)
	function esFechaValida(fecha, idControl){
		var jqControl = eval("'#" + idControl + "'");

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
				mensajeSis("Fecha introducida errónea");
				$(jqControl).val(fechaAplicacion);
				$(jqControl).focus();
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
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
	var tipoLista = 3;
	dwr.util.removeAllOptions('tipoLineaAgroID');
	dwr.util.addOptions('tipoLineaAgroID', {'':'SELECCIONAR'});
	tiposLineasAgroServicio.listaCombo(tipoLista, function(tiposLineasAgroBean){
		dwr.util.addOptions('tipoLineaAgroID', tiposLineasAgroBean, 'tipoLineaAgroID', 'nombre');
	});
}

function deshabilitaDetalles(){
	deshabilitaControl('saldoDisponible');
	deshabilitaControl('pagado');
	deshabilitaControl('ultMontoDisposicion');
	deshabilitaControl('saldoComAnual');
	deshabilitaControl('saldoDeudor');
	deshabilitaControl('numeroCreditos');
	deshabilitaControl('dispuesto');
	deshabilitaControl('ultFechaDisposicion');
	$("#fechaInicio").attr('readonly', true);
	$("#fechaInicio").datepicker("destroy");
	$("#fechaVencimiento").attr('readonly', true);
	$("#fechaVencimiento").datepicker("destroy");
}

function deshabilitaComisiones(){
	deshabilitaControl('manejaComAdmon');
	deshabilitaControl('forCobComAdmon');
	deshabilitaControl('porcentajeComAdmon');
	deshabilitaControl('manejaComGarantia');
	deshabilitaControl('forCobComGarantia');
	deshabilitaControl('porcentajeComGarantia');
}

function habilitaComisiones(){
	habilitaControl('manejaComAdmon');
	habilitaControl('forCobComAdmon');
	habilitaControl('porcentajeComAdmon');
	habilitaControl('manejaComGarantia');
	habilitaControl('forCobComGarantia');
	habilitaControl('porcentajeComGarantia');
}

function deshabilitaPantalla(){
	deshabilitaControl('clienteID');
	deshabilitaControl('tipoLineaAgroID');
	deshabilitaControl('solicitado');
	deshabilitaControl('fechaInicio');
	deshabilitaControl('fechaVencimiento');
	deshabilitaBoton('activa', 'submit');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaControl('cuentaID');
	deshabilitaControl('monedaID');
	deshabilitaControl('montoUltimoIncremento');
	deshabilitaControl('fechaNuevoVenci');
	deshabilitaDetalles();
	deshabilitaComisiones();
	deshabilitaBoton('activa', 'submit');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaDetalles();
	$("#fechaInicio").attr('readonly', true);
	$("#fechaInicio").datepicker("destroy");
	$("#fechaVencimiento").attr('readonly', true);
	$("#fechaVencimiento").datepicker("destroy");
	$("#fechaNuevoVenci").attr('readonly', true);
	$("#fechaNuevoVenci").datepicker("destroy");
}

function habilitaPantalla(){
	habilitaControl('tipoLineaAgroID');
	habilitaControl('fechaVencimiento');
	habilitaControl('manejaComAdmon');
	habilitaControl('forCobComAdmon');
	habilitaControl('porcentajeComAdmon');
	habilitaControl('manejaComGarantia');
	habilitaControl('forCobComGarantia');
	habilitaControl('porcentajeComGarantia');
}

function limpiarPantalla(){
	$('#fechaNuevoVenci').val(fechaAplicacion);
	$("#clienteID").val('');
	$("#nombreCte").val('');
	$("#tipoLineaAgroID").val('');
	$("#cuentaID").val('');
	$("#desCuenta").val('');
	$("#monedaID").val('');
	$("#moneda").val('');
	$("#solicitado").val('');
	$('#fechaInicio').val('');
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
	$("#montoUltimoIncremento").val('');
	$("#ultFechaDisposicion").val('');
	$("#saldoDisponible").val('');
	$("#pagado").val('');
	$("#saldoComAnual").val('');
	$("#saldoDeudor").val('');
	$("#ultMontoDisposicion").val('');
	$("#fechaUltimoDisposicion").val('');
	$("#numeroCreditos").val('');
	$("#dispuesto").val('');
	$('#reactiva').hide();
	$('#modifica').show();
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