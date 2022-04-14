
var parametroBean = consultaParametrosSession();
var procedeSubmit = false;

$(document).ready(function() {
	$('#tipoCancelacion').focus();
	esTab = true;
	procedeSubmit = true;

	var catTipoConsultaInstituciones = {
		'principal':1,
		'foranea':2
	};

	var catTipoConsultaMotivos= {
			'motivos':1
		};

	var catTipoConsultaCheques = {
		'chequesGastosAnt':5,
		'chequesSinReq':6,
		'chequesConReq':7,
		'chequesConConcilia':8
	};

	var cat_TransCancelacionCheques = {
			'cancelarCheque' :1,
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('cancelarCheque','submit');
	inicializaForma('formaGenerica', 'institucionID');

	$('#trFact1').hide();
	$('#trFact2').hide();
	$('#proveedorID').val('');
	$('#nombreProveedor').val('');
	$('#numFactura').val('');

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
        	if(procedeSubmit){
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'numeroPoliza','funcionExito','funcionFallo');
        	}
        }
    });


	$('#institucionID').bind('keyup',function(e){
		lista('institucionID', '2', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#motivoCancela').bind('keyup',function(e){
		lista('motivoCancela', '2', '2', 'descripcion', $('#motivoCancela').val(), 'listaMotivosCancelacion.htm');
	});

	$('#numCtaInstit').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numCtaInstit";
		camposLista[1] = "institucionID";
		parametrosLista[0] = $('#numCtaInstit').val();
		parametrosLista[1] = $('#institucionID').val();
		listaAlfanumerica('numCtaInstit', '2', '7', camposLista,parametrosLista, 'ctaNostroLista.htm');
	});



	$('#numCtaInstit').blur(function() {
		if($('#numCtaInstit').val() != '' ){
			consultaCuentaBan(this.id);
		}

		if(isNaN($('#numCtaInstit').val()) ){
			$('#numCtaInstit').val("");
			$('#numCtaInstit').focus();


		}

	});

 	function cargaTipoChequera(){
		tipoChequeraBean = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': $('#numCtaInstit').val()
				};

			cuentaNostroServicio.listaCombo(15,tipoChequeraBean,function(tiposChe){
				if(tiposChe!=''){
					dwr.util.removeAllOptions('tipoChequera');
  			  		dwr.util.addOptions('tipoChequera', {'':'SELECCIONAR'});
  			  		dwr.util.addOptions('tipoChequera', tiposChe, 'tipoChequera', 'descripTipoChe');
				}
			});
		}

