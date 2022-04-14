$(document).ready(function() {
	esTab = false;

	//Definicion de Constantes y Enums
	var catTipoTransaccionTipoCuenta = {
  		'agrega':'1',
  		'modifica':'2',
	};

	var catTipoConsultaTipoCuenta = {
  		'principal':1,
  		'foranea':2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	$('#clasificacionContaV').attr('checked', true);
	$('#clasificacionContaA').attr('checked', false);
	$('#clasificacionConta').val("V");
	$('#limAbonosMensuales').val("");
	$('#abonosMenHasta').val("0");
	$('#perAboAdi').val("");
	$('#aboAdiHas').val("0");
	$('#limSaldoCuenta').val("");
	$('#saldoHasta').val("0");
	$('#tdAbonosMenHastaLbl').hide();
	$('#tdAbonosMenHastaText').hide();
	$('#trPerAboAdi').hide();
	$('#tdSaldoHastaLbl').hide();
	$('#tdSaldoHastaText').hide();
	$('#tipoCuentaID').focus();
	$('#participaSpei').val('N');
	$('#cobraSpei').val('N');
	$('#chkEnvioSMSRetiro').attr('checked', false);
	$('#depositoActivaNO').attr('checked', true);
	$('#envioSMSRetiro').val('N');
	$('#montoMinSMSRetiro').val(0.00);
	deshabilitaControl('comSpeiPerFis');
	deshabilitaControl('comSpeiPerMor');
	consultaMoneda();
	validaCampoHuella();
	consultaNivelesCta();
	$('#notificaSms').attr('checked', false);
	$('#notificaSms2').attr('checked', true);
	$('#plantillaLbl').hide();
	$('#plantillaFields').hide();
	$('#plantillaID').val('0');
	$('#plantillaDes').val('');
	$('#comisionSalProm').val(0.00);
	$('#saldoPromMinReq').val(0.00);
	$('#exentaCobroSalPromOtros').val('N');

	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) {
      	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje',
										'true', 'tipoCuentaID', 'funcionExitoTipCta','funcionFalloTipCta');
      }
   });

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionTipoCuenta.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionTipoCuenta.modifica);
	});

	$('#agrega').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');

	$('#tipoCuentaID').blur(function() {
  		validaTipoCuenta(this.id);
	});

	$('#tipoCuentaID').bind('keyup',function(e){
		if(this.value.length >= 3){
			lista('tipoCuentaID', '3', '8', 'descripcion', $('#tipoCuentaID').val(), 'listaTiposCuenta.htm');
		}
	});

	$('#clasificacionContaV').click(function() {
		$('#clasificacionContaV').attr('checked', true);
		$('#clasificacionContaA').attr('checked', false);
		$('#clasificacionConta').val("V");
		$('#clasificacionContaV').focus();
	});

	$('#clasificacionContaA').click(function() {
		$('#clasificacionContaA').attr('checked', true);
		$('#clasificacionContaV').attr('checked', false);
		$('#clasificacionConta').val("A");
		$('#clasificacionContaA').focus();
	});



	$('#participaSpei').change(function() {
		if($('#participaSpei').val() == 'S'){
			habilitaControl('cobraSpei');

		}else{
			deshabilitaControl('cobraSpei');
			deshabilitaControl('comSpeiPerFis');
			deshabilitaControl('comSpeiPerMor');
			$('#cobraSpei').val('N').selected = true;
			$('#comSpeiPerFis').val('');
			$('#comSpeiPerMor').val('');

		}

	});


	$('#cobraSpei').change(function() {
		if($('#participaSpei').val() == 'S' && $('#cobraSpei').val() == 'S'){
			habilitaControl('comSpeiPerFis');
			habilitaControl('comSpeiPerMor');

		}else{
			deshabilitaControl('comSpeiPerFis');
			deshabilitaControl('comSpeiPerMor');
			$('#comSpeiPerFis').val('');
			$('#comSpeiPerMor').val('');

		}

	});

	$('#comSpeiPerFis').blur(function() {
		if($('#comSpeiPerFis').asNumber() == ''  && $('#cobraSpei').val() == 'S'
			&& $('#tipoCuentaID').val() != ''){
		mensajeSis("El Monto de Comisión Persona Física debe ser mayor a Cero");
		$('#comSpeiPerFis').focus();
		$('#comSpeiPerFis').val('');
	}
	});

	$('#comSpeiPerMor').blur(function() {
				if($('#comSpeiPerMor').asNumber() == '' && $('#cobraSpei').val() == 'S'
					&& $('#tipoCuentaID').val() != ''){
				mensajeSis("El Monto de Comisión Persona Moral debe ser mayor a Cero");
				$('#comSpeiPerMor').focus();
				$('#comSpeiPerMor').val('');
			}


	});

	$('#fechaInscripcion').change(function() {
		var Yfecha= $('#fechaInscripcion').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaInscripcion').val(parametroBean.fechaSucursal);
			}
				if($('#fechaInscripcion').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inscripcion  es Mayor a la Fecha del Sistema.");
					$('#fechaInscripcion').val(parametroBean.fechaSucursal);
				}

		}else{
			$('#fechaInscripcion').val(parametroBean.fechaSucursal);
		}

	});

	/*==== Funcion valida fecha formato (yyyy-MM-dd) =====*/
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
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

	$('#notificaSms').click(function() {
		$('#plantillaLbl').show();
		$('#plantillaFields').show();
		$('#plantillaID').val('');
		$('#plantillaDes').val('');
	});

	$('#notificaSms2').click(function() {
		$('#plantillaLbl').hide();
		$('#plantillaFields').hide();
		$('#plantillaID').val('0');
		$('#plantillaDes').val('');
	});

	$('#plantillaID').blur(function(){
		validaPlantilla(this.id);
	});

	$('#plantillaID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			//camposLista[0] = "plantillaID";
			camposLista[0] = "nombre";
			parametrosLista[0] = $('#plantillaID').val();
			listaAlfanumerica('plantillaID', '1', '1', camposLista, parametrosLista, 'listaPlantilla.htm');
		}
	});



	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			monedaID 		: 	'required',
			descripcion		:  {
				required 	: 	true,
				minlength	: 	5
			},
			abreviacion 	:  {
				required 	: 	true,
				maxlength	: 	10
			},
			generaInteres 	: 	'required',
			esServicio  	:	'required',
			esBancaria 		: 	'required',
			minimoApertura: {
				required: true,
				number: true,
				minlength: 1
			},
			plantillaID: {
				required: true,
				number: true
			},
			comApertura: {
				required: true,
				number: true,
				minlength: 1
			},
			comManejoCta: {
				required: true,
				number: true,
				minlength: 1
			},
			comAnirvesario : {
				required: true,
				number: true,
				minlength: 1
			},
			cobraBanEle  : 'required',
			cobraSpei    : 'required',
			comFalsoCobro : {
				required: true,
				number: true,
				minlength: 1
			},
			ExPrimDispSeg  : 'required',
			ComDispSeg: {
				required: true,
				number: true,
				minlength: 1
			},
			tipoPersona: {
				required :true
			},
			esBloqueoAuto: {
				required: true
			},
			comSpeiPerFis: {
				required : function() {return $('#cobraSpei').val() == 'S'}
			},
			comSpeiPerMor: {
				required : function() {return $('#cobraSpei').val() == 'S'}
			},
			direccionOficial:{
				required: true
			},
			idenOficial:{
				required: true
			},
			conCuenta:{
				required: true
			},
			checkListExpFisico:{
				required: true
			},
			relacionadoCuenta:{
				required: true
			},
			registroFirmas:{
				required: true
			},
			limAbonosMensuales:{
				required: true
			},
			perAboAdi: {
				required : function() {return $('#limAbonosMensuales').val() == 'S';}
			},
			limSaldoCuenta:{
				required: true
			},
			numRegistroRECA: {
				maxlength: 100
			},
			fechaInscripcion:{
				date : true
			},
			claveCNBV : {
							soloAlfanumerico : $('#claveCNBV').val()
						},
			envioSMSRetiro: {
				required: true
			},
			montoMinSMSRetiro: {
				required: true,
				number: true,
				min: 0
			},
			estadoCivil:{
				required: true
			},
			montoDepositoActiva: {
				required: function() {return $('#depositoActivaSI').is(':checked');},
				number: function() {return $('#depositoActivaSI').is(':checked');},

			}
		},

		messages: {
			monedaID		: 'Especifique Tipo de Moneda.',
			descripcion		: {
				required	: 'Especifique la Descripción.',
				minlength: 'Mínimo 5 Caracteres.'
			},
			abreviacion		:{
				required	: 'Especifique la Descripción.',
				maxlength: 'Máximo 10 Caracteres.'
			},
			generaInteres: 'Especifique Si Genera Intereses.',
			esServicio: 'Especifique si es Cuenta de servicio.',
			esBancaria : 'Especifique  si es Cuenta Bancaria.',
			minimoApertura: {
				required: 'Especifique el Mínimo para Apertura.',
				number: 'Solo Números.',
				minlength: 'Especifique una Cantidad.'
			},
			plantillaID: {
				required: 'Especifique una Plantilla.',
				number: 'Solo Números.'
			},
			comApertura: {
				required: 'Especifique Comisión.',
				number: 'Solo Números.',
				minlength: 'Especifique una Cantidad.'
			},
			comManejoCta: {
				required: 'Especifique Comisión.',
				number: 'Solo Números.',
				minlength: 'Especifique una Cantidad.'
			},
			comAnirvesario : {
				required: 'Especifique Comisión.',
				number: 'Solo Números.',
				minlength: 'Especifique una Cantidad.'
			},
			cobraBanEle  : 'Especifique si Cobra Comisión.',
			cobraSpei    : 'Especifique si Cobra SPEI.',
			comFalsoCobro : {
				required: 'Especifique Comisión.',
				number: 'Solo Números.',
				minlength: 'Especifique una Cantidad.'
			},
			ExPrimDispSeg   : 'Especifique si Cobra Comisión.',
			ComDispSeg: {
				required: 'Especifique Comisión',
				number: 'Solo Números.',
				minlength: 'Especifique una Cantidad.'
			},
			tipoPersona:{
				required: 'Especifique el Tipo de Persona.'
			},
			esBloqueoAuto: {
				required: 'Especifique si es Bloqueo Automático.'
			},
			comSpeiPerFis: {
				required: 'Especifique Comisión Persona Física.'
			},
			comSpeiPerMor: {
				required: 'Especifique Comisión Persona Moral.'
			},
			direccionOficial:{
				required: 'Especifique Si Valida Dirección Oficial.'
			},
			idenOficial:{
				required: 'Especifique Si Valida Identificación Oficial.'
			},
			conCuenta:{
				required: 'Especifique Si valida Conocimiento de Cte. y Cta.'
			},
			checkListExpFisico:{
				required: 'Especifique Si Requiere CheckList.'
			},
			relacionadoCuenta:{
				required: 'Especifique Si Valida Relacionado Cuenta.'
			},
			registroFirmas:{
				required: 'Especifique Si Valida Registro Firmas.'
			},

			limAbonosMensuales:{
				required: 'Especifique Si Limita Abonos Mensuales.'
			},
			perAboAdi: {
				required: 'Especifique Si Permite Abonos Adicionales.'
			},
			limSaldoCuenta:{
				required: 'Especifique Si Limita Saldo Cuenta.'
			},
			numRegistroRECA: {
				maxlength: 'Máximo 100 Caracteres.'
			},
			fechaInscripcion:{
				date : 'Fecha Incorrecta.'
			},
			envioSMSRetiro: {
				required: 'Especifique habilitado de envios SMS'
			},
			montoMinSMSRetiro: {
				required: 'Especifique monto mínimo',
				number: 'Solo números',
				min: 'Solo números positivos'
			},
			estadoCivil:{
				required: 'Especifique Si Valida Estado Civil.'
			},
			montoDepositoActiva: {
				required: 'Especifique Monto para Activación Cta.',
				number: 'Solo números',

			}
		}
	});


	jQuery.validator.addMethod("soloAlfanumerico", function(value, element) {
  		return this.optional( element ) || /^[a-zA-Z0-9]*$/.test( value );
	}, "No se permiten caracteres especiales");

	//------------------------------NUEVAS VALIDACIONES---------------//
	//------ limite abonos mensuales--------

	$('#limAbonosMensuales').blur(function() {
		if ($('#limAbonosMensuales option:selected').text() == "SI") {
			$('#tdAbonosMenHastaLbl').show();
			$('#tdAbonosMenHastaText').show();
			$('#trPerAboAdi').show();


			$('#tdAboAdiHasLbl').hide();
			$('#tdAboAdiHasText').hide();

		} else {
			$('#tdAbonosMenHastaLbl').hide();
			$('#tdAbonosMenHastaText').hide();
			$('#trPerAboAdi').hide();
			$('#perAboAdi').val("");
			$('#aboAdiHas').val("0");
		}
	});

	$('#perAboAdi').blur(function() {
		if ($('#perAboAdi option:selected').text() == "SI") {
			$('#tdAboAdiHasLbl').show();
			$('#tdAboAdiHasText').show();

		} else {
			$('#tdAboAdiHasLbl').hide();
			$('#tdAboAdiHasText').hide();
		}
	});

	$('#limSaldoCuenta').blur(function() {
		if ($('#limSaldoCuenta option:selected')
				.text() == "SI") {
			$('#tdSaldoHastaLbl').show();
			$('#tdSaldoHastaText').show();

		} else {
			$('#tdSaldoHastaLbl').hide();
			$('#tdSaldoHastaText').hide();
		}
	});

	$('#limAbonosMensuales').change(function() {
		if($('#limAbonosMensuales option:selected').text()=="SI"){
			$('#tdAbonosMenHastaLbl').show();
			$('#tdAbonosMenHastaText').show();
			$('#trPerAboAdi').show();
			$('#tdAboAdiHasLbl').hide();
			$('#tdAboAdiHasText').hide();
			$('#abonosMenHasta').val('0');
			$('#abonosMenHasta').rules("add", {
			     required: function() {if ($('#limAbonosMensuales').val()=='S')return true;else $('#abonosMenHasta').rules("remove");},
			     min : 1,
			messages: {
				required: 'Especifique valor',
				min: 'El valor debe ser mayor a 0'
				}
			});

		}else{
			$('#tdAbonosMenHastaLbl').hide();
			$('#tdAbonosMenHastaText').hide();
			$('#trPerAboAdi').hide();
			$('#perAboAdi').val("");
			$('#aboAdiHas').val("0");

		}
		});

	$('#perAboAdi').change(function() {
		if ($('#perAboAdi option:selected').text() == "SI") {
			$('#tdAboAdiHasLbl').show();
			$('#tdAboAdiHasText').show();
			$('#aboAdiHas').val('0');
			$('#aboAdiHas').rules("add", {
				required : function() {
					if ($('#perAboAdi').val() == 'S')
						return true;
					else
						$('#aboAdiHas').rules("remove");
				},
				min : 1,
				messages : {
					required : 'Especifique valor',
					min : 'El valor debe ser mayor a 0'
				}
			});

		} else {
			$('#tdAboAdiHasLbl').hide();
			$('#tdAboAdiHasText').hide();
		}
	});

	$('#limSaldoCuenta').change(function() {
		if($('#limSaldoCuenta option:selected').text()=="SI"){
			$('#tdSaldoHastaLbl').show();
			$('#tdSaldoHastaText').show();
			$('#saldoHasta').val('0');
			$('#saldoHasta').rules("add", {
			     required: function() {if ($('#limSaldoCuenta').val()=='S')return true;else $('#saldoHasta').rules("remove");},
			     min : 1,
			messages: {
				required: 'Especifique valor',
				min: 'El valor debe ser mayor a 0'
				}
			});

		}
		else{
			$('#tdSaldoHastaLbl').hide();
			$('#tdSaldoHastaText').hide();
		}
	});

	$('#depositoActivaSI').click(function() {
		if($('#depositoActivaSI').is(':checked')){
			$('#tdLblMontoDepositoActiva').show();
			$('#tdMontoDepositoActiva').show();
			$('#montoDepositoActiva').val('0.00');
		}
	});

	$('#depositoActivaNO').click(function() {
		if($('#depositoActivaNO').is(':checked')){
			$('#tdLblMontoDepositoActiva').hide();
			$('#tdMontoDepositoActiva').hide();
			$('#montoDepositoActiva').val('0.00');
		}
	});

	$('#montoDepositoActiva').blur(function() {
		if(esTab){
			if($('#depositoActivaSI').is(':checked')){
				if($('#montoDepositoActiva').asNumber() <= 0 && $('#montoDepositoActiva').val() != ''){
					mensajeSis('El Monto para Activación Cta debe ser Mayor a Cero.');
					$('#montoDepositoActiva').val('0.00');
					$('#montoDepositoActiva').focus();
				}
			}
		}
	});
	//---------------------FIN NUEVAS VALIDACIONES----------------------------//

	//------------ Validaciones de Controles -------------------------------------
	function validaTipoCuenta(control) {
		var numCta = $('#tipoCuentaID').val();
		var TipoCuentaBeanCon = {
  			'tipoCuentaID':numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCta != '' && !isNaN(numCta) && esTab){
			if(numCta=='0'){
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','tipoCuentaID');
				$('#tipoPersona').val('');
				$('#clasificacionContaV').attr('checked', true);
				$('#clasificacionContaA').attr('checked', false);
				$('#clasificacionConta').val("V");
				$('#participaSpei').val('N');
				$('#cobraSpei').val('N');

				$('#fechaInscripcion').val("");
				$('#conCuenta').val("");
				$('#checkListExpFisico').val("");
				$('#relacionadoCuenta').val("");
				$('#registroFirmas').val("");
				$('#estadoCivil').val("");
				$('#huellasFirmante').val("N");
				$('#limAbonosMensuales').val("");
				$('#abonosMenHasta').val("0");
				$('#tdAbonosMenHastaLbl').hide();
				$('#tdAbonosMenHastaText').hide();
				$('#trPerAboAdi').hide();
				$('#perAboAdi').val("");
				$('#aboAdiHas').val("0");
				$('#limSaldoCuenta').val("");
				$('#saldoHasta').val("0");
				$('#tdSaldoHastaLbl').hide();
				$('#tdSaldoHastaText').hide();
				$('#claveCNBV').val("");
				$('#chkEnvioSMSRetiro').attr('checked', false);
				$('#envioSMSRetiro').val('N');
				$('#montoMinSMSRetiro').val(0.00);
				deshabilitaControl('comSpeiPerFis');
				deshabilitaControl('comSpeiPerMor');
				inicializaCampos();
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				tiposCuentaServicio.consulta(1, TipoCuentaBeanCon,function(tipoCuenta) {
					if(tipoCuenta!=null){
						dwr.util.setValues(tipoCuenta);

						var tipoPersonas = tipoCuenta.tipoPersona;
						consultaTipoPersona(tipoPersonas);

						$('#monedaID').val(tipoCuenta.monedaID).selected = true;

						if($('#participaSpei').val() == 'S'){
							habilitaControl('cobraSpei');
						 }else{
							deshabilitaControl('cobraSpei');

						}

						if($('#cobraSpei').val() == 'S'){
							habilitaControl('comSpeiPerFis');
							habilitaControl('comSpeiPerMor');
						}else{
							deshabilitaControl('comSpeiPerFis');
							deshabilitaControl('comSpeiPerMor');

						}

						if(tipoCuenta.fechaInscripcion=='1900-01-01'){
							$('#fechaInscripcion').val("");

						}else{
							$('#fechaInscripcion').val(tipoCuenta.fechaInscripcion);
						}

						if(tipoCuenta.clasificacionConta=='V'){
							$('#clasificacionContaA').attr('checked', false);
							$('#clasificacionContaV').attr('checked', true);
							$('#clasificacionConta').val("V");
						}else{
							$('#clasificacionContaA').attr('checked', true);
							$('#clasificacionContaV').attr('checked', false);
							$('#clasificacionConta').val("A");
						}

						$('#tipoInteres').val(tipoCuenta.tipoInteres).checked = true;
						if(tipoCuenta.tipoInteres=='D'){
							$('#tipoInteresD').attr("checked","1") ;
						}else{
							if(tipoCuenta.tipoInteres=='M'){
								$('#tipoInteresM').attr("checked","1") ;
							}
							if(tipoCuenta.esBancaria=='S'){
								$('#EsBancaria').val('S').selected = true;
							}
							if(tipoCuenta.esBancaria=='N'){
								$('#EsBancaria').val('N').selected = true;
							}
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
						}

						//------------------------------NUEVAS VALIDACIONES---------------//

						if($('#limAbonosMensuales option:selected').text()=="SI"){
							$('#tdAbonosMenHastaLbl').show();
							$('#tdAbonosMenHastaText').show();
							$('#trPerAboAdi').show();

						} else {
							$('#tdAbonosMenHastaLbl').hide();
							$('#tdAbonosMenHastaText').hide();
							$('#trPerAboAdi').hide();
							$('#perAboAdi').val("");
							$('#aboAdiHas').val("0");

						}

						if($('#perAboAdi option:selected').text()=="SI"){
							$('#tdAboAdiHasLbl').show();
							$('#tdAboAdiHasText').show();
						 }
						 else{
							$('#tdAboAdiHasLbl').hide();
							$('#tdAboAdiHasText').hide();
						 }

						if($('#limSaldoCuenta option:selected').text()=="SI"){
							$('#tdSaldoHastaLbl').show();
							$('#tdSaldoHastaText').show();

						} else {
							$('#tdSaldoHastaLbl').hide();
							$('#tdSaldoHastaText').hide();
						}
						if ($('#envioSMSRetiro').val() == 'S') {
							$('#chkEnvioSMSRetiro').attr('checked', true);
						} else {
							$('#chkEnvioSMSRetiro').attr('checked', false);
						}
						if (tipoCuenta.notificaSms == 'S'){
							$('#notificaSms').attr('checked', true);
							$('#notificaSms2').attr('checked', false);
							$('#plantillaLbl').show();
							$('#plantillaFields').show();
							validaPlantilla('plantillaID');
						}else{
							$('#notificaSms').attr('checked', false);
							$('#notificaSms2').attr('checked', true);
							$('#plantillaLbl').hide();
							$('#plantillaFields').hide();
						}
						if (tipoCuenta.estatus == 'I'){
							mensajeSis("El Producto "+ tipoCuenta.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
							$('#tipoCuentaID').focus();
							deshabilitaBoton('modifica', 'submit');
						}
						if(tipoCuenta.depositoActiva == 'S'){
							$('#depositoActivaSI').attr('checked', true);
							$('#tdLblMontoDepositoActiva').show();
							$('#tdMontoDepositoActiva').show();
							$('#montoDepositoActiva').val(tipoCuenta.montoDepositoActiva);
						}else{
							$('#depositoActivaNO').attr('checked', true);
							$('#tdLblMontoDepositoActiva').hide();
							$('#tdMontoDepositoActiva').hide();
							$('#montoDepositoActiva').val('0.00');
						}
					}else{
						limpiaForm($('#formaGenerica'));
						mensajeSis("No Existe el Tipo de Cuenta.");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						inicializaCampos();
						$('#tipoCuentaID').focus();
						$('#tipoCuentaID').select();
					}
					agregaFormatoControles('formaGenerica');
				});
			}
		}
	}

function validaCampoHuella() {
	var numEmpresaID = 1;
	var tipoCon = 1;
	var ParametrosSisBean = {
			'empresaID'	:numEmpresaID
	};
	if (numEmpresaID != '' && !isNaN(numEmpresaID)) {

			parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
				if(parametrosSisBean.funcionHuella == 'S'){

					if(parametrosSisBean.reqhuellaProductos == 'S'){
						$('#reqHuella').show();
						$('#etiHuella').show();
						$('#sepHuella').show();
						$('#trHuella').show();
						$('#huellasFirmante').val('N');
					}

				}else {
					$('#trHuella').hide();
					$('#huellasFirmante').val("");
				}
			});
	}
}

	function consultaTipoPersona(tipoPersonas) {
		var tipo= tipoPersonas.split(',');
		var tamanio = tipo.length;
		for (var i=0;i< tamanio;i++) {
			var tip = tipo[i];
			var jqTipoPersona = eval("'#tipoPersona option[value="+tip+"]'");
			$(jqTipoPersona).attr("selected","selected");
		}
	}


	function consultaMoneda() {
  			dwr.util.removeAllOptions('monedaID');

			dwr.util.addOptions('monedaID', {"":'SELECCIONAR'});
			monedasServicio.listaCombo(3, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
			});
	}

	$('#chkEnvioSMSRetiro').change(function () {
		if ($(this).is(':checked')) {
			$('#envioSMSRetiro').val('S');
		} else {
			$('#envioSMSRetiro').val('N');
		}
	});

	$('#envioSMSRetiro').change(function () {
		if ($(this).val() == 'S') {
			$('#chkEnvioSMSRetiro').attr('checked', true);
		} else {
			$('#chkEnvioSMSRetiro').attr('checked', false);
		}
	});
});

