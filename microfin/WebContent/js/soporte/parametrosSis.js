var habilitaConfPass = '';

$(document).ready(function() {

	$("#empresaID").focus();

	parametros = consultaParametrosSession();

	esTab = true;

	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	var catTipoTransaccionParametros = {
		'alta' : '1',
		'modificacion' : '2'
	};


	var catTipoConsultaInstituciones = {
		'principal':1,
		'foranea':2
	};

	var catTipoConsultaSucursal = {
		  'principal':1,
		  'foranea':2
	};

	var catTipoConsultaTipoCuenta = {
		  'principal':1,
		  'foranea':2
	};
	var catTipoConsultaUsuario = {
			  'principal':1,
		};

	var Enum_Constantes = {
		'SI'		: 'S',
		'NO'		: 'N',
	};

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
		}
	});


		// ------------ Metodos y Manejo de Eventos
	deshabilitaControl('correoRemitente');
	deshabilitaControl('correoRemitenteCierre');
	deshabilitaBoton('modificar', 'submit');
	agregaFormatoControles('formaGenerica');
	$('#aplCobPenCieDia1').attr("checked",true);
	$('#aplCobPenCieDia2').attr("checked",false);
	$('#mostrarSaldDispCta1').attr("checked",true);
	$('#divideIngresoInteres').attr("checked",true);
	$('#tipoContaMora').attr("checked",true);
	$('#aplCobPenCieDia').val("S");
	$('#validaFacturaNO').attr("checked",true);
	$('#validaFacturaSI').attr("checked",false);
	$('#camFuenFonGarFiraSI').attr("checked",false);
	$('#camFuenFonGarFiraNO').attr("checked",true);
	$('#ejecDepreAmortiAutSI').attr("checked",false);
	$('#ejecDepreAmortiAutNO').attr("checked",true);
	$('#alerVerificaConvenio').attr("checked",false);
	$('#alerVerificaConvenio1').attr("checked",true);
	limpiaAlertaVenConvenio();

	$.validator.setDefaults({
	    submitHandler: function(event) {
	    		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','empresaID');
	      }
	 });

	$('#modificar').click(function() {
		if($('#fechaUltimoComite').val()==""){
			$('#fechaUltimoComite').val("1900-01-01");
		}

		if(habilitaConfPass == 'S') {
			if( parseInt($('#caracterMinimo').val()) != (parseInt($('#caracterMayus').val()) + parseInt($('#caracterMinus').val()) + parseInt($('#caracterNumerico').val()) + parseInt($('#caracterEspecial').val())) ){
				mensajeSis("La cantidad de caracteres mínimos para la Contraseña no debe ser menor que la cantidad de caracteres en mayúscula, minúscula, especiales y número.");
				$('#caracterMinimo').focus();
				return false;
			}
		}

		if (noRequiereRolesDeFlujoCred()) {
			$('#tipoTransaccion').val(catTipoTransaccionParametros.modificacion);
		}


	});

	$('#empresaID').blur(function() {
		validaEmpresaID(this);
	});

	$('#remitenteID').bind('keyup', function (e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#remitenteID').val();
			lista('remitenteID', '1', '1', camposLista, parametrosLista, 'listacorreo.htm');
		}
	});

	$('#remitenteID').blur(function() {
		var TarEnvioCorreoParamBeanCon = {
			'remitenteID': $('#remitenteID').val()
		};
		if ($('#remitenteID').val()!='' && $('#remitenteID').val()!=0) {
			tarEnvioCorreoParamServicio.consulta(1, TarEnvioCorreoParamBeanCon, function (correo) {
				if (correo != null) {
					if (correo.correoSalida!="" && correo.correoSalida!=null) {
						$('#correoRemitente').val(correo.correoSalida);
					}else{
						mensajeSis("El remitente no tiene un correo registrado.");
					}
				}
				else {
					mensajeSis("No Existe el Remitente");
					$('#remitenteID').focus();
					$('#remitenteID').val('');
					$('#correoRemitente').val('');
				}
			});

		}

	});
	//Remitente Cierre de día
	$('#remitenteCierreID').bind('keyup', function (e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#remitenteCierreID').val();
			lista('remitenteCierreID', '1', '1', camposLista, parametrosLista, 'listacorreo.htm');
		}
	});

	$('#remitenteCierreID').blur(function() {
		var numRemCierreID = $('#remitenteCierreID').val();
		var TarEnvioCorreoParamBeanCon = {
			'remitenteID': $('#remitenteCierreID').val()
		};
		if (numRemCierreID != '' && !isNaN(numRemCierreID)) {
			tarEnvioCorreoParamServicio.consulta(1, TarEnvioCorreoParamBeanCon, function (correo) {
				if (correo != null) {
					if (correo.correoSalida!="" && correo.correoSalida!=null) {
						$('#correoRemitenteCierre').val(correo.correoSalida);
					}else{
						mensajeSis("El remitente no tiene un correo registrado.");
					}
				}
				else {
					mensajeSis("No Existe el Remitente");
					$('#remitenteCierreID').focus();
					$('#remitenteCierreID').val('');
					$('#correoRemitenteCierre').val('');
				}
			});

		}else{
			mensajeSis("Especifique ID para el Remitente Cierre de Día.");
			$('#remitenteCierreID').val('');
			$('#correoRemitenteCierre').val('');
			$('#remitenteCierreID').focus();
		}

	});

	// tipo documentos
	$('#tipoDocumentoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "tipoDocumentoID";
		parametrosLista[0] = $('#tipoDocumentoID').val();
		lista('tipoDocumentoID', '1', '4', camposLista,parametrosLista, 'ListaTiposDocumentos.htm');

	});

	  $('#tipoDocumentoID').blur(function() {
		  if(esTab){
			  if($('#tipoDocumentoID').val()!="" && $('#tipoDocumentoID').asNumber()!=0){
				  consultaDescripcionFirma(this.id);
			   }else{
				   $('#tipoDocumentoID').val("");
				   $('#descripcionDoc').val("");
			   }
		  }
	  });

	$('#empresaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreInstitucion";
		parametrosLista[0] = $('#empresaID').val();
		lista('empresaID', '1', '1', camposLista,parametrosLista, 'listaParametrosSis.htm');
	});

	$('#institucionID').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombre";
		parametrosLista[0] = $('#institucionID').val();
		lista('institucionID', '1', '1', camposLista,parametrosLista, 'listaInstituciones.htm');
	});

	 $('#institucionID').blur(function() {
	   	if($('#institucionID').val()!=""){
	   		consultaInstitucion(this.id);
	   	} 	else{
	   		$('#nombreInstitucion').val('');
	   	}
	 });

	 $('#clienteInstitucion').bind('keyup',function(e){
			lista('clienteInstitucion', '3', '1', 'nombreCompleto', $('#clienteInstitucion').val(), 'listaCliente.htm');
		});

	 $('#clienteInstitucion').blur(function() {
			if($('#clienteInstitucion').val()!=""){
				consultaCliente(this.id);
		   	} 	else{
		   		$('#nombreInstitucionCliente').val('');
		   	}
		});
	$('#ctaContaDepCtaAho').blur(function (params) {
		validaCunetaContable(this.id);
	})

	  $('#bancoCaptacion').bind('keyup',function(e){
	      var camposLista = new Array();
	      var parametrosLista = new Array();
	      camposLista[0] = "nombre";
	      parametrosLista[0] = $('#bancoCaptacion').val();
	      lista('bancoCaptacion', '1', '1', camposLista,parametrosLista, 'listaInstituciones.htm');
	  });
	  $('#bancoCaptacion').blur(function() {
		  if($('#bancoCaptacion').val()!=""){
			  consultaInstituciones(this.id);
		   }	else{
		   		$('#nombreInstituciones').val('');
		   	}
	  });

	   $('#rolTesoreria').bind('keyup',function(e){
	       	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#rolTesoreria').val();
			lista('rolTesoreria', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');
		});

		$('#rolTesoreria').blur(function() {
			  if($('#rolTesoreria').val()!=""){
				  consultaRoles(this.id);
			   }	else{
			   		$('#nombreRolTesoreria').val('');
			   	}

		});

		 $('#rolAdminTeso').bind('keyup',function(e){
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#rolAdminTeso').val();
			lista('rolAdminTeso', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');
		});

		$('#rolAdminTeso').blur(function() {
			if($('#rolAdminTeso').val()!=""){
				consultaAdminTesoreriaRoles(this.id);
			   }	else{
			   		$('#nombreAdminRolTesoreria').val('');
			   	}

		});
		$('#primerRolFlujoSolID').blur(function() {
			if($('#primerRolFlujoSolID').val()!=""){
				consultaPrimerRolFluj(this.id);
			}else{
				$('#nombrePrimerRol').val('');
			}
		});
		$('#primerRolFlujoSolID').bind('keyup',function(e){
	       	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#primerRolFlujoSolID').val();
			lista('primerRolFlujoSolID', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');
		});
		$('#segundoRolFlujoSolID').blur(function() {
			if($('#segundoRolFlujoSolID').val()!=""){
				consultaSegunRolFluj(this.id);
			}else{
				$('#nombreSegundoRol').val('');
			}
		});
		$('#segundoRolFlujoSolID').bind('keyup',function(e){
	       	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#segundoRolFlujoSolID').val();
			lista('segundoRolFlujoSolID', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');
		});


		$('#perfilWsVbc').bind('keyup',function(e){
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#perfilWsVbc').val();
			lista('perfilWsVbc', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');
		});

		$('#perfilWsVbc').blur(function() {
			if($('#perfilWsVbc').val()!=""){
				consultaRolesVBC(this.id);
			}else{
				$('#nombrePerfilWsVbc').val('');
			}
		});

		$('#perfilAutEspAport').bind('keyup',function(e){
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#perfilAutEspAport').val();
			lista('perfilAutEspAport', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');
		});

		$('#perfilAutEspAport').blur(function() {
			if($('#perfilAutEspAport').val()!=""){
				consultaRolesAutAport(this.id);
			}else{
				$('#nomPerfilAutEspAport').val('');
			}
		});

		$('#perfilCamCarLiqui').bind('keyup',function(e){
		   	var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreRol";
			parametrosLista[0] = $('#perfilCamCarLiqui').val();
			lista('perfilCamCarLiqui', '1', '1', camposLista,parametrosLista, 'listaRoles.htm');
		});

		$('#perfilCamCarLiqui').blur(function() {
			if($('#perfilCamCarLiqui').val()!=""){
				consultaRolesCamCarta(this.id);
			}else{
				$('#nomPerfilCamCarLiqui').val('');
			}
		});

		$('#sucursalMatrizID').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreSucurs";
			parametrosLista[0] = $('#sucursalMatrizID').val();
			lista('sucursalMatrizID', '2', '4', camposLista,parametrosLista, 'listaSucursales.htm');
		});

		$('#sucursalMatrizID').blur(function() {
			if($('#sucursalMatrizID').val()!=""){
			  	consultaSucursal(this.id);
			   }	else{
			   		$('#nombreMatriz').val('');
			   	}
		});

		$('#tipoCuenta').bind('keyup',function(e){
			if(this.value.length >= 3){
				lista('tipoCuenta', '3', '1', 'descripcion', $('#tipoCuenta').val(), 'listaTiposCuenta.htm');
			}
		});
		$('#tipoCuenta').blur(function() {
			if($('#tipoCuenta').val()!=""){
				consultaCuenta(this.id);
			   }	else{
			   		$('#descripcion').val('');
			   	}

		});
		$('#oficialCumID').bind('keyup',function(e){
			lista('oficialCumID', '2', '1', 'nombreCompleto', $('#oficialCumID').val(), 'listaUsuarios.htm');
		});

		$('#oficialCumID').blur(function() {
			validaUsuario(this.id);
		});

		$('#dirGeneralID').bind('keyup',function(e){
			lista('dirGeneralID', '2', '1', 'nombreCompleto', $('#dirGeneralID').val(), 'listaUsuarios.htm');
		});

		$('#dirGeneralID').blur(function() {
			validaUsuario(this.id);
		});

		$('#dirOperID').bind('keyup',function(e){
			lista('dirOperID', '2', '1', 'nombreCompleto', $('#dirOperID').val(), 'listaUsuarios.htm');
		});

		$('#dirOperID').blur(function() {
			validaUsuario(this.id);
		});

		$('#servReactivaCliID').blur(function() {
			validaCatalogoServicio(this.id);
		});

		$('#sistemasID').bind('keyup',function(e){
			lista('sistemasID', '2', '1', 'nombreCompleto', $('#sistemasID').val(), 'listaUsuarios.htm');
		});

		$('#sistemasID').blur(function() {
			validaUsuario(this.id);
		});

		$('#ctaIniGastoEmp').bind('keyup',function(e){
			if(this.value.length >= 2){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "descripcion";
				parametrosLista[0] = $('#ctaIniGastoEmp').val();
				listaAlfanumerica('ctaIniGastoEmp', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
			}
		});
		$('#ctaFinGastoEmp').bind('keyup',function(e){
			if(this.value.length >= 2){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "descripcion";
				parametrosLista[0] = $('#ctaFinGastoEmp').val();
				listaAlfanumerica('ctaFinGastoEmp', '1', '1', camposLista, parametrosLista, 'listaCuentasContables.htm');
			}
		});

		//Lista de Catalogos de Servicios
		$('#servReactivaCliID').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "servReactivaCliID";
			camposLista[1] = "nombreServicio";

			parametrosLista[0] = 0;
			parametrosLista[1] = $('#servReactivaCliID').val();

			lista('servReactivaCliID', '1', '4', camposLista,parametrosLista, 'listaCatalogoServicios.htm');
		});

		$('#ctaIniGastoEmp').blur(function() {
			maestroCuentasDescripcion(this.id,'descCuentaInicial','ctaFinGastoEmp');
		});

		$('#ctaFinGastoEmp').blur(function() {
			maestroCuentasDescripcion(this.id,'decctaFinGastoEmp','ctaIniGastoEmp');
		});

		$('#reqAportacionSo1').click(function() {
			$('#tlMontoAportacion').show(500);
			$('#montoAportacion').show(500);
		});
		$('#reqAportacionSo2').click(function() {
			$('#tlMontoAportacion').hide(500);
			$('#montoAportacion').hide(500);
			$('#montoAportacion').val('');
		});

		//Predeterminando radiobuton faturacion electronica
		$('#timbraEdoCta1').attr("checked",true);
		$('#generaCFDINoReg1').attr("checked",true);
		$('#generaEdoCtaAuto1').attr("checked",true);




		$('#promotorID').bind('keyup',function(e){
			//TODO Agregar Libreria de Constantes Tipo Enum
			lista('promotorID', '1', '1', 'nombrePromotor', $('#promotorID').val(), 'listaPromotores.htm');
		});

		$('#promotorID').blur(function() {
	  		validaPromotor(this.id, 'nombrePromotor', $('#promotorID').val());
		});

		//RadioButton Validacion Facturas

		$('#validaFacturaSI').click(function() {
			$('#validaFacturaSI').focus();
			$('#validaFacturaSI').attr("checked",true);
			$('#validaFacturaNO').attr("checked",false);
			$('#validaFactura').val("S");
			$('#validaFacturaUrl').attr('disabled',false);
			$('#tiempoEspera').attr("disabled",false);
		});

		$('#validaFacturaNO').click(function() {
			$('#validaFacturaNO').focus();
			$('#validaFacturaNO').attr("checked",true);
			$('#validaFacturaSI').attr("checked",false);
			$('#validaFactura').val("N");
			$('#validaFacturaUrl').attr('disabled',true);
			$('#tiempoEspera').attr("disabled",true);
		});

		$('#validaFacturaUrl').change(function(){
			$('#validaFacturaURL').val($('#validaFacturaUrl').val());
		});

		$('#tiempoEspera').change(function(){
			$('#tiempoEsperaWS').val($('#tiempoEspera').val());
		});

		$('#validaCapitalConta').change(function(){
			if($('#validaCapitalConta').val()=="N"){
				deshabilitaControl('porMaximoDeposito');
				$('#porMaximoDeposito').val(0.00);
				$('#porMaximoDeposito').focus();
			}else{
				habilitaControl('porMaximoDeposito');
			}
		});



		$('#aplCobPenCieDia1').click(function() {
			$('#aplCobPenCieDia1').focus();
			$('#aplCobPenCieDia1').attr("checked",true);
			$('#aplCobPenCieDia2').attr("checked",false);
			$('#aplCobPenCieDia').val("S");

		});

		$('#aplCobPenCieDia2').click(function() {
			$('#aplCobPenCieDia2').focus();
			$('#aplCobPenCieDia2').attr("checked",true);
			$('#aplCobPenCieDia1').attr("checked",false);
			$('#aplCobPenCieDia').val("N");
		});
		$('#fechaUltimoComite').change(function(){

			var Xfecha= $('#fechaUltimoComite').val();
			if(Xfecha!=''){
				$('#fechaUltimoComite').focus();
				if(esFechaValida(Xfecha)){
					var Yfecha=parametroBean.fechaSucursal;
					if (mayor(Xfecha, Yfecha) ){
						mensajeSis("La fecha seleccionada no debe ser mayor a la de hoy.")	;
						$('#fechaUltimoComite').val(parametroBean.fechaSucursal);
						$('#fechaUltimoComite').focus();
					}
				}else{
						$('#fechaUltimoComite').val(parametroBean.fechaSucursal);
				}
			}
		});
		$('#ctaContaSobrante').bind('keyup',function(e){
			listaMaestroCuentas(this.id,'descripCtaContaSobrante');
		});
		$('#ctaContaFaltante').bind('keyup',function(e){
			listaMaestroCuentas(this.id, 'descripCtaContaFaltante');
		});
		$('#ctaContaDocSBCD').bind('keyup',function(e){
			listaMaestroCuentas(this.id,'descripCtaSBCCOD');
		});
		$('#ctaContaDocSBCA').bind('keyup',function(e){
			listaMaestroCuentas(this.id, 'descripCtaSBCCOA');
		});

		$('#institucionCirculoCredito').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "tipoInstitucion";
			parametrosLista[0] = $('#institucionCirculoCredito').val();
			lista('institucionCirculoCredito', '2', '1', camposLista,parametrosLista, 'listaTipoInstitucionCirculo.htm');
		});

		$('#institucionCirculoCredito').blur(function() {
			if(esTab){
				consultaInstitucionCirculoCredito(this.id);
			}
		});

		$('#ctaContaSobrante').blur(function() {
			if(esTab){
				consultaCuentasContaDescripcion(this.id, 'descripCtaContaSobrante');
			}
		});
		$('#ctaContaFaltante').blur(function() {
			if(esTab){
				consultaCuentasContaDescripcion(this.id, 'descripCtaContaFaltante');
			}
		});
		$('#ctaContaDocSBCD').blur(function() {
			if(esTab){
				consultaCuentasContaDescripcion(this.id, 'descripCtaSBCCOD');
			}
		});
		$('#ctaContaDocSBCA').blur(function() {
			if(esTab){
				consultaCuentasContaDescripcion(this.id, 'descripCtaSBCCOA');
			}
		});

		$('#afectaContaRecSBC1').click(function() {
			$('#trSBCCOD').show();
			$('#trSBCCOA').show();
			$('#centroCostos').show();

			$('#ctaContaDocSBCD').val('');
			$('#descripCtaSBCCOD').val('');
			$('#ctaContaDocSBCA').val('');
			$('#descripCtaSBCCOA').val('');
		});
		$('#afectaContaRecSBC2').click(function() {
			$('#trSBCCOD').hide();
			$('#trSBCCOA').hide();
			$('#centroCostos').hide();

			$('#ctaContaDocSBCD').val('');
			$('#descripCtaSBCCOD').val('');
			$('#ctaContaDocSBCA').val('');
			$('#descripCtaSBCCOA').val('');
			$('#cenCostosChequesSBC').val('');

		});

		$('#telefonoLocal').setMask('phone-us');
		$('#telefonoInterior').setMask('phone-us');

		$('#telefonoLocal').blur(function(){
			if($('#telefonoLocal').val() == ''){
				$('#extTelefonoLocal').val('');
			}
		});
		$('#telefonoInterior').blur(function(){
			if($('#telefonoInterior').val()==''){
				$('#extTelefonoInt').val('');
			}
		});

		$("#extTelefonoLocal").blur(function(){
			if(this.value != ''){
				if($("#telefonoLocal").val() == ''){
					this.value = '';
					mensajeSis("El Número de Teléfono está Vacío.");
					$("#telefonoLocal").focus();
				}
			}
		});


		$("#extTelefonoInt").blur(function(){
			if(this.value != ''){
				if($("#telefonoInterior").val() == ''){
					this.value = '';
					mensajeSis("El Número de Teléfono está Vacío.");
					$("#telefonoInterior").focus();
				}
			}
		});

		consultaTiposCuenta();


		$('#conBuroCreDefautBuro').click(function() {
			$('#conBuroCreDefautBuro').focus();
			$('#conBuroCreDefautBuro').attr("checked",true);
			$('#conBuroCreDefautCirculo').attr("checked",false);
			$('#conBuroCreDefaut').val("B");
		});


		$('#conBuroCreDefautCirculo').click(function() {
			$('#conBuroCreDefautCirculo').focus();
			$('#conBuroCreDefautCirculo').attr("checked",true);
			$('#conBuroCreDefautBuro').attr("checked",false);
			$('#conBuroCreDefaut').val("C");
		});

		 $('#cancelaAutSolCre1').click(function() {
			$('#diasCancela').show();
			$('#diasCancelaAutSolCre').show();
			$('#diasCancelaAutSolCre').val('');
			$('#diasCancelaAutSolCre').rules("add", {
					required: function() {return $('#cancelaAutSolCre1').is(':checked');},
					min: 1,
				messages: {
					required: 'Especifique días de cancelación',
					min: 'El día de cancelación debe ser mayor a 0'
					}
				});
		 	});


		$('#cancelaAutSolCre2').click(function() {
			$('#diasCancelaAutSolCre').rules("remove");
			$("label.error").hide();
			$(".error").removeClass("error");
			$('#diasCancela').hide();
			$('#diasCancelaAutSolCre').hide();
			$('#diasCancelaAutSolCre').val(0);

		});

		$('input[name="evaluacionMatriz"]').change(function (event){
			var evaluacionMatriz = $('input[name=evaluacionMatriz]:checked').val();
			if(evaluacionMatriz===Enum_Constantes.SI){
				muestraFrecuenciaMatriz(true);
			} else if(evaluacionMatriz===Enum_Constantes.NO){
				muestraFrecuenciaMatriz(false);
			}
		});

		$('#reestCalendarioVenNo').click(function() {

			$('#validaEstatusReesSi').hide();
			$('#validaEstatusReesNo').hide();
			$('#lblValidaEstatusTxt').hide();
			$('#lblValidaEstatusSi').hide();
			$('#lblValidaEstatusNo').hide();




		});

		$('#cuentasCapConta').blur(function() {
			var expresionRegular = /^[0-9]+%{0,}(\-[0-9]+%{0,}|\+[0-9]+%{0,})*$/;
			var cadena = $('#cuentasCapConta').val();
			var evaluarExpresion = expresionRegular.test(cadena);
			if(evaluarExpresion == true){
				$('#validaCapitalConta').focus();
			} else{
				$('#cuentasCapConta').val('');
				mensajeSis("Valor Invalido. El campo solo acepta los caracteres '+,-,%'. Ejemplo: 4%+5% o 5%-2%");
				$('#cuentasCapConta').focus();
			}

		});

		$('#ctaFinGastoEmp').blur(function() {
			maestroCuentasDescripcion(this.id,'decctaFinGastoEmp','ctaIniGastoEmp');
		});

		$('#cobranzaAutCie1').click(function() {
			$('#cobranzaAutCie1').focus();
			$('#cobranzaAutCie1').attr("checked",true);
			$('#cobranzaAutCie2').attr("checked",false);
			$('#cobranzaAutCie').val("S");

			$('#cobroCompletoAut1').show();
			$('#cobroCompletoAut2').show();
			$('#lblcobroCompletoAut1').show();
			$('#lblcobroCompletoAut2').show();
			$('#lblcobroCompletoAutTxt').show();



		});

		$('#cobranzaAutCie2').click(function() {
			$('#cobranzaAutCie2').focus();
			$('#cobranzaAutCie2').attr("checked",true);
			$('#cobranzaAutCie1').attr("checked",false);
			$('#cobranzaAutCie').val("N");

			$('#cobroCompletoAut1').hide();
			$('#cobroCompletoAut2').hide();
			$('#lblcobroCompletoAut1').hide();
			$('#lblcobroCompletoAut2').hide();
			$('#lblcobroCompletoAutTxt').hide();


		});


		$('#cobroCompletoAut1').click(function() {
			$('#cobroCompletoAut1').focus();
			$('#cobroCompletoAut1').attr("checked",true);
			$('#cobroCompletoAut2').attr("checked",false);
			$('#cobroCompletoAut').val("S");

		});

		$('#cobroCompletoAut2').click(function() {
			$('#cobroCompletoAut2').focus();
			$('#cobroCompletoAut2').attr("checked",true);
			$('#cobroCompletoAut1').attr("checked",false);
			$('#cobroCompletoAut').val("N");

		});

		$('#reqCaracterMayusSI').click(function() {
			$('#reqCaracterMayusSI').attr("checked",true);
			$('#reqCaracterMayusNO').attr("checked",false);
			$('#tdCaracterMayus').show();
			$('#caracterMayus').val("");
		});

		$('#reqCaracterMayusNO').click(function() {
			$('#reqCaracterMayusSI').attr("checked",false);
			$('#reqCaracterMayusNO').attr("checked",true);
			$('#tdCaracterMayus').hide();
			$('#caracterMayus').val(0);
		});

		$('#reqCaracterMinusSI').click(function() {
			$('#reqCaracterMinusSI').attr("checked",true);
			$('#reqCaracterMinusNO').attr("checked",false);
			$('#tdCaracterMinus').show();
			$('#caracterMinus').val("");
		});

		$('#reqCaracterMinusNO').click(function() {
			$('#reqCaracterMinusSI').attr("checked",false);
			$('#reqCaracterMinusNO').attr("checked",true);
			$('#tdCaracterMinus').hide();
			$('#caracterMinus').val(0);
		});

		$('#reqCaracterNumericoSI').click(function() {
			$('#reqCaracterNumericoSI').attr("checked",true);
			$('#reqCaracterNumericoNO').attr("checked",false);
			$('#tdCaracterNumerico').show();
			$('#caracterNumerico').val("");
		});

		$('#reqCaracterNumericoNO').click(function() {
			$('#reqCaracterNumericoSI').attr("checked",false);
			$('#reqCaracterNumericoNO').attr("checked",true);
			$('#tdCaracterNumerico').hide();
			$('#caracterNumerico').val(0);
		});

		$('#reqCaracterEspecialSI').click(function() {
			$('#reqCaracterEspecialSI').attr("checked",true);
			$('#reqCaracterEspecialNO').attr("checked",false);
			$('#tdCaracterEspecial').show();
			$('#caracterEspecial').val("");
		});

		$('#reqCaracterEspecialNO').click(function() {
			$('#reqCaracterEspecialSI').attr("checked",false);
			$('#reqCaracterEspecialNO').attr("checked",true);
			$('#tdCaracterEspecial').hide();
			$('#caracterEspecial').val(0);
		});

		$('#alerVerificaConvenio').click(function(){
			limpiaAlertaVenConvenio();
		});

		$('#alerVerificaConvenio1').click(function(){
			limpiaAlertaVenConvenio();
		});
		$('#porMaximoDeposito').blur(function(){
			var porMaxDeposito = parseFloat($("#porMaximoDeposito").val());
			if(porMaxDeposito>100){
				mensajeSis("El porcentaje no puede ser superior del 100%");
				$('#porMaximoDeposito').focus();
				$('#porMaximoDeposito').val(100.00);
			}
			if(porMaxDeposito==0 && $("#validaCapitalConta").val()=="S"){
				mensajeSis("El porcentaje no puede ser 0%. Debe ser superior a 0% y menor o igual a 100%");
				$('#porMaximoDeposito').focus();
				$('#porMaximoDeposito').val(0.01);
			}
		});

			//------------ Validaciones de la Forma -------------------------------------
				$('#formaGenerica').validate({
					rules: {
						empresaID: {
							required: true,
							minlength: 1,
							number: true
						},
						sucursalMatrizID: {
							number: true
						},
						institucionID: {
							required: true,
							number: true
						},
						empresaDefault: {
							required: true,
							number: true,
							numeroPositivo: true
						},
						nombreRepresentante:{
							required: true
						},
						RFCRepresentante: {
							maxlength : 13,
							minlength : 10,
							required: true
						},
						monedaBaseID: {
							required: true
						},
						monedaExtrangeraID: {
							required: true
						},
						tasaISR: {
							required: true,
							number: true,
							numeroPositivo: true
						},
						tasaIDE: {
							number: true,
							numeroPositivo: true,
							required: true
						},
						montoExcIDE: {
							number: true,
							numeroPositivo: true
						},
						ejercicioVigente: {
							number: true,
							numeroPositivo: true,
							required: true
						},
						periodoVigente: {
							number: true,
							numeroPositivo: true,
							required: true
						},
						diasInversion: {
							required: true,
							minlength: 1,
							number: true,
							numeroPositivo: true
						},
						diasCredito: {
							required: true,
							minlength: 1,
							number: true,
							numeroPositivo: true
						},
						diasCambioPass: {
							required: true,
							minlength: 1,
							number: true,
							numeroPositivo: true
						},
						lonMinCaracPass: {
							required: true,
							minlength: 1,
							number: true,
							numeroPositivo: true
						},
						clienteInstitucion: {
							required: true,
							number: true,
							numeroPositivo: true
						},
						cuentaInstituc: {
							required: true,
							number: true,
							numeroPositivo: true
						},
						manejaCaptacion: {
							required : true
						},
						bancoCaptacion: {
							required : function() {return $('#manejaCaptacion:checked').val() == 'S';},
							number : true
						},
						rutaArchivos: {
							required: true
						},
						tipoCuenta: {
							required: true
						},
						rolTesoreria: {
							required: true,
							number: true,
						},
						rolAdminTeso: {
							required: true,
							number: true,
						},
						tipoCtaGLAdi: {
							required: true,
							number: true,
						},
						ctaIniGastoEmp: {
							number: true,
						},
						ctaFinGastoEmp: {
							number: true,
						},
						montoAportacion: {
							number: true,
						},
						montoSegAyuda: {
							number: true,
						},
						lonMinPagRemesa: {
							numeroPositivo: true,
							number: true,
						},
						lonMaxPagRemesa: {
							numeroPositivo: true,
							number: true,
						},
						lonMinPagOport: {
							numeroPositivo: true,
							number: true,
						},
						lonMaxPagOport: {
							numeroPositivo: true,
							number: true,
						},
					    cuentasCapConta: {
					        	required: true,
						},
					    salMinDF: {

							number: true,
						},
						salMinDFReal: {

							number: true,
						},
						montoPolizaSegA: {
							number: true,
						},
						promotorID: {
							required: true,
						},
						calleEmpresa: {
							required: true,
						},
						numIntEmpresa: {
							required: true,
							maxlength : 50
						},
						numExtEmpresa: {
							maxlength : 50
						},
						CPEmpresa: {
							required: true,
							number: true,
						},
						timbraEdoCta: {
							required : true
						},
						generaCFDINoReg: {
							required : true
						},
						generaEdoCtaAuto: {
							required : true
						},
						aplCobPenCieDia:{
							required: true
						},
						direcCompleta:{
							required: true
						},
						rfcEmpresa: {
							required: true,
							minlength : 12,
							maxlength : 12
						},
						califAutoCliente: {
							required: true
						},
						cancelaAutMenor: {
							required: true
						},

						ctaContaDocSBCD: {
							required : function() {return $('#afectaContaRecSBC1:checked').val() == 'S';},
						},
						ctaContaDocSBCA: {
							required : function() {return $('#afectaContaRecSBC1:checked').val() == 'S';},
						},
						mostrarSaldDisCtaYSbc: {
							required: true
						},
						validaAutComite: {
							required: true
						},
						extTelefonoLocal:{
							number:true
						},
						extTelefonoInt: {
							number: true
						},
						estCreAltInvGar: {
							required: true
						},
						activaPromotorCapta: {
							required: true
						},
						numTratamienCre: {
							required: true,
							number : true,
							maxlength : 10
						},
						capitalCubierto: {
							required: true,
							number : true,
							min : 0,
							maxlength : 10
						},
						pagoIntVertical: {
							required: true
						},
						numMaxDiasMora: {
							required: true,
							maxlength : 10
						},

						sistemasID: {
							required: true,
							maxlength : 6,
							numeroPositivo: true,
						},
						evaluacionMatriz: {
							required: true
						},
						frecuenciaMensual: {
							required : function() { return $('#frecuenciaMensual').is(":visible");},
							maxlength: 2,
							min: 1
						},
						capitalContNeto: {
							number: true,
						},
						capitalCubiertoReac: {
							required: true,
							number : true,
							min : 0,
							maxlength : 10
						},

						porcPersonaFisica: {
							required: true,
							number : true,
							min : 0,
							maxlength : 7
						},
						porcPersonaMoral: {
							required: true,
							number : true,
							min : 0,
							maxlength : 7
						},
						validaFacturaUrl: {
							required : function() {return $('#validaFactura').val() == 'S';},
						},
						tiempoEspera:{
							required : function() {return $('#validaFactura').val() == 'S';},
						},
						numTratamienCreRees: {
							required: true,
							number : true,
							maxlength : 10
						},
						vecesSalMinVig: {
							required: true,
							number : true,
							maxlength : 11
						},
						caracterMinimo: {
							required: true,
							number : true
						},
						caracterMayus:{
							required : function() {return $('#reqCaracterMayusSI').val() == 'S';},
							number : true
						},
						caracterMinus:{
							required : function() {return $('#reqCaracterMinusSI').val() == 'S';},
							number : true
						},
						caracterNumerico:{
							required : function() {return $('#reqCaracterNumericoSI').val() == 'S';},
							number : true
						},
						caracterEspecial:{
							required : function() {return $('#reqCaracterEspecialSI').val() == 'S';},
							number : true
						},
						ultimasContra: {
							required: true,
							number : true
						},
						diaMaxCamContra: {
							required: true,
							number : true
						},
						diaMaxInterSesion: {
							required: true,
							number : true
						},
						numIntentos: {
							required: true,
							number : true
						},
						numDiaBloq: {
							required: true,
							number : true
						},
						alerVerificaConvenio: {
							required: true
						},
						noDiasAntEnvioCorreo: {
							number: true,
							required : function() {return $('#alerVerificaConvenio').is(':checked');},
						},
						remitenteCierreID: {
							required: true,
							number: true
						},
						remitenteID:{
							required : function() {return $('#alerVerificaConvenio').is(':checked');},
						},
						correoAdiDestino :{
							required : function() {return $('#alerVerificaConvenio').is(':checked');},
						},
						porMaximoDeposito: {
							numeroPositivo: true,
							number: true,
						}
					},
					messages: {
						empresaID: {
							required: 'Especificar la empresa',
							minlength: 'Al menos 1 Caracteres',
							number: 'solo números'
						},
						sucursalMatrizID: {
							number: 'Sólo números'
						},
						institucionID: {
							required: 'Debe indicar el nombre de la institución',
								number: 'Sólo números'
						},
						empresaDefault: {
							required: 'Debe indicar el numero de la empresa default',
							number: 'Sólo números',
							numeroPositivo: 'Sólo positivos'
						},
						nombreRepresentante:{
							required: 'Ingrese el nombre del representante'
						},
						RFCRepresentante: {
							maxlength : 'Maximo 13 caracteres',
							minlength : 'Minimo 10 caracteres',
							required: 'Indique el RFC'
						},
						monedaBaseID: {
							required: 'Indique la moneda base'
						},
						monedaExtrangeraID: {
							required: 'Debe especificar la moneda extranjera'
						},
						tasaISR: {
							required: 'Especifique la tasa del ISR',
							number:'Sólo números',
							numeroPositivo: 'Sólo números positivos'
						},
						tasaIDE: {
							number: 'Sólo números',
							numeroPositivo: 'Sólo números positivos',
							required: 'Especifique la tasa IDE'
						},
						montoExcIDE: {
							number: 'Sólo números',
							numeroPositivo: 'Sólo números positivos'
						},
						ejercicioVigente: {
							number: 'Sólo números',
							numeroPositivo: 'Sólo números positivos',
							required: 'Especifique el ejercicio Vigente'
						},
						periodoVigente: {
							number: 'Sólo números',
							numeroPositivo: 'Sólo números positivos',
							required: 'Especifique el periodo Vigente'
						},
						diasInversion: {
							required: 'Especifique los días de inversión',
							minlength: 'mínimo 1 caracter',
							number: 'solo números',
							numeroPositivo:'Números positivos'
						},
						diasCredito: {
							required: 'Especifique los días de crédito',
							minlength: 'mínimo 1 caracter',
							number: 'solo números',
							numeroPositivo:'Números positivos'
						},
						diasCambioPass: {
							required: 'Especifique los días de crédito',
							minlength: 'mínimo 1 caracter',
							number: 'solo números',
							numeroPositivo:'Números positivos'
						},
						lonMinCaracPass: {
							required: 'Especifique la longitud mínima de caracteres',
							minlength: 'mínimo 1 caracter',
							number: 'solo números',
							numeroPositivo:'Números positivos'
						},
						clienteInstitucion: {
							required: 'Especifique el número de cliente de institución',
							numeroPositivo: 'Sólo números positivos',
							number: 'solo números'
						},
						cuentaInstituc: {
							required: 'Especifique el número de cuenta de institucion',
							numeroPositivo: 'Sólo números positivos',
							number: 'solo números'
						},
						manejaCaptacion: {
							required :'Especifique si maneja captación'
						},
						bancoCaptacion: {
							required :'Especifique el número de Banco Captación',
							number : 'Sólo números'
						},
						rutaArchivos: {
							required: 'Especifique la ruta del archivos'
						},
						tipoCuenta: {
							required: 'Especifique el tipo de cuenta'
						},
						rolTesoreria: {
							required: 'Especifique el rol del usuario de tesoreria',
							number: 'solo números'
						},
						rolAdminTeso: {
							required: 'Especifique el rol del administrador de la tesoreria',
							number: 'solo números'
						},
						tipoCtaGLAdi: {
							required: 'Especifique la cuenta adicional',
							number: 'solo numeros',
						},
						ctaIniGastoEmp: {
							number: 'Sólo Números',
						},
						ctaFinGastoEmp: {
							number: 'Sólo Números',
						},
						montoAportacion: {
							number: 'Sólo Números',
						},
						montoSegAyuda: {
							number: 'Sólo Números',
						},
						lonMinPagRemesa: {
							number: 'Solo Números',
						},
						lonMaxPagRemesa: {
							number: 'Solo Números',
						},
						lonMinPagOport: {
							number: 'Solo Números',
						},
						lonMaxPagOport: {

							number: 'Solo Números',
						},
						cuentasCapConta: {
					        required:'Este campo no debe estar vacio.' ,
						},
						salMinDF: {
							number: 'Solo Números',
						},
						salMinDFReal: {
							number: 'Solo Números',
						},
						montoPolizaSegA: {
							number: 'Sólo Números',
						},
						promotorID: {
							required: 'Especifique Número de Promotor'
						},
						calleEmpresa: {
							required: 'Especifique Nombre de la Calle'
						},
						numIntEmpresa: {
							required: 'Especifique Número ',
							maxlength : 'Maximo 50 caracteres'
						},
						numExtEmpresa: {
							maxlength : 'Maximo 50 caracteres'
						},
						CPEmpresa: {
							number: 'Especifique Codigo Postal, Solo Numeros',
						},
						aplCobPenCieDia:{
							required: 'Especifique Valor '
						},
						direcCompleta:{
							required: 'Especifique la Direccion Fiscal Completa'
						},
						rfcEmpresa: {
							required: 'Especifique el RFC de la Empresa',
							minlength : 'Minimo 12 caracteres',
							maxlength : 'Maximo 12 caracteres'
						},
						timbraEdoCta: {
							required : 'Seleccione una Opcion'
						},
						generaCFDINoReg: {
							required : 'Seleccione una Opcion'
						},
						generaEdoCtaAuto: {
							required : 'Seleccione una Opcion'
						},
						servReactivaCliID: {
							required: 'Seleccione un servicio'
						},
						califAutoCliente: {
							required:  'Seleccione una Opción'
						},
						cancelaAutMenor: {
							required:  'Seleccione una Opción'
						},
						ctaContaDocSBCD: {
							required : 'Ingrese una Cuenta Contable',
						},
						ctaContaDocSBCA: {
							required : 'Ingrese una Cuenta Contable',
						},
						mostrarSaldDisCtaYSbc:{
							required : 'Seleccione una opción'
						},
						validaAutComite: {
							required: 'Seleccione una opción'
						},
						extTelefonoLocal: {
							number:'Sólo Números(Campo opcional)'
						},
						extTelefonoInt: {
							number: 'Sólo Números(Campo opcional)'
						},
						estCreAltInvGar: {
							required: 'Seleccione al menos una Opción'
						},

						activaPromotorCapta: {
							required: 'Seleccione una Opción'
						},
						numTratamienCre: {
							required: "Especifique Renovaciones Permitidas",
							number : 'Sólo Números',
							maxlength : 'Máximo 10 Caracteres'
						},
						capitalCubierto: {
							required: "Especifique % de Capital",
							number : 'Sólo Números',
							min : "Especifique Valor",
							maxlength : 'Máximo 10 Caracteres'
						},
						pagoIntVertical: {
							required: "Especifique Forma de Pago"
						},
						numMaxDiasMora: {
							required: "Especifique No. de Días",
							maxlength : 'Máximo 10 Caracteres'
						},

						sistemasID: {
							required: 'Especifique al Encargado del Depto. de Sistemas/T.I.',
							maxlength : 'Máximo 6 Caracteres',
							numeroPositivo: 'Sólo números',
						},
						evaluacionMatriz: {
							required: 'Especifique si requiere Evaluación de la Matriz de Riesgo.'
						},
						frecuenciaMensual: {
							required: 'Especificar la Frecuencia de Evaluación.',
							maxlength: 'Máximo 2 dígitos.',
							min: 'La Frecuencia en Meses debe ser mayor a 0.'
						},
						capitalContNeto: {
							number: 'Sólo Números',
						},
						capitalCubiertoReac: {
							required: "Especifique % de Capital",
							number : 'Sólo Números',
							min : "Especifique Valor",
							maxlength : 'Máximo 10 Caracteres'
						},

						porcPersonaFisica: {
							required: "Especifique % de Capital Contable para Persona Física",
							number : 'Sólo Números',
							min : "Especifique Valor",
							maxlength : 'Máximo 10 Caracteres'
						},

						porcPersonaMoral: {
							required: "Especifique % de Capital Contable para Persona Moral",
							number : 'Sólo Números',
							min : "Especifique Valor",
							maxlength : 'Máximo 10 Caracteres'
						},
						validaFacturaUrl: {
							required : "Especifique la URL para la Validación",
						},
						tiempoEspera: {
							required : "Especifique un Tiempo de Espera en milisegundos",
						},
						numTratamienCreRees: {
							required: "Especifique Reestructuras Permitidas",
							number : 'Sólo Números',
							maxlength : 'Máximo 10 Caracteres'
						},
						vecesSalMinVig: {
							required: 'Especificar el número de veces del salario minimo',
							maxlength: 'Máximo 11 Caracteres',
							number: 'Solo Números'
						},
						caracterMinimo: {
							required: "Especifique el número mínimo de caracteres que se compondrá una contraseña",
							number : 'Sólo Números'
						},
						caracterMayus: {
							required : "Especifique el número de caracteres mayúsculas en una contraseña",
							number : 'Sólo Números'
						},
						caracterMinus:{
							required : "Especifique el número de caracteres Minúsculas en una contraseña",
							number : 'Sólo Números'
						},
						caracterNumerico:{
							required : "Especifique el número de caracteres Númericos en una contraseña",
							number : 'Sólo Números'
						},
						caracterEspecial:{
							required : "Especifique el número de caracteres Especiales en una contraseña",
							number : 'Sólo Números'
						},
						ultimasContra: {
							required: 'Especifique cuantas de las últimas contraseñas no se pueden utilizar',
							number : 'Sólo Números'
						},
						diaMaxCamContra: {
							required : "Especifique el número de días que pasarán hasta que el sistema solicite una nueva contraseña al usuario",
							number : 'Sólo Números'
						},
						diaMaxInterSesion: {
							required : "Especifique el número en minutos que la sesión se mantendrá activa mientras el usuario no tenga interacción con el sistema",
							number : 'Sólo Números'
						},
						numIntentos: {
							required : "Especifique el número de intentos que tendrá el usuario antes de que se bloquee el usuario",
							number : 'Sólo Números'
						},
						numDiaBloq: {
							required : "Especifique el número de días que pasarán después del último acceso al sistema para que el usuario se bloquee automáticamente",
							number : 'Sólo Números'
						},
						alerVerificaConvenio: {
							required: "Especifique Alerta Vencimiento del Convenio"
						},
						noDiasAntEnvioCorreo: {
							number: 'Sólo Números',
							required : 'Numero de días es Requerido',
						},
						remitenteCierreID: {
							required: "Especifique ID para el Remitente Cierre de Día",
							number: 'Sólo Números'
						},
						remitenteID:{
							required : "El Remitente es Requerido",
						},
						correoAdiDestino :{
							required : "El correo Adi. Destino es Requerido",
						},
						porMaximoDeposito: {
							number: 'Sólo números',
							numeroPositivo: 'Sólo positivos'
						},
					}
				});


//-------------------- Métodos------------------
	function validaEmpresaID(control) {
		var tamanoTicket='T';
		var si='S';
		var numEmpresaID = $('#empresaID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		if (numEmpresaID != '' && !isNaN(numEmpresaID)) {
			if (numEmpresaID == '0') {
				deshabilitaBoton('modificar', 'submit');
				inicializaForma('formaGenerica', 'empresaID');
			} else {
				habilitaBoton('modificar', 'submit');
				parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
					if (parametrosSisBean != null) {
						dwr.util.setValues(parametrosSisBean);

						if(parametrosSisBean.validaCapitalConta=="N"){
							deshabilitaControl('porMaximoDeposito');
						}else{
							habilitaControl('porMaximoDeposito');
						}
						if(parametrosSisBean.institucionCirculoCredito != ""){
							consultaInstitucionCirculoCredito("institucionCirculoCredito");
						}
						if(parametrosSisBean.reportarTotalIntegrantes == 'S') {
							$('#reportarTotalIntegrantesSI').attr("checked",true);
						} else {
							$('#reportarTotalIntegrantesNO').attr("checked",true);
						}
						if(parametrosSisBean.tipoContaMora == 'I'){
							$('#tipoContaMora1').attr("checked",true);
						}else{
							$('#tipoContaMora').attr("checked",true);
						}
						if(parametrosSisBean.divideIngresoInteres == 'S'){
							$('#divideIngresoInteres').attr("checked",true);
						}else{
							$('#divideIngresoInteres1').attr("checked",true);
						}
						if(parametrosSisBean.fechaUltimoComite=="1900-01-01"){
							$('#fechaUltimoComite').val("");
						}
						if($('#tipoDocumentoID').val()!= ''  && $('#tipoDocumentoID').asNumber()!=0){
							consultaDescripcionFirma();
						}else{
							$('#tipoDocumentoID').val("");
							$('#descripcionDoc').val("");
						}
						if(parametrosSisBean.camFuenFonGarFira == 'S'){
							$('#camFuenFonGarFiraSI').attr("checked",true);
						} else {
							$('#camFuenFonGarFiraNO').attr("checked",true);
						}
						if(parametrosSisBean.ejecDepreAmortiAut == 'S'){
							$('#ejecDepreAmortiAutSI').attr("checked",true);
						} else {
							$('#ejecDepreAmortiAutNO').attr("checked",true);
						}
						if(parametrosSisBean.mostrarBtnResumen == 'S'){
							$('#mostrarBtnResumenSI').attr("checked",true);
						} else {
							$('#mostrarBtnResumenNO').attr("checked",true);
						}
						if(parametrosSisBean.alerVerificaConvenio == 'S') {
							$('#alerVerificaConvenio').attr("checked",true);
							limpiaAlertaVenConvenio();

						} else {
							$('#alerVerificaConvenio1').attr("checked",true);
							limpiaAlertaVenConvenio();
						}

						if(parametrosSisBean.validarEtiqCambFond == 'S'){
							$('#validarEtiqCambFondSI').attr("checked",true);
						} else {
							$('#validarEtiqCambFondNO').attr("checked",true);
						}

						consultaSucursal('sucursalMatrizID');
						consultaInstitucion('institucionID');
						consultaCuenta('tipoCuenta');
						consultaInstituciones('bancoCaptacion');
						consultaCliente('clienteInstitucion');
						consultaRoles('rolTesoreria');
						consultaRolesVBC('perfilWsVbc');
						consultaRolesAutAport('perfilAutEspAport');
						consultaRolesCamCarta('perfilCamCarLiqui');
						maestroCuentasDescripcion('ctaIniGastoEmp','descCuentaInicial');
						maestroCuentasDescripcion('ctaFinGastoEmp','decctaFinGastoEmp');

						consultaCuentasContaDescripcion('ctaContaSobrante', 'descripCtaContaFaltante');
						consultaCuentasContaDescripcion('ctaContaFaltante', 'descripCtaContaSobrante');

						consultaCuentasContaDescripcion('ctaContaDocSBCD', 'descripCtaSBCCOD');
						consultaCuentasContaDescripcion('ctaContaDocSBCA', 'descripCtaSBCCOA');
						consultaEstatusInverGar(parametrosSisBean.estCreAltInvGar);

						if (parametrosSisBean.ocultaBtnRechazoSol == 'S' || parametrosSisBean.restringebtnLiberacionSol == 'S') {
							if (parametrosSisBean.primerRolFlujoSolID != 0) {
								consultaPrimerRolFluj('primerRolFlujoSolID');
							} else {
								$('#primerRolFlujoSolID').val('');
								$('#nombrePrimerRol').val('');

							}
							if (parametrosSisBean.segundoRolFlujoSolID != 0) {
								consultaSegunRolFluj('segundoRolFlujoSolID');
							} else {
								$('#segundoRolFlujoSolID').val('');
								$('#nombreSegundoRol').val('');
							}


						} else {
							$('#primerRolFlujoSolID').val('');
							$('#segundoRolFlujoSolID').val('');
							$('#nombrePrimerRol').val('');
							$('#nombreSegundoRol').val('');
						}

						esTab=true;
						consultaEstado('estadoEmpresa');
						consultaMunicipio('municipioEmpresa');
						consultaLocalidad('localidadEmpresa');
						consultaColonias('coloniaEmpresa');
						$('#CPEmpresa').val(parametrosSisBean.CPEmpresa);
						$('#diasVigenciaBC').val(parametrosSisBean.diasVigenciaBC);
						validaCatalogoServicio('servReactivaCliID');

						consultaAdminTesoreriaRoles('rolAdminTeso');
							if (parametrosSisBean.manejaCaptacion == si) {
								$('#manejaCaptacion').attr("checked",true);
								$('#manejaCaptacion1').attr("checked",false);
								$('#bancoCaptacion').show(500);
								$('#nombreInstituciones').show(500);
								$('#maneja').show(500);
							}else{
								$('#manejaCaptacion1').attr("checked",true);
								$('#manejaCaptacion').attr("checked",false);
								$('#bancoCaptacion').hide(500);
								$('#nombreInstituciones').hide(500);
								$('#maneja').hide(500);
							}
							$('#manejaCaptacion').click(function() {
								$('#bancoCaptacion').val(parametrosSisBean.bancoCaptacion);
								$('#bancoCaptacion').show(500);
								$('#nombreInstituciones').show(500);
								$('#maneja').show(500);
								$('#bancoCaptacion').val('');
								$('#nombreInstituciones').val("");
							});

							$('#manejaCaptacion1').click(function() {
								$('#bancoCaptacion').val('');
								$('#nombreInstituciones').val('');
								$('#bancoCaptacion').hide(500);
								$('#nombreInstituciones').hide(500);
								$('#maneja').hide(500);
							});

							if(parametrosSisBean.oficialCumID !=0 && parametrosSisBean.oficialCumID !='' ){
								 validaUsuario('oficialCumID');
							}
							if(parametrosSisBean.dirGeneralID !=0 && parametrosSisBean.dirGeneralID !=''){
								validaUsuario('dirGeneralID');
							}
							if(parametrosSisBean.dirOperID !=0 && parametrosSisBean.dirOperID !=''){
								validaUsuario('dirOperID');
							}
							if(parametrosSisBean.sistemasID !=0 && parametrosSisBean.sistemasID !=''){
								validaUsuario('sistemasID');
							}
							if(parametrosSisBean.tipoImpTicket == tamanoTicket){
								$('#tipoImpTicket1').attr("checked",false);
								$('#tipoImpTicket2').attr("checked",true);
							}else{
								$('#tipoImpTicket1').attr("checked",true);
								$('#tipoImpTicket2').attr("checked",false);
							}
							if(parametrosSisBean.reqAportacionSo == si){
								$('#reqAportacionSo1').attr("checked",true);
								$('#reqAportacionSo2').attr("checked",false);
								$('#tlMontoAportacion').show(500);
								$('#montoAportacion').show(500);
							}else{
								$('#reqAportacionSo1').attr("checked",false);
								$('#reqAportacionSo2').attr("checked",true);
								$('#tlMontoAportacion').hide(500);
								$('#montoAportacion').hide(500);
							}
							if(parametrosSisBean.timbraEdoCta == 'S'){
								$('#timbraEdoCta1').attr("checked",true);
								$('#timbraEdoCta2').attr("checked",false);
							}else
							if(parametrosSisBean.timbraEdoCta == 'N'){
								$('#timbraEdoCta2').attr("checked",true);
								$('#timbraEdoCta1').attr("checked",false);
							}
							if(parametrosSisBean.generaCFDINoReg == 'S'){
								$('#generaCFDINoReg1').attr("checked",true);
								$('#generaCFDINoReg2').attr("checked",false);
							}else
							if(parametrosSisBean.generaCFDINoReg == 'N'){
								$('#generaCFDINoReg2').attr("checked",true);
								$('#generaCFDINoReg1').attr("checked",false);
							}
							if(parametrosSisBean.generaEdoCtaAuto == 'S'){
								$('#generaEdoCtaAuto1').attr("checked",true);
								$('#generaEdoCtaAuto2').attr("checked",false);
							}else if(parametrosSisBean.generaCFDINoReg == 'N'){
								$('#generaEdoCtaAuto2').attr("checked",true);
								$('#generaEdoCtaAuto1').attr("checked",false);
							}
							if(parametrosSisBean.aplCobPenCieDia == 'S'){
								$('#aplCobPenCieDia1').attr("checked",true);
								$('#aplCobPenCieDia2').attr("checked",false);
								$('#aplCobPenCieDia').val("S");
							}else{
								if(parametrosSisBean.aplCobPenCieDia == 'N'){
									$('#aplCobPenCieDia2').attr("checked",true);
									$('#aplCobPenCieDia1').attr("checked",false);
									$('#aplCobPenCieDia').val("N");
								}else{
									$('#aplCobPenCieDia2').attr("checked",false);
									$('#aplCobPenCieDia1').attr("checked",false);
									$('#aplCobPenCieDia').val("N");
								}
							}
							$('#zonaHoraria').val(parametrosSisBean.zonaHoraria);

							if(parametrosSisBean.mostrarSaldDisCtaYSbc== 'S'){
								$('#mostrarSaldDispCta1').attr("checked",true);
								$('#mostrarSaldDispCta2').attr("checked",false);
							}else if(parametrosSisBean.mostrarSaldDisCtaYSbc== 'N'){
								$('#mostrarSaldDispCta2').attr("checked",true);
								$('#mostrarSaldDispCta1').attr("checked",false);
							}

							if(parametrosSisBean.afectaContaRecSBC == 'S'){
								$('#afectaContaRecSBC1').attr("checked",true);
								$('#afectaContaRecSBC2').attr("checked",false);
								$('#trSBCCOD').show();
								$('#trSBCCOA').show();
								$('#centroCostos').show();
							}else if(parametrosSisBean.afectaContaRecSBC == 'N'){
								$('#afectaContaRecSBC2').attr("checked",true);
								$('#afectaContaRecSBC1').attr("checked",false);
								$('#trSBCCOD').hide();
								$('#trSBCCOA').hide();
								$('#centroCostos').hide();
							}
							if(parametrosSisBean.contabilidadGL=="S"){
								$('#contabilidadGLS').attr('checked',"1");
								$('#contabilidadGLN').attr('checked',false);
							}else{
								$('#contabilidadGLS').attr('checked',false);
								$('#contabilidadGLN').attr('checked',"1");
							}

							if(parametrosSisBean.conBuroCreDefaut == 'B'){
								$('#conBuroCreDefautBuro').attr("checked",true);
								$('#conBuroCreDefautCirculo').attr("checked",false);
								$('#conBuroCreDefaut').val("B");
							}else{
								$('#conBuroCreDefautCirculo').attr("checked",true);
								$('#conBuroCreDefautBuro').attr("checked",false);
								$('#conBuroCreDefaut').val("C");
							}

							if(parametrosSisBean.cancelaAutSolCre == si){
								$('#cancelaAutSolCre1').attr("checked",true);
								$('#cancelaAutSolCre2').attr("checked",false);
								$('#diasCancelaAutSolCre').show(500);
								$('#diasCancela').show();
							}else{
								$('#cancelaAutSolCre1').attr("checked",false);
								$('#cancelaAutSolCre2').attr("checked",true);
								$('#diasCancelaAutSolCre').hide(500);
								$('#diasCancela').hide();
							}

							$('#frecuenciaMensual').val(parametrosSisBean.frecuenciaMensual);
							$('input[name="evaluacionMatriz"]').change();

							if(parametrosSisBean.reestCalendarioVen == 'N'){

								$('#validaEstatusReesSi').hide();
								$('#validaEstatusReesNo').hide();
								$('#lblValidaEstatusTxt').hide();
								$('#lblValidaEstatusSi').hide();
								$('#lblValidaEstatusNo').hide();
							}else{
									$('#validaEstatusReesSi').show();
									$('#validaEstatusReesNo').show();
									$('#lblValidaEstatusTxt').show();
									$('#lblValidaEstatusSi').show();
									$('#lblValidaEstatusNo').show();
							}

							if(parametrosSisBean.tipoDetRecursos == 1){
								$('#detRutaSAFI').attr("checked",true);
								$('#detRecurso').attr("checked",false);
							}else{
								$('#detRutaSAFI').attr("checked",false);
								$('#detRecurso').attr("checked",true);
							}

							if(parametrosSisBean.calculaCURPyRFC == "S"){
								$('#calCURPyRFCsi').attr("checked",true);
								$('#calCURPyRFCno').attr("checked",false);
							}else{
								$('#calCURPyRFCsi').attr("checked",false);
								$('#calCURPyRFCno').attr("checked",true);
							}
							if(parametrosSisBean.validaRef == "S"){
								$('#validaRefSI').attr("checked",true);
								$('#validaRefNO').attr("checked",false);
							}else{
								$('#validaRefSI').attr("checked",false);
								$('#validaRefNO').attr("checked",true);
							}
							if(parametrosSisBean.manejaCarAgro == "S"){
								$('#manejaCarAgroSI').attr("checked",true);
								$('#manejaCarAgroNO').attr("checked",false);
							}else{
								$('#manejaCarAgroSI').attr("checked",false);
								$('#manejaCarAgroNO').attr("checked",true);
							}

							if(parametrosSisBean.evaluaRiesgoComun == "S"){
								$('#evaluaRiesgoComunSI').attr("checked",true);
								$('#evaluaRiesgoComunNO').attr("checked",false);
							}else{
								$('#evaluaRiesgoComunSI').attr("checked",false);
								$('#evaluaRiesgoComunNO').attr("checked",true);
							}
							//
							if(parametrosSisBean.permitirMultDisp == "S"){
								$('#permitirMultDispSI').attr("checked",true);
								$('#permitirMultDispNO').attr("checked",false);
							}else{
								$('#permitirMultDispSI').attr("checked",false);
								$('#permitirMultDispNO').attr("checked",true);
							}



							if(parametrosSisBean.cobranzaAutCie == "S"){
								$('#cobranzaAutCie1').attr("checked",true);
								$('#cobranzaAutCie2').attr("checked",false);
								$('#cobroCompletoAut1').show();
								$('#cobroCompletoAut2').show();
								$('#lblcobroCompletoAut1').show();
								$('#lblcobroCompletoAut2').show();
								$('#lblcobroCompletoAutTxt').show();
							}else{
								$('#cobranzaAutCie1').attr("checked",false);
								$('#cobranzaAutCie2').attr("checked",true);
								$('#cobroCompletoAut1').hide();
								$('#cobroCompletoAut2').hide();
								$('#lblcobroCompletoAut1').hide();
								$('#lblcobroCompletoAut2').hide();
								$('#lblcobroCompletoAutTxt').hide();
							}

							if(parametrosSisBean.cobranzaAutCie == "S" && parametrosSisBean.cobroCompletoAut == "S"){
								$('#cobroCompletoAut1').attr("checked",true);
								$('#cobroCompletoAut2').attr("checked",false);
							}else{
								$('#cobroCompletoAut1').attr("checked",false);
								$('#cobroCompletoAut2').attr("checked",true);
							}

							if(parametrosSisBean.fechaConsDisp == "S"){
								$('#fechaConsDispSi').attr("checked",true);
								$('#fechaConsDispNo').attr("checked",false);
							}else{
								$('#fechaConsDispSi').attr("checked",false);
								$('#fechaConsDispNo').attr("checked",true);
							}

							if(parametrosSisBean.invPagoPeriodico == "S"){
								$('#invPagoPeriodicoSi').attr("checked",true);
								$('#invPagoPeriodicoNo').attr("checked",false);
							}else{
								$('#invPagoPeriodicoSi').attr("checked",false);
								$('#invPagoPeriodicoNo').attr("checked",true);
							}

							if(parametrosSisBean.validaFactura == "S"){
								$('#validaFacturaSI').attr("checked",true);
								$('#validaFacturaNO').attr("checked",false);
								$('#validaFacturaUrl').val(parametrosSisBean.validaFacturaURL);
								$('#validaFacturaURL').val(parametrosSisBean.validaFacturaURL);
								$('#tiempoEsperaWS').val(parametrosSisBean.tiempoEsperaWS);
								$('#tiempoEspera').val(parametrosSisBean.tiempoEsperaWS);
								$('#validaFacturaUrl').attr("disabled",false);
								$('#tiempoEspera').attr("disabled",false);
							}else{
								$('#validaFacturaSI').attr("checked",false);
								$('#validaFacturaNO').attr("checked",true);
								$('#validaFacturaUrl').val(parametrosSisBean.validaFacturaURL);
								$('#validaFacturaURL').val(parametrosSisBean.validaFacturaURL);
								$('#tiempoEsperaWS').val(parametrosSisBean.tiempoEsperaWS);
								$('#tiempoEspera').val(parametrosSisBean.tiempoEsperaWS);
								$('#validaFacturaUrl').attr("disabled",true);
								$('#tiempoEspera').attr("disabled",true);
							}

							if(parametrosSisBean.restringeReporte == "S"){
								$('#restringeReporteSI').attr("checked",true);
							}else{
								$('#restringeReporteNO').attr("checked",true);
							}

							if(parametrosSisBean.personNoDeseadas == "S"){
								$('#personNoDeseadasSi').attr("checked",true);
								$('#personNoDeseadasNo').attr("checked",false);
							}else{
								$('#personNoDeseadasSi').attr("checked",false);
								$('#personNoDeseadasNo').attr("checked",true);
							}

							if(parametrosSisBean.funcionHuella == "S"){
								$('#funcionHuellaSi').attr("checked",true);
								$('#funcionHuellaNo').attr("checked",false);
							}else{
								$('#funcionHuellaSi').attr("checked",false);
								$('#funcionHuellaNo').attr("checked",true);
							}

							if(parametrosSisBean.reqhuellaProductos == "S"){
								$('#reqhuellaProductosSi').attr("checked",true);
								$('#reqhuellaProductosNo').attr("checked",false);
							}else{
								$('#reqhuellaProductosSi').attr("checked",false);
								$('#reqhuellaProductosNo').attr("checked",true);
							}

							if(parametrosSisBean.reqhuellaProductos == "S"){
								$('#reqhuellaProductosSi').attr("checked",true);
								$('#reqhuellaProductosNo').attr("checked",false);
							}else{
								$('#reqhuellaProductosSi').attr("checked",false);
								$('#reqhuellaProductosNo').attr("checked",true);
							}

							habilitaConfPass = parametrosSisBean.habilitaConfPass;

							if(parametrosSisBean.habilitaConfPass == "S"){
								$('#caracterMinimo').val(parametrosSisBean.caracterMinimo);
								$('#caracterMayus').val(parametrosSisBean.caracterMayus);
								$('#caracterMinus').val(parametrosSisBean.caracterMinus);
								$('#caracterNumerico').val(parametrosSisBean.caracterNumerico);
								$('#caracterEspecial').val(parametrosSisBean.caracterEspecial);
								$('#ultimasContra').val(parametrosSisBean.ultimasContra);
								$('#diaMaxCamContra').val(parametrosSisBean.diaMaxCamContra);
								$('#diaMaxInterSesion').val(parametrosSisBean.diaMaxInterSesion);
								$('#numIntentos').val(parametrosSisBean.numIntentos);
								$('#numDiaBloq').val(parametrosSisBean.numDiaBloq);

								if(parametrosSisBean.reqCaracterMayus == "S"){
									$('#reqCaracterMayusSI').attr("checked",true);
									$('#reqCaracterMayusNO').attr("checked",false);
								}else{
									$('#reqCaracterMayusNO').attr("checked",true);
									$('#reqCaracterMayusSI').attr("checked",false);
									$('#tdCaracterMayus').hide();
								}

								if(parametrosSisBean.reqCaracterMinus == "S"){
									$('#reqCaracterMinusSI').attr("checked",true);
									$('#reqCaracterMinusNO').attr("checked",false);
								}else{
									$('#reqCaracterMinusNO').attr("checked",true);
									$('#reqCaracterMinusSI').attr("checked",false);
									$('#tdCaracterMinus').hide();
								}

								if(parametrosSisBean.reqCaracterNumerico == "S"){
									$('#reqCaracterNumericoSI').attr("checked",true);
									$('#reqCaracterNumericoNO').attr("checked",false);
								}else{
									$('#reqCaracterNumericoNO').attr("checked",true);
									$('#reqCaracterNumericoSI').attr("checked",false);
									$('#tdCaracterNumerico').hide();
								}

								if(parametrosSisBean.reqCaracterEspecial == "S"){
									$('#reqCaracterEspecialSI').attr("checked",true);
									$('#reqCaracterEspecialNO').attr("checked",false);
								}else{
									$('#reqCaracterEspecialNO').attr("checked",true);
									$('#reqCaracterEspecialSI').attr("checked",false);
									$('#tdCaracterEspecial').hide();
								}

								$('#remitenteCierreID').val(parametrosSisBean.remitenteCierreID);
								$('#correoRemitenteCierre').val(parametrosSisBean.correoRemitenteCierre);

								$('#divConfigContra').show();
							}else{
								$('#caracterMinimo').val(0);
								$('#caracterMayus').val(0);
								$('#caracterMinus').val(0);
								$('#caracterNumerico').val(0);
								$('#caracterEspecial').val(0);
								$('#ultimasContra').val(0);
								$('#diaMaxCamContra').val(0);
								$('#diaMaxInterSesion').val(0);
								$('#numIntentos').val(0);
								$('#numDiaBloq').val(0);
								$('#reqCaracterMayusSI').attr("checked",false);
								$('#reqCaracterMayusNO').attr("checked",true);
								$('#reqCaracterMinusSI').attr("checked",false);
								$('#reqCaracterMinusNO').attr("checked",true);
								$('#reqCaracterNumericoNO').attr("checked",true);
								$('#reqCaracterNumericoSI').attr("checked",false);
								$('#reqCaracterEspecialSI').attr("checked",false);
								$('#reqCaracterEspecialNO').attr("checked",true);
								$('#divConfigContra').hide();
							}

							agregaFormatoMoneda('formaGenerica');
							habilitaBoton('modificar','submit');
					} else {
						limpiaForm($('#formaGenerica'));
						deshabilitaBoton('modificar','submit');
						$('#empresaID').focus();
						$('#empresaID').select();
					}
					$('#telefonoLocal').setMask('phone-us');
					$('#telefonoInterior').setMask('phone-us');
				});
			}//else
		}//if

	}//validaEmpresaID

	consultaMonedaExtranjera();
	consultaMonedaBase();

	function consultaMonedaExtranjera() {
		dwr.util.removeAllOptions('monedaExtrangeraID');
		dwr.util.addOptions('monedaExtrangeraID', {0:'SELECCIONAR'});
		monedasServicio.listaCombo(3, function(monedas){
			dwr.util.addOptions('monedaExtrangeraID', monedas, 'monedaID', 'descripcion');
		});
	}
	function consultaMonedaBase() {
		dwr.util.removeAllOptions('monedaBaseID');
		dwr.util.addOptions('monedaBaseID', {0:'SELECCIONAR'});
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaBaseID', monedas, 'monedaID', 'descripcion');
		});
	}



	function consultaCuenta(idControl) {
		var jqCuenta = eval("'#" + idControl + "'");
		var numCta = $(jqCuenta).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var TipoCuentaBeanCon = {
				'tipoCuentaID':numCta	};
		if(numCta != '' && !isNaN(numCta)){
			tiposCuentaServicio.consulta(catTipoConsultaTipoCuenta.foranea, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){
					$('#descripcion').val(tipoCuenta.descripcion);
				}else{
					mensajeSis("No existe la cuenta");
					$('#tipoCuenta').val('');
					$('#tipoCuenta').focus();
					$('#descripcion').val("");
				}
		});
		}
	}

	function consultaInstitucionCirculoCredito(idControl){

		var jqClaveID = eval("'#" + idControl + "'");
		var claveID = $(jqClaveID).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoInstitucionBean = {
			'claveID':claveID
		};

		if(claveID != '' && !isNaN(claveID)){
			tipoInstitucionCirculoServicio.consulta(1,tipoInstitucionBean,function(instituto){
				if(instituto!=null){
					$('#tipoInstitucionCirculoCredito').val(instituto.tipoInstitucion);
				}else{
					mensajeSis("No existe el Tipo de Institución de Círculo de Crédito.");
					$(jqClaveID).val('');
					$(jqClaveID).focus();
					$('#tipoInstitucionCirculoCredito').val("");
				}
			});
		}

	}

	 function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
				'institucionID':numInstituto
			};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
				if(instituto!=null){
					$('#nombreInstitucion').val(instituto.nombre);
				}else{
					mensajeSis("No existe la Institución");
					$('#institucionID').val('');
					$('#institucionID').focus();
					$('#nombreInstitucion').val("");
					}
			});
		}
	}

	   function consultaInstituciones(idControl) {
			var jqInstituto = eval("'#" + idControl + "'");
			var numInstituto = $(jqInstituto).val();
			setTimeout("$('#cajaLista').hide();", 200);
			var InstitutoBeanCon = {
				'institucionID':numInstituto
			};
			if(numInstituto != '' && !isNaN(numInstituto)){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
					if(instituto!=null){
						$('#nombreInstituciones').val(instituto.nombre);
					}else{
						mensajeSis("No existe la Institución");
						$('#bancoCaptacion').val('');
						$('#bancoCaptacion').focus();
						$('#nombreInstituciones').val("");
					}
				});
			}
		}

		function consultaRoles(idControl) {
			var jqRol = eval("'#" + idControl + "'");
			var numRol = $(jqRol).val();
			var conRol=2;
			var rolesBeanCon = {
	  				'rolID':numRol
					};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numRol != '' && !isNaN(numRol)){
				rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
					if(roles!=null){
						$('#nombreRolTesoreria').val(roles.nombreRol);
					}else{
						mensajeSis("No Existe el Rol");
						$('#rolTesoreria').val('');
						$('#nombreRolTesoreria').val("");
					}
				});
			}
		}

		function consultaRolesVBC(idControl) {
			var jqRol = eval("'#" + idControl + "'");
			var numRol = $(jqRol).val();
			var conRol=2;
			var rolesBeanCon = {
	  				'rolID':numRol
					};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numRol != '' && !isNaN(numRol)){
				rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
					if(roles!=null){
						$('#nombrePerfilWsVbc').val(roles.nombreRol);
					}else{
						mensajeSis("No Existe el Perfil Indicado");
						$('#perfilWsVbc').val('');
						$('#perfilWsVbc').focus();
						$('#nombrePerfilWsVbc').val("");
					}
				});
			}
		}

		function consultaRolesAutAport(idControl) {
			var jqRol = eval("'#" + idControl + "'");
			var numRol = $(jqRol).val();
			var conRol=2;
			var rolesBeanCon = {
	  				'rolID':numRol
					};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numRol != '' && !isNaN(numRol)){
				rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
					if(roles!=null){
						$('#nomPerfilAutEspAport').val(roles.nombreRol);
					}else{
						mensajeSis("No Existe el Perfil Indicado");
						$('#perfilAutEspAport').val('');
						$('#perfilAutEspAport').focus();
						$('#nomPerfilAutEspAport').val("");
					}
				});
			}
		}

		function consultaRolesCamCarta(idControl) {
			var jqRol = eval("'#" + idControl + "'");
			var numRol = $(jqRol).val();
			var conRol=2;
			var rolesBeanCon = {
	  				'rolID':numRol
					};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numRol != '' && !isNaN(numRol)){
				rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
					if(roles!=null){
						$('#nomPerfilCamCarLiqui').val(roles.nombreRol);
					}else{
						mensajeSis("No Existe el Perfil Indicado");
						$('#perfilCamCarLiqui').val('');
						$('#perfilCamCarLiqui').focus();
						$('#nomPerfilCamCarLiqui').val("");
					}
				});
			}
		}

		function consultaPrimerRolFluj(idControl) {
			var jqRol = eval("'#" + idControl + "'");
			var numRol = $(jqRol).val();
			var conRol=2;
			var rolesBeanCon = {
	  				'rolID':numRol
					};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numRol != '' && !isNaN(numRol)){
				rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
					if(roles!=null){
						$('#nombrePrimerRol').val(roles.nombreRol);
					}else{
						mensajeSis("No Existe el Rol");
						$('#primerRolFlujoSolID').val('');
						$('#nombrePrimerRol').val("");
					}
				});
			}
		}
		function consultaSegunRolFluj(idControl) {
			var jqRol = eval("'#" + idControl + "'");
			var numRol = $(jqRol).val();
			var conRol=2;
			var rolesBeanCon = {
	  				'rolID':numRol
					};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numRol != '' && !isNaN(numRol)){
				rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
					if(roles!=null){
						$('#nombreSegundoRol').val(roles.nombreRol);
					}else{
						mensajeSis("No Existe el Rol");
						$('#segundoRolFlujoSolID').val('');
						$('#nombreSegundoRol').val("");
					}
				});
			}
		}




		function consultaTiposCuenta() {
			var bean={};
			dwr.util.removeAllOptions('tipoCtaGLAdi');
			dwr.util.addOptions('tipoCtaGLAdi', {'':'SELECCIONAR'});
			tiposCuentaServicio.listaCombo(4,bean, function(tiposCuenta){
				dwr.util.addOptions('tipoCtaGLAdi', tiposCuenta, 'tipoCuentaID', 'descripcion');
			});
		}
		function consultaCatTarjetas() {
			dwr.util.removeAllOptions('tipoTarjetaHN1');
			dwr.util.addOptions('tipoTarjetaHN1', {"":'SELECCIONAR'});
			tipoTarjetaDebServicio.listaCombo(1, function(tiposTarjetas){
			dwr.util.addOptions('tipoTarjetaHN1', tiposTarjetas, 'tipoTarjetaDebID', 'descripcion');
			});
		}


		function consultaAdminTesoreriaRoles(idControl) {
			var jqRol = eval("'#" + idControl + "'");
			var numRol = $(jqRol).val();
			var conRol=catTipoConsultaSucursal.foranea;
			var rolesBeanCon = {
	  				'rolID':numRol
					};
			setTimeout("$('#cajaLista').hide();", 200);
			if(numRol != '' && !isNaN(numRol) ){
				rolesServicio.consultaRoles(conRol,rolesBeanCon,function(roles) {
					if(roles!=null){
						$('#nombreAdminRolTesoreria').val(roles.nombreRol);
					}else{
						mensajeSis("No Existe el Rol");
						$('#rolAdminTeso').val('');
						$('#nombreAdminRolTesoreria').val("");
					}
				});
			}
		}

		function consultaSucursal(idControl) {
			var jqSucursal = eval("'#" + idControl + "'");
			var numSucursal = $(jqSucursal).val();
			var conSucursal=2;
			setTimeout("$('#cajaLista').hide();", 200);
			if(numSucursal != '' && !isNaN(numSucursal)){
				sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
					if(sucursal!=null){
						$('#sucursalMatrizID').val(sucursal.sucursalID);
						$('#nombreMatriz').val(sucursal.nombreSucurs);
					}else{
						mensajeSis("No Existe la Sucursal");
						$(jqSucursal).focus();
						$('#sucursalMatrizID').val('');
						$('#nombreMatriz').val("");
					}
				});
			}
		}
		 function consultaCliente(idControl) {
				var jqCliente = eval("'#" + idControl + "'");
				var numCliente = $(jqCliente).val();
				var tipConForanea = 2;
				setTimeout("$('#cajaLista').hide();", 200);

				if(numCliente != '' && !isNaN(numCliente)){
					clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
								if(cliente!=null){
									$('#clienteInstitucion').val(cliente.numero);
									$('#nombreInstitucionCliente').val(cliente.nombreCompleto);
								}else{
									mensajeSis("No Existe el Cliente");
									$('#clienteInstitucion').focus();
									$('#clienteInstitucion').val('');
									$('#nombreInstitucionCliente').val("");
								}
						});
					}
				}
		 // funcion para consultar El nombre del Cliente
		 function validaUsuario(control) {
				var jqUsuario = eval("'#" + control + "'");
				var numUsuario = $(jqUsuario).val();

				setTimeout("$('#cajaLista').hide();", 200);
				if(numUsuario != '' && !isNaN(numUsuario)){
					var usuarioBeanCon = {
							'usuarioID':numUsuario
					};
					usuarioServicio.consulta(catTipoConsultaUsuario.principal,usuarioBeanCon,function(usuario) {
						if(usuario!=null){
							if(control=='oficialCumID'){
								$('#nombreOficialCumID').val(usuario.nombreCompleto);
							}
							if(control=='dirGeneralID'){
								$('#nombredirGeneralID').val(usuario.nombreCompleto);
							}
							if(control=='dirOperID'){
								$('#nombreDirOperID').val(usuario.nombreCompleto);
							}
							if(control=='sistemasID'){
								$('#nombreEncargadoSistemas').val(usuario.nombreCompleto);
							}

						}else{
							mensajeSis("No Existe el Usuario");
							if(control =='oficialCumID'){
								$('#oficialCumID').focus();
								$('#oficialCumID').select();
								$('#oficialCumID').val('');
								$('#nombreOficialCumID').val('');
							}else if(control=='dirGeneralID'){
								$('#dirGeneralID').focus();
								$('#dirGeneralID').select();
								$('#dirGeneralID').val('');
								$('#nombredirGeneralID').val('');
							}else if(control=='dirOperID'){
								$('#dirOperID').focus();
								$('#dirOperID').select();
								$('#dirOperID').val('');
								$('#nombreDirOperID').val('');
							}else if(control=='sistemasID'){
								$('#sistemasID').focus();
								$('#sistemasID').select();
								$('#sistemasID').val('');
								$('#nombreEncargadoSistemas').val('');
							}
						}
					});

				}
			}
		 function maestroCuentasDescripcion(idControl,campoDescripcion,otraCuentaContable){
				var jqCtaContable = eval("'#" + idControl + "'");
				var numCtaContable =  $(jqCtaContable).val();
				var conForanea = 2;
				var CtaContableBeanCon = {
						'cuentaCompleta':numCtaContable
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCtaContable != '' && !isNaN(numCtaContable)){
					cuentasContablesServicio.consulta(conForanea,CtaContableBeanCon,function(ctaConta){
						if(ctaConta!=null){
							$('#'+campoDescripcion).val(ctaConta.descripcion);

							if(($('#ctaFinGastoEmp').val() < $('#ctaIniGastoEmp').val()) && $('#'+otraCuentaContable).val() != ''){
								mensajeSis("La Cuenta final debe ser mayor a la cuenta inicial");
								$('#'+campoDescripcion).val('');
								$(jqCtaContable).focus();
								$(jqCtaContable).val('');
							}
						}
						else{
							mensajeSis("No existe la cuenta contable");
							$('#'+campoDescripcion).val('');
							$(jqCtaContable).focus();
						}
					});
				}

			}
		 function validaPromotor(idOrigen, idDestino, valor) {
				var jqDestino= eval("'#"+idDestino+"'");
				var jqorigen= eval("'#"+idOrigen+"'");
				setTimeout("$('#cajaLista').hide();", 200);

				if(valor != '' && !isNaN(valor) ){

						var promotor = {
							 'promotorID' :valor
							};

						var consultaPrincipal = 1;
						promotoresServicio.consulta(consultaPrincipal, promotor,function(promotor) {
								if(promotor!=null){
									$(jqDestino).val(promotor.nombrePromotor);
								}else{
									mensajeSis("No Existe el Promotor");
									$(jqorigen).val('');
									$(jqDestino).val('');
									$(jqorigen).focus().select();
								}
						});


				}
			}

		 //Cargando en una lista los campos de Facturacion electrónica

		 $('#estadoEmpresa').bind('keyup',function(e){
				lista('estadoEmpresa', '2', '1', 'nombre', $('#estadoEmpresa').val(), 'listaEstados.htm');
			});

			$('#estadoEmpresa').blur(function() {

		  		consultaEstado(this.id);
			});

		 $('#municipioEmpresa').bind('keyup',function(e){
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "estadoID";
				camposLista[1] = "nombre";


				parametrosLista[0] = $('#estadoEmpresa').val();
				parametrosLista[1] = $('#municipioEmpresa').val();

				lista('municipioEmpresa', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
			});

			$('#localidadEmpresa').bind('keyup',function(e){
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "estadoID";
				camposLista[1] = 'municipioID';
				camposLista[2] = "nombreLocalidad";


				parametrosLista[0] = $('#estadoEmpresa').val();
				parametrosLista[1] = $('#municipioEmpresa').val();
				parametrosLista[2] = $('#localidadEmpresa').val();

				lista('localidadEmpresa', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
			});

			$('#coloniaEmpresa').bind('keyup',function(e){
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "estadoID";
				camposLista[1] = 'municipioID';
				camposLista[2] = "localidadID";
				camposLista[3] = "asentamiento";


				parametrosLista[0] = $('#estadoEmpresa').val();
				parametrosLista[1] = $('#municipioEmpresa').val();
				parametrosLista[2] = $('#localidadEmpresa').val();
				parametrosLista[3] = $('#coloniaEmpresa').val();

				lista('coloniaEmpresa', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
			});


			$('#municipioEmpresa').blur(function() {
		  		consultaMunicipio(this.id);
			});
			$('#localidadEmpresa').blur(function() {
				consultaLocalidad(this.id);
			});
			$('#coloniaEmpresa').blur(function() {
				consultaColonia(this.id);
			});


			// nombres del servicio
			function validaCatalogoServicio(control) {
				var jqCatalogoServicio  = eval("'#" +control + "'");
				var catalogoServicio = $(jqCatalogoServicio).val();
				if(catalogoServicio != '' && !isNaN(catalogoServicio) && catalogoServicio !='0'){
					var catalogoServ = {
							'catalogoServID':catalogoServicio
					};
					catalogoServicios.consulta(1,catalogoServ,function(catalogoServicioBean) {
						if(catalogoServicioBean != null){
							if(catalogoServicioBean.requiereCliente=="S"){
								$('#nombreServReactivaCli').val(catalogoServicioBean.nombreServicio);
							}else{
								mensajeSis("El Servicio debe Requerir "+ $('#tipoCliente').val());
								$('#nombreServReactivaCli').val('');
								$('#servReactivaCliID').val('');
								$('#servReactivaCliID').focus();
							}

						}else{
							mensajeSis("El Servicio no Existe");
							$('#nombreServReactivaCli').val('');
							$('#servReactivaCliID').val('');
							$('#servReactivaCliID').focus();
						}
					});
				}else{
					$('#nombreServReactivaCli').val('');
					$('#servReactivaCliID').val('');
				}
			}

		 // Cargando los valores en las  cajas: estado, municipio, localidad, colonia parafacturacion electrnica
			function consultaEstado(idControl) {
				var jqEstado = eval("'#" + idControl + "'");
				var numEstado = $(jqEstado).val();
				var tipConForanea = 2;
				setTimeout("$('#cajaLista').hide();", 200);


				if(numEstado != '' && !isNaN(numEstado) && esTab){
					estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
						if(estado!=null){
							$('#nombreEstadoEmpresa').val(estado.nombre);
							}
							else{
							mensajeSis("No Existe el Estado");
							$('#nombreEstadoEmpresa').val("");
							$('#estadoEmpresa').val("");
							$('#estadoEmpresa').focus();
							$('#estadoEmpresa').select();
						}
					});
				}
			}

			function consultaMunicipio(idControl) {
				var jqMunicipio = eval("'#" + idControl + "'");
				var numMunicipio = $(jqMunicipio).val();
				var numEstado =  $('#estadoEmpresa').val();
				var tipConForanea = 2;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
					municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
						if(municipio!=null){
							$('#nombreMunicipioEmpresa').val(municipio.nombre);
						}else{
							mensajeSis("No Existe el Municipio");
							$('#nombreMunicipioEmpresa').val("");
							$('#municipioEmpresa').val("");
							$('#municipioEmpresa').focus();
							$('#municipioEmpresa').select();
						}
					});
				}
			}


			function consultaLocalidad(idControl) {
				var jqLocalidad = eval("'#" + idControl + "'");
				var numLocalidad = $(jqLocalidad).val();
				var numMunicipio =	$('#municipioEmpresa').val();
				var numEstado =  $('#estadoEmpresa').val();
				var tipConPrincipal = 1;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numLocalidad != '' && !isNaN(numLocalidad) && esTab){
					localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
						if(localidad!=null){
							$('#nombreLocalidadEmpresa').val(localidad.nombreLocalidad);
						}else{
							mensajeSis("No Existe la Localidad");
							$('#nombreLocalidadEmpresa').val("");
							$('#localidadEmpresa').val("");
							$('#localidadEmpresa').focus();
							$('#localidadEmpresa').select();
						}
					});
				}
			}
			// consulta la colonia y el codigo postal
			function consultaColonia(idControl) {
				var jqColonia = eval("'#" + idControl + "'");
				var numColonia= $(jqColonia).val();
				var numEstado =  $('#estadoEmpresa').val();
				var numMunicipio =	$('#municipioEmpresa').val();
				var tipConPrincipal = 1;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numColonia != '' && !isNaN(numColonia) && esTab){
					coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
						if(colonia!=null){
							$('#nombreColoniaEmpresa').val(colonia.asentamiento);
							$('#CPEmpresa').val(colonia.codigoPostal);
						}else{
							mensajeSis("No Existe la Colonia");
							$('#nombreColoniaEmpresa').val("");
							$('#coloniaEmpresa').val("");
							$('#coloniaEmpresa').focus();
							$('#coloniaEmpresa').select();
						}
					});
				}
			}

			// consulta solo la colonia
			function consultaColonias(idControl) {
				var jqColonia = eval("'#" + idControl + "'");
				var numColonia= $(jqColonia).val();
				var numEstado =  $('#estadoEmpresa').val();
				var numMunicipio =	$('#municipioEmpresa').val();
				var tipConPrincipal = 1;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numColonia != '' && !isNaN(numColonia) && esTab){
					coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
						if(colonia!=null){
							$('#nombreColoniaEmpresa').val(colonia.asentamiento);
						}else{
							mensajeSis("No Existe la Colonia");
							$('#nombreColoniaEmpresa').val("");
							$('#coloniaEmpresa').val("");
							$('#coloniaEmpresa').focus();
							$('#coloniaEmpresa').select();
						}
					});
				}
			}
			function mayor(fecha, fecha2){
				//0|1|2|3|4|5|6|7|8|9|
				//2 0 1 2 / 1 1 / 2 0
				var xMes=fecha.substring(5, 7);
				var xDia=fecha.substring(8, 10);
				var xAnio=fecha.substring(0,4);

				var yMes=fecha2.substring(5, 7);
				var yDia=fecha2.substring(8, 10);
				var yAnio=fecha2.substring(0,4);

				if (xAnio > yAnio){
					return true;
				}else{
					if (xAnio == yAnio){
						if (xMes > yMes){
							return true;
						}
						if (xMes == yMes){
							if (xDia > yDia){
								return true;
							}else{
								return false;
							}
						}else{
							return false;
						}
					}else{
						return false ;
					}
				}
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
						mensajeSis("Fecha introducida errónea");
					return false;
					}
					if (dia>numDias || dia==0){
						mensajeSis("Fecha introducida errónea");
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
			// Funcion generica
			function listaMaestroCuentas(idControl, descripCta){
				var jqControl = eval("'#" + idControl+ "'");

				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "descripcion";
				parametrosLista[0] = $(jqControl).val();
				if($(jqControl).val() != '' && !isNaN($(jqControl).val() )){
					listaAlfanumerica(idControl, '1', '6', camposLista, parametrosLista, 'listaCuentasContables.htm');
				}
				else{
					listaAlfanumerica(idControl, '1', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
				}
			 }
			function consultaCuentasContaDescripcion(idControl,descripcionCta) {
				var jqCuentaContable = eval("'#" + idControl + "'");
				var numCta = $(jqCuentaContable).val();
				var jdDescripvionCta =eval("'#" + descripcionCta + "'");
				var tipConForanea = 2;
				var ctaContableBeanCon = {
				  'cuentaCompleta':numCta
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if (numCta != '' && !isNaN(numCta)) {
					//if(numCta.length >= 10){
						cuentasContablesServicio.consulta(tipConForanea,ctaContableBeanCon,function(ctaConta){
							if (ctaConta != null) {
								if(ctaConta.grupo != "E"){
									$(jdDescripvionCta).val(ctaConta.descripcion);
								} else{
									mensajeSis("Solo Cuentas Contables De Detalle");
									$(jqCuentaContable).val("");
									$(jqCuentaContable).focus();
									$(jdDescripvionCta).val("");
								}
							}else {
								mensajeSis("La Cuenta Contable no existe.");
								$(jqCuentaContable).val("");
								$(jqCuentaContable).focus();
								$(jdDescripvionCta).val("");
							}
						});
					//s}
				}else{
					if(numCta == ''){
						$(jdDescripvionCta).val("");
					}
				}
			}



});

function consultaDirecCompleta() {
		var ca 		= $('#calleEmpresa').val();
  		var nu  	= $('#numIntEmpresa').val();
  		var ni  	= $('#numExtEmpresa').val();
  		var co 	 	= $('#nombreColoniaEmpresa').val();
  		var cp  	= $('#CPEmpresa').val();
  		var nm  	= $('#nombreMunicipioEmpresa').val();
  		var ne 		= $('#nombreEstadoEmpresa').val();

  		var dirCom =  ca;
  		if(nu != ''){
  			dirCom = (dirCom +", No. "+ nu);
  		}
		if(ni != ''){
  			dirCom = (dirCom +", INTERIOR "+ ni);
  		}
  		dirCom = (dirCom+", "+ co +", C.P. "+ cp +", "+ nm  + ", "+ ne +"." );
  		$('#dirFiscal').val(dirCom);
	}

//Consulta descripcion firma
function consultaDescripcionFirma(){
	setTimeout("$('#cajaLista').hide();", 200);
	var tipoConsulta = 1;
	var num = $('#tipoDocumentoID').val();
	var bean={
			'tipoDocumentoID':num
	};

	if(num != '' && !isNaN(num)){
			tiposDocumentosServicio.consulta(tipoConsulta,bean, { async: false, callback: function(descripcion) {
			if(descripcion!=null){
				$('#descripcionDoc').val(descripcion.descripcion);

			}else{
				mensajeSis("No existe el tipo de Documento");
				$('#tipoDocumentoID').val("");
				$('#descripcionDoc').val("");
				$('#tipoDocumentoID').focus();
			}
		}});
	}else{
		mensajeSis("Texto invalido");
		$('#tipoDocumentoID').val("");
		$('#descripcionDoc').val("");
		$('#tipoDocumentoID').focus();
	}
}


function ayudaCR(){
	var data;


	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
			'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista" >&SC</td><td id="contenidoAyuda"><b>Sucursal Cliente</b></td>'+
				'</tr>'+
			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
			'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplos: </legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 1: </b></td>'+
					'<td id="contenidoAyuda">&SO</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 2:</b></td>'+
					'<td id="contenidoAyuda">&SC</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 3:</b></td>'+
					'<td id="contenidoAyuda">15</td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+
			'</fieldset>'+
			'</fieldset>';

	$('#ContenedorAyuda').html(data);
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: {
                top:  ($(window).height() - 400) /2 + 'px',
                left: ($(window).width() - 400) /2 + 'px',
                width: '400px'
            } });
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}

