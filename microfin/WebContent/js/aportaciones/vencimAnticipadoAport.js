var esTab = true;

$(document).ready(function() {
	var parametroBean = consultaParametrosSession();

	$(':text').focus(function() {
	 	esTab = false;
	});
	$('#aportacionID').focus();

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	var catTipoTransaccion = {
		'vencimientoAnt':11
	};

	var catTipoConsulta = {
			'vencimiento':9
		};

	var catTipoLista ={
			'vencimiento' : 11
	};

	var catTipoListaCambioTasa = {
		'principal': 16
	};

	deshabilitaBoton('cancela', 'submit');
	agregaFormatoControles('formaGenerica');
	$('#esAnclaje').val('');
	$('#anclajeHijo').val('');
	ocultarSimulador();

	$.validator.setDefaults({
		submitHandler: function(event) {
			var aportMadre = $('#esAnclaje').val();
			var aportHijo  = $('#anclajeHijo').val();
			if( aportMadre == ''){
				 var confirmar = confirm("¿Está Seguro de Vencer Anticipadamente La Aportación?");
				 if(confirmar == true){
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','aportacionID','exito','error');
				}
			}else {
				var confirmar = confirm("La Aportación " +$('#aportacionID').val()+ " es parte de un Anclaje, al Vencer Anticipadamente" +
						" se vencerán todos los Anclajes Relacionados La Aportación. Aportación Madre: " +aportMadre+
						" ANCLAJES: "+aportHijo+" ¿Está Seguro de Vencer Anticipadamente La Aportación?");
				 if(confirmar == true){
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','aportacionID','exito','error');
				}

			}


		}
	});

	$('#aportacionID').bind('keyup',function(e){
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "nombreCliente";
		 parametrosLista[0] = $('#aportacionID').val();
		lista('aportacionID', 2, catTipoLista.vencimiento, camposLista, parametrosLista, 'listaAportaciones.htm');
	});

	$('#aportacionID').blur(function(){
		if(esTab){

			validaAportacion(this.id);
		}

	});

	$('#cancela').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.vencimientoAnt);
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			aportacionID:{
				required: true,
			}
		},
		messages: {
			aportacionID:{
				required:'Especifique Número de Aportación.',
			}
		}
	});


	//------------ Funciones ------------------------------------------------------

	function validaAportacion(idControl){
		var jqAport = eval("'#" + idControl + "'");
		var numAport = $(jqAport).val();
		var aportBean = {
			'aportacionID' : numAport
		};
		if(numAport != 0 && numAport != '' && !isNaN(numAport) && esTab){
			aportacionesServicio.consulta(catTipoConsulta.vencimiento, aportBean, function(aportaBean){
				if(aportaBean!=null){
					if(aportaBean.existe != 'S'){
						habilitaBoton('cancela', 'submit');
						estatus = aportaBean.estatus;

						$('#clienteID').val(aportaBean.clienteID);
						$('#cuentaAhoID').val(aportaBean.cuentaAhoID);
						$('#tipoAportacionID').val(aportaBean.tipoAportacionID);
						$('#tipoPagoInt').val(aportaBean.tipoPagoInt);

						$('#monto').val(aportaBean.monto);
						$('#plazo').val(aportaBean.plazo);
						$('#plazoOriginal').val(aportaBean.plazoOriginal);
						$('#fechaInicio').val(aportaBean.fechaInicio);
						$('#fechaVencimiento').val(aportaBean.fechaVencimiento);

						$('#tasaFija').val(aportaBean.tasaFija);
						$('#tasaISR').val(aportaBean.tasaISR);
						$('#tasaNeta').val(aportaBean.tasaNeta);
						$('#valorGat').val(aportaBean.valorGat);

						$('#interesGenerado').val(aportaBean.saldoProvision);
						$('#valorGatReal').val(aportaBean.valorGatReal);
						$('#estatus').val(estatus);
						mostrarElementoPorClase('trMontoGlobal',aportBean.tasaMontoGlobal);
						$('#montoGlobal').val(aportBean.montoGlobal);
						agregaFormatoControles('formaGenerica');

						consultaCliente(aportaBean.clienteID);
						consultaTipoAportacion();
						diasTranscurridos(aportaBean.inicioPeriodo, parametroBean.fechaSucursal);
						validaAportacionAnclaje();


						diasBase = parametroBean.diasBaseInversion;
						salarioMinimo = parametroBean.salMinDF;
						var salarioMinimoGralAnu = parametroBean.salMinDF * 5 * parametroBean.diasBaseInversion; // Salario minimo General Anualizado
						// SI EL MONTO DE APORTACIÓN es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
						// entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
						// si no es CERO
						interRetener = aportaBean.interesRetener;

						$('#interesRetener').val(interRetener);
						$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});


						var interGenerado =$('#interesGenerado').asNumber();
						var interRecibir = (interGenerado - interRetener);

						$('#interesRecibir').val(interRecibir);
						$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

						total = $('#monto').asNumber() + interRecibir;

						$('#totalRecibir').val(total);
						$('#totalRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

						// Si existen comentarios de la aportación los carga en el campo
						if(parseInt(aportaBean.comentarios) > 0){
							$('#comentAport').val('');
							aportacionesServicio.lista(catTipoListaCambioTasa.principal,aportBean,function(comentarios){
								if(comentarios != null){
									comentarios.forEach(function(coment) {
										var aux=$('#comentAport').val();
										$('#comentAport').val(aux +""+ coment.desComentarios.toString()+"\n");
									});
									$('#tablaComentario').show();
								}
							});
						}else{
							$('#tablaComentario').hide();
							$('#comentAport').val('');
						}

						//llamada a función para cargar los campos de especificacion.
						cargaCamposEspecifica (aportaBean.tipoPagoInt,
												aportaBean.diasPagoInt,
												aportaBean.capitaliza,
												aportaBean.reinversion,
												aportaBean.notas);
						consultaSimulador();

						if(estatus == 'C'){
							mensajeSis("La Aportación se encuentra Cancelada.");
							deshabilitaBoton('cancela', 'submit');
							$(jqAport).focus();
						}

						if(estatus == 'P'){
							mensajeSis("La Aportación se encuentra Pagada (Abonada a Cuenta).");
							deshabilitaBoton('cancela', 'submit');
							$(jqAport).focus();
						}

						if(estatus == 'A'){
							mensajeSis("La Aportación no esta Autorizada.");
							deshabilitaBoton('cancela', 'submit');
							$(jqAport).focus();
						}


						if(estatus == 'N'){
							if(aportaBean.fechaInicio == parametroBean.fechaSucursal){
								mensajeSis("La Aportación es del día de hoy, utilice la pantalla de Cancelación.");
								deshabilitaBoton('cancela', 'submit');
								$(jqAport).focus();
							}
						}
					} else {
						mensajeSis('La Aportación se Encuentra en un Grupo de Consolidación.<br>Para Vencerla Anticipadamente se debe Retirar del Grupo de Consolidación.');
						deshabilitaBoton('cancela', 'submit');
						inicializaForma('formaGenerica','aportacionID');
						$(jqAport).focus();
						$(jqAport).select();
					}
				}else{
					mensajeSis('La Aportación no Existe.');
					deshabilitaBoton('cancela', 'submit');
					inicializaForma('formaGenerica','aportacionID');
					$(jqAport).focus();
					$(jqAport).select();
				}
			});
		}else {
			deshabilitaBoton('cancela', 'submit');
			inicializaForma('formaGenerica','aportacionID');
			$(jqAport).focus();
			$(jqAport).val('');
			$(jqAport).select();
		}
	}


	function consultaCliente(numCliente) {
		var conCliente = 5;
		var rfc = '';
		if(numCliente!='0'){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente)){
				clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
							if(cliente!=null){
								$('#nombreCompleto').val(cliente.nombreCompleto);
							}
							else{
								mensajeSis("El Cliente no Existe.");
								deshabilitaBoton('cancela', 'submit');
							}
					});
				}
			}
		}


	function consultaTipoAportacion(){
		var tipoAport = $('#tipoAportacionID').val();
		var conPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		var tipoAportBean = {
                'tipoAportacionID':tipoAport,
        };
			if(tipoAportBean != 0){
				tiposAportacionesServicio.consulta(conPrincipal, tipoAportBean, function(tipoAport){
					if(tipoAport!=null){
						$('#descripcion').val(tipoAport.descripcion);
						$('#diaInhabil').val(tipoAport.diaInhabil);
						validaSabadoDomingo();
					}
				});
			}
		}

	/* Valida el tipo de Aportaciones cuando se encuentre parametrizado dia inhábil: Sabado y Domingo
     * para que no se realicen vencimiento anticipados de Aportaciones el día Sábado */
	function validaSabadoDomingo(){
		var fecha = parametroBean.fechaSucursal;
		var diaInhabil = $('#diaInhabil').val();
		var aporta = $('#aportacionID').val();
		var estatus = $('#estatus').val();
		var diasTranscurridos = $('#diasTrans').val();
		var sabDom	='SD';
		var noEsFechaHabil = 'N';
		var vigente = 'N';
		var tipoAportacionID = $('#tipoAportacionID').val();

		var diaInhabilBean = {
				'fecha': fecha,
				'numeroDias': 0,
				'salidaPantalla':'S',
		};
		if (diaInhabil == sabDom && aporta > 0 && estatus == vigente
				&& diasTranscurridos >1){
			var sabado = 'Sábado y Domingo';
			diaFestivoServicio.calculaDiaFestivo(3,diaInhabilBean,function(data){
				if(data!=null){
					$('#esDiaHabil').val(data.esFechaHabil);
					if($('#esDiaHabil').val() == noEsFechaHabil){
						mensajeSis("El Tipo de Aportación " +tipoAportacionID +  " Tiene Parametrizado Día Inhábil: " + sabado +
								" por tal Motivo No se Puede Realizar el Vencimiento Anticipado de Aportación.");
						$('#aportacionID').focus();
						$('#aportacionID').select();
						$('#diaInhabil').val('');
						$('#esDiaHabil').val('');
						deshabilitaBoton('cancela', 'submit');
					}
				}
			});
		}
	}

	//Función para calcular los días transcurridos entre dos fechas
	function diasTranscurridos(fInicio,fActual) {
		var fechaInicio = new Date(fInicio);
	    var fechaActual = new Date(fActual);
	    var tiempo = fechaActual.getTime() - fechaInicio.getTime();
	    var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));
	    $('#diasTrans').val(dias);

	 }


	function validaAportacionAnclaje() {

		var aportaAnc = $('#aportacionID').val();
		var tipConsulta = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		if(aportaAnc != '' && !isNaN(aportaAnc)) {
				var aportBean = {
					'aportAnclajeID': aportaAnc
				};
				aportacionesAnclajeServicio.consulta(tipConsulta, aportBean, function(aportAncla) {
					if(aportAncla != null && aportAncla.aportacionID != '0') {
						$('#esAnclaje').val(aportAncla.aportacionOriID);
						consultaAnclajeHijo();
					} else {
						$('#esAnclaje').val('');
					}
				});

		}

	}

	function consultaAnclajeHijo(){

		var aportMadre = $('#esAnclaje').val();
		var tipConsulta = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if(aportMadre != '' && !isNaN(aportMadre)) {
				var aportBean = {
					'aportAnclajeID': aportMadre
				};
				aportacionesAnclajeServicio.consulta(tipConsulta, aportBean, function(aportAncla) {
					if(aportAncla != null && aportAncla.aportacionID != '0') {
						$('#anclajeHijo').val(aportAncla.aportacionOriID);
					} else {
						$('#anclajeHijo').val('');
					}
				});
		}

	}

