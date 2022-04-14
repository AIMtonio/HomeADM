//este archivo es usado por solicitudCreditoGrupal.jsp
var siRequiereCalculoRatios='S';
var siRequiereReferencias='S';
var noAceptado = 0;
$(document).ready(function() {
	$('#grupo').focus();

	esTab = true;
	solicitudActual = "";
	//Definicion de Constantes y Enums
	var catTipoConCreditoGrup = {
	'principal' : 15,
	'foranea' : 2,
	};

	var catTipoTranCreditoGrup = {
	'altaGrupal' : 13,
	'actualiza' : 3
	};

	var catTipoActCreditoGrup = {
	'rechazar' : 4,
	'liberar' : 6,
	'agregaComentario' : 7
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('agregar', 'submit');
	agregaFormatoControles('formaMenu');

	$(':text').focus(function() {
		esTab = false;
	});

	$('#tabs').tabs({
		ajaxOptions : {
			error : function(xhr, status, index, anchor) {
				$(anchor.hash).html("Couldn't load this tab. We'll try to fix this as soon as possible. " + "If this wouldn't be a demo.");
			}
		}
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccion(event, 'formaMenu', 'contenedorForma', 'mensaje', 'true', 'grupo');
		}

	});

	$('#liberarGrupal').click(function() {
		if (muestraErrorValidaGrupal()) {
			return false;
		}
		$('#tipoTransaccion').val(catTipoTranCreditoGrup.actualiza);
		$('#tipoActualizacion').val(catTipoActCreditoGrup.liberar);
	});

	$('#cancelar').click(function() {

		var motivoRechazo = '';

		var comentarioEjec = $('#nuevosComents').val();
		var comentario = $.trim(comentarioEjec);
		if (comentario == '') {
			motivoRechazo = prompt("Favor de agregar el motivo del rechazo.");

			if (motivoRechazo != null) {
				var motivoR = $.trim(motivoRechazo);
				motivoR = motivoR.toUpperCase();
				$('#motivoRechazo').val(motivoR);

			} else {
				return false;
			}

		} else {
			motivoRechazo = confirm('Esta seguro que este es el motivo del rechazo: "' + comentario + '"');

			if (motivoRechazo == true) {

				$('#motivoRechazo').val(comentario);

			} else {
				return false;
			}
		}

		$('#tipoTransaccion').val(catTipoTranCreditoGrup.actualiza);
		$('#tipoActualizacion').val(catTipoActCreditoGrup.rechazar);
		setTimeout("refrescaIntegrantesGrid();", 300);
	});

	$('#agregarComent').click(function() {

		var comentarioEjec = $('#nuevosComents').val();
		var comentario = $.trim(comentarioEjec);
		if (comentario == '') {
			mensajeSis("Agregue un comentario");
			return false;
		}

		$('#tipoTransaccion').val(catTipoTranCreditoGrup.actualiza);
		$('#tipoActualizacion').val(catTipoActCreditoGrup.agregaComentario);
		setTimeout("refrescaIntegrantesGrid();", 300);

	});

	$('#grupo').blur(function() {
		validaGrupo(this.id);
	});

	$('#solic').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href", "#asignaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#conceptoInver").attr("href", "#conInver");
		$("#check").attr("href", "#checklist");

		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined) {
			consultaSolicitudCredito();
		}
		$(this).removeAttr("href");
	});

	$('#bc').click(function() {

		$("#grup").attr("href= '#grupos'");
		$("#solic").attr("href", "#solicitud");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href", "#asignaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#conceptoInver").attr("href", "#conInver");
		$("#check").attr("href", "#checklist");
		$('#solicitud').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined) {
			consultaBC();
		}
		$(this).removeAttr("href");
	});

	$('#check').click(function() {

		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href", "#asignaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#conceptoInver").attr("href", "#conInver");

		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined) {
			consultaCheckList();
		}
		$(this).removeAttr("href");
	});

	$('#aval').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#asigAval").attr("href", "#asignaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#conceptoInver").attr("href", "#conInver");
		$("#check").attr("href", "#checklist");

		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#asignaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined) {
			consultaAvales();
		}
		$(this).removeAttr("href");
	});

	$('#asigAval').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#conceptoInver").attr("href", "#conInver");
		$("#check").attr("href", "#checklist");

		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined) {
			consultaAsignaAvales();
		}

		$(this).removeAttr("href");
	});

	$('#garan').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href", "#asignaAval");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#conceptoInver").attr("href", "#conInver");
		$("#check").attr("href", "#checklist");

		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined) {
			consultaGarantias();
		}
		$(this).removeAttr("href");

	});

	$('#asigGaran').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href", "#asignaAval");
		$("#garan").attr("href", "#garantias");
		$("#conceptoInver").attr("href", "#conInver");
		$("#check").attr("href", "#checklist");

		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#garantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined) {
			consultaAsignaGarantias();
		}
		$(this).removeAttr("href");

	});

	$('#datSosEc').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href", "#asignaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#conceptoInver").attr("href", "#conInver");

		$("#check").attr("href", "#checklist");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#conInver').html("");
		if ($(this).attr("href") != undefined) {
			consultaDtsSocioEc();
		}
		$(this).removeAttr("href");
	});

	$('#grup').click(function() {
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#datSosEc").attr("href", "#dtsSocioEcon");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href", "#asignaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#conceptoInver").attr("href", "#conInver");
		$("#check").attr("href", "#checklist");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		$('#dtsSocioEcon').html("");
		$('#conInver').html("");
		esTab = true;
	});

	$('#conceptoInver').click(function() {
		$("#grup").attr("href", "#grupos");
		$("#solic").attr("href", "#solicitud");
		$("#bc").attr("href", "#burocredito");
		$("#aval").attr("href", "#contAvales");
		$("#asigAval").attr("href", "#asignaAval");
		$("#garan").attr("href", "#garantias");
		$("#asigGaran").attr("href", "#asignaGarantias");
		$("#conceptoInver").attr("href", "#conInver");
		$("#check").attr("href", "#checklist");
		$('#solicitud').html("");
		$('#burocredito').html("");
		$('#checklist').html("");
		$('#contAvales').html("");
		$('#asignaAval').html("");
		$('#garantias').html("");
		$('#asignaGarantias').html("");
		if ($(this).attr("href") != undefined) {
			consultaConInv();
		}
		$(this).removeAttr("href");
	});

	$('#grupo').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreGrupo";
			parametrosLista[0] = $('#grupo').val();
			listaContenedor('grupo', '1', '5', camposLista, parametrosLista, 'listaGruposCredito.htm');
		}
	});

	$('#formaMenu').validate({
	rules : {
		grupo : {
			required : true
		}

	},

	messages : {
		grupo : {
			required : 'Seleccione un Grupo'
		}

	}
	});

	//------------ Validaciones de Controles -------------------------------------

	function validaGrupo(idControl) {
		var jqGrupo = eval("'#" + idControl + "'");
		var grupo = $(jqGrupo).val();

		var grupoBeanCon = {
			'grupoID' : grupo
		};
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		inicializaForma('formaMenu', 'grupo');
		$('#Integrantes').html("");
		if (grupo != '' && !isNaN(grupo) && esTab) {
			$('#nombreGrupo').val("");
			$('#cicloActual').val("");
			gruposCreditoServicio.consulta(15, grupoBeanCon, function(grupos) {
				if (grupos != null) {
					esTab = true;
					solicitudActual = "";
					$('#numSolicitud').val("");

					$('#nombreGrupo').val(grupos.nombreGrupo);
					$('#fechaRegistro').val(grupos.fechaRegistro);
					consultaIntegrantesGrid();
					var nombEstatus = "";
					switch (grupos.estatusCiclo) {
						case 'N' :
							nombEstatus = "NO INICIADO";
							$('#puedeAgregarSolicitudes').val('S');
							break;
						case 'A' :
							nombEstatus = "ABIERTO";
							$('#puedeAgregarSolicitudes').val('S');
							break;
						case 'C' :
							nombEstatus = "CERRADO";
							$('#puedeAgregarSolicitudes').val('N');
							break;
					}
					if (grupos.tipoOperacion == "NF") {
						$('#tipoOperacionFIRA').val('NO FORMAL');
					} else {
						$('#tipoOperacionFIRA').val('GLOBAL');
					}
					if (grupos.estatusCiclo != 'A') {
						mensajeSis("El Grupo debe estar Abierto para Asignar Integrantes");
						$(jqGrupo).focus();
						deshabilitaBoton('agregar', 'submit');
					} else {
						$('#nombreEstatusCiclo').val(nombEstatus);
						$('#cicloActual').val(grupos.cicloActual);
					}

				} else {
					mensajeSis("El Grupo no Existe");
					$(jqGrupo).focus();
					deshabilitaBoton('agregar', 'submit');
				}
			});
		}
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente = 1;
		var rfc = ' ';
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(conCliente, numCliente, rfc, function(cliente) {
				if (cliente != null) {
					$('#nombreCliente').val(cliente.nombreCompleto);
				} else {
					mensajeSis("No Existe el Cliente");
					$(jqCliente).focus();
				}
			});
		}
	}

	function consultaSolicitudCredito() {
		$('#solicitud').load("solicitudCreditoAgro.htm");
	}

	function consultaBC() {
		$('#burocredito').load("consultaSolicitudBCVista.htm");
	}

	function consultaAvales() {
		$('#contAvales').load("avalesAgroCatalogo.htm");
	}

	function consultaAsignaAvales() {
		$('#asignaAval').load("avalesPorSolicitudAgro.htm");
	}

	function consultaGarantias() {
		$('#garantias').load("registroGarantiaAgro.htm");
	}

	function consultaAsignaGarantias() {
		$('#asignaGarantias').load("asignacionGarantiaAgro.htm");
	}

	function consultaCheckList() {
		$('#checklist').load("solicitudCheckListAgro.htm");
	}

	function consultaDtsSocioEc() {
		$('#dtsSocioEcon').load("altaDatSocioEcoAgro.htm");
	}
	function consultaConInv() {
		$('#conInver').load("conceptosInversionAgro.htm");
	}

}); // fin funcion principal