function consultaEstatusInverGar(varEstatus) {
	if(varEstatus != null){
		var tp= varEstatus.split(',');
		var tamanio = tp.length;
	 	for (var i=0;i<tamanio;i++) {
			var tip = tp[i];
			var jqTipo = eval("'#estCreAltInvGar option[value="+tip+"]'");
			$(jqTipo).attr("selected","selected");
		}
	}
}


function validador(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else
  		return false;
	}
}



function ayudaSeguroCuota(){
	var data;

	data =
	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
		'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Cobro de Seguro por Cuota</legend>'+
			'<table border="0" id="tablaLista" width="100%" style="margin-top:10px">'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda" style="padding: 5px"><b>Si se cambia &eacute;ste par&aacute;metro de SI a NO, '+
					'actualizar&aacute; los productos de cr&eacute;dito y los reportes de saldos podr&aacute;n presentar desajustes '+
					'si ya existen cr&eacute;ditos vigentes o pagados.</b></td>'+
				'</tr>'+
			'</table>'+
		'</div>'+
	'</fieldset>';

	$('#ContenedorAyuda').html(data);

	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
			 left: '50%',
			 top: '50%',
			 margin: '-200px 0 0 -200px',
			 border: '0',
			 'background-color': 'transparent'
		}
	});
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}
function ayudaRestringeLiberacion(){
	var data;

	data =
	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
		'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Restringir Liberaci&oacute;n de Solcitud</legend>'+
			'<table border="0" id="tablaLista" width="100%" style="margin-top:10px">'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda" style="padding: 5px"><b>Especificar un rol el cual pueda liberar las solicitudes de cr&eacute;dito desde '+
					'el flujo de solicitud de cr&eacute;dito.</b></td>'+
				'</tr>'+
			'</table>'+
		'</div>'+
	'</fieldset>';

	$('#ContenedorAyuda').html(data);

	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
			 left: '50%',
			 top: '50%',
			 margin: '-200px 0 0 -200px',
			 border: '0',
			 'background-color': 'transparent'
		}
	});
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}
function ayudaBloqueaBtonRechazar(){
	var data;

	data =
	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
		'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ocultar Bot&oacute;n Rechazar Solicitud</legend>'+
			'<table border="0" id="tablaLista" width="100%" style="margin-top:10px">'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda" style="padding: 5px"><b>Oculta el botón de rechazar solicitud unicamente en el flujo de solicitud de cr&eacute;dito.'+
					'el flujo de solicitud de cr&eacute;dito.</b></td>'+
				'</tr>'+
			'</table>'+
		'</div>'+
	'</fieldset>';

	$('#ContenedorAyuda').html(data);

	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
			 left: '50%',
			 top: '50%',
			 margin: '-200px 0 0 -200px',
			 border: '0',
			 'background-color': 'transparent'
		}
	});
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}
function noRequiereRolesDeFlujoCred() {
	var noRequiereRol = true;
	if ($('#siRestringebtnLiberacionSol:checked').val() == 'S') {
		noRequiereRol = false;
	}
	if ($('#siOcultaBtnRechazoSol:checked').val() == 'S') {
		noRequiereRol = false;
	}
	//Si necesita rol valida y devuelve false
	if (!noRequiereRol) {
		if($('#primerRolFlujoSolID').val() == '' && $('#segundoRolFlujoSolID').val() == ''){
			mensajeSis("Es necesario parametrizar al menos un rol para liberar solicitud");
			return noRequiereRol;
		} else {
			noRequiereRol = true;
			return noRequiereRol;
		}
	} else {
		//si no requiere rol limpia los campos a vacios
		$('#primerRolFlujoSolID').val('');
		$('#segundoRolFlujoSolID').val('');
		$('#nombrePrimerRol').val('');
		$('#nombreSegundoRol').val('');
	}
	return noRequiereRol;
}

