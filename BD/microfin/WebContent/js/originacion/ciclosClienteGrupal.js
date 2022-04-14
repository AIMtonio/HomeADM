var montoMinimo = 0;
var montoMaximo = 0;
var requiereGL = '';
var contador = 0;
var numErr = 0;
var errMsj = "";
var numFilas = 0;
var encontrado = [];
var idMontoSol = [];
var tipoComApertura;
var montoComapertura; // monto en $ de la comision por apertura
var formaComApertura; // anticipado, deduccion o financiado
var tipoPlazo = 0;
var amortizaciones = 0; // numero de amortizaciones para el capital
var amortizacionesInt = 0; // numero de amortizaciones para el interes
var amortizacionReal = 0; // guarda el numero de amortizacion de capital que se calcula cuando se modifica el plazo o la frecuencia
var amortizacionRealInt = 0; // guarda el numero de amortizacion de interes que se calcula cuando se modifica el plazo o la frecuencia
var diaPagCapit	= ''; // especifica si el pago de capital un dia del mes o el último
var modalidad;
var tipoPagoSeg = "";
var esquemaSeguro;
var prodCredito;
var factorRS;
var porcentajeDesc;
var montoPol;
var descuentoSeg;
var pagoSeg;
var dias;
var productoCredito;
var montoComIvaSol = 0; // monto que incluye el iva, la comision por apertura
var requiereSegurgoVida;  // Indica si se cobrara seguro de vida
//Definición de constantes y Enums
var parametroBean = consultaParametrosSession();
var fechaSucursal = parametroBean.fechaSucursal;
var diaSucursal = fechaSucursal.substring(8,10);
var usuario = parametroBean.numeroUsuario;

var catTipoConsultaCredito = {
		'principal'	: 1,
		'foranea'	: 2,
		'pago'		: 7
};

var catTipoTranCredito = {
		'actualizaCalendario'		: 4 ,
};
// Definicion de Constantes y Enums
var catTipoConsultaSolicitud = {
	'principal' : 1,
	'foranea' : 2
};
var tipoConAccesorio = {
	'producto'  : 38,
	'plazo'     : 39
};


esTab = false;
var cobraAccesoriosGen = 'N';
var cobraAccesorios = 'N';
var NumCuotas = 0; // se utiliza para saber cuando se agrega o quita una cuota
var NumCuotasInt = 0; // se utiliza para saber cuando se agrega o quita una
var manejaCalendario = '';
var solicitudID = 0;
var calificacionCliente = "0.00";  // calificacion numerica del cliente
var var_TasaFija = 0.00;

$(document).ready(function(){
$("#grupoID").focus();
//-----------------------Métodos y manejo de eventos-----------------------

deshabilitaBoton('modificar', 'submit');

$(':text').focus(function() {
	 esTab = false;
});
$(':text').bind('keydown',function(e){
	if (e.which == 9 && !e.shiftKey){
		esTab= true;
	}
});

agregaFormatoControles('formaGenerica');

   $.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','funcionExito','funcionFallo');
		}
});


   $('#modificar').click(function() {
	   $('#tipoTransaccion').val(catTipoTranCredito.actualizaCalendario);
});


   $('#grupoID').blur(function() {
	if(esTab){
		validaGrupoSolicitudesInactivas(this.id);
	}
});


 $('#grupoID').bind('keyup',function(e){
	 if(this.value.length >= 2){
		var camposLista = new Array();
		var parametrosLista = new Array();
			camposLista[0] = "nombreGrupo";
			parametrosLista[0] = $('#grupoID').val();
	 listaAlfanumerica('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); }
 });

//------------ Validaciones de la Forma -------------------------------------

$('#formaGenerica').validate({
	rules: {
		grupoID: {
			required: true
		}
	},
	messages: {
		grupoID: {
			required: 'Especificar Grupo'
		}
	}
});


//-------------Validaciones de controles---------------------


});//======================== Fin de jquery ========================

///consulta GridIntegrantes////////////
function consultaIntegrantesGrupo(valorGrupo, producto){
	var numFilas = 0;
	var params = {};
	var consulta = 0 ;
	params['tipoLista'] = 15;
	params['grupoID'] 	= valorGrupo;
	params['ciclo'] 	= 0;
	params['controlIntegrante'] = 1;
	$.post("listaIntegrantesGpo.htm", params, function(data){
			if(data.length >0) {
				$('#gridIntegrantes').html(data);
				$('#gridIntegrantes').show(400);

				numFilas = cuentaFilasGrid();

				if(numFilas > 0){
					habilitaBoton('modificar', 'submit');
				}else{
					deshabilitaBoton('modificar', 'submit');
				}

				consultacicloCliente(producto);// Consulta el Ciclo del Cliente en relacion al produc indicado
				//Consultamos si cobra accesorios
				consultaCobraAccesorios();
			}else{
				$('#gridIntegrantes').html("");
				$('#gridIntegrantes').hide(400);
			}

	});
}



