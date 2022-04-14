	$(document).ready(function () {
		esTab = true;
		var numEmpresaID = 1;

		$('.prioridad').hide();

		//Definicion de Constantes y Enums
		var catTipoTransaccion = {
			'grabar': '1',
			'modificar': '2'
		};

		//------------ Metodos y Manejo de Eventos -----------------------------------------
		ocultarCampos('I');
		agregaFormatoControles('formaGenerica');
		deshabilitaBoton('modificar');

		$('#empresaID').focus();

		$(':text').focus(function () {
			esTab = false;
		});

		$(':text').bind('keydown', function (e) {
			if (e.which == 9 && !e.shiftKey) {
				esTab = true;
			}
		});

		$('#modificar').click(function () {
			validarCorreo();
			$('#tipoTransaccion').val(catTipoTransaccion.modificar);
			$('#horarioInicio').val(concatHoraMin('horarioInicioHrs', 'horarioInicioMins'));
			$('#horarioFin').val(concatHoraMin('horarioFinHrs', 'horarioFinMins'));
			$('#horarioFinVen').val(concatHoraMin('horarioFinVenHrs', 'horarioFinVenMins'));
			$('#frecuenciaEnvio').val("00:00:" + frecuencia('frecuenciaEnMins'));

		});

		$('#horarioInicioHrs').change(function () {
			$('#horarioInicio').val(concatHoraMin('horarioInicioHrs', 'horarioInicioMins'));
		});

		$('#horarioInicioMins').change(function () {
			$('#horarioInicio').val(concatHoraMin('horarioInicioHrs', 'horarioInicioMins'));
		});

		$('#horarioFinHrs').change(function () {
			$('#horarioFin').val(concatHoraMin('horarioFinHrs', 'horarioFinMins'));
		});

		$('#horarioFinMins').change(function () {
			$('#horarioFin').val(concatHoraMin('horarioFinHrs', 'horarioFinMins'));
		});

		$('#horarioFinVenHrs').change(function () {
			$('#horarioFinVen').val(concatHoraMin('horarioFinVenHrs', 'horarioFinVenMins'));
		});

		$('#horarioFinVenMins').change(function () {
			$('#horarioFinVen').val(concatHoraMin('horarioFinVenHrs', 'horarioFinVenMins'));
		});

		$('#frecuenciaEnMins').change(function () {
			$('#frecuenciaEnvio').val("00:00:" + frecuencia('frecuenciaEnMins'));
		});
		
		$('#participanteSpei').blur(function(){
			var participante = $('#participanteSpei').asNumber();
			if(participante <= 0){
				$('#participanteSpei').val("0");
				mensajeSis('La Clave del Participante SPEI no Puede ser 0');
				setTimeout("$('#participanteSpei').focus()", 50);
			}
		});

		for (var i = 0; i < 24; i++) {
			var s = i.toString();
			if (s.length == 1) {
				s = "0" + s;
			}
			document.getElementById("horarioInicioHrs").innerHTML += ("<option value='" + i + "'>" + s + "</option>");
		}
		for (var i = 0; i < 60; i++) {
			var s = i.toString();
			if (s.length == 1) {
				s = "0" + s;
			}
			document.getElementById("horarioInicioMins").innerHTML += ("<option value='" + i + "'>" + s + "</option>");
		}
		for (var i = 0; i < 24; i++) {
			var s = i.toString();
			if (s.length == 1) {
				s = "0" + s;
			}
			document.getElementById("horarioFinHrs").innerHTML += ("<option value='" + i + "'>" + s + "</option>");
		}
		for (var i = 0; i < 60; i++) {
			var s = i.toString();
			if (s.length == 1) {
				s = "0" + s;
			}
			document.getElementById("horarioFinMins").innerHTML += ("<option value='" + i + "'>" + s + "</option>");
		}
		for (var i = 0; i < 24; i++) {
			var s = i.toString();
			if (s.length == 1) {
				s = "0" + s;
			}
			document.getElementById("horarioFinVenHrs").innerHTML += ("<option value='" + i + "'>" + s + "</option>");
		}
		for (var i = 0; i < 60; i++) {
			var s = i.toString();
			if (s.length == 1) {
				s = "0" + s;
			}
			document.getElementById("horarioFinVenMins").innerHTML += ("<option value='" + i + "'>" + s + "</option>");
		}

		for (var i = 0; i < 60; i++) {
			var s = i.toString();
			if (s.length == 1) {
				s = "0" + s;
			}
			document.getElementById("frecuenciaEnMins").innerHTML += ("<option value='" + i + "'>" + s + "</option>");
		}

		$.validator.setDefaults({
			submitHandler: function (event) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'empresaID',
					'funcionExitoParametrosSpei', 'funcionErrorParametrosSpei');
			}
		});

		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({

			rules: {
				empresaID: {
					required:  function () {
						return $('#habilitadoSi:checked').val() == 'S';
					},
					minlength: 1,
					number: true
				},
				clabe: {
					required: function () {
						return $('#habilitadoSi:checked').val() == 'S';
					},
					numeroPositivo: true,
				},
				ctaSpei: {
					required: function () {
						return $('#habilitadoSi:checked').val() == 'S';
					},
					numeroPositivo: true,
				},
				monReqAutTeso: {
					required: function () {
						return $('#habilitadoSi:checked').val() == 'S';
					},
					number: true,
				},
				monMaxSpeiBcaMovil: {
					required: function () {
						return ($('#participaPagoMovil1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					},
					number: true,
				},
				montoMinimoBloq: {
					required: function () {
						return ($('#bloqueoRecepcion1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					},
					number: true,
				},
				ctaContableTesoreria: {
					required: function () {
						return $('#habilitadoSi:checked').val() == 'S';
					},
					number: true,
				},
				monMaxSpeiVen: {
					required: function () {
						return $('#habilitadoSi:checked').val() == 'S';
					},
					number: true,
				},
				participanteSpei: {
					required: function () {
						return $('#habilitadoSi:checked').val() == 'S';
					},
					numeroPositivo: true,
				},
				saldoMinimoCuentaSTP : {
					required: function(){
						return ($('#Tipo1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					}
				},
				rutaKeystoreStp :{
					required: function(){
						return ($('#Tipo1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					}
				},
				aliasCertificadoStp :{
					required: function(){
						return ($('#Tipo1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					}
				},
				passwordKeystoreStp :{
					required: function(){
						return ($('#Tipo1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					}
				},
				empresaSTP :{
					required: function(){
						return ($('#Tipo1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					}
				},
				correoNotificacion: {
					required: function () {
						return ($('#Tipo1:checked').val() == 'S' && $('#notificacion1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					}
				},
				remitenteID: {
					required: function () {
						return ($('#Tipo1:checked').val() == 'S' && $('#notificacion1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					},
					number: true
				},
				intentosMaxEnvio: {
					required: function () {
						return ($('#Tipo1:checked').val() == 'S' && $('#habilitadoSi:checked').val() == 'S');
					},
					number: true
				},
				monReqAutDesem: {
					required: function () {
						return $('#habilitadoSi:checked').val() == 'S';
					},
					number: true,
				}
			},
			messages: {
				empresaID: {
					required: 'Especificar la empresa',
					minlength: 'Al menos 1 Caracter',
					number: 'solo números'
				},
				clabe: {
					required: 'Especificar Cuenta Clabe',
					numeroPositivo: "Solo números"
				},
				ctaSpei: {
					required: 'Especificar Cuenta Contable',
					numeroPositivo: "Solo números"
				},
				monReqAutTeso: {
					required: 'Especificar Monto que Requiere Autorización',
					number: 'Sólo Números'
				},
				monMaxSpeiBcaMovil: {
					required: 'Especificar Monto Máximo',
					number: 'Sólo Números'
				},
				montoMinimoBloq: {
					required: 'Especificar Monto Mínimo de Bloqueo',
					number: 'Sólo Números'
				},
				monMaxSpeiVen: {
					required: 'Especificar Monto Máximo',
					number: 'Sólo Números'
				},
				ctaContableTesoreria: {
					required: 'Especificar Cuenta Tesoreria',
					number: 'Sólo Números'
				},
				participanteSpei: {
					required: 'Especificar Número del Participante',
					numeroPositivo: "Solo números"
				},
				saldoMinimoCuentaSTP : {
					required: 'Especificar Saldo mínimo STP'
				},
				rutaKeystoreStp :{
					required: 'Especificar Ruta Keystore de STP'
				},
				aliasCertificadoStp :{
					required: 'Especificar Alias de Certificado de STP'
				},
				passwordKeystoreStp :{
					required: 'Especificar Password Keystore de STP'
				},
				empresaSTP :{
					required: 'Especificar Empresa STP'
				},
				correoNotificacion: {
					required: 'El Correo está Vacio',
				},
				remitenteID: {
					required: 'El Remitente está Vacio',
					number: 'Solo Números'
				},
				intentosMaxEnvio: {
					required: 'El Máximo de Intentos está Vacios',
					number: 'Solo Números'
				},
				monReqAutDesem: {
					required: 'Especificar Monto que Requiere Autorización para Desembolsos',
					number: 'Sólo Números'
				}
			}
		});
		

		$('input , select').blur(function() {
			if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
				setTimeout(function() {
					$('#formaGenerica :input:enabled:visible:first').focus();
				}, 0);
			}
		});

		$('#empresaID').bind('keyup', function (e) {
			lista('empresaID', '3', '1', 'nombreInstitucion', $('#empresaID').val(), 'listaParametrosSpei.htm');
		});

		$('#ctaContableTesoreria').bind('keyup', function (e) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#ctaContableTesoreria').val();
			listaAlfanumerica('ctaContableTesoreria', '1', '2', camposLista, parametrosLista, 'listaParametrosSpei.htm');
		});

		$('#remitenteID').bind('keyup', function (e) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "remitenteID";
			parametrosLista[0] = $('#remitenteID').val();
			lista('remitenteID', '1', '3', camposLista, parametrosLista, 'listaremitentes.htm');
		});

		$('#ctaContableTesoreria').blur(function (event) {
			validaCuentaContableEnTransito(this.id);
		});

		$('#ctaSpei').blur(function (event) {
			validaCuentaContableEnTransito(this.id);
		});

		$('#empresaID').blur(function () {
			if (!isNaN($('#empresaID').val()) && $('#empresaID').asNumber() > 0) {
				consultaParametrosSPei();
			} else {
				$('#empresaID').focus();
			}
		});

		$('#remitenteID').blur(function () {
			esTab = true;
			validaCorreo(this.id);
		});

		$('#participaPagoMovil1').click(function () {
			mostrarCampos('M');
			$('#monMaxSpeiBcaMovil').focus();
		});

		$('#participaPagoMovil2').click(function () {
			ocultarCampos('M');
			$('#monMaxSpeiBcaMovil').val('0.00');
			$('#participaPagoMovil2').focus();
		});

		$('#bloqueoRecepcion1').click(function () {
			mostrarCampos('B');
			$('#montoMinimoBloq').focus();
		});
		$('#bloqueoRecepcion2').click(function () {
			ocultarCampos('B');
			$('#montoMinimoBloq').val('0.00');
			$('#bloqueoRecepcion2').focus();
		});

		$('#monMaxSpeiBcaMovil').blur(function () {
			validarCampos();
		});

		$('#montoMinimoBloq').blur(function () {
			validarCampos();
		});

		$('#Tipo1').click(function () {
			ocultarCampos('ST');
			mostrarCampos('CSTP');
		});

		$('#Tipo2').click(function () {
			mostrarCampos('BA');
			ocultarCampos('CB');
		});

		$('#notificacion1').click(function () {
			mostrarCampos('C');
			$('#correoNotificacion').focus();
		});

		$('#notificacion2').click(function () {
			ocultarCampos('C');
		});

		$('#intentosMaxEnvio').blur(function (){
			if($('#intentosMaxEnvio').val() < 5) {
				mensajeSis('El número de Intentos Máximos debe de ser como mínimo 5');
				$('#intentosMaxEnvio').val(5);
				$('#intentosMaxEnvio').focus();
			}
		});
		
		$('#habilitadoSi').click(function(){
			mostrarCampos('SPEI');
		});
		
		$('#habilitadoNo').click(function(){
			ocultarCampos('SPEI');
		});
	});

	// funcion para consultar Parametros Spei
	function consultaParametrosSPei() {
		var numEmpresa = $('#empresaID').val();
		var tipConsulta = 1;
		var parBeanCon = {
			'empresaID': numEmpresa,
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEmpresa != '' && !isNaN(numEmpresa) && esTab) {

			parametrosSpeiServicio.consulta(tipConsulta, parBeanCon, function (data) {
				//si el resultado obtenido de la consulta regreso un resultado
				if (data != null) {

					//coloca los valores del resultado en sus campos correspondientes
					$('#empresaID').val(data.empresaID);
					$('#nombreInsitutcion').val(data.nombreInstitucion);
					$('#clabe').val(data.clabe);
					$('#ctaSpei').val(data.ctaSpei);
					$('#tipoOperacion').val(data.tipoConexion);
					$('#saldoMinimoCuentaSTP').val(data.saldoMinimoCuentaSTP);
					$('#rutaKeystoreStp').val(data.rutaKeystoreStp);
					$('#aliasCertificadoStp').val(data.aliasCertificadoStp);
					$('#passwordKeystoreStp').val(data.passwordKeystoreStp);
					$('#empresaSTP').val(data.empresaSTP);
					$('#notificacionesCorreo').val(data.notificacionesCorreo);
					$('#correoNotificacion').val(data.correoNotificacion);
					$('#remitenteID').val(data.remitenteID);
					$('#remitenteCorreo').val(data.remitenteCorreo);
					$('#intentosMaxEnvio').val(data.intentosMaxEnvio);
					$('#urlWS').val(data.urlWS);
					$('#usuarioContraseniaWS').val(data.usuarioContraseniaWS);
					
					
					$('#monReqAutTeso').val(data.monReqAutTeso);
					$('#monMaxSpeiVen').val(data.monMaxSpeiVen);
					$('#monMaxSpeiBcaMovil').val(data.monMaxSpeiBcaMovil);
					$('#montoMinimoBloq').val(data.montoMinimoBloq);
					$('#participanteSpei').val(data.participanteSpei);
					$('#ctaContableTesoreria').val(data.ctaContableTesoreria);
					$('#monReqAutDesem').val(data.monReqAutDesem);

					var selecthoraini = eval("'#horarioInicioHrs option[value=" + extraeHora(data.horarioInicio) + "]'");
					$(selecthoraini).attr('selected', 'true');

					var selectminini = eval("'#horarioInicioMins option[value=" + extraeMin(data.horarioInicio) + "]'");
					$(selectminini).attr('selected', 'true');


					var selecthorafin = eval("'#horarioFinHrs option[value=" + extraeHora(data.horarioFin) + "]'");
					$(selecthorafin).attr('selected', 'true');

					var selectminfin = eval("'#horarioFinMins option[value=" + extraeMin(data.horarioFin) + "]'");
					$(selectminfin).attr('selected', 'true');

					var selecthorafinven = eval("'#horarioFinVenHrs option[value=" + extraeHora(data.horarioFinVen) + "]'");
					$(selecthorafinven).attr('selected', 'true');

					var selectminfinven = eval("'#horarioFinVenMnis option[value=" + extraeMin(data.horarioFinVen) + "]'");
					$(selectminfinven).attr('selected', 'true');

					var selectsegfrec = eval("'#frecuenciaEnMins option[value=" + extraeSeg(data.frecuenciaEnvio) + "]'");
					$(selectsegfrec).attr('selected', 'true');

					if (data.participaPagoMovil == 'S') {
						$('#participaPagoMovil1').attr('checked', true);
						$('#participaPagoMovil2').attr('checked', false);
						mostrarCampos('M');
					}
					if (data.participaPagoMovil == 'N') {
						$('#participaPagoMovil1').attr('checked', false);
						$('#participaPagoMovil2').attr('checked', true);
						ocultarCampos('M');
					}
					if (data.topologia == 'T') {
						$('#topologia1').attr('checked', true);
						$('#topologia2').attr('checked', false);
					}
					if (data.topologia == 'V') {
						$('#topologia1').attr('checked', false);
						$('#topologia2').attr('checked', true);
					}
					if (data.tipoOperacion == 'S') {
						$('#Tipo1').attr('checked', true);
						$('#Tipo2').attr('checked', false);
						ocultarCampos('ST');
						mostrarCampos('CSTP');

					}
					if (data.tipoOperacion == 'B') {
						$('#Tipo2').attr('checked', true);
						$('#Tipo1').attr('checked', false);
						mostrarCampos('BA');
						ocultarCampos('CB');
					}

					if (data.notificacionesCorreo == 'S') {
						$('#notificacion1').attr('checked', true);
						$('#notificacion2').attr('checked', false);
						mostrarCampos('C');
					}
					if (data.notificacionesCorreo == 'N') {
						$('#notificacion1').attr('checked', false);
						$('#notificacion2').attr('checked', true);
						ocultarCampos('C');

					}
					if (data.speiVenAutTes == 'S') {
						$('#speiVenAutTes1').attr('checked', true);
						$('#speiVenAutTes2').attr('checked', false);
					}
					if (data.speiVenAutTes == 'N') {
						$('#speiVenAutTes1').attr('checked', false);
						$('#speiVenAutTes2').attr('checked', true);
					}

					if (data.bloqueoRecepcion == 'S') {
						$('#bloqueoRecepcion1').attr('checked', true);
						$('#bloqueoRecepcion2').attr('checked', false);
						mostrarCampos('B');
					}
					if (data.bloqueoRecepcion == 'N') {
						$('#bloqueoRecepcion1').attr('checked', false);
						$('#bloqueoRecepcion2').attr('checked', true);
						ocultarCampos('B');
					}
					
					if(data.habilitado == 'S'){
						$('#habilitadoSi').attr('checked', true);
						$('#habilitadoNo').attr('checked', false);
						mostrarCampos('SPEI');
					}
					
					if(data.habilitado == 'N'){
						$('#habilitadoSi').attr('checked', false);
						$('#habilitadoNo').attr('checked', true);
						ocultarCampos('SPEI');
					}


					$('#urlWSPM').val(data.urlWSPM);
					$('#urlWSPF').val(data.urlWSPF);
					
					habilitaBoton('modificar');

				} else {
					mensajeSis("No Existe Empresa");
					limpiaCampos();
				}
			});
		}
	}

	var catTipoConsultaCorreo = {
		'principal': 1
	};

	function validaCorreo(idControl) {
		var jqCorreo = eval("'#" + idControl + "'");
		var numCorreo = $(jqCorreo).val();
		
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCorreo != '' && !isNaN(numCorreo) && esTab) {
			var TarEnvioCorreoParamBeanCon = {
				'remitenteID': numCorreo
			};

			tarEnvioCorreoParamServicio.consulta(catTipoConsultaCorreo.principal, TarEnvioCorreoParamBeanCon, function (Correo) {

				if (Correo != null) {
					$('#remitenteCorreo').val(Correo.correoSalida);
				} else {
					mensajeSis("No Existe el Correo");
					$('#remitenteID').focus();
					$('#remitenteID').val(0);
				}

			});
		}
	}

	function extraeHora(hora) {
		var hrs = parseInt(hora.substring(0, 2));
		return hrs;
	}

	function extraeMin(hora) {
		var mins = parseInt(hora.substring(3, 5));
		return mins;
	}

	function extraeSeg(hora) {
		var segs = parseInt(hora.substring(6, 8));
		return segs;
	}

	function concatHoraMin(idControlHrs, idControlMins) {
		var hora = $("#" + idControlHrs + " option:selected").html() + ":" + $("#" + idControlMins + " option:selected").html();
		return hora;
	}

	function frecuencia(idControlSegs) {
		var seg = $("#" + idControlSegs + " option:selected").html();
		return seg;
	}

	function limpiaCampos() {
		inicializaForma('formaGenerica', 'empresaID');
		$('#empresaID').focus();
		$('#topologia1').attr('checked', true);
		$('#prioridad1').attr('checked', true);
		$('#horarioInicioHrs').val($('option:first', $('#horarioInicioHrs')).val());
		$('#horarioInicioMins').val($('option:first', $('#horarioInicioMins')).val());
		$('#horarioFinHrs').val($('option:first', $('#horarioFinHrs')).val());
		$('#horarioFinMins').val($('option:first', $('#horarioFinMins')).val());
		$('#horarioFinVenHrs').val($('option:first', $('#horarioFinVenHrs')).val());
		$('#horarioFinVenMnis').val($('option:first', $('#horarioFinVenMnis')).val());
		$('#frecuenciaEnMins').val($('option:first', $('#frecuenciaEnMins')).val());
		$('#intentosMaxEnvio').val('');
	}

	function funcionExitoParametrosSpei() {

		limpiaCampos();
		$('#monMaxSpeiBcaMovil').val('');
		$('#montoMinimoBloq').val('');
		deshabilitaBoton('modificar');

	}

	function funcionErrorParametrosSpei() {}

	function ocultarCampos(tipo) {
		var bloqueo = 'B';
		var bancaMovil = 'M';
		var iniciaForma = 'I';

		var STP = 'ST';
		var correo = 'C';
		var correoBanxico = 'CB';
		
		var contenedorSPEI = 'SPEI';
		
		if (tipo == contenedorSPEI) {
			$('#contenedorSPEI').hide();
			return;
		}

		if (tipo == STP) {
			$('.topologia').hide();
			$('.urlWS').show();
			$('.usuarioContraseniaWS').show();
			$('.urlWSPF').show();
			$('.urlWSPM').show();
			
			
			$('.saldoMinimoCuentaSTP').show();
			$('.rutaKeystoreStp').show();
			$('.aliasCertificadoStp').show();
			$('.passwordKeystoreStp').show();
			$('.empresaSTP').show();
		}
		

		if (tipo == correo) {
			$('.correoNotificacion').hide();
			$('.remitenteID').hide();
		}

		if (tipo == correoBanxico) {
			$('.notificacionesCorreo').hide();
			$('.correoNotificacion').hide();
			$('.remitenteID').hide();
			$('.intentosMaxEnvio').hide();
			$('.urlWSPF').hide();
			$('.urlWSPM').hide();
		}

		if (tipo == bloqueo) {
			$('#lblMontoMinimoBloq').hide();
			$('#montoMinimoBloq').hide();
		}
		if (tipo == bancaMovil) {
			$('#lblMonMaxSpeiBcaMovil').hide();
			$('#monMaxSpeiBcaMovil').hide();
		}
		if (tipo == iniciaForma) {
			$('#lblMontoMinimoBloq').hide();
			$('#montoMinimoBloq').hide();
			$('#lblMonMaxSpeiBcaMovil').hide();
			$('#monMaxSpeiBcaMovil').hide();
		}
	}

	function mostrarCampos(tipo) {
		var bloqueo = 'B';
		var bancaMovil = 'M';
		var banxico = 'BA';
		var correo = 'C';
		var correoSTP = 'CSTP';
		var contenedorSPEI = 'SPEI';
		
		if (tipo == contenedorSPEI) {
			$('#contenedorSPEI').show();
			return;
		}

		if (tipo == banxico) {
			$('.topologia').show();
			$('.urlWS').hide();
			$('.usuarioContraseniaWS').hide();
			$('.saldoMinimoCuentaSTP').hide();
			$('.rutaKeystoreStp').hide();
			$('.aliasCertificadoStp').hide();
			$('.passwordKeystoreStp').hide();
			$('.empresaSTP').hide();
		}

		if (tipo == correo) {
			$('.correoNotificacion').show();
			$('.remitenteID').show();
		}

		if (tipo == correoSTP) {
			$('#notificacion1').attr('checked', true);
			$('.notificacionesCorreo').show();
			$('.correoNotificacion').show();
			$('.remitenteID').show();
			$('.intentosMaxEnvio').show();
		}

		if (tipo == bloqueo) {
			$('#lblMontoMinimoBloq').show();
			$('#montoMinimoBloq').show();
		}
		if (tipo == bancaMovil) {
			$('#lblMonMaxSpeiBcaMovil').show();
			$('#monMaxSpeiBcaMovil').show();
		}
	}

	function validarCampos() {
		var montoMinimoBloq = $('#montoMinimoBloq').asNumber();
		var monMaxSpeiBcaMovil = $('#monMaxSpeiBcaMovil').asNumber();
		
		if ($('input[name=bloqueoRecepcion]:checked').val() == 'S') {
			if (montoMinimoBloq == 0) {
				$('#montoMinimoBloq').val("0.00");
				mensajeSis('El Monto de Bloqueo por Recepción de SPEI no puede ser Cero');
				setTimeout("$('#montoMinimoBloq').focus()", 50);
			}
		}
		if ($('input[name=participaPagoMovil]:checked').val() == 'S') {
			if (monMaxSpeiBcaMovil == 0) {
				$('#monMaxSpeiBcaMovil').val("0.00");
				mensajeSis('El Monto Máximo SPEI Banca Móvil no puede ser Cero');
				setTimeout("$('#monMaxSpeiBcaMovil').focus()", 50);
			}
		}
	}

	function soloNumeros(e) {
		var key = window.Event ? e.which : e.keyCode
		return (key >= 48 && key <= 57)
	}

	function validarCorreo() {
		if ($('#Tipo1').is(':checked')) {
			if ($('#notificacion2').is(':checked')) {
				$('#correoNotificacion').val('');
				$('#remitenteID').val(0);
			}
		}

		if ($('#Tipo2').is(':checked')) {
			$('#notificacion2').attr('checked', true);
			$('#correoNotificacion').val('');
			$('#remitenteID').val(0);
		}
		
	}

	function ayudausuario(){	
		var data;	       
		data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
				'<div id="ContenedorAyuda">'+ 
					'<legend class="ui-widget ui-widget-header ui-corner-all">Usuario y contraseña del WS :</legend>'+
					'<label>' +
					'Usuario y contraseña encriptadas en base 64.<br>' +
					'El formato debe ser el siguiente: usuario:password' +
					'</label>' +
					'<hr>' +
					'<label>' +
					'Ejemplo: dXN1YXJpbzpjb250cmFzZW5pYQ==' + 
					'</label>' +
				'</div>'+
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