function muestraFrecuenciaMatriz(muestra){
	var frecuenciaMensual = $('#frecuenciaMensual').asNumber();
	if(muestra){
		$('#tdFrecuenciaMensual1').show();
		$('#tdFrecuenciaMensual2').show();
		if(frecuenciaMensual == 0){
			$('#frecuenciaMensual').val('');
		}
	} else {
		$('#tdFrecuenciaMensual1').hide();
		$('#tdFrecuenciaMensual2').hide();
		$('#frecuenciaMensual').val('');
	}
}


function ayudaRestringeReporte(){
	var data;

	data =
	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
		'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Restringe reportes</legend>'+
			'<table border="0" id="tablaLista" width="100%" style="margin-top:10px">'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda" style="padding: 5px"><b>La opción SI, limita la visualización de la información de los reportes del módulo de cartera de acuerdo a la persona que esté generando dicho reporte ya que solo podrá ver información que se va generando de sus subordinados(Organigrama).'+
				'Reportes:<br>'+
					'*  Vencimientos.<br>'+
					'*  Reestructuras.<br>'+
					'*  Ministraciones.<br>'+
					'*  Saldos de Cartera.<br>'+
					'*  Analitica Cartera.<br>'+
					'*  Pagos de Créditos.<br>'+
					'*  Cartera Castigada.<br>'+
					'*  Operación Básica de Unidad.<br>'+

					'El check NO, tendrá la funcionalidad de no restringir la información de los reportes del módulo de cartera.</b></td>'+
				'</tr>'+
			'</table>'+
		'</div>'+
	'</fieldset>';

	$('#ContenedorAyuda').html(data);

	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
			 left: '50%',
			 top: '50%',
			 margin: '-200px 0 0 -200px',
			 border: '0',
			 'background-color': 'transparent'
		}
	});
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}