// Consulta de grupos
function consultaGrupo(valID, id, desGrupo) {
	var jqDesGrupo  = eval("'#" + desGrupo + "'");
	var jqIDGrupo  = eval("'#" + id + "'");
	var numGrupo = valID;
	var tipConGrupo= 1;
	var grupoBean = {
		'grupoID'	:numGrupo
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if(numGrupo != '' && !isNaN(numGrupo)){
		gruposCreditoServicio.consulta(tipConGrupo, grupoBean,function(grupo) {
			if(grupo!=null){
				$(jqIDGrupo).val(grupo.grupoID);
				$(jqDesGrupo).val(grupo.nombreGrupo);
				$('#productoCreditoID').val(grupo.productoCre);
				$('#cicloActual').val(grupo.cicloActual);
				$('#fechaRegistro').val(grupo.fechaRegistro);

				var nombEstatus="";
				switch(grupo.estatusCiclo){
					case 'N': nombEstatus="NO INICIADO";
					break;
					case 'A': nombEstatus="ABIERTO";
					break;
					case 'C':
							nombEstatus="CERRADO";
					break;
				}
				$('#estatusCiclo').val(nombEstatus);

				consultaIntegrantesGrupo(grupo.grupoID, grupo.productoCre);

			}else{
				mensajeSis("El Grupo Indicado No Existe.");
				$(jqIDGrupo).focus();
				$(jqDesGrupo).val("");
				$(jqIDGrupo).val("");
				$('#productoCreditoID').val("");
				$('#descripProducto').val("");
				$('#gridIntegrantes').html("");
				$('#gridIntegrantes').hide();
				inicializaForma('formaGenerica','grupoID');
				deshabilitaBoton('modificar', 'submit');
				plazos ='';
			}
		});
	}
}

//funcion que inicializa los combos del calendario de pagos
function funcionExito(){
$("#grupoID").focus();

}
//funcion que inicializa los combos del calendario de pagos
function funcionFallo(){
$("#grupoID").focus();
}


/* Consulta el Ciclo del Cliente */
function consultacicloCliente(producto){
var numFilas = cuentaFilasGrid();
var contador = 0;
var numCanceladas = 0;
$('tr[name=renglon]').each(function() {

	var numero= this.id.substring(7,this.id.length);
	var jqCliente = eval("'#clienteID" + numero+"'");
	var jqProspecto = eval("'#prospectoID" + numero+"'");
	var jqCicloCte = eval("'#ciclo" + numero+"'");
	var jqEstatusSolicitud = eval("'#estatus" + numero+"'");

	if($(jqEstatusSolicitud).val() == 'C'){
		numCanceladas += 1;

		if(numCanceladas == numFilas){
			deshabilitaBoton('modificar','submit');
		}
	}

	var CicloCreditoBean = {
			'clienteID':$(jqCliente).val(),
			'prospectoID':$(jqProspecto).val(),
			'productoCreditoID':producto,
			'grupoID':$('#grupoID').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	solicitudCredServicio.consultaCiclo(CicloCreditoBean,function(cicloCreditoCte) {
		contador += 1;
		if(cicloCreditoCte !=null){
			$(jqCicloCte).val(cicloCreditoCte.cicloCliente);

		}else{
			mensajeSis('No hay Ciclo para el Cliente.');
		}
	});
});
}

/*    cuenta las filas de la tabla del grid       */
function cuentaFilasGrid(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
	});
	return totales;
}

function consultaCobraAccesorios(){
	var tipoConsulta = 24;
	var bean = {
			'empresaID'     : 1
	};
	paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
		if (parametro != null){
			cobraAccesoriosGen = parametro.valorParametro;
		}else{
			cobraAccesoriosGen = 'N';
		}
	}});
}

/**
 *
 * @param {*} idControl
 * @description: Funcion para calcular las amortizaciones del ciclo del grupo
 */
function calculaCicloCliente(idControl){
	var jqSolicitud = eval("'#"+idControl+"'");
	solicitudID = $(jqSolicitud).val();
	var varSeleccion = jqSolicitud;
	var var_jqCiclo = eval('ciclo'+varSeleccion.substr(13));
	var var_ciClo =  $(var_jqCiclo).val();

	if( (solicitudID * 1) > 0 && (var_ciClo * 1)  > 0 ){
		var solCredBeanCon = {
			'solicitudCreditoID' : solicitudID,
			'usuario' : usuario
		};
		solicitudCredServicio.consulta(catTipoConsultaSolicitud.principal,solCredBeanCon,{ async: false, callback:
			function(solicitudBeanRes) {
				if (solicitudBeanRes != null) {
					if(cobraAccesoriosGen == 'S'){
						cobraAccesorios = solicitudBeanRes.cobraAccesorios;
					}
					// Validamos el estatus de la solicitud
					if(solicitudBeanRes.estatus != 'I'){
						mensajeSis('La solicitud de credito tiene un estatus diferente a inactivo');
						$(jqSolicitud).focus();
						return var_jqCiclo;
					}
					//Consulamos si existe una tasa para el ciclo
					consultaTasaCreditoNuevoCiclo(solicitudBeanRes,var_ciClo, var_jqCiclo);
				}
			}
		});
	}else{
		mensajeSis("El ciclo debe de ser mayor a cero.");
		$(var_jqCiclo).focus();
	}
}