//-- Lista de cheques emitidos--//
	$('#numCheque').bind('keyup',function(e) {
		var tipoCancelacion = $('#tipoCancelacion').val();
		if(tipoCancelacion == 1){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "institucionID"; //DONDE MOSTRAR RESULTADO
			camposLista[1] = "cuentaInstitucion";
			camposLista[2] = "beneficiario";
			camposLista[3] = "tipoChequera";
			parametrosLista[0] = $('#institucionID').val();//FILTROS
			parametrosLista[1] = $('#numCtaInstit').val();
			parametrosLista[2] = $('#numCheque').val();
			parametrosLista[3] = $('#tipoChequera').val();
			lista('numCheque', '2', '6',  camposLista, parametrosLista, 'listaChequesEmitidos.htm');

		}else if(tipoCancelacion == 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "institucionID"; //DONDE MOSTRAR RESULTADO
			camposLista[1] = "cuentaInstitucion";
			camposLista[2] = "beneficiario";
			camposLista[3] = "tipoChequera";
			parametrosLista[0] = $('#institucionID').val();//FILTROS
			parametrosLista[1] = $('#numCtaInstit').val();
			parametrosLista[2] = $('#numCheque').val();
			parametrosLista[3] = $('#tipoChequera').val();
			lista('numCheque', '2', '7',  camposLista, parametrosLista, 'listaChequesEmitidos.htm');

		}else if(tipoCancelacion == 3){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "institucionID"; //DONDE MOSTRAR RESULTADO
			camposLista[1] = "cuentaInstitucion";
			camposLista[2] = "beneficiario";
			camposLista[3] = "tipoChequera";
			parametrosLista[0] = $('#institucionID').val();//FILTROS
			parametrosLista[1] = $('#numCtaInstit').val();
			parametrosLista[2] = $('#numCheque').val();
			parametrosLista[3] = $('#tipoChequera').val();
			lista('numCheque', '2', '8',  camposLista, parametrosLista, 'listaChequesEmitidos.htm');
		}else if(tipoCancelacion == ''){
			mensajeSis("Seleccione el Tipo de Cancelación");
			$('#tipoCancelacion').focus();

		}


	});



	$('#tipoCancelacion').change(function() {
		$('#institucionID').val('');
		$('#nombreInstitucion').val('');
		$('#numCtaInstit').val('');
		$('#tipoChequera').val('');
		$('#numCheque').val('');
		$('#sucursalEmision').val('');
		$('#nombreSurcursal').val('');
		$('#fechaEmision').val('');
		$('#monto').val('');
		$('#beneficiario').val('');
		$('#concepto').val('');
		$('#motivoCancela').val('');
		$('#descripcion').val('');
		$('#comentario').val('');

		$('#numReqGasID').val('');
		$('#proveedorID').val('');
		$('#nombreProveedor').val('');
		$('#numFactura').val('');
		deshabilitaBoton('cancelarCheque','submit');

		var tipoCancelacion = $('#tipoCancelacion').val();
		if (tipoCancelacion == 3) {
			$('#trFact1').show();
			$('#trFact2').show();

		} else {
			$('#trFact1').hide();
			$('#trFact2').hide();
			$('#proveedorID').val('0');
			$('#nombreProveedor').val('0');
			$('#numFactura').val('');
		}

 	});

	$('#institucionID').blur(function() {
	   consultaInstitucion(this.id);
 	});

	$('#motivoCancela').blur(function() {
		   consultaMotivo(this.id);
	 	});



	$('#numCheque').blur(function(){
		var tipoCancelacion = $('#tipoCancelacion').val();
		
		$('#sucursalEmision').val('');
		$('#nombreSurcursal').val('');
		$('#fechaEmision').val('');
		$('#monto').val('');
		$('#beneficiario').val('');
		$('#concepto').val('');
		$('#motivoCancela').val('');
		$('#descripcion').val('');
		$('#comentario').val('');

		$('#numReqGasID').val('');
		$('#proveedorID').val('');
		$('#nombreProveedor').val('');
		$('#numFactura').val('');
		
		if(tipoCancelacion == 1){
			consultaChequesGastAnt(this.id);

		}else if(tipoCancelacion == 2){
			consultaChequesEmiSinReq(this.id);

		}
		else if(tipoCancelacion == 3){
			consultaChequesEmiConReq(this.id);
	    }
	});


	$('#numCheque').blur(function(){
		if($('#numCheque').val()!='' &&  !isNaN($('#numCheque').val())){
		habilitaBoton('cancelarCheque','submit');
		}
	});

  	$('#cancelarCheque').click(function(){
  		$('#tipoTransaccion').val(cat_TransCancelacionCheques.cancelarCheque);
  		confirmarGuardar();
  	});


   //Funcion de consulta para obtener el nombre de la institucion
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");

		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto!='' && !isNaN(numInstituto)){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
						if(instituto!=null){
							$('#nombreInstitucion').val(instituto.nombre);

							$('#numCtaInstit').val('');
							$('#tipoChequera').val('');
							$('#numCheque').val('');
							$('#sucursalEmision').val('');
							$('#nombreSurcursal').val('');
							$('#fechaEmision').val('');
							$('#monto').val('');
							$('#beneficiario').val('');
							$('#concepto').val('');
							$('#motivoCancela').val('');
							$('#descripcion').val('');
							$('#comentario').val('');

							$('#numReqGasID').val('');
							$('#proveedorID').val('');
							$('#nombreProveedor').val('');
							$('#numFactura').val('');
							deshabilitaBoton('cancelarCheque','submit');

						}else{
							mensajeSis("No existe la Institución");
							$('#institucionID').val('');
							$('#institucionID').focus();
							$('#nombreInstitucion').val("");

							$('#numCtaInstit').val('');
							$('#tipoChequera').val('');
							$('#numCheque').val('');
							$('#sucursalEmision').val('');
							$('#nombreSurcursal').val('');
							$('#fechaEmision').val('');
							$('#monto').val('');
							$('#beneficiario').val('');
							$('#concepto').val('');
							$('#motivoCancela').val('');
							$('#descripcion').val('');
							$('#comentario').val('');

							$('#numReqGasID').val('');
							$('#proveedorID').val('');
							$('#nombreProveedor').val('');
							$('#numFactura').val('');
							deshabilitaBoton('cancelarCheque','submit');




						}
				});
		}

	}


	function consultaCuentaBan(idControl) {
		var jqCuentaBan= eval("'#" + idControl + "'");
		var numCuenta = $(jqCuentaBan).val();
		setTimeout("$('#cajaLista').hide();", 200);


		var tipoConsulta = 9;
		var DispersionBeanCta = {
				'institucionID': $('#institucionID').val(),
				'numCtaInstit': numCuenta
		};
		if(!isNaN(numCuenta)){
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data){
				if(data!=null){
					$('#numCtaInstit').val(data.numCtaInstit);
					$('#tipoChequera').val('');
					$('#numCheque').val('');
					$('#sucursalEmision').val('');
					$('#nombreSurcursal').val('');
					$('#fechaEmision').val('');
					$('#monto').val('');
					$('#beneficiario').val('');
					$('#concepto').val('');
					$('#motivoCancela').val('');
					$('#descripcion').val('');
					$('#comentario').val('');

					$('#numReqGasID').val('');
					$('#proveedorID').val('');
					$('#nombreProveedor').val('');
					$('#numFactura').val('');
					deshabilitaBoton('cancelarCheque','submit');
					cargaTipoChequera();
				}else{
					mensajeSis("No se encontró la cuenta bancaria.");
					$('#numCtaInstit').val("");
					$('#numCtaInstit').focus();
					$('#tipoChequera').val('');
					$('#numCheque').val('');
					$('#sucursalEmision').val('');
					$('#nombreSurcursal').val('');
					$('#fechaEmision').val('');
					$('#monto').val('');
					$('#beneficiario').val('');
					$('#concepto').val('');
					$('#motivoCancela').val('');
					$('#descripcion').val('');
					$('#comentario').val('');

					$('#numReqGasID').val('');
					$('#proveedorID').val('');
					$('#nombreProveedor').val('');
					$('#numFactura').val('');
					deshabilitaBoton('cancelarCheque','submit');

				}
			});
		}
	}



	  //Funcion de consulta para obtener la descripcion del motivo de cancelacion
	function consultaMotivo(idControl) {
		var jqMotivo = eval("'#" + idControl + "'");

		var numMotivo = $(jqMotivo).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var MotivoBeanCon = {
			'motivoID':numMotivo
		};
		if(numMotivo!='' && !isNaN(numMotivo)){
			motivoCancelacionChequesServicio.consultaMotivos(catTipoConsultaMotivos.motivos,MotivoBeanCon,function(motivo){
						if(motivo!=null){
							if(motivo.estatus == "A"){
								$('#descripcion').val(motivo.descripcion);
							}
							else if(motivo.estatus == "I"){
								mensajeSis("El Motivo de Cancelación esta Inactivo");
								$('#motivoCancela').val('');
								$('#motivoCancela').focus();
								$('#descripcion').val("");
							}
						}else{
							mensajeSis("No existe el Motivo de Cancelación");
							$('#motivoCancela').val('');
							$('#motivoCancela').focus();
							$('#descripcion').val("");
						}
				});
		}

	}

	 //Funcion de consulta para obtener datos del cheque que fue emitido y se va a cancelar
	function consultaChequesGastAnt(idControl) {
		var jqNumCheque = eval("'#" + idControl + "'");
		var numCheque = parseFloat($(jqNumCheque).val());
		setTimeout("$('#cajaLista').hide();", 200);
		var ChequeBeanCon = {
		'institucionID' : $('#institucionID').val(),
		'cuentaInstitucion' : $('#numCtaInstit').val(),
		'tipoChequera' : $('#tipoChequera').val(),
		'numeroCheque' : numCheque,
		};

		if (numCheque != '' && !isNaN(numCheque) && esTab) {
			chequesEmitidosServicio.consulta(1, ChequeBeanCon, function(cheq) {
				if (cheq != null) {
					if (cheq.estatus == 'C' || cheq.estatus == 'O' || cheq.estatus == 'P' || cheq.estatus == 'R') {
						mensajeErrorCheque(cheq);
					} else {
						chequesEmitidosServicio.consulta(catTipoConsultaCheques.chequesConConcilia, ChequeBeanCon, function(concilia) {
							if (concilia != null) {
								if (concilia.estatusMov == 'N') {
									chequesEmitidosServicio.consulta(catTipoConsultaCheques.chequesGastosAnt, ChequeBeanCon, function(cheque) {
										if (cheque != null) {
											$('#sucursalEmision').val(cheque.sucursalID);
											$('#nombreSurcursal').val(cheque.nombreSucurs);
											$('#fechaEmision').val(cheque.fechaEmision);
											$('#monto').val(cheque.monto);
											$('#monto').formatCurrency({
											positiveFormat : '%n',
											negativeFormat : '%n',
											roundToDecimalPlace : 2
											});
											$('#beneficiario').val(cheque.beneficiario);
											$('#concepto').val(cheque.concepto);
											$('#motivoCancela').focus();
										}

										else {
											mensajeSis("El Número de Cheque no Existe o se Encuentra Pagado,Cancelado, Reemplazado o Conciliado");
											limpiaCamposCheque();
										}
									});

								} else if (concilia.estatusMov == 'C') {
									mensajeSis("El Cheque no puede Cancelarse en esta pantalla o ya fue Conciliado.");
									limpiaCamposCheque();
								}

							} else {
								mensajeSis("No existe información con los valores indicados.");
								limpiaCamposCheque();

							}
						});
					}
				} else {
					mensajeSis("No se pudo consultar el cheque.");
					limpiaCamposCheque();
				}
			});

		}
	}


	 // Funcion de consulta para obtener datos del cheque que fue emitido y
		// se va a cancelar
	function consultaChequesEmiSinReq(idControl) {
		var jqNumCheque = eval("'#" + idControl + "'");
		var numCheque = parseFloat($(jqNumCheque).val());
		setTimeout("$('#cajaLista').hide();", 200);
		var ChequeBeanCon = {
		'institucionID' : $('#institucionID').val(),
		'cuentaInstitucion' : $('#numCtaInstit').val(),
		'tipoChequera' : $('#tipoChequera').val(),
		'numeroCheque' : numCheque,
		};

		if (numCheque != '' && !isNaN(numCheque) && esTab) {
			chequesEmitidosServicio.consulta(1, ChequeBeanCon, function(cheq) {
				if (cheq != null) {
					console.log(cheq);
					if (cheq.estatus == 'C' || cheq.estatus == 'O' || cheq.estatus == 'P' || cheq.estatus == 'R') {
						mensajeErrorCheque(cheq);
					} else {
						chequesEmitidosServicio.consulta(catTipoConsultaCheques.chequesConConcilia, ChequeBeanCon, function(concilia) {
							if (concilia != null) {
								if (concilia.estatusMov == 'N') {
									chequesEmitidosServicio.consulta(catTipoConsultaCheques.chequesSinReq, ChequeBeanCon, function(cheque) {
										if (cheque != null) {
											if (cheque.estatusDisp == 'A') {
												$('#sucursalEmision').val(cheque.sucursalID);
												$('#nombreSurcursal').val(cheque.nombreSucurs);
												$('#fechaEmision').val(cheque.fechaEmision);
												$('#monto').val(cheque.monto);
												$('#monto').formatCurrency({
												positiveFormat : '%n',
												negativeFormat : '%n',
												roundToDecimalPlace : 2
												});
												$('#beneficiario').val(cheque.beneficiario);
												$('#concepto').val(cheque.concepto);
												$('#motivoCancela').focus();

											} else if (cheque.estatusDisp == 'P') {
												mensajeSis("Para Cancelar este Cheque debe ir a la pantalla de Dispersiones.");
												limpiaCamposCheque();
											}
										}
										else {
											mensajeSis("El Número de Cheque no Existe o se Encuentra Pagado,Cancelado, Reemplazado o Conciliado");
											limpiaCamposCheque();
										}
									});
								} else if (concilia.estatusMov == 'C') {
									mensajeSis("El Cheque no puede Cancelarse en esta pantalla o ya fue Conciliado.");
									limpiaCamposCheque();
								}
							} else {
								mensajeSis("No existe información con los valores indicados.");
								limpiaCamposCheque();
							}
						});
					}
				} else {
					mensajeSis("No existe información con los valores indicados.");
					limpiaCamposCheque();
				}

			});

		}
	}


		 // Funcion de consulta para obtener datos del cheque que fue emitido
			// y se va a cancelar
	function consultaChequesEmiConReq(idControl) {
		var jqNumCheque = eval("'#" + idControl + "'");
		var numCheque = parseFloat($(jqNumCheque).val());
		setTimeout("$('#cajaLista').hide();", 200);
		var ChequeBeanCon = {
		'institucionID' : $('#institucionID').val(),
		'cuentaInstitucion' : $('#numCtaInstit').val(),
		'tipoChequera' : $('#tipoChequera').val(),
		'numeroCheque' : numCheque,
		};

		if (numCheque != '' && !isNaN(numCheque) && esTab) {

			chequesEmitidosServicio.consulta(1, ChequeBeanCon, function(cheq) {
				if (cheq != null) {
					console.log(cheq);
					if (cheq.estatus == 'C' || cheq.estatus == 'O' || cheq.estatus == 'P' || cheq.estatus == 'R') {
						mensajeErrorCheque(cheq);
					} else {
						chequesEmitidosServicio.consulta(catTipoConsultaCheques.chequesConConcilia, ChequeBeanCon, function(concilia) {
							if (concilia != null) {
								if (concilia.estatusMov == 'N') {
									chequesEmitidosServicio.consulta(catTipoConsultaCheques.chequesConReq, ChequeBeanCon, function(cheques) {
										if (cheques != null) {
											if (cheques.anticipoFact != 'S') {
												if (cheques.estatusDisp == 'A') {
													if (cheques.facturaProvID != '0') {
														$('#sucursalEmision').val(cheques.sucursalID);
														$('#nombreSurcursal').val(cheques.nombreSucurs);
														$('#fechaEmision').val(cheques.fechaEmision);
														$('#numReqGasID').val(cheques.numReqGasID);
														$('#proveedorID').val(cheques.proveedorID);
														$('#nombreProveedor').val(cheques.nombreProv);
														$('#numFactura').val(cheques.referencia);
														$('#monto').val(cheques.monto);
														$('#monto').formatCurrency({
														positiveFormat : '%n',
														negativeFormat : '%n',
														roundToDecimalPlace : 2
														});
														$('#beneficiario').val(cheques.beneficiario);
														$('#concepto').val(cheques.concepto);
														$('#motivoCancela').focus();
													} else if (cheques.facturaProvID == '0') {
														mensajeSis("La Requisicion no puede Cancelarse, no es una Factura.");
														limpiaCamposCheque();
													}

												} else if (cheques.estatusDisp == 'P') {
													mensajeSis("Para Cancelar este Cheque debe ir a la pantalla de Dispersiones.");
													limpiaCamposCheque();

												}
											} else if (cheques.anticipoFact == 'S') {
												mensajeSis("El Cheque pertenece a un Anticipo, No puede Cancelarse.");
												limpiaCamposCheque();
											}

										} else {
											mensajeSis("El Número de Cheque no Existe o se Encuentra Pagado,Cancelado, Reemplazado o Conciliado");
											limpiaCamposCheque();
										}
									});

								} else if (concilia.estatusMov == 'C') {
									mensajeSis("El Cheque no puede Cancelarse en esta pantalla o ya fue Conciliado.");
									limpiaCamposCheque();
								}

							} else {
								mensajeSis("No existe información con los valores indicados.");
								limpiaCamposCheque();

							}

						});

					}

				}
			});
		}
	}




  	$('#formaGenerica').validate({
  		rules: {
   			tipoCancelacion: {
  				required: true
  			},
  			institucionID: {
  				required: true
  			},
  			numCtaInstit:{
  				required: true,
  				maxlength: 25,
  				minlength: 1
  			},
  			tipoChequera:{
  				required: true
  			},
  			numCheque:{
  				required:true
  			},
  			sucursalEmision:{
  				required:true
  			},
  			fechaEmision:{
  				required:true
  			},
  			numReqGasID:{
  				required : function() {return $('#tipoCancelacion').val() == '3';}
  			},
  			proveedorID:{
  				required : function() {return $('#tipoCancelacion').val() == '3';}
  			},
  			numFactura:{
  				required : function() {return $('#tipoCancelacion').val() == '3';}
  			},
  			monto:{
  				required:true
  			},
   			motivoCancela:{
  				required: true
  			},
  			comentario:{
  				required: true,
  				maxlength: 500
  			}
  		},
  		messages: {
  			tipoCancelacion: {
  				required: 'Especifique el Tipo de Cancelaciòn.',
  			},
  			institucionID: {
  				required: 'Especifique la Institución.',
  			},
  			numCtaInstit:{
  				required: 'Especifique el Número de Cuenta.',
  				maxlength: 'Máximo 25 Caracteres.',
  				minlength: 'Mínimo 1 Cacter.',
  			},
  			tipoChequera:{
  				required: 'Especifique el Formato del Cheque a Cancelar.'
  			},
  			numCheque:{
  				required:'Especifique el Número de Cheque.'
  			},
  			sucursalEmision:{
  				required:'Especifique la Sucursal.'
  			},
  			fechaEmision:{
  				required:'Especifique la Fecha.'
  			},
  			numReqGasID:{
  				required : 'Especifique el Nùmero de Requisiciòn.'
  			},
  			proveedorID:{
  				required : 'Especifique el Nùmero de Proveedor.'
  			},
  			numFactura:{
  				required : 'Especifique el Nùmero de Factura.'
  			},
  			monto:{
  				required:'Especifique el Monto.'
  			},
 			motivoCancela:{
  				required: 'Especifique el Motivo de Cancelación'
  			},
  			comentario:{
  				required: 'Especifique el Comentario.',
  				maxlength: 'Máximo 500 Caracteres.'
  			}
  		}
  	});

});