function limpiaAlertaVenConvenio(){
	if($('#alerVerificaConvenio').is(':checked')){
		$('#alerVerificaConvenio1').attr('checked',false);
		$('.alertaVenConvenio').show();

	}
	if($('#alerVerificaConvenio1').is(':checked')){
		$('#alerVerificaConvenio').attr('checked',false);
		$('#noDiasAntEnvioCorreo').val('');
		$('#remitenteID').val('');
		$('#correoAdiDestino').val('');
		$('#correoRemitente').val('');
		$('.alertaVenConvenio').hide();

	}
}

function ayudaValidaReferencia(){
	var data;

	data =
	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
		'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">Valida Referencia por Pago de Instrumento</legend>'+
			'<table border="0" id="tablaLista" width="100%" style="margin-top:10px">'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda" style="padding: 5px"><b>Este parámetro valida que a el crédito que se le esta generando la reportería, '+
					'cuente con una referencia por pago de instrumento, '+
					'dicha validación se aplica en el botón “Tabla de amortización”, de la pantalla pagaré de crédito.</b></td>'+
				'</tr>'+
			'</table>'+
		'</div>'+
	'</fieldset>';

	$('#ContenedorAyuda').html(data);

	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
			 left: '50%',
			 top: '50%',
			 margin: '-200px 0 0 -200px',
			 border: '0',
			 'background-color': 'transparent'
		}
	});
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}