// llamada al cotizador de amortizaciones
function simuladorAmortizaciones(solicitudBeanRes) {
	var paramsRequests = {};
	var var_tipoLista = 1;
	var var_tipoPagoCapital = solicitudBeanRes.tipoPagoCapital;
	if (solicitudBeanRes.calcInteresID == 1) {
		if (solicitudBeanRes.tipoCalInteres == '2') {
			var_tipoLista = 11;
		} else {
			switch (var_tipoPagoCapital) {
			case "C": // si el tipo de pago es // CRECIENTES
				var_tipoLista = 1;
				break;
			case "I":// si el tipo de pago es // IGUALES
				var_tipoLista = 2;
				break;
			case "L": // si el tipo de pago es // LIBRES
				var_tipoLista = 3;
				break;
			default:
				var_tipoLista = 1;
			}
		}
	}
	paramsRequests['tipoLista'] = var_tipoLista;
	if ( solicitudBeanRes != null && solicitudBeanRes.solicitudCreditoID != 0) {

		paramsRequests['montoCredito']      	= solicitudBeanRes.montoSolici;
		paramsRequests['tasaFija']         		= solicitudBeanRes.tasaFija;
		paramsRequests['frecuenciaCap']     	= solicitudBeanRes.frecuenciaCap;
		paramsRequests['frecuenciaInt']     	= solicitudBeanRes.frecuenciaInt;
		paramsRequests['periodicidadCap']   	= solicitudBeanRes.periodicidadCap;
		paramsRequests['periodicidadInt']   	= solicitudBeanRes.periodicidadInt;
		paramsRequests['producCreditoID']   	= solicitudBeanRes.productoCreditoID;
		paramsRequests['clienteID']         	= solicitudBeanRes.clienteID;
		paramsRequests['montoComision']     	= solicitudBeanRes.montoComApert;
		paramsRequests['diaPagoCapital']    	= solicitudBeanRes.diaPagoCapital;
		paramsRequests['diaPagoInteres']    	= solicitudBeanRes.diaPagoInteres;
		paramsRequests['diaMesCapital']     	= solicitudBeanRes.diaMesCapital;
		paramsRequests['diaMesInteres']     	= solicitudBeanRes.diaMesInteres;
		paramsRequests['fechaInicio']       	= solicitudBeanRes.fechaInicioAmor;
		paramsRequests['numAmortizacion']   	= solicitudBeanRes.numAmortizacion;
		paramsRequests['numAmortInteres']   	= solicitudBeanRes.numAmortInteres;
		paramsRequests['fechaInhabil']      	= solicitudBeanRes.fechInhabil;
		paramsRequests['ajusFecUlVenAmo']   	= solicitudBeanRes.ajFecUlAmoVen;
		paramsRequests['ajusFecExiVen']     	= solicitudBeanRes.ajusFecExiVen;
		paramsRequests['montoGarLiq']       	= solicitudBeanRes.aporteCliente;
		paramsRequests['numTransacSim']     	= '0';
		paramsRequests['empresaID']         	= parametroBean.empresaID;
		paramsRequests['usuario']           	= parametroBean.numeroUsuario;
		paramsRequests['fecha']             	= parametroBean.fechaSucursal;
		paramsRequests['direccionIP']       	= parametroBean.IPsesion;
		paramsRequests['sucursal']          	= parametroBean.sucursal;
		paramsRequests['cobraSeguroCuota']  	= solicitudBeanRes.cobraSeguroCuota;
		paramsRequests['cobraIVASeguroCuota']	= solicitudBeanRes.cobraIVASeguroCuota;
		paramsRequests['montoSeguroCuota']  	= solicitudBeanRes.montoSeguroCuota;
		paramsRequests['tipoCredito']       	= solicitudBeanRes.tipoCredito;
		paramsRequests['plazoID']           	= solicitudBeanRes.plazoID;
		paramsRequests['tipoOpera']         	= 1;
		paramsRequests['cobraAccesorios']   	= solicitudBeanRes.cobraAccesorios;
		paramsRequests['convenioNominaID']  	= solicitudBeanRes.convenioNominaID;

		bloquearPantallaAmortizacion();
		var numeroError = 0;
		var mensajeTransaccion = "";
		if (var_tipoPagoCapital != "L") {
			$.post("simPagCredito.htm", paramsRequests, function(data) {

				if (data.length > 0 || data != null) {
					$('#contenedorSimulador').html(data);
					if ($("#numeroErrorList").length) {
						numeroError = $('#numeroErrorList').asNumber();
						mensajeTransaccion = $('#mensajeErrorList').val();
					}
					if(numeroError==0){
						$('#contenedorSimulador').show();
						$('#contenedorSimuladorLibre').html("");
						$('#contenedorSimuladorLibre').hide();
						$('#numTransacSim').val($('#transaccion').val());
						//funcionScrollDinamico('contenedorSimulador',20);
						// actualiza la nueva fecha de vencimiento que devuelve el simulador
						var jqFechaVen = eval("'#fech'");
						$('#fechaVencimiento').val($(jqFechaVen).val());

						// asigna el valor de car decuelto por el simulador
						$('#CAT').val($('#valorCat').val());
						$('#CAT').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 1
						});

						// asigna el valor de monto de la cuota deulto por el simulador
						if (var_tipoPagoCapital == "C") {
							$('#montoCuota').val($('#valorMontoCuota').val());
							$('#montoCuota').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});
						} else {
							if (solicitudBeanRes.frecuenciaCap == "U" && var_tipoPagoCapital == "I") {
								$('#montoCuota').val($('#valorMontoCuota').val());
								$('#montoCuota').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});
							} else {
								$('#montoCuota').val("0.00");
							}
						}
						// actualiza el numero de cuotas generadas por el simulador
						$('#numAmortInteres').val($('#valorCuotasInt').val());
						$('#numAmortizacion').val($('#cuotas').val());
						// se utiliza para saber si agregar 1 cuotas mas o restar 1
						NumCuotas = $('#cuotas').val();

						// Si el tipo de pago de capital es iguales o saldos gloables devuelve el numero de cuotas de interes
						if (var_tipoPagoCapital == 'I' || var_tipoLista == 11) {
							$('#numAmortInteres').val($('#valorCuotasInt').val());
							// se utiliza para saber si agregar 1 cuotas mas o restar 1
							NumCuotasInt = $('#valorCuotasInt').val();
						}

						if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
							$('#filaTotales').hide();
						}

						if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
							$('#filaTotales').show();
						}
						$('#ExportExcel').hide();

						if (manejaCalendario = 'S') {
							$('#fechaInicioAmor').val($('#fechaInicio1').val());
						}
						if (solicitudBeanRes.tipoCalInteres == '2' && var_tipoPagoCapital == "I") {
							$('#montoCuota').val($('#valorMontoCuota').val());
							$('#montoCuota').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});
						}

						if (solicitudBeanRes.tipoCalInteres == '2' && cobraAccesorios == 'S') {
							desgloseOtrasComisiones($('#numTransacSim').val());
						}
					}
				} else {
						$('#contenedorSimulador').html("");
						$('#contenedorSimulador').hide();
						$('#contenedorSimuladorLibre').html("");
						$('#contenedorSimuladorLibre').hide();
					}
				$('#contenedorForma').unblock();

				/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
				if(numeroError!=0){
					$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
					mensajeSisError(numeroError,mensajeTransaccion);
				}
				/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
			});
		} else {
			mensajeSis("El cambio de ciclo no aplica para pagos capitales libres.");
		}

	} else {
		mensajeSis("Seleccionar Frecuencia de Capital.");
		$('#frecuenciaCap').focus();
	}
}// fin funcion simulador()