function validaDigitos(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46){
		if (key==8|| key == 46 || key == 0){
			return true;
		}
		else
  		return false;
	}
}

function validaDigitosConNegat(e,campo){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46){
		if (key==8|| key == 46 || key == 0 || key == 45){
			if(e.target.value.toUpperCase().indexOf('-')>=0 && e.key.toUpperCase() === '-')
			  {
			      e.preventDefault();
			    }
			return true;
		}
		else
  		return false;
	}
}

function funcionExitoTipCta() {
	inicializaForma('formaGenerica', 'tipoCuentaID');
	$('#limAbonosMensuales').val("");
	$('#perAboAdi').val("");
	$('#limSaldoCuenta').val("");
	$('#abonosMenHasta').val("0");
	$('#aboAdiHas').val("0");
	$('#saldoHasta').val("0");
	$('#tdAbonosMenHastaLbl').hide();
	$('#tdAbonosMenHastaText').hide();
	$('#trPerAboAdi').hide();
	$('#tdSaldoHastaLbl').hide();
	$('#tdSaldoHastaText').hide();
	$('#fechaInscripcion').val("");
	$('#chkEnvioSMSRetiro').attr('checked', false);
	$('#envioSMSRetiro').val('N');
	$('#montoMinSMSRetiro').val(0.00);

	inicializaCampos();
}

