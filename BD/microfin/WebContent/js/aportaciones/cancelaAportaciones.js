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
		'cancela':10
	};

	var catTipoConsulta = {
			'principal':1
		};

	var catTipoLista ={
			'cancela' : 10
	};

	var catTipoListaCambioTasa = {
		'principal': 16
	};

	deshabilitaBoton('cancela', 'submit');
	agregaFormatoControles('formaGenerica');
	$('#tdCajaRetiro').hide();
	ocultarSimulador();

	$.validator.setDefaults({
		submitHandler: function(event) {
		 var confirmar = confirm("¿Está Seguro de que Desea Cancelar la Aportación?");
			 if(confirmar == true){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','aportacionID','exito','error');
			}
		}
	});

	$('#aportacionID').bind('keyup',function(e){
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "nombreCliente";
		 parametrosLista[0] = $('#aportacionID').val();
		lista('aportacionID', 2, catTipoLista.cancela, camposLista, parametrosLista, 'listaAportaciones.htm');
	});

	$('#aportacionID').blur(function(){
		if(esTab){
			validaAportacion(this.id);
		}
	});

	$('#cancela').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.cancela);
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
		var jqAportacion = eval("'#" + idControl + "'");
		var numAportacion = $(jqAportacion).val();
		var aportaBean = {
			'aportacionID' : numAportacion
		};
		if(numAportacion != 0 && numAportacion != '' && !isNaN(numAportacion) && esTab){
			aportacionesServicio.consulta(catTipoConsulta.principal, aportaBean, function(aportBean){
				if(aportBean!=null){
					habilitaBoton('cancela', 'submit');
					estatus = aportBean.estatus;

					if(aportBean.aportacionMadreID > 0){
						esAnclaje ='S';
					}else{
						esAnclaje='N';
					}

					$('#clienteID').val(aportBean.clienteID);
					$('#cuentaAhoID').val(aportBean.cuentaAhoID);
					$('#tipoAportacionID').val(aportBean.tipoAportacionID);
					$('#tipoPagoInt').val(aportBean.tipoPagoInt);

					$('#monto').val(aportBean.monto);
					$('#plazo').val(aportBean.plazo);
					$('#plazoOriginal').val(aportBean.plazoOriginal);
					$('#fechaInicio').val(aportBean.fechaInicio);
					$('#fechaVencimiento').val(aportBean.fechaVencimiento);

					$('#tasaFija').val(aportBean.tasaFija);
					$('#tasaISR').val(aportBean.tasaISR);
					$('#tasaNeta').val(aportBean.tasaNeta);
					$('#valorGat').val(aportBean.valorGat);

					$('#interesGenerado').val(aportBean.interesGenerado);
					$('#interesRetener').val(aportBean.interesRetener);
					$('#interesRecibir').val(aportBean.interesRecibir);
					$('#valorGatReal').val(aportBean.valorGatReal);
					$('#totalRecibir').val(aportBean.totalRecibir);
					$('#estatus').val(estatus);
					mostrarElementoPorClase('trMontoGlobal',aportBean.tasaMontoGlobal);
					$('#montoGlobal').val(aportBean.montoGlobal);
					agregaFormatoControles('formaGenerica');

					consultaCliente(aportBean.clienteID);
					consultaTipoAportacion();


					if(estatus == 'C'){
						mensajeSis("La Aportación se encuentra Cancelada.");
						deshabilitaBoton('cancela', 'submit');
						$('#aportacionID').focus();
					}

					if(estatus == 'P'){
						mensajeSis("La Aportación se encuentra Pagada (Abonada a Cuenta).");
						deshabilitaBoton('cancela', 'submit');
						$('#aportacionID').focus();
					}


					if(estatus == 'A' || estatus == 'N'){
						if(aportBean.fechaInicio != parametroBean.fechaSucursal){
							mensajeSis("La Aportación no es del Día de Hoy.");
							deshabilitaBoton('cancela', 'submit');
							$('#aportacionID').focus();
						}
					}

					// Si existen comentarios de la aportación los carga en el campo
					if(parseInt(aportBean.comentarios) > 0){
						$('#comentAport').val('');
						aportacionesServicio.lista(catTipoListaCambioTasa.principal,aportaBean,function(comentarios){
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
					cargaCamposEspecifica (aportBean.tipoPagoInt,
											aportBean.diasPagoInt,
											aportBean.capitaliza,
											aportBean.reinversion,
											aportBean.notas);
					consultaSimulador();
				}else{
					mensajeSis('La Aportación no Existe.');
					deshabilitaBoton('cancela', 'submit');
					inicializaForma('formaGenerica','aportacionID');
					$('#aportacionID').focus();
					$(jqAportacion).select();
				}

			});
		}else{
				deshabilitaBoton('cancela', 'submit');
				inicializaForma('formaGenerica','aportacionID');
				$('#aportacionID').focus();
				$('#aportacionID').val('');
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
		var tipoAportacion = $('#tipoAportacionID').val();
		var conPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		var tipoAportacionBean = {
                'tipoAportacionID':tipoAportacion,
        };
			if(tipoAportacionBean != 0){
				tiposAportacionesServicio.consulta(conPrincipal, tipoAportacionBean, function(tipoAportacion){
					if(tipoAportacion!=null){
						$('#descripcion').val(tipoAportacion.descripcion);
						$('#diaInhabil').val(tipoAportacion.diaInhabil);
						validaSabadoDomingo();
					}
				});
			}
		}

	/* Valida el tipo de Aportaciones cuando se encuentre parametrizado dia inhábil: Sabado y Domingo
     * para que no se cancelen Aportaciones el día Sábado */
	function validaSabadoDomingo(){
		var fecha = parametroBean.fechaSucursal;
		var diaInhabil = $('#diaInhabil').val();
		var aportacion = $('#aportacionID').val();
		var estatus = $('#estatus').val();
		var fechaInicio = $('#fechaInicio').val();
		var sabDom	='SD';
		var noEsFechaHabil = 'N';
		var vigente = 'N';
		var tipoAportacionID = $('#tipoAportacionID').val();

		var diaInhabilBean = {
				'fecha': fecha,
				'numeroDias': 0,
				'salidaPantalla':'S',
		};
		if (diaInhabil == sabDom && aportacion > 0 && estatus == vigente
				&& fechaInicio == fecha){
			var sabado = 'Sábado y Domingo';
			diaFestivoServicio.calculaDiaFestivo(3,diaInhabilBean,function(data){
				if(data!=null){
					$('#esDiaHabil').val(data.esFechaHabil);
					if($('#esDiaHabil').val() == noEsFechaHabil){
						mensajeSis("El Tipo de Aportación " +tipoAportacionID +  " Tiene Parametrizado Día Inhábil: " + sabado +
								" por tal Motivo No se Puede Cancelar la Aportación.");
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
});

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

function ocultarSimulador(){
	$('#contenedorSimulador').html("");
	$('#contenedorSim').hide();
	$('#contenedorSimulador').hide();
}

function exito(){
	ocultarSimulador();
	deshabilitaBoton('cancela', 'submit');
}
function error(){}