//funcion que bloque la pantalla mientras se cotiza
function bloquearPantallaAmortizacion() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});

}

function desgloseOtrasComisiones(numTransacSim){
	var listaDesglose = 6;
	var beanEntrada = {
			'creditoID':0,
			'numTransacSim':numTransacSim
	};
	esquemaOtrosAccesoriosServicio.lista(listaDesglose, beanEntrada, function(resultado) {
		if (resultado != null && resultado.length > 0) {

			var numRegistros = resultado.length;
			var numAmorAcc = resultado[0].numAmortizacion;
			var numAccesorios = resultado[0].contadorAccesorios;

			if (parseInt(numAccesorios) > 0){
				$('#tdLabelOtrasComis').remove();
				$('#tdLabelIvaOtrasComis').remove();
				$('#tdTotalOtrasComis').remove();
				$('#tdTotalIvaOtrasComis').remove();
			}

			var contadorItera = 0;

			// Itera por accesorio
			for (var contAcc = 0; contAcc < numAccesorios; contAcc++){

				var encabezadoLista = resultado[contadorItera].encabezadoLista;
				var encabezados = encabezadoLista.split(',');
				var numEncabezados = encabezados.length;

				// Se inserta el encabezado por comision
				for (var enc = 0; enc < numEncabezados; enc++){
					var elemento = encabezados[enc];
					var encabezado = '<td class="label" align="center"><label for="lblDesglose">'+ elemento +'</label></td>';
					$(encabezado).insertBefore("#tdEncabezadoAccesorios");
				}

				// Se insertan los montos por concepto y por cuota
				for (var amorAcc = 0; amorAcc < numAmorAcc; amorAcc++){

					var renglonID = amorAcc + 1;

					$('#tdOtrasComisiones' + renglonID).remove();
					$('#tdIvaOtrasComisiones' + renglonID).remove();

					var montoCuotaAcc = resultado[contadorItera].montoCuota;
					var colMontoCuotaAcc = '<td><input id="montoCuotaAcc' + contadorItera +'"  size="18" style="text-align: right;" type="text" value="' + montoCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
					$(colMontoCuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);
					var montoIVACuotaAcc = resultado[contadorItera].montoIVACuota;
					var colMontoIVACuotaAcc = '<td><input id="montoIVACuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIVACuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
					$(colMontoIVACuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);

					if (resultado[contadorItera].generaInteres == 'S'){
						var montoIntCuotaAcc = resultado[contadorItera].montoIntCuota;
						var colMontoIntCuotaAcc = '<td><input id="montoIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIntCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colMontoIntCuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);
						var montoIvaIntCuotaAcc = resultado[contadorItera].montoIVAIntCuota;
						var colMontoIvaIntCuotaAcc = '<td><input id="montoIvaIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIvaIntCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colMontoIvaIntCuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);
					}

					// Insercion de totales
					if ((amorAcc + 1) == numAmorAcc) {
						var montoTotalAcc = resultado[contadorItera].montoAccesorio;
						var colTotalMontoCuotaAcc = '<td><input id="totalMontoCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colTotalMontoCuotaAcc).insertBefore("#tdTotalVacio");
						var ivaTotalAcc = resultado[contadorItera].montoIVAAccesorio;
						var colTotalMontoIVACuotaAcc = '<td><input id="totalMontoIVACuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + ivaTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
						$(colTotalMontoIVACuotaAcc).insertBefore("#tdTotalVacio");

						if (resultado[contadorItera].generaInteres == 'S'){
							var interesTotalAcc = resultado[contadorItera].montoInteres;
							var colTotalMontoIntCuotaAcc = '<td><input id="totalMontoIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + interesTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
							$(colTotalMontoIntCuotaAcc).insertBefore("#tdTotalVacio");
							var ivaInteresTotalAcc = resultado[contadorItera].montoIVAInteres;
							var colTotalMontoIvaIntCuotaAcc = '<td><input id="totalMontoIvaIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + ivaInteresTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
							$(colTotalMontoIvaIntCuotaAcc).insertBefore("#tdTotalVacio");
						}
					}

					contadorItera += 1;
				}
			}
		}
	});
}