function funcionFalloTipCta() {
}

// funcion para cargar combo Niveles de Cuenta
function consultaNivelesCta() {
	var tipoCon = 1;
	dwr.util.removeAllOptions('nivelCtaID');
	catalogoNivelesServicio.listaCombo(tipoCon, function(niveles) {
		dwr.util.addOptions('nivelCtaID', niveles, 'nivelID', 'descripcion');
	});
}

// **********   funcion para inicializar combos y multiselect ***** //
function inicializaCampos(){
	$('#monedaID').val('');
	$('#clasificacionContaV').attr('checked', true);
	$('#clasificacionContaA').attr('checked', false);
	$('#tipoInteresD').attr('checked', true);
	$('#tipoInteresM').attr('checked', false);
	$("#esBloqueoAuto option[value='']").attr("selected",true);
	$("#nivelCtaID option[value=1]").attr("selected",true);
	$("#tipoPersona").attr("selected",false);
	$("#direccionOficial option[value='']").attr("selected",true);
	$("#idenOficial option[value='']").attr("selected",true);
	habilitaControl('cobraSpei');
	$('#participaSpei').val('N');
	$('#cobraSpei').val('N');
	$('#tipoPersona').val('');

	$('#conCuenta').val("");
	$('#checkListExpFisico').val("");
	$('#relacionadoCuenta').val("");
	$('#registroFirmas').val("");
	$('#estadoCivil').val("");
	$('#huellasFirmante').val("N");
	$('#chkEnvioSMSRetiro').attr('checked', false);
	$('#envioSMSRetiro').val('N');
	$('#montoMinSMSRetiro').val(0.00);
	$('#notificaSms').attr('checked', false);
	$('#notificaSms2').attr('checked', true);
	$('#plantillaLbl').hide();
	$('#plantillaFields').hide();
	$('#plantillaID').val('0');
	$('#plantillaDes').val('');
	$('#comisionSalProm').val(0.00);
	$('#saldoPromMinReq').val(0.00);
	$('#exentaCobroSalPromOtros').val('N');
	$('#depositoActivaNO').attr('checked', true);
	$('#tdLblMontoDepositoActiva').hide();
	$('#tdMontoDepositoActiva').hide();
	$('#montoDepositoActiva').val('0.00');
}
function deshabilitaDireccionIdentificacion(){// avelasco temporal 10dic2015
	$("#direccionOficial").attr("disabled",true);
	$("#direccionOficial option[value=S]").attr("selected",true);
	$("#idenOficial").attr("disabled",true);
	$("#idenOficial option[value=S]").attr("selected",true);
}

