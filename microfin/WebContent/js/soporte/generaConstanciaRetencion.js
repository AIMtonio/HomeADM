$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/
	esTab = false;
	
	var catTipoConsultaSucursal ={
		'principal' :  1
	};
	
	var catTipoConsultaParams ={
		'facturaElectronica' :  5
	};
		
	var catTipoConsultaConst ={
		'foranea' : 2
	};
		
	var Constantes = {
		'SI' : 'S',
		'CADENAVACIA' : ''
	};

	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/
	var parametroBean = consultaParametrosSession(); 
	$('#OrigenDatos').val(parametroBean.origenDatos);
	var fechaSucursal =parametroBean.fechaSucursal;  
	var anioSucursal = fechaSucursal.substr(0,4);

	agregaFormatoControles('formaGenerica');
	llenarAnio();
	validaParametros();

	$("#sucursalInicio").focus();

    /******* VALIDACIONES DE LA FORMA *******/	
	$.validator.setDefaults({
      submitHandler: function(event) {
    		  grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','anio');  
       }
    });	

	$('#formaGenerica').validate({
		rules: {
			sucursalInicio: 'required',
			sucursalFin: 'required'
		},
		messages: {
			sucursalInicio: 'Especifique Sucursal Inicio',
			sucursalFin: 'Especifique Sucursal Fin'
		}
	});
	
	/******* MANEJO DE EVENTOS *******/	
	$(':text').focus(function() {	
	 	esTab = false;
	});
   
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#procesar').click(function () {
		$('#anioProceso').val($('#anio').val());
	});
	
	$('#sucursalInicio').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('sucursalInicio', '2', '1', 'nombreSucurs', $('#sucursalInicio').val(), 'listaSucursales.htm');
	});
	
	$('#sucursalInicio').blur(function() {
		var sucFin = $('#sucursalFin').val();
		if (sucFin != Constantes.CADENAVACIA && !isNaN(sucFin) ){
			if (parseInt(this.value) > parseInt(sucFin) ){
				mensajeSis('La Sucursal Inicio debe Ser Menor o Igual a la Sucursal Fin');
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
		if (sucIni != Constantes.CADENAVACIA && !isNaN(sucIni) ){
			if (parseInt(sucIni) > parseInt(this.value) ){
				mensajeSis('La Sucursal Fin debe Ser Mayor o Igual a la Sucursal Inicio.');
				$(this).val('');
				$('#descsucursalFin').val('');				
				$(this).focus();
			}
		}
		validaSucursalFin(this.id);
	});

	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/	
	//FUNCIÓN PARA VALIDAR SUCURSAL INICIO	
	function validaSucursalInicio(control) {
		var jqSucursal = eval("'#" + control + "'" );
		var numSucursal = $(jqSucursal).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numSucursal != Constantes.CADENAVACIA && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(catTipoConsultaSucursal.principal,numSucursal,function(sucursal) {
				if(sucursal != null){
					$('#desc'+control).val(sucursal.nombreSucurs);
				}else{
					mensajeSis("No Existe la Sucursal.");
					$(jqSucursal).focus();
					$('#sucursalInicio').val('');
					$('#descsucursalInicio').val('');
				}
			});
		}
	}
	
	//FUNCIÓN PARA VALIDAR SUCURSAL FIN
	function validaSucursalFin(control) {
		var jqSucursal = eval("'#" + control + "'" );
		var numSucursal = $(jqSucursal).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numSucursal != Constantes.CADENAVACIA && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(catTipoConsultaSucursal.principal,numSucursal,function(sucursal) {
				if(sucursal != null){
					$('#desc'+control).val(sucursal.nombreSucurs);
				}else{
					mensajeSis("No Existe la Sucursal.");
					$(jqSucursal).focus();
					$('#sucursalFin').val('');
					$('#descsucursalFin').val('');
				}
			});
		}
	}
	
	//FUNCIÓN PARA VALIDAR PARÁMETROS DE SISTEMA Y DE CONSTANCIAS DE RETENCIÓN
	function validaParametros(){
		parametrosSisServicio.consulta(catTipoConsultaParams.facturaElectronica, function(parametrosSis) {
			if(parametrosSis == null){
				mensajeSis("Especifique en Param. Generales los Datos para Facturación Electrónica.");
				deshabilitaBoton('procesar', 'submit');
			}else{
				if (parametrosSis.timbraConsRet == Constantes.SI) { 
					if (parametrosSis.usuarioFactElect == null || parametrosSis.usuarioFactElect == Constantes.CADENAVACIA ){
						mensajeSis("Especifique en Parámetros del Sistema el Usuario para Conectar con el PAC.");
						deshabilitaBoton('procesar', 'submit');
					}else if(parametrosSis.passFactElec == null || parametrosSis.passFactElec == Constantes.CADENAVACIA){
						mensajeSis("Especifique en Parámetros del Sistema el Password para Conectar con el PAC.");
						deshabilitaBoton('procesar', 'submit');
					}
				}
				generaConstanciaRetencionServicio.consulta(catTipoConsultaConst.foranea, function(paramConstancia) {
					if (paramConstancia != null){
						if(paramConstancia.rutaConstanciaPDF == null || paramConstancia.rutaConstanciaPDF == Constantes.CADENAVACIA){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta para PDF.");
							deshabilitaBoton('procesar', 'submit');
						}else if(paramConstancia.rutaReporte == null || paramConstancia.rutaReporte == Constantes.CADENAVACIA ){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta del PRPT.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramConstancia.rutaCBB == null || paramConstancia.rutaCBB == Constantes.CADENAVACIA){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta para CBB.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramConstancia.rutaXML == null || paramConstancia.rutaXML == Constantes.CADENAVACIA){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta para XML.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramConstancia.rutaLogo == null || paramConstancia.rutaLogo == Constantes.CADENAVACIA){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta del Logo.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramConstancia.rutaCedula == null || paramConstancia.rutaCedula == Constantes.CADENAVACIA){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta de la Cédula Fiscal.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramConstancia.rfcEmisor == null || paramConstancia.rfcEmisor == Constantes.CADENAVACIA){
							mensajeSis("Especifique en Param. Generales el RFC de la Empresa.");
							deshabilitaBoton('procesar', 'submit');
						}
					}else{
						mensajeSis("Especifique en Paramámetros de Constancia de Retención la Información Solicitada.");
						deshabilitaBoton('procesar', 'submit');
					}
				});
			}
		});
	}
	
	//FUNCIÓN PARA OBTENER EL AÑO ANTERIOR	
	function llenarAnio(){
		var i=0;
		anioSucursal = anioSucursal - 1; 
		
		document.forms[0].anio.clear;
		document.forms[0].anio.length = 1;
		for (i=0; i < (document.forms[0].anio.length); i++){
			document.forms[0].anio[i].text = anioSucursal-i;
			document.forms[0].anio[i].value = anioSucursal-i;			
		}
		document.forms[0].anio[0].selected = true;
	}
});