/*FUNCION PARA MOSTRAR EL SCROL DE MANERA DINAMICA(
idDivGrid= ID DEL DIV DEL GRID
maxfilas=NUMERO MAXIMO DE FILAS PARA NO APARECER EL SCROLL */
function funcionScrollDinamico(idDivGrid,maxfilas){
	var jqIdDivGrid = eval("'#" + idDivGrid + "'");
	var numFilas = cuentaFilasGrid();

	if(numFilas > maxfilas){
		$(jqIdDivGrid).css("height",'300px');
		$(jqIdDivGrid).css("overflow-y",'scroll');
		$(jqIdDivGrid).css("overflow-x",'scroll');
	}else{
		$(jqIdDivGrid).css("height",'300px');
		$(jqIdDivGrid).css("overflow-y",'scroll');
		$(jqIdDivGrid).css("overflow-x",'scroll');
	}
}

//Valida que existan Accesorios parametrizados para el producto de crédito
function validaAccesorios(tipoCon, cicloCliente, solicitudBeanRes){
	var valAccesorios = false;
	var paramCon = {};
	paramCon['cicloCliente'] = cicloCliente;
	paramCon['producCreditoID'] = solicitudBeanRes.productoCreditoID;

	if(tipoCon==38){
		creditosServicio.consulta(tipoCon, paramCon, {
			async : false,
			callback : function(accesorios) {
				if (accesorios != null) {
					if(accesorios.plazoID > 0 || accesorios.plazoID != "")
					valAccesorios = true;

				}
			}
		});
	}else if (tipoCon==39){
		paramCon['plazoID'] = solicitudBeanRes.plazoID;
		paramCon['montoPorDesemb'] = solicitudBeanRes.montoSolici;
		paramCon['convenioNominaID'] = solicitudBeanRes.convenioNominaID;
		creditosServicio.consulta(tipoCon, paramCon, {
			async : false,
			callback : function(accesorios) {
				if (accesorios != null) {
					valAccesorios = true;
				}
			}
		});
	}

	return valAccesorios;
}

function muestraGridAccesorios(solicitudBeanRes){
	var params = {};
	params['tipoLista'] = 2;
	params['producCreditoID'] =  solicitudBeanRes.productoCreditoID;
	params['clienteID'] =  solicitudBeanRes.clienteID;
	params['montoCredito'] =  solicitudBeanRes.montoSolici;
	params['plazoID'] =  solicitudBeanRes.plazoID;
	params['institNominaID'] = 0;
	params['convenioID'] = solicitudBeanRes.convenioNominaID;

	$.post("accesoriosGridVista.htm", params, function(data) {
		if (data.length > 0) {
			$('#divAccesoriosCred').html(data);
			var numFilas = consultaFilasAccesorios();
			if (numFilas == 0) {
				$('#divAccesoriosCred').html("");
				$('#divAccesoriosCred').show();
				$('#fieldOtrasComisiones').hide();
			} else {
				$('#divAccesoriosCred').show();
				$('#fieldOtrasComisiones').show();
				agregaFormatoControles('gridDetalleDiv');
				asignaValoresAccesorios();
			}
		} else {
			$('#divAccesoriosCred').html("");
			$('#divAccesoriosCred').show();
			$('#fieldOtrasComisiones').hide();
		}
	});


}

function asignaValoresAccesorios() {
	$("input[name=formaCobro]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');
		var jqIdChecked = eval("'formaCobro" + numero + "'");
		var formaCobro = document.getElementById(jqIdChecked).value;
		if (formaCobro == 'F') {
			$('#formaCobro' + numero).val('FINANCIAMIENTO');
		}
		if (formaCobro == 'A') {
			$('#formaCobro' + numero).val('ANTICIPADO');
		}
		if (formaCobro == 'D') {
			$('#formaCobro' + numero).val('DEDUCCION');
		}
	});

	$("input[name=montoAccesorio]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');
		var jqIdChecked = eval("'montoAccesorio" + numero + "'");
		agregaFormatoMonedaGrid(jqIdChecked)
	});
	$("input[name=montoIVAAccesorio]").each(function(i) {
		var numero = this.id.replace(/\D/g,'');
		var jqIdChecked = eval("'montoIVAAccesorio" + numero + "'");
		agregaFormatoMonedaGrid(jqIdChecked)
	});
}