function consultaProducCreditoGrupales(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaListaContenedor').hide();", 200);
		var linea =$('#lineaCreditoID').val();
		var conPrincipal= 1;

			if(ProdCred != '' && !isNaN(ProdCred) && esTab){
				productosCreditoServicio.consulta(conPrincipal,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						$('#nombreProducto').val(prodCred.descripcion);
						validaProductoRequiereCheckList(prodCred.requiereCheckList);

					}else{
						mensajeSis("No Existe el Producto de Crédito");
						$('#producCreditoID').focus();
						$('#producCreditoID').select();
					}
				});
			}
	}


	//funcion solo para consultar cada que cambia el grupo
	function consultaIntegrantesGrid(){
		$('#Integrantes').val('');
		var params = {};

		params['tipoLista'] = 4;
		params['grupoID'] = $('#grupo').val();


		$.post("integrantesGpoCreditoGridVista.htm", params, function(data){

			if(data.length >0) {
				var fecIn = $('#fechaInicio').val();
				$('#Integrantes').html(data);
				$('#Integrantes').show();
				agregaFormatoControles('Integrantes');
				var fechaRegis = $('#fecRegistro').val();
				if(fechaRegis !=""){
					$('#fechaRegistro').val(fechaRegis);
				}
				var productCred = $('#prodCreditoID').val();
				$('#productoCredito').val(productCred);


				consultaProducCreditoGrupales('productoCredito');
				solicitudActual = $('#numSolicitud').val();

				if($('#1').val()=='S'){
					solicitudActual= $('#radioSolicitud1').val();
				}
				validaCheckSolicitud();
				validarRadioSeleccionado();
			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}
		});
	}




	//funcion solo para refrescar cada que  se agrega un mensaje
	function refrescaIntegrantesGrid(){
		$('#Integrantes').val('');
		var params = {};

		params['tipoLista'] = 4;
		params['grupoID'] = $('#grupo').val();


		$.post("integrantesGpoCreditoGridVista.htm", params, function(data){

			if(data.length >0) {
				var fecIn = $('#fechaInicio').val();
				$('#Integrantes').html(data);
				$('#Integrantes').show();

				///aqui se guardan los valores datos de extado civil y sexp


				agregaFormatoControles('Integrantes');
				var fechaRegis = $('#fecRegistro').val();
				if(fechaRegis !=""){
					$('#fechaRegistro').val(fechaRegis);
				}
				var productCred = $('#prodCreditoID').val();
				$('#productoCredito').val(productCred);
				consultaProducCreditoGrupales('productoCredito');
				solicitudActual = $('#numSolicitud').val();
				validaCheckSolicitud();
				validarRadioSeleccionado();
			}else{
				$('#Integrantes').html("");
				$('#Integrantes').show();
			}
		});
	}
	function validaGrupales(){
		if($('#tipoOperacionFIRA').val()=="NO FORMAL"){
			if ($('#solicitudCre1').asNumber() > 0) {
				consultaValoresPrimeraSolicitudGrupal($('#solicitudCre1').asNumber());
				deshabilitaInputsSolGrupal();
			}
		}
	}
	// funcion para obtener los valores de la primera solicitud si ya existe una
	// sólo se ocupa para solicitudes grupales y cuando ya es la segunda que se da de alta.
	function consultaValoresPrimeraSolicitudGrupal(solCred) {
		setTimeout("$('#cajaLista').hide();", 200);
		if (solCred != '' && !isNaN(solCred) && esTab) {
			if (solCred != '0') {
				var SolCredBeanCon = {
						'solicitudCreditoID' : solCred,
						'usuario' : usuario
				};
				solicitudCredServicio.consulta(9,SolCredBeanCon,function(solicitud) {
							if (solicitud != null && solicitud.solicitudCreditoID != 0) {
								// forma de pago del producto de credito com apertura
								if (solicitud.forCobroComAper == 'F') {
									$('#formaComApertura').val(financiado);
								} else {
									if (solicitud.forCobroComAper == 'D') {
										$('#formaComApertura').val(deduccion);
									} else {
										if (solicitud.forCobroComAper == 'A') {
											$('#formaComApertura').val(anticipado);
										}
									}
								}

								/*campo auxiliar para la forma del cobro usado en el calculo del seguro de vida
								 * cuando se da de alta la segunda solicitud grupal*/
								$('#auxTipPago').val(solicitud.forCobroSegVida);


								// forma de pago del seguro de vida
								if (solicitud.forCobroSegVida == 'F') {
									$('#tipoPagoSeguro').val(financiado);
									$('#forCobroSegVida').val("F");
								} else {
									if (solicitud.forCobroSegVida == 'D') {
										$('#tipoPagoSeguro').val(deduccion);
										$('#forCobroSegVida').val("D");

									} else {
										if (solicitud.forCobroSegVida == 'A') {
											$('#tipoPagoSeguro').val(anticipado);
											$('#forCobroSegVida').val("A");

										}else{
											if (solicitud.forCobroSegVida == 'O') {
												$('#forCobroSegVida').val("O");

											}
										}
									}
								}

								// valores del calendario de pagos
								if (solicitud.fechInhabil == 'S') {
									$('#fechInhabil').val("S");
								} else {
									$('#fechInhabil').val("A");
								}

								if (solicitud.ajusFecExiVen == 'S') {
									$('#ajusFecExiVen').val("S");
								} else {
									$('#ajusFecExiVen').val("N");
								}

								$('#calendIrregular').val("S");
									deshabilitaControl('numAmortizacion');
									deshabilitaControl('numAmortInteres');

								if (solicitud.ajFecUlAmoVen == 'S') {
									$('#ajFecUlAmoVen').val("S");
								} else {
									$('#ajFecUlAmoVen').val("N");
								}

								$('#diaPagoCapital').val(solicitud.diaPagoCapital);
								$('#diaPagoInteres').val(solicitud.diaPagoInteres);

								if (solicitud.tipoFondeo == "P") {
									$('#tipoFondeo').attr('checked',true);
									$('#tipoFondeo2').attr("checked",false);
									deshabilitaControl('lineaFondeoID');
								} else {
									if (solicitud.tipoFondeo == "F") {
										$('#tipoFondeo2').attr('checked',true);
										$('#tipoFondeo').attr("checked",false);
										habilitaControl('lineaFondeoID');
									}
								}


								fechaVencimientoInicial = solicitud.fechaVencimiento;
								NumCuotas = solicitud.numAmortizacion;
								NumCuotasInt = solicitud.numAmortInteres;
								$('#fechaVencimiento').val(solicitud.fechaVencimiento);
								$('#productoCreditoID').val(solicitud.productoCreditoID);
								$('#grupoID').val(solicitud.grupoID);
								setCalcInteresID(solicitud.calcInteresID,false);
								$('#tipoCalInteres').val(solicitud.tipoCalInteres).selected = true;
								$('#diaMesCapital').val(solicitud.diaMesCapital);
								$('#diaMesInteres').val(solicitud.diaMesInteres);

								$('#numAmortizacion').val(solicitud.numAmortizacion);
								$('#numAmortInteres').val(solicitud.numAmortInteres);
								$('#periodicidadInt').val(solicitud.periodicidadInt);
								$('#periodicidadCap').val(solicitud.periodicidadCap);

								// se llena la parte del calendario y valores parametrizados en el producto
								// seleccionando los que se trajo de resultado la consulta
								consultaCalendarioPorProductoSolicitud(solicitud.productoCreditoID,solicitud.tipoPagoCapital,
												solicitud.frecuenciaCap,solicitud.frecuenciaInt,solicitud.plazoID,solicitud.tipoDispersion);
								esTab= true;
								consultaProducCreditoForanea(solicitud.productoCreditoID,solicitud.fechaVencimiento);
								consultaMinistracionesGrupales(solicitud.solicitudCreditoID);


							}
						});
			}
		}
	}

