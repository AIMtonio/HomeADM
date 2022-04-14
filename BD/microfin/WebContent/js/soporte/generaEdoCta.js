$(document).ready(function() {
	esTab = true;
	
	deshabilitaBoton('timbrado', 'submit');
	deshabilitaBoton('cadena', 'submit');
	
	var parametroBean = consultaParametrosSession();      
	var fechaSucursal =parametroBean.fechaSucursal;  
	var mesSucursal = fechaSucursal.substr(5,2);
	var anioSucursal = fechaSucursal.substr(0,4);
	
	var catTipoConEdoCta= {
		'conRangos'	:	3,
		'infoCte'	:	1,
		'edoCtaGen'	:	4
	};
	
	var catTipoGeneracion= {
		'mensual'	:	'M',
		'semestral'	:	'S'
	};
	
	var catNumMes= {
		'enero'		:	1,
		'junio'		:	6,
		'julio'		:	7,
		'diciembre'	:	12
	};
	
	var catNumSemestre= {
		'primerSemestre'	:	1,
		'segundoSemestre'	:	2
	};

	var catTipoTransaccionInstitucion = {
	  		'principal':'1',
	  		'crediclub':'2', 
	  		'crediclubGenCadenas' : '3',
	  		'crediclubTrimbrado' : '4'
	};
	
	var instCrediclub = 'CREDICLUB';
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$(':text').focus(function() {	
	 	esTab = false;
	});
   
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	agregaFormatoControles('formaGenerica');
	llenarAnio();
	llenarMes();
	consultaInstitucion();
	llenarAnioSemestre();
	validaParametros();
	$("#sucursalInicio").focus();
	$('#tipoGeneracion').val('M');
	$("#tipoGeneracionM").attr("checked",true);
	$('#generacionMensual').show();

	
	$('#sucursal').val(parametroBean.sucursal);
	$('#sucursalInicio').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalInicio', '2', '1', 'nombreSucurs', $('#sucursalInicio').val(), 'listaSucursales.htm');
	});
		
	$('#sucursalInicio').blur(function() {
		var sucFin = $('#sucursalFin').val();
		if (sucFin != '' && !isNaN(sucFin) ){
			if (parseInt(this.value) > parseInt(sucFin) ){
				alert('La Sucursal Inicio debe Ser Menor o Igual a la Sucursal Fin');
				$(this).val('');
				$('#descsucursalInicio').val('');				
				$(this).focus();
			}
		}
		validaSucursalInicio(this.id);
	});
	
	$('#sucursalFin').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalFin', '2', '1', 'nombreSucurs', $('#sucursalFin').val(), 'listaSucursales.htm');
	});
		
	$('#sucursalFin').blur(function() {
		var sucIni = $('#sucursalInicio').val();
		if (sucIni != '' && !isNaN(sucIni) ){
			if (parseInt(sucIni) > parseInt(this.value) ){
				alert('La Sucursal Fin debe Ser Mayor o Igual a la Sucursal Inicio');
				$(this).val('');
				$('#descsucursalFin').val('');				
				$(this).focus();
			}
		}
		validaSucursalFin(this.id);
	});
	// se selecciona el mes actual
	$('#mes').val(mesSucursal).selected = true;
  	
 	
	
			$.validator.setDefaults({
        submitHandler: function(event) {

        	if($('#tipoTransaccion').val()==catTipoTransaccionInstitucion.crediclub && $('#tipoGeneracion').val() == catTipoGeneracion.semestral){
				mensajeSisRetro({
					mensajeAlert : 'Debe asegurarse de realizar el proceso de timbrado previo a la Generación de Estado de Cuenta Semestral. ¿Desea continuar?',
					muestraBtnAceptar: true,
					muestraBtnCancela: true,
					txtAceptar : 'Aceptar',
					txtCancelar : 'Cancelar',
					funcionAceptar : function(){
    	        		 grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','anio');
					},
					funcionCancelar : function(){
					}
				});
        	}else{
        		 grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','anio');
        	}
        }
	});
	
	$('#anio').blur(function(){
		$('#mes').focus();
		otra = false;
		continuar = false;
	});

	$('#mes').blur(function(){
		$('#cuentaAhoID').focus();
		otra = false;
		continuar = false;
	});
	

	$('#procesar').click(function () {
		if($('#tipoGeneracion').val() == catTipoGeneracion.mensual){
			$('#fechaProceso').val($('#anio').val() + $('#mes').val());
			llenaCamposGeneracionMensual();
		}
		if($('#tipoGeneracion').val() == catTipoGeneracion.semestral){
			$('#tipoTransaccion').val(catTipoTransaccionInstitucion.crediclub);
			if($('#numSemestre').val() == catNumSemestre.primerSemestre){
				$('#mesInicioGen').val(catNumMes.enero);
				$('#mesFinGen').val(catNumMes.junio);
				mesInicio = ("0" + catNumMes.enero).slice (-2);
				mesFinal = ("0" + catNumMes.junio).slice (-2);
			}
			if($('#numSemestre').val() == catNumSemestre.segundoSemestre){
				$('#mesInicioGen').val(catNumMes.julio);
				$('#mesFinGen').val(mesFinal);
				mesInicio = ("0" + catNumMes.julio).slice (-2);
				mesFinal = catNumMes.diciembre;
			}
			$('#anioGeneracion').val($('#anioSemestre').val());
			$('#fechaProceso').val($('#anioSemestre').val() +mesInicio+ mesFinal);
		}
		consultaRangos();
	});
	
	$('#tipoGeneracionM').click(function() {
		$('#tipoGeneracion').val('M');
		$('#tipoGeneracionM').focus();
	});
	$('#tipoGeneracionS').click(function() {
		$('#tipoGeneracion').val('S');
		$('#tipoGeneracionS').focus();
	});
	
	$('#tipoGeneracionM').change(function() {
		$('#tipoGeneracion').val('M');
		muestraCamposGeneracion();
	});
	$('#tipoGeneracionS').change(function() {
		muestraCamposGeneracion();
		$('#tipoGeneracion').val('S');
	});
	$('#numSemestre').change(function() {
		muestraRangoSemestre();
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------	
	$('#formaGenerica').validate({
		rules: {
			anio: 'required',
			mes: 'required',
			anioSemestral: 'required',
			numSemestre: 'required',
			sucursalInicio: 'required',
			sucursalFin: 'required'
		},
		messages: {
			anio: 'Especifique el Año',
			mes: 'Especifique el Mes',
			anioSemestral: 'Especifique el Año',
			numSemestre: 'Especifique el Semestre',
			sucursalInicio: 'Especifique la Sucursal Inicio',
			sucursalFin: 'Especifique la Sucursal Fin'
		}
	});
	
	//------------ Validaciones de Controles -------------------------------------
	// Valida Sucursal Inicio
	function validaSucursalInicio(control) {
		var jqSucursal = eval("'#" + control + "'" );
		var numSucursal = $(jqSucursal).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) {
				if(sucursal != null){
					$('#desc'+control).val(sucursal.nombreSucurs);
				}else{
					alert("No Existe la Sucursal");
					$(jqSucursal).focus();
					$('#sucursalInicio').val('');
					$('#descsucursalInicio').val('');
				}
			});
		}
	}

	//Valida Sucursal Fin
	function validaSucursalFin(control) {
		var jqSucursal = eval("'#" + control + "'" );
		var numSucursal = $(jqSucursal).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) {
				if(sucursal != null){
					$('#desc'+control).val(sucursal.nombreSucurs);
				}else{
					alert("No Existe la Sucursal");
					$(jqSucursal).focus();
					$('#sucursalFin').val('');
					$('#descsucursalFin').val('');
				}
			});
		}
	}


	function consultaRangos(){
		var beanEdoCta = {
				'sucursalInicio' : $('#sucursalInicio').val(),
				'sucursalFin' : $('#sucursalFin').val()
		};
		generaEdoCtaServicio.consulta(catTipoConEdoCta.conRangos, beanEdoCta, function(paramEdoCta) {
			if (paramEdoCta != null){
				$('#clienteInicio').val(paramEdoCta.clienteInicio);
				$('#clienteFin').val(paramEdoCta.clienteFin);
			}
		});
	}
	
		
	function validaParametros(){
		var conParamSis = 5;
		var conParamEdo = 2;
		parametrosSisServicio.consulta(conParamSis, function(parametrosSis) {
			if(parametrosSis == null){
				alert("Especifique en Param. Generales los Datos para Facturación Electrónica.");
				deshabilitaBoton('procesar', 'submit');
			}else{
				if (parametrosSis.timbraEdoCta == 'S') {
					if (parametrosSis.usuarioFactElect == null || parametrosSis.usuarioFactElect == '' ){
						alert("Especifique en Param. Generales el Usuario para Conectar con el PAC.");
						deshabilitaBoton('procesar', 'submit');
					}else if(parametrosSis.passFactElec == null || parametrosSis.passFactElec == ''){
						alert("Especifique en Param. Generales el Password para Conectar con el PAC.");
						deshabilitaBoton('procesar', 'submit');
					}
				}
				generaEdoCtaServicio.consulta(conParamEdo, function(paramEdoCta) {
					if (paramEdoCta != null){
						if(paramEdoCta.rutaEdoCtaPDF == null || paramEdoCta.rutaEdoCtaPDF == '' ){
							alert("Especifique en Param. de Estado de Cuenta la Ruta para PDF.");
							deshabilitaBoton('procesar', 'submit');
						}else if(paramEdoCta.rutaReporte == null || paramEdoCta.rutaReporte =='' ){
							alert("Especifique en Param. de Estado de Cuenta la Ruta del PRPT.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramEdoCta.rutaCBB == null || paramEdoCta.rutaCBB == ''){
							alert("Especifique en Param. de Estado de Cuenta la Ruta para CBB.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramEdoCta.rutaXML == null || paramEdoCta.rutaXML == '' ){
							alert("Especifique en Param. de Estado de Cuenta la Ruta para XML.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramEdoCta.rfcEmisor == null || paramEdoCta.rfcEmisor == ''){
							alert("Especifique en Param. Generales el RFC de la Empresa.");
							deshabilitaBoton('procesar', 'submit');
						}
					}else{
						alert("Especifique en Param. de Estado de Cuenta la información solicitada.");
						deshabilitaBoton('procesar', 'submit');
					}
				});
			}
		});
	}
	
	function llenarAnio(){
		var i=0;
		if (mesSucursal == 1) {
			anioSucursal = anioSucursal - 1; 
		}
		document.forms[0].anio.clear;
		document.forms[0].anio.length = 1;
		for (i=0; i < (document.forms[0].anio.length); i++){
			document.forms[0].anio[i].text = anioSucursal-i;
			document.forms[0].anio[i].value = anioSucursal-i;			
		}
		document.forms[0].anio[0].selected = true;
	}

	function llenarMes(){
		var txtMes = "";
		var i=0;
		var mes = mesSucursal - 1;

		if (mes == 0){
			mes = 12;
			mesSucursal = 13;
		}
		switch (mes){
				case 1: txtMes="Enero";	break;
				case 2: txtMes="Febrero"; break;
				case 3: txtMes="Marzo"; break;
				case 4: txtMes="Abril";	break;
				case 5: txtMes="Mayo"; break;
				case 6: txtMes="Junio"; break;
  				case 7: txtMes="Julio"; break;
  				case 8: txtMes="Agosto"; break;
  				case 9: txtMes="Septiembre"; break;
  				case 10: txtMes="Octubre"; break;
				case 11: txtMes="Noviembre"; break;
				case 12: txtMes="Diciembre"; break;
		}
		document.forms[0].mes.clear;
		document.forms[0].mes.length = 1;
		document.forms[0].mes[0].text = txtMes;
		document.forms[0].mes[0].value = ("0" + (mesSucursal-1)).slice (-2);
		document.forms[0].mes[0].selected = true;

	}
	
	function convierteStrInt(jControl){
		var valor=($(jControl).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		})).asNumber();
		return  parseFloat(valor);
	}
	function llenaCamposGeneracionMensual(){
		$('#anioGeneracion').val($('#anio').val());
		$('#mesInicioGen').val($('#mes').val());
		$('#mesFinGen').val($('#mes').val());
	}
	//Funcion que llena el campo AnioSemestre con el anio del sistema y el anio anterior al mismo
	function llenarAnioSemestre(){
		var options = $('#anioSemestre').attr('options');
		options[options.length] = new Option(anioSucursal - 1, anioSucursal - 1);
		options[options.length] = new Option(anioSucursal, anioSucursal, true, true);
	}
	
	//Funcion que oculta las secciones de generacion de estado de cuenta de acuerdo al tipo de generacion seleccionado
	function muestraCamposGeneracion() {
		if ($('#tipoGeneracionM').is(':checked') == true) {
			$('#generacionMensual').show();
			$('#generacionSemestral').hide();
			$('#rangoSemestral').hide();
			$('#tipoGeneracionM').attr('checked', 'false');
		} else {
			if ($('#tipoGeneracionS').is(':checked') == true) {
				$('#generacionMensual').hide();
				$('#generacionSemestral').show();
				$('#rangoSemestral').show();
				$('#tipoGeneracionS').attr('checked', 'false');
				$('#numSemestre').val(1);
				muestraRangoSemestre();
			}
		}
	}// fin muestraCamposGeneracion
	
	//Funcion que despliega el rango de meses en el campo correspondiente de acuerdo al semestre seleccionado
	//en la generacion de estado de cuenta semestral
	function muestraRangoSemestre() {
		if ($('#numSemestre').val() == catNumSemestre.primerSemestre) {
			$('#mesInicio').val('Enero');
			$('#mesFin').val('Junio');
		} else {
			if ($('#numSemestre').val() == catNumSemestre.segundoSemestre) {
				$('#mesInicio').val('Julio');
				$('#mesFin').val('Diciembre');
			}
		}
	}// fin muestraRangoSemestre
	
	// Consulta el tipo de institucion
	function consultaInstitucion() {			
		var parametrosSisCon ={
	 		 	'empresaID' : 1
		};
		parametrosSisServicio.consulta(10,parametrosSisCon, function(parametros) {
			if (parametros != null) {
				nombreCortoInstitucion = parametros.nombreCortoInst;

				if(nombreCortoInstitucion == instCrediclub){
					$('#tipoTransaccion').val(catTipoTransaccionInstitucion.crediclub);
					$('#opcionesTipoGeneracion').show();
				}else{
					$('#tipoTransaccion').val(catTipoTransaccionInstitucion.principal);
					$('#tipoGeneracion').val() == catTipoGeneracion.mensual;
					$('#opcionesTipoGeneracion').hide();
					$('#generacionSemestral').hide();
					$('#rangoSemestral').hide();
					$('#tipoGeneracionM').attr('checked', 'false');
				}
			}
		});
	}
	
	
	
});