//Función consulta el total de creditos en la lista
function consultaFilasAccesorios() {
	var totales = 0;
	$('tr[name=renglonAccesorio]').each(function() {
		totales++;

	});
	return totales;
}

//funcion para poner el formato de moneda en el Grid
function agregaFormatoMonedaGrid(controlID) {
	jqID = eval("'#" + controlID + "'");
	$(jqID).formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 2
	});
}

/* Funcion que genera el reporte Proyeccion de Credito, para mostrar la tabla de amortizaciones generada por el simulador */
function generaReporte() {

	if( (solicitudID * 1) > 0){
		var solCredBeanCon = {
			'solicitudCreditoID' : solicitudID,
			'usuario' : usuario
		};
		var numCliente = 0, numProspecto = 0;
		solicitudCredServicio.consulta(catTipoConsultaSolicitud.principal,solCredBeanCon,
			function(solicitudBean) {
				if (solicitudBean != null) {

					numCliente = solicitudBean.clienteID;
					numProspecto = solicitudBean.prospectoID;
					validaPeriodicidad(solicitudBean.frecuenciaCap);
					//Cuando la solicitud es de un prospecto
					if( (numProspecto * 1) > 0){
						var prospectoBeanCons = {
								'prospectoID' : numProspecto
						};
						var tipoConProspCal = 4;
						prospectosServicio.consulta(tipoConProspCal,prospectoBeanCons,function(calificacion) {
							if (calificacion != null) {
								calificacionCliente = calificacion.calificaProspectos;
								if (calificacion.calificaProspectos == 'N') {
									$('#calificaCredito').val('NO ASIGNADA');
								}
								if (calificacion.calificaProspectos == 'A') {
									$('#calificaCredito').val('EXCELENTE');
								}
								if (calificacion.calificaProspectos == 'C') {
									$('#calificaCredito').val('REGULAR');
								}
								if (calificacion.calificaProspectos == 'B') {
									$('#calificaCredito').val('BUENA');
								}
							}
						});

						var tipoConProsp = 1;
						prospectosServicio.consulta(tipoConProsp,prospectoBeanCons,function(beanProspecto) {
							if (beanProspecto != null) {
								$("#nombreProspecto").val(beanProspecto.nombreCompleto);
							}
						});
					}

					// Cuando la solicitud pertenece a un cliente
					if( (numCliente * 1) > 0){
						// consulta la calificacion numerica del cliente
						clienteServicio.consulta(16,numCliente,function(cliente) {
							if(cliente!=null){
								calificacionCliente = cliente.calificacion;
							}
						});
						clienteServicio.consulta(1,numCliente,{ async: false, callback: function(cliente) {
							if(cliente!=null){
								$('#nombreCte').val(cliente.nombreCompleto);
								if(cliente.calificaCredito=='N'){
									$('#calificaCredito').val('NO ASIGNADA');
								}
								if(cliente.calificaCredito=='A'){
									$('#calificaCredito').val('EXCELENTE');
								}
								if(cliente.calificaCredito=='C'){
									$('#calificaCredito').val('REGULAR');
								}
								if(cliente.calificaCredito=='B'){
									$('#calificaCredito').val('BUENA');
								}
							}
						}});

					}

					var clienteID = solicitudBean.clienteID;
					var nombreCliente = $("#nombreCte").val();
					var tipoReporte = 1; // PDF
					var nombreInstitucion = parametroBean.nombreInstitucion;
					var capitalPagar = $("#totalCap").asNumber();
					var interesPagar =  $("#totalInt").asNumber();
					var ivaPagar =  $("#totalIva").asNumber();
					var frecuencia = solicitudBean.frecuenciaCap;
					var frecuenciaInt = solicitudBean.frecuenciaInt;
					var frecuenciaDes =  $("#frecuenciaCapDes").val();
					var tasaFija = solicitudBean.tasaFija;

					var numCuotas = solicitudBean.numAmortizacion;
					var numCuotasInt = solicitudBean.numAmortInteres;
					var califCliente =  $("#calificaCredito").val() + "     " + calificacionCliente;
					var ejecutivo = parametroBean.nombreUsuario;
					var numTransaccion = $('#numTransacSim').val();
					var montoSol = $("#totalCap").asNumber();
					var periodicidad = solicitudBean.periodicidadCap;
					var periodicidadInt = solicitudBean.periodicidadInt;

					var diaPago = solicitudBean.diaPagoCapital;
					var diaPagoInt = solicitudBean.diaPagoInteres;
					var diaMes = solicitudBean.diaMesCapital;
					var diaMesInt = solicitudBean.diaMesInteres;

					var fechaInicio = solicitudBean.fechaInicioAmor;
					var producCreditoID = solicitudBean.productoCreditoID;
					var diaHabilSig = solicitudBean.fechInhabil;
					var ajustaFecAmo = solicitudBean.ajFecUlAmoVen;
					var ajusFecExiVen = solicitudBean.ajusFecExiVen;
					var comApertura= solicitudBean.montoPorComAper;
					var calculoInt= solicitudBean.calcInteresID;
					var tipoCalculoInt= solicitudBean.tipoCalInteres;
					var tipoPagCap = solicitudBean.tipoPagoCapital;
					var cat = solicitudBean.CAT;
					var leyenda = encodeURI($('#lblTasaVariable').text().trim());
					var plazoID = solicitudBean.plazoID;
					// SEGUROS
					var cobraSeguroCuota = solicitudBean.cobraSeguroCuota;
					var cobraIVASeguroCuota = solicitudBean.cobraIVASeguroCuota;
					var montoSeguroCuota = solicitudBean.montoSeguroCuota;
					var convenio        = solicitudBean.convenioNominaID;

					if(clienteID =='' || clienteID ==0 ){
						var clienteID = 0;
						var nombreCliente = $("#nombreProspecto").val();
					}
					if(periodicidad == ''){
						periodicidad = 0;
					}
					if(periodicidadInt == ''){
						periodicidadInt = 0;
					}
					if(diaMes == ''){
						diaMes = 0;
					}
					if(diaMesInt == ''){
						diaMesInt = 0;
					}
					if(cat == ''){
						cat = 0.0;
					}
					if(convenio = '' || convenio == null){
						convenio = 0;
					}
					if(comApertura = '' || comApertura == null){
						comApertura = 0;
					}

					url = 'reporteProyeccionCredito.htm?clienteID='+clienteID
															+ '&nombreCliente='+nombreCliente
															+ '&tipoReporte='+tipoReporte
															+ '&nombreInstitucion='+nombreInstitucion
															+ '&totalCap='+capitalPagar
															+ '&totalInteres='+interesPagar
															+ '&totalIva='+ivaPagar
															+ '&cat='+cat
															+ '&califCliente='+califCliente
															+ '&usuario='+ejecutivo
															+ '&frecuencia='+frecuencia
															+ '&frecuenciaInt='+frecuenciaInt
															+ '&frecuenciaDes='+frecuenciaDes
															+ '&tasaFija='+tasaFija
															+ '&numCuotas='+numCuotas
															+ '&numCuotasInt='+numCuotasInt
															+ '&montoSol='+montoSol
															+ '&periodicidad='+periodicidad
															+ '&periodicidadInt='+periodicidadInt
															+ '&diaPago='+diaPago
															+ '&diaPagoInt='+diaPagoInt
															+ '&diaMes='+diaMes
															+ '&diaMesInt='+diaMesInt
															+ '&fechaInicio='+fechaInicio
															+ '&producCreditoID='+producCreditoID
															+ '&diaHabilSig='+diaHabilSig
															+ '&ajustaFecAmo='+ajustaFecAmo
															+ '&ajusFecExiVen='+ajusFecExiVen
															+ '&comApertura='+comApertura
															+ '&calculoInt='+ calculoInt
															+ '&tipoCalculoInt='+tipoCalculoInt
															+ '&tipoPagCap='+tipoPagCap
															+ '&numTransaccion='+numTransaccion
															+ '&cobraSeguroCuota='+cobraSeguroCuota
															+ '&cobraIVASeguroCuota='+cobraIVASeguroCuota
															+ '&montoSeguroCuota='+montoSeguroCuota
															+ '&leyendaTasaVariable='+leyenda
															+ '&convenioNominaID='+convenio
															+ '&cobraAccesorios='+cobraAccesorios
															+ '&cobraAccesoriosGen='+cobraAccesoriosGen
															+ '&plazoID='+plazoID;
															window.open(url, '_blank');
				}
			});
	}
}