// consulta



	// funcion llamada en el onclick de el radio buton del grid de integrantes del grupo
	function validarRadio(númeroFila){

		$('input[name=radioSeleccionado]').each(function() {
			var jqRadio = eval("'#" + this.id + "'");
				if ( $(jqRadio).val()=='S' ){
					$(jqRadio).val('N');
				}
			});

				var jqRadioSelecionado = eval("'#" + númeroFila + "'");
				var jqsolic = eval("'#radioSolicitud" + númeroFila + "'");
				var jqProspecto = eval("'#prospecto" + númeroFila + "'");
				var jqCliente = eval("'#cliente" + númeroFila + "'");
				var jqRequiereGarant = eval("'#requiereGarantia" + númeroFila + "'");
				var jqComntEjecutivo = eval("'#comentarioEjecutivo" + númeroFila + "'");
				var jqNuevosComentarios =  eval("'#nuevosComentarios" + númeroFila + "'");
				var jqEstatusSolicitud =  eval("'#estatusSolicitud" + númeroFila + "'");
				var jqRequiereAvales =  eval("'#requiereAvales" + númeroFila + "'");
				//var jqRequiereReferencias=  eval("'#requiereReferencias" + númeroFila + "'");
				var jqMontoSolicitado = eval("'#montoSolici" + númeroFila + "'");

				var numSol = 	$(jqsolic).val();
				var idProspecto = $(jqProspecto).asNumber();
				var idCliente = $(jqCliente).asNumber();
				var requiereGarantia = $(jqRequiereGarant).val();
				var requiereAvales = $(jqRequiereAvales).val();
				var comentario =  $(jqComntEjecutivo).val();
				var estatusSolici = $(jqEstatusSolicitud).val();
				var montoSolicitado = $(jqMontoSolicitado).asNumber();
				$(jqRadioSelecionado).val('S');
			    clienteActualGrup = idCliente;
				prospectoActualGrup = idProspecto;
				solicitudActual = numSol;
				$('#numSolicitud').val(solicitudActual);
				$('#clientIDGrupal').val(idCliente);
				$('#prospectIDGrupal').val(idProspecto);
				$('#montSolicit').val(montoSolicitado);
				validaProductoRequiereGarantia(requiereGarantia);
				validaProductoRequiereAvales(requiereAvales);
				validaContieneComentario(comentario);
				validaNuevosComentarios(estatusSolici,jqNuevosComentarios);
	}

	function validaNuevosComentarios(estatusSolicitud, jqComentarioNuevo){
		var inactiva = 'I';
		if(estatusSolicitud == inactiva){
			 habilitaBoton('agregarComent', 'submit');
			 $('#nuevosComents').removeAttr('disabled');
		}else{
			deshabilitaBoton('agregarComent', 'submit');
			$('#nuevosComents').attr('disabled',true);
			$('#nuevosComents').val('');
		}
	}


	function validaProductoRequiereGarantia(requiereGarantia){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereGarantia == siRequiere){
			$('#garan').show('slow');
			$('#asigGaran').show('slow');
		}
		if(requiereGarantia == noRequiere){
			$('#garantias').html("");
			$('#asignaGarantias').html("");
			$('#garan').hide('slow');
			$('#asigGaran').hide('slow');
		}
	}

	function validaProductoRequiereAvales(requiereAvales){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereAvales == siRequiere){
			$('#aval').show('slow');
			$('#asigAval').show('slow');

		}
		if(requiereAvales == noRequiere){
			$('#contAvales').html("");
			$('#asignaAval').html("");
			$('#aval').hide('slow');
			$('#asigAval').hide('slow');
		}
	}


	function validaContieneComentario(comentario){
		var comentarioEjecutivo =  $.trim(comentario);
		if(comentarioEjecutivo !=''){
			$('#comentEjecut').val(comentarioEjecutivo);
			$('#comentDeEjecutivo').show('slow');
			$('#labelHistorialCom').show('slow');
		}else{
			$('#comentEjecut').val('');
			$('#comentDeEjecutivo').hide('slow');
			$('#labelHistorialCom').hide('slow');
		}
	}

	function validarRadioSeleccionado(){
		$('input[name=radioSeleccionado]').each(function() {
		var jqRadio = eval("'#" + this.id + "'");
			if ( $(jqRadio).val()=='S' ){
				validarRadio(this.id);
			}
		});
	}

	function validaProductoRequiereCheckList(requiereCheckList){
		var siRequiere='S';
		var noRequiere='N';
		if(requiereCheckList == siRequiere){
			$('#check').show('slow');
		}
		if(requiereCheckList == noRequiere){
			$('#checklist').html("");
			$('#check').hide('slow');
		}
	}

	// funcion para validar que cuando se regrese a la pantalla pivote (solicitud credito grupal)
	// se mantenga en seleccion la solicitud actual (esto debido a que cada que se desplaza de pestaña
	// se refresca el grid de integrantes del grupo)
	function validaCheckSolicitud(){
		var numDeta = $('input[name=consecutivo]').length;
		for(var i = 1; i <= numDeta; i++){
			var jqSolic = eval("'#solicitudCre" +i+ "'");
			var jqRadioSolic = eval("'#radioSolicitud" +i+ "'");
			var jqSoliciSeleccionada = eval("'#" +i+ "'");
			$(jqSoliciSeleccionada).val('N');
			var solicit = $(jqSolic).val();
			if(solicitudActual == solicit){
				$(jqRadioSolic).attr("checked",true);
				$(jqSoliciSeleccionada).val('S');
			}

		}
	}
	//deshabilita inputs de la solicitud grupal cuando las solicitud es >1
	function deshabilitaInputsSolGrupal() {
		deshabilitaControl('tipoPagoCapital');
		deshabilitaControl('frecuenciaCap');
		deshabilitaControl('plazoID');
		deshabilitaControl('tipoDispersion');
		deshabilitaControl('tipPago');
		deshabilitaControl('productoCreditoID');

	}

	 function muestraErrorValidaGrupal(){
		 switch(noAceptado){
		 case 1:mensajeSis('El Grupo No Existe');
			 break;
		 case 2:mensajeSis('El Grupo No Tiene Integrantes');
			 break;
		 case 3:mensajeSis('El Grupo No Tiene Integrantes Relacionados');
			 break;
		 case 4:mensajeSis('El Grupo No Tiene Producto de Crédito Relacionado.');
			 break;
		 }
		 if(noAceptado == 0 || noAceptado == 13)
			 return false;
		return true;
	 }
	/////funcion para consultar y validar los datos grupales	y guarda el error
	 function validaDatosGrupalesG( productoCre , grupo ){//id control se refiere al dato que esta tomando de el espacio select, input de la forma para procesar la informacion

		 if( 	productoCre > 0 ){
	 		//nuevo paso n 1 obtener los datos ya que tenemos grupo y producto de credito de credito
	 		var proCredBean='';
			var max 	= Number(0);
			var maxh	= Number(0);
			var maxm	= Number(0);
			var maxms	= Number(0);
			var minms	= Number(0);
			var numeroi	= Number(0);
			var numeroms= Number(0);
			var numerom	= Number(0);
			var numeroh	= Number(0);
			var conGrupo = 8;
			proCredBean = {
				  'producCreditoID':productoCre
				};
			productosCreditoServicio.consulta(4,	proCredBean, function(procred) {
	    			if(procred != null ){
	    				if(procred.esGrupal == 'S'){

		    				 max 	= Number(procred.maxIntegrantes);
		    				 maxh	= Number(procred.maxHombres);
		    				 maxm	= Number(procred.maxMujeres);
		    				 maxms	= Number(procred.maxMujeresSol);
		    				 minms	= Number(procred.minMujeresSol);
		    				 if(grupo>0){
		    					 var GrupoBeanCon = {
		 	    						'grupoID' : grupo
		 	    					};
		 	    				gruposCreditoServicio.consulta(conGrupo, GrupoBeanCon, function(grupo) {
		 	    					if(grupo!=null){

		 	    					}else{
		 	    						mensajeSis('El Grupo No Existe');
		 	    					}
		 	    				});
		    				 }
		    			}
	    			}else{
	    			mensajeSis('El Producto de Crédito Ingresado No existe.');
	    		}
			});

	 	}
	 }