function cargaCamposEspecifica (tipoPago, diaPago, capitaliza, tipoReinversion, notas) {

	// Carga el valor en el combo tipo de pago de interés
	var tipoPagoDescrip='';
	dwr.util.removeAllOptions('tipoPagoInt');
	switch (tipoPago) {
	case "V": // VENCIMIENTO
		tipoPagoDescrip = 'AL VENCIMIENTO';
		break;
	case "F": // FIN DE MES
		tipoPagoDescrip = 'FIN DE MES';
		break;
	case "P":// PERIODO
		tipoPagoDescrip = 'POR PERIODO';
		break;
	case "E":// PROGRAMADO
		tipoPagoDescrip = 'PROGRAMADO';
		break;
	default:
		tipoPagoDescrip = '';
	}

	$('#tipoPagoInt').append($('<option>', {
		    value: tipoPago,
		    text: tipoPagoDescrip
	}));
	deshabilitaControl('tipoPagoInt');

	dwr.util.removeAllOptions('diasPagoInt');
	if (parseInt(diaPago) > 0) {
		// Carga valor en el combo día de pago
		$('#diasPagoInt').append($('<option>', {
			    value: diaPago,
			    text: diaPago
		}));
		$('#diasPagoInt').show();
		$('#lbldiasPago').show();
	}else {
		// Carga valor en el combo día de pago
		$('#diasPagoInt').append($('<option>', {
			    value: 0,
			    text: 0
		}));
		$('#diasPagoInt').hide();
		$('#lbldiasPago').hide();
	}
	deshabilitaControl('diasPagoInt');

	// Carga valor en el combo capitaliza interés
	dwr.util.removeAllOptions('capitaliza');
	if (capitaliza == "S") {
		dwr.util.addOptions( "capitaliza", {'S':'SI'});
	}else {
		dwr.util.addOptions( "capitaliza", {'N':'NO'});
	}
	deshabilitaControl('capitaliza');

	// Marca el radio tipo de reinversión
	if (tipoReinversion == 'F') {
		$('#reinvertirPost').attr('checked', true);
		$('#reinvPost').text('Posteriormente');
		$('#reinvertirPost').val('F');
	}else if (tipoReinversion == 'S') {
		$('#reinvertirPost').attr('checked', true);
		$('#reinvPost').text('Reinversión Automática');
		$('#reinvertirPost').val('S');
	}else if(tipoReinversion == 'N') {
		$('#reinvertirPost').attr('checked', true);
		$('#reinvPost').text('No Realiza Reinversión');
		$('#reinvertirPost').val('N');
	}else{
		$('#reinvertirPost').attr('checked', false);
		$('#reinvPost').text('Posteriormente');
		$('#reinvertirPost').val('F');
	}
	deshabilitaControl('reinvertirPost');

	// Carga contenido el el campo notas
	$('#notas').val(notas);
	deshabilitaControl('notas');

}