function limpiaCamposCheque(){
	$('#institucionID').val('');
	$('#nombreInstitucion').val('');
	$('#numCtaInstit').val('');
	$('#tipoChequera').val('');
	$('#numCheque').val('');
	$('#sucursalEmision').val('');
	$('#nombreSurcursal').val('');
	$('#fechaEmision').val('');
	$('#monto').val('');
	$('#beneficiario').val('');
	$('#concepto').val('');
	$('#motivoCancela').val('');
	$('#descripcion').val('');
	$('#comentario').val('');

	$('#numReqGasID').val('');
	$('#proveedorID').val('');
	$('#nombreProveedor').val('');
	$('#numFactura').val('');
	$('#tipoCancelacion').val('');
	$('#tipoCancelacion').focus();
	deshabilitaBoton('cancelarCheque','submit');


}

/* funcion para confirmar el cancelar el socio.*/
function confirmarGuardar() {
	var confirmar=confirm("¿Desea Continuar con el Proceso de Cancelación del Cheque?");

	if (confirmar == true) {
		procedeSubmit = true;
	}else{
		procedeSubmit = false;
	}
}



function funcionExito(){
	limpiaCamposCheque();
	$('#numeroPoliza').val($('#consecutivo').val());

}

function funcionFallo(){

}

function mensajeErrorCheque(bean){
	
	var mensajeError="";
	switch(bean.estatus){
		case "R": mensajeError = "El Cheque fue Reemplazado.";
		break;
		case "C": mensajeError = "El Cheque ya fue Cancelado.";
		break;
		case "O": mensajeError = "El Cheque ya fue Conciliado.";
		break;
		case "P": mensajeError = "El Cheque ya fue Pagado";
		break;
		default: mensajeError = "Estatus del Cheque no Válido: "+bean.estatus;
	}
	mensajeSis(mensajeError);
	if(bean.numReqGasID>0){
		$('#tipoCancelacion').val(3);
		$('#trFact1').show();
		$('#trFact2').show();
	} else {
		$('#tipoCancelacion').val(2);
		$('#trFact1').hide();
		$('#trFact2').hide();
		$('#proveedorID').val('0');
		$('#nombreProveedor').val('0');
		$('#numFactura').val('');
	}
	
	deshabilitaBoton('cancelarCheque','submit');
	$('#sucursalEmision').val(bean.sucursalID);
	$('#nombreSurcursal').val(bean.nombreSucurs);
	$('#fechaEmision').val(bean.fechaEmision);
	$('#numReqGasID').val(bean.numReqGasID);
	$('#proveedorID').val(bean.proveedorID);
	$('#nombreProveedor').val(bean.nombreProv);
	$('#numFactura').val(bean.referencia);
	$('#monto').val(bean.monto);
	$('#monto').formatCurrency({
		positiveFormat: '%n',
		negativeFormat: '%n',
		roundToDecimalPlace: 2
	});
	$('#beneficiario').val(bean.beneficiario);
	$('#concepto').val(bean.concepto);
	$('#comentario').val(bean.comentario);
	$('#motivoCancela').val(bean.motivoCancela);
	$('#descripcion').val(bean.motivoCanDes);
}