function ayudaPorcentajeCapitalNeto(){
	var data;

	data =
	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
		'<div id="ContenedorAyuda">'+
			'<legend class="ui-widget ui-widget-header ui-corner-all">VALIDA CAPITAL CONTABLE NETO</legend>'+
			'<table border="0" id="tablaLista" width="100%" style="margin-top:10px">'+
				'<tr>'+
					'<td colspan="0" id="contenidoAyuda" style="padding: 5px">'+
						'<b>Este parámetro valida que el monto no supere el porcentaje del capital contable neto de la entidad.</b><br>'+
						'<b>Dicha validación se realiza en las siguientes pantallas:</b><br>'+
					'</td>'+
				'</tr>'+
				'<tr style="text-align: left">'+
					'<td colspan="0" id="contenidoAyuda" style="padding: 5px"; >'+
						'1.-Inversion a Plazo -> Registro -> Autoriza Inversion'+'<br>'+
						'2,-CEDES ->Registro -> Autorizar CEDE'+'<br>'+
						'3.-Ventanilla -> Regitro -> Ingresos de Operaciones(Abono a Cuenta)'+'<br>'+
					'</td>'+
				'</tr>'+
			'</table>'+
		'</div>'+
	'</fieldset>';

	$('#ContenedorAyuda').html(data);

	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
			 left: '50%',
			 top: '50%',
			 margin: '-200px 0 0 -200px',
			 border: '0',
			 'background-color': 'transparent'
		}
	});
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}