// asigna en dias la periodicidad, dependiendo de la frecuencia seleccionada
function validaPeriodicidad(frecuenciaCap) {
	switch (frecuenciaCap) {
		case "S": // SI ES SEMANAL
			$('#frecuenciaCapDes').val('SEMANAL');
			break;
		case "D": // SI ES DECENAL
			$('#frecuenciaCapDes').val('DECENAL');
			break;
		case "C": // SI ES CATORCENAL
			$('#frecuenciaCapDes').val('CATORCENAL');
			break;
		case "Q": // SI ES QUINCENAL
			$('#frecuenciaCapDes').val('QUINCENAL');
			break;
		case "M": // SI ES MENSUAL
			$('#frecuenciaCapDes').val('MENSUAL');
			break;
		case "B": // SI ES BIMESTRAL
			$('#frecuenciaCapDes').val('BIMESTRAL');
			break;
		case "T": // SI ES TRIMESTRAL
			$('#frecuenciaCapDes').val('TRIMESTRAL');
			break;
		case "R": // SI ES TETRAMESTRAL
			$('#frecuenciaCapDes').val('TETRAMESTRAL');
			break;
		case "E": // SI ES SEMANAL
			$('#frecuenciaCapDes').val('SEMANAL');
			break;
		case "A": // SI ES ANUAL
			$('#frecuenciaCapDes').val('ANUAL');
			break;
		case "L": // SI ES LIBRE
			$('#frecuenciaCapDes').val('LIBRE');
			break;
		case "P": // SI ES PERIODO
			$('#frecuenciaCapDes').val('PERIODO');
			break;
		case "U": // SI ES UNICO
			$('#frecuenciaCapDes').val('UNICO');
			break;
		default: // SI ES DEFAULT
			$('#frecuenciaCapDes').val('');
			break;
	}
}