function mostrarAyudaSMSRetiros(){
	var data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
	'<div id="ContenedorAyuda">'+
	'<legend class="ui-widget ui-widget-header ui-corner-all">Alertas SMS en Retiros:</legend>'+
	'<label>' +
	'Opción para habilitar y deshabilitar el envío de SMS en retiros de ventanilla.' +
	'</label>' +
	'<hr>' +
	'<label>' +
	'El envío de SMS aplica para las opciones: Retiro de Efectivo, Transferencia entre cuentas, Transferencia interna, Desembolso de crédito, Pago de Servicios en Línea y SPEI' +
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

function validaPlantilla(idControl){
	var jqCampania  = eval("'#" + idControl + "'");
	var numPlantilla = $(jqCampania).val();

	if( numPlantilla != '' && !isNaN(numPlantilla)){
		var tipoConsulta = 1;
		var plantillaBean = {
		'plantillaID' :	$('#plantillaID').val()};
		smsPlantillaServicio.consulta(tipoConsulta, plantillaBean, function(plantilla){
			if(plantilla != null){
				$('#plantillaDes').val(plantilla.nombre);
			}else{
				mensajeSis("Plantilla no Encontrada");
				$('#plantillaID').val('');
				$('#plantillaID').focus();
				$('#plantillaDes').val('');
			}
		});
	}
}