// Carga Grid, funcion para consultar el calendario de pagos de Aportación */
	function consultaSimulador(){
		if(validaSimulador() == 0){
			var params = {};
			params['tipoLista']		= 2;
			params['fechaInicio']	= $('#fechaInicio').val();
			params['fechaVencimiento'] = $('#fechaVencimiento').val();
			params['monto']			= $('#monto').asNumber();
			params['clienteID']		= $('#clienteID').val();
			params['tipoAportacionID']	= $('#tipoAportacionID').val();
			params['tasaFija']		= $('#tasaFija').val();
			params['tipoPagoInt']	= $('#tipoPagoInt').val();
			params['diasPeriodo']	= $('#diasPeriodo').val();
			params['pagoIntCal']	= $('#pagoIntCal').val();
			params['diasPagoInt']	= $('#diasPagoInt').val();
			params['plazoOriginal']	= $('#plazoOriginal').val();
			params['capitaliza']	= ($('#tipoPagoInt').val()=="E")?$('#capitaliza').val():'';

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
					$("#varSaldoCapital").text(formatoMonedaVariable(varTotalCapital,true));
					$("#varTotalCapital").text(formatoMonedaVariable(varTotalCapital,true));
					$("#varTotalInteres").text(formatoMonedaVariable(varTotalInteres,true));
					$("#varTotalISR").text(formatoMonedaVariable(varTotalISR,true));
					$("#varTotalFinal").text(formatoMonedaVariable(varTotalFinal,true));

					agregaFormatoControles('formaGenerica');
				}else{
					ocultarSimulador();
				}
			});
		}
	}

function validaSimulador(){
		if($('#tipoPagoInt').val() != 'V' &&  $('#tipoPagoInt').val() != 'F' &&  $('#tipoPagoInt').val() != 'P' && $('#tipoPagoInt').val() != 'E'){
			mensajeSis('Indique el Tipo de Pago.');
			$('#tipoPagoInt').focus();
			return 1;
		}
		if($('#monto').asNumber() <= 0){
			mensajeSis('Indique un Monto Mayor a 0.');
			$('#monto').focus();
			return 1;
		}
		if($('#plazoOriginal').asNumber() <= 0 && $('#tipoPagoInt').val() != 'E'){
			mensajeSis('Indique un Plazo Mayor a 0.');
			$('#plazoOriginal').focus();
			return 1;
		}
		return 0;
	}
});

function ocultarSimulador(){
	$('#contenedorSimulador').html("");
	$('#contenedorSim').hide();
	$('#contenedorSimulador').hide();
}

function exito(){
	limpiaFormaCompleta('formaGenerica', true, [ 'aportacionID' ]);
	deshabilitaBoton('cancela', 'submit');
	ocultarSimulador();
}

function error(){
}