//Funcion para Consultar el Grupo con Solicitudes Liberadas
function validaGrupoSolicitudesInactivas(idControl){
	var jqGrupo  = eval("'#" + idControl + "'");
	var grupo = $(jqGrupo).val();

	var grupoBeanCon = {
			'grupoID':grupo,
			'usuario':parametroBean.numeroUsuario
	};
	var con_soliInactiva = 17;
	var existeGrupo = false;
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	$('#contenedorSimuladorLibre').html("");
	$('#contenedorSimuladorLibre').hide();
	if(grupo != 0 && !isNaN(grupo) && (grupo* 1) > 0){
		gruposCreditoServicio.consulta(con_soliInactiva,grupoBeanCon,
			{async : false,callback : function(grupos) {
				if(grupos!=null){
					if(grupos.estatusSol=='I'){
						existeGrupo=true;
						consultaGrupo($('#grupoID').val(), 'grupoID', 'nombreGrupo');
					}else{
						mensajeSis("El Grupo indicado no tiene Solicitudes Inactivas.");
						$(jqGrupo).focus();
						$(jqGrupo).val('');
					}
				}else{
					inicializaFormaGrupal();
					existeGrupo = false;
					mensajeSis("El Grupo indicado no existe o no tiene solicitudes de creditos inactivas.");
					$(jqGrupo).focus();
					$(jqGrupo).val('');
					}
				}
			});

	}else{
		mensajeSis("El Grupo indicado no existe.");
		$(jqGrupo).focus();
		$(jqGrupo).val('');
	}
}

/**
 *
 * @description Funcion Post para registros los ciclos de los clientes del grupo
 */
function altaCiclosCliente(cicloActual,beanSol) {
	var paramsRequest = {};
	var tipoTransaccion = 11;
	paramsRequest['clienteID'] = beanSol.clienteID,
	paramsRequest['prospectoID'] = beanSol.prospectoID,
	paramsRequest['cicloActual'] = cicloActual,
	paramsRequest['tipoTransaccion'] = tipoTransaccion,
	paramsRequest['grupoID'] = $('#grupoID').val()
	var mensajeBean = "";

	$.post("ciclosProcesaClienteGrupal.htm", paramsRequest, function(respuesta) {
		mensajeBean = $('#mensajeErrorList').val();
		//Solos se habilita cuando es exitoso
		if (respuesta.numero == 0) {
			paramsRequest = respuesta;
		} else {
			paramsRequest = respuesta;
			mensajeSisError(respuesta.numero,mensajeBean);
			return false;
		}
	});
}

function inicializaFormaGrupal(){
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	$('#divAccesoriosCred').html("");
	$('#divAccesoriosCred').show();
	$('#fieldOtrasComisiones').hide();
	$('#gridIntegrantes').html("");
	$('#gridIntegrantes').hide();
	$('#cicloActual').val("");
	$('#estatusCiclo').val("");
	$('#fechaRegistro').val("");
	$('#nombreGrupo').val("");
}


// consulta la tasa de credito
function consultaTasaCreditoNuevoCiclo(solicitudBean, cicloCliente, jqCiclo) {

	var var_prodCred = solicitudBean.productoCreditoID
	var monto =  solicitudBean.montoSolici;
	var numCred = ''; // variable numero del ciclo del Cliente
	// If para tomar el valor si el producto de credito es grupal y ademas que si sea ponderado
	numCred = parseInt(cicloCliente,10);
	var var_clienteID = solicitudBean.clienteID;
	var var_prospectoID = solicitudBean.prospectoID;
	var var_plazoID = solicitudBean.plazoID;
	var var_calificacionCliente = "N";

	// bean para cuando es un cliente
	var credBeanCon = {
		'clienteID'         : var_clienteID,
		'sucursal'          : parametroBean.sucursal,
		'producCreditoID'   : var_prodCred,
		'montoCredito'      : monto,
		'calificaCliente'   : var_calificacionCliente,
		'plazoID'           : var_plazoID ,
		'empresaNomina'		: 0,
		'convenioNominaID'	: solicitudBean.convenioNominaID
	};
	// se ejecuta la función para buscar la tasa
	if (monto != '' && !isNaN(monto)) {
		// solo entra cuando se trata de un cliente
		if ( var_clienteID != '0' || var_prospectoID != '0') {
			if( var_plazoID != ''){
			creditosServicio.consultaTasa(numCred,credBeanCon, { async: false, callback: function(tasas) {
				if (tasas != null) {
					if (tasas.valorTasa > 0) {
						//Asignamos el valor de la tasa
						var_TasaFija = tasas.valorTasa;

						//Realizamos el alta del ciclo del cliente y registro de la bitacora
						altaCiclosCliente(cicloCliente,solicitudBean);
						//Realizamos la simulacion
						simuladorAmortizaciones(solicitudBean);
						//Mostramos los accesorios
						if(validaAccesorios(tipoConAccesorio.producto, cicloCliente, solicitudBean)==true && solicitudBean.cobraAccesorios == 'S'){
							muestraGridAccesorios(solicitudBean);
						}
					} else {
						mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados del Ciclo: " + cicloCliente);
						var_TasaFija = "0.00";
						$(jqCiclo).focus();
					}
				} else {
					mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados del Ciclo: " + cicloCliente);
					var_TasaFija = "0.00";
					$(jqCiclo).focus();

				}
			}});
		  }
			else{
				var_TasaFija = "0.00";
				$(jqCiclo).focus();
			}
		}
	}
}