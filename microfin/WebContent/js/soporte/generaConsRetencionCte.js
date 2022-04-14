$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/
	esTab = false;

	var catTipoConsultaCliente ={
		'clientesConstancia' :  3
	};
	
	var catTipoConsultaSucursal ={
		'principal' :  1
	};
	
	var catTipoConsultaDireccion ={
		'direccion' :  3
	};
	
	var catTipoConsultaParams ={
		'facturaElectronica' :  5
	};
	
	var catTipoConsultaConst ={
		'foranea' : 2
	};
	
	var Constantes = {
		'SI' 			: 'S',
		'CADENAVACIA' 	: ''
	};

	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/
	var parametroBean = consultaParametrosSession(); 
	$('#OrigenDatos').val(parametroBean.origenDatos);
	var fechaSucursal = parametroBean.fechaSucursal;  
	var anioSucursal = fechaSucursal.substr(0,4);
	var var_clienteSocio = $("#clienteSocio").val(); 	// Guarda si el sistema maneja Clientes o Socios

	agregaFormatoControles('formaGenerica');
	llenarAnio();
	validaParametros();
	
	$('#clienteID').focus();
	
    /******* VALIDACIONES DE LA FORMA *******/	
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','anio','funcionExito', 'funcionError');
		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required'
		},
		messages: {
			clienteID: 'Especifique Número de '+ var_clienteSocio + '.'
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

	$('#clienteID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "anioProceso";
		camposLista[1] = "nombreCompleto";
		parametrosLista[0] = $('#anio').val();
		parametrosLista[1] = $('#clienteID').val(); 
		lista('clienteID', '2', '5',camposLista, parametrosLista, 'listaClienteConsRet.htm');
	});

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});

	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/	
	// FUNCIÓN PARA CONSULTA DE CLIENTES
	function consultaCliente(idControl) {
		var numCliente = $('#clienteID').val();
		var anio      = $('#anio').val();

		var bean ={
			'clienteID' : numCliente,
			'anioProceso' : anio
		};

		if (numCliente != Constantes.CADENAVACIA && !isNaN(numCliente)) {
			// Se consulta los datos del cliente
			generaConsRetencionCteServicio.consulta(catTipoConsultaCliente.clientesConstancia, bean, function(cliente) {
				if (cliente != null) {
					$('#clienteID').val(cliente.clienteID);
					$('#nombreCompleto').val(cliente.nombreCompleto);
					$('#sucursalInicio').val(cliente.sucursalInicio);
					validaSucursal('sucursalInicio');
					var direccionesCliente ={
			 			'clienteID' : $('#clienteID').val()
					};
					// Se consulta la dirección del cliente
					direccionesClienteServicio.consulta(catTipoConsultaDireccion.direccion,direccionesCliente,function(direccion) {
						if(direccion!=null){
							$('#direccion').val(direccion.direccionCompleta);
						}else{
							$('#direccion').val('');
						}
					});
				}
				else{
					mensajeSis('El Número de '+ var_clienteSocio +' No Existe o No tiene Información para Generar la Constancia de Retención.');
					$('#clienteID').focus();
					$('#clienteID').val('');
					$('#nombreCompleto').val('');
					$('#sucursalInicio').val('');
					$('#descsucursalInicio').val('');
					$('#direccion').val('');
				} 
			});
		}
	}	
	
	// FUNCIÓN PARA CONSULTAR LA SUCURSAL	 
	function validaSucursal(control) {
		var jqSucursal = eval("'#" + control + "'" );
		var numSucursal = $(jqSucursal).val();
		if(numSucursal != Constantes.CADENAVACIA && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(catTipoConsultaSucursal.principal,numSucursal,function(sucursal) {
				if(sucursal != null){
					$('#descsucursalInicio').val(sucursal.nombreSucurs);
				}else{
					mensajeSis("No Existe la Sucursal.");
					$(jqSucursal).focus();
				}
			});
		}
	}

	// FUNCIÓN PARA VALIDAR PARÁMETROS DE SISTEMA Y DE CONSTANCIAS DE RETENCIÓN	
	function validaParametros(){
		parametrosSisServicio.consulta(catTipoConsultaParams.facturaElectronica, function(parametrosSis) {
			if(parametrosSis == null){
				mensajeSis("Especifique en Param. Generales los Datos para Facturación Electrónica.");
				deshabilitaBoton('procesar', 'submit');
			}else{
				if (parametrosSis.timbraConsRet == Constantes.SI) {
					if (parametrosSis.usuarioFactElect == null || parametrosSis.usuarioFactElect == Constantes.CADENAVACIA){
						mensajeSis("Especifique en Parámetros del Sistema el Usuario para Conectar con el PAC.");
						deshabilitaBoton('procesar', 'submit');
					}else if(parametrosSis.passFactElec == null || parametrosSis.passFactElec == Constantes.CADENAVACIA){
						mensajeSis("Especifique en Parámetros del Sistema el Password para Conectar con el PAC.");
						deshabilitaBoton('procesar', 'submit');
					}
				}
				generaConsRetencionCteServicio.consulta(catTipoConsultaConst.foranea, function(paramConstancia) {
					if (paramConstancia != null){
						if(paramConstancia.rutaConstanciaPDF == null || paramConstancia.rutaConstanciaPDF == Constantes.CADENAVACIA ){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta para PDF.");
							deshabilitaBoton('procesar', 'submit');
						}else if(paramConstancia.rutaReporte == null || paramConstancia.rutaReporte == Constantes.CADENAVACIA ){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta del PRPT.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramConstancia.rutaCBB == null || paramConstancia.rutaCBB == Constantes.CADENAVACIA){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta para CBB.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramConstancia.rutaXML == null || paramConstancia.rutaXML == Constantes.CADENAVACIA ){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta para XML.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramConstancia.rutaLogo == null || paramConstancia.rutaLogo == Constantes.CADENAVACIA ){
							mensajeSis("Especifique en Parámetros de Constancia de Retención la Ruta del Logo.");
							deshabilitaBoton('procesar', 'submit');
						}else if (paramConstancia.rutaCedula == null || paramConstancia.rutaCedula == Constantes.CADENAVACIA ){
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

	// FUNCIÓN PARA OBTENER EL AÑO ANTERIOR	
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
	
});// FIN DOCUMENT READY

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	$('#clienteID').focus();
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
	$('#clienteID').focus();
} 