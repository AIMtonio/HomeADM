// Definicion de Constantes y Enums	
var catTipoTransaccionInversion = {
  		'agrega'	:1,
  		'elimina': 2
};

var catTipoConsultaInversion = {
		'principal' : 1
};

var resultado			= false;
var varGarantizadoInv	= 0;
var procede = true;
var esAutomatico = "";
var tipoAutomatico = "";
$(document).ready(function() {
	// Definicion de Constantes y Enums	
	catTipoTransaccionInversion = {
	  		'agrega'	:1,
	  		'actualiza': 2
	};
	
	catTipoActualizacionInversion = {
			'elimina'	:1,
	};


	catTipoConsultaInversion = {
			'principal' : 1
	};
	resultado	= false;
	procede		= false;

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	/* se manda a llamar funcion para inicializar el formulario */
	inicializaInvGarantia();
	agregaFormatoControles('formaGenerica');
	
	//-- Haciendo la transaccion
	$.validator.setDefaults({
		submitHandler: function(event) {
			if(validaAgregarEliminarInverGar()){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'funcionExitoCreditoInv', 'funcionErrorCreditoInv');
			}
		}
	});
	
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '12', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
		
	});
	
	$('#creditoID').blur(function (){
		consultaCredito($('#creditoID').val()); // funcion para consultar el credito 
	});
	
	$('#inversionID').bind('keyup',function(e){
		var tipoListaPrincipal = 1;
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "creditoID";
		camposLista[1] = "inversionID";
		camposLista[2] = "nombreCliente";
		camposLista[3] = "clienteID";
		parametrosLista[0] = $('#creditoID').val();
		parametrosLista[1] = 0;	
		parametrosLista[2] = 0;
		parametrosLista[3] = $('#clienteID').val();	
		lista('inversionID', 2, tipoListaPrincipal, camposLista, parametrosLista, 'listaInvGarantia.htm');
	});
	
	$('#inversionID').blur(function(){
		consultaInversion($('#inversionID').asNumber());
	});
	
	$('#montoEnGar').blur(function(){
		validaTotalGarantizadoInv( $('#inversionID').val());
	});
	
	
	$('#agrega').click(function(  ){
		$('#tipoTransaccion').val(catTipoTransaccionInversion.agrega);
		$('#tipoActualizacion').val("0");
	});
	
	
	$('#elimina').click(function(  ){
		$('#tipoTransaccion').val(catTipoTransaccionInversion.actualiza);
		$('#tipoActualizacion').val(catTipoActualizacionInversion.elimina);
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			inversionID: 'required',
			creditoID: 'required'	
		},
		messages: {
			inversionID: 'Especifique número de Inversión',
			creditoID: 'Especifique número de Crédito'
		}
	});
	
});

/* funcion para consultar el crédito*/
function consultaCredito(numCre){ 
	
	if(numCre > 0 && !isNaN(numCre) &&  numCre.length <= 11 ){
		var bean={
				'creditoID':numCre
		};
		var tipoConsultaCreditoPrincipal = 1;
		creditosServicio.consulta(tipoConsultaCreditoPrincipal, bean,{ async: false, callback: function(credito){
			if(credito!=null){
				$('#creditoID').val(credito.creditoID);
				$('#proCre').val(credito.producCreditoID);
				$('#montoCre').val(credito.montoCredito);
				$('#montoCre').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});
				$('#fechaIniCre').val(credito.fechaInicio);
				$('#fechaVenCre').val(credito.fechaVencimien);
				$('#clienteID').val(credito.clienteID);
				$('#cuentaAhoID').val(credito.cuentaID);
				$('#porcentajeGarantia').val(credito.porcGarLiq);
				$('#montoGarantia').val(credito.aporteCliente);			
				$('#porcentajeGarantia').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 4	
				});
				$('#montoGarantia').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});
				
				esAutomatico = credito.esAutomatico;
				tipoAutomatico = credito.tipoAutomatico;
				if(esAutomatico == 'S' && tipoAutomatico == 'I'){
				var inversion = credito.inversionID;
				$('#inversionID').val(inversion);

				consultaInversion($('#inversionID').asNumber());
				deshabilitaControl('inversionID');
					$('#inversionID').attr('readOnly', true);
				}
				else{
					habilitaControl('inversionID');
				}
	
				
				consultaNombreCliente(credito.clienteID); // /* consulta nombre del cliente*/
				consultaTotalGarantiaLiqCubierta(credito.creditoID);
				consultaProductoCredito(credito.producCreditoID,credito.montoCredito,numCre,credito.estatus);
			}else{
				mensajeSis('El Crédito No Existe.');
				inicializaInvGarantia();
			}
		}
		});
	}else{
		if(!isNaN(numCre) && numCre!=''){
			inicializaInvGarantia();
		}
	}
	
}

/* consulta nombre del cliente*/
function consultaNombreCliente(varClienteID){
	var tipoConsultaClienteForanea = 2;
	clienteServicio.consulta(tipoConsultaClienteForanea,varClienteID,"",{ async: false, callback:function(cliente){
		if(cliente != null){
			if(Number(cliente.numero) >= 0){
				$('#nombreCli').val(cliente.nombreCompleto);
			}
		}
	}
	});
}

// funcion para consultar inversiones
function consultaInversion(invnumb){
	if($('#creditoID').asNumber() <= 0 ){
		mensajeSis('Especifique Crédito.');
		$('#inversionID').val('');
		$('#creditoID').val('');
		$('#creditoID').focus();
	}else{
		if(invnumb > 0 && !isNaN(invnumb)){
			var InversionBean = {
					'inversionID' :  $('#inversionID').val()
			};
			inversionServicioScript.consulta(catTipoConsultaInversion.principal, InversionBean, { async: false, callback: function(inversionCon){

				if(inversionCon!=null){
	
					$('#montoInversion').val(inversionCon.monto);
					$('#tasa').val(inversionCon.tasa);
					$('#fechaVencimiento').val(inversionCon.fechaVencimiento);
					$('#reinvertir').val(inversionCon.reinvertir);
					$('#reinvertirDes').val(inversionCon.reinvertirDes);
					$('#etiqueta').val(inversionCon.etiqueta);		
					$('#montoEnGar').val("");	
					$('#montoInversion').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
						});
					$('#tasa').formatCurrency({
							positiveFormat: '%n', 
							roundToDecimalPlace: 4	
							});
					$('#interesRecibir').formatCurrency({
							positiveFormat: '%n', 
							roundToDecimalPlace: 2	
							});
					

					if(Number($('#clienteID').val()) == Number(inversionCon.clienteID)){
						if(comparaFechas($('#fechaVenCre').val(), inversionCon.fechaVencimiento, inversionCon.reinvertir)){
							if(inversionCon.estatus == 'N'){
								if( $('#montoCre').asNumber() >  0 ){
									validaTotalGarantizadoInv( $('#inversionID').val());
									validaMontos();
								}else{
									mensajeSis('El Monto Del Crédito Debe Ser Mayor a Cero.');
								}
							}else{
								mensajeSis('La Inversión No Se Encuentra Vigente.');
								deshabilitaBoton('agrega', 'submit');
								deshabilitaBoton('elimina', 'submit');
								limpiaCamposInversion();
								$('#inversionID').focus();								
							}
						}else{
							mensajeSis("La Fecha de Vencimiento de Inversión debe ser Mayor a la Fecha de Vencimiento del Crédito.");
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('elimina', 'submit');
							limpiaCamposInversion();
							$('#inversionID').focus();	
						}
					}else{
						mensajeSis('La Inversión No pertenece al '+$('#socioCliente').val() +' Indicado.');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('elimina', 'submit');
						limpiaCamposInversion();
						$('#montoDisponible').val("");
						$('#montoGarantizado').val("");
						$('#inversionID').focus();
					}
				}else{	
					mensajeSis('La Inversión No Existe.');
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('elimina', 'submit');
					limpiaCamposInversion();
					$('#inversionID').focus();
				}
			}});
		}else{
			if(esTab){
				mensajeSis('La Inversión No Existe.');
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('elimina', 'submit');
				limpiaCamposInversion();
				$('#inversionID').focus();
			}
		}
	}
}

/* valida el  total garantizado por inversion */
function validaTotalGarantizadoInv(numInversion){
	varGarantizadoInv = 0;
	var bean={
		'inversionID':numInversion
	};
	invGarantiaServicio.consulta(3,bean,function(inverGaran){
		if(inverGaran != null){
			varGarantizadoInv  = parseFloat(parseFloat($('#montoEnGar').asNumber()) + 	parseFloat(inverGaran.totalGarInv));
			if(inverGaran.totalGarInv > 0){
				varGarantizadoInv  = parseFloat(parseFloat($('#montoEnGar').asNumber()) + 	parseFloat(inverGaran.totalGarInv));
				if(	varGarantizadoInv   > $('#montoInversion').asNumber()){
					/* si el monto garantizado de la inversion mas el monto a garantizar es mayor que el monto de la inversion se manda alerta*/
					mensajeSis("El Monto a Garantizar más el Monto Garantizado, no debe ser Mayor al Monto de la Inversión.");
					$('#montoEnGar').val("");
					$('#montoEnGar').focus();
					deshabilitaBoton('agrega', 'submit');
				}else{
					habilitaBoton('agrega', 'submit');
				}
			}else{
				if(	parseFloat($('#montoEnGar').asNumber()) > $('#montoInversion').asNumber()){
					mensajeSis("El Monto a Garantizar no debe ser Mayor al Monto de la Inversión.");
					$('#montoEnGar').val("");
					$('#montoEnGar').focus();
					deshabilitaBoton('agrega', 'submit');
				}else{
					habilitaBoton('agrega', 'submit');
				}
			}
		}else{
			varGarantizadoInv  = 0;
		}
	});
}


/* consulta el total de garantia liquida cubierto */
function consultaTotalGarantiaLiqCubierta(numCredito){
	varGarantizadoInv = 0;
	var bean={
		'creditoID':numCredito
	};
	invGarantiaServicio.consulta(1,bean,{ async: false, callback:function(inverGaran){
		if(inverGaran != null){
			$('#garantiaCubierta').val(inverGaran.montoGarLiq);
			$('#garantiaCubierta').formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
			});
		}else{
			$('#garantiaCubierta').val(0.00);
		}
	}
	});
}

/* funcion para limpiar los campos de la inversion */
function limpiaCamposInversion(){
	$('#inversionID').val("");	
	$('#montoInversion').val("");	
	$('#tasa').val("");	
	$('#fechaVencimiento').val("");	
	$('#reinvertir').val("");	
	$('#reinvertirDes').val("");
	$('#montoEnGar').val("");	
	$('#etiqueta').val("");
	$('#montoGarantizado').val("");	
	$('#montoDisponible').val("");
	if($('#creditoID').asNumber()==0){
		$('#gridInversionesRelacionadas').html("");
		$('#gridInversionesRelacionadas').hide();
	}
}


/* funcion para limpiar los campos de la inversion */
function limpiaCamposCredito(){
	$('#creditoID').val("");
	$('#estatusCre').val("");
	$('#estatus').val("");
	
	$('#clienteID').val("");
	$('#nombreCli').val("");
	$('#cuentaAhoID').val("");
	$('#proCre').val("");
	$('#nombreProCre').val("");
	$('#montoCre').val("");
	$('#fechaIniCre').val("");
	$('#fechaVenCre').val("");
	$('#porcentajeGarantia').val("");
	$('#montoGarantia').val("");
	$('#garantiaCubierta').val("");
}

/* funcion para consultar el producto de credito*/
function consultaProductoCredito(varProductoCredito, varMontoCredito,numCre , varEstatusCre){
	var beanprocre={
			'producCreditoID':varProductoCredito
	};
	var tipoConsultaProCrePincipal = 1;
	productosCreditoServicio.consulta(tipoConsultaProCrePincipal,beanprocre,{ async: false, callback:function(proCre){
		if(proCre != null){
			$('#nombreProCre').val(proCre.descripcion);
			if(Number(proCre.producCreditoID) >= 0){
				if(proCre.garantizado != "S" ){
					mensajeSis('El Producto de Crédito no Requiere Garantía Líquida.');
					inicializaInvGarantia();
				}else{
					validaParametroEstatus(numCre);
					$('#estatus').val(varEstatusCre);
					switch (varEstatusCre){
						case 'I':
							$('#estatusCre').val('INACTIVO');
							break;
						case 'A':
							$('#estatusCre').val('AUTORIZADO');
							break;
						case 'V':
							$('#estatusCre').val('VIGENTE');
							break;
						case 'P':
							$('#estatusCre').val('PAGADO');
							mensajeSis('El Crédito esta Pagado.');
							break;
						case 'C':
							$('#estatusCre').val('CANCELADO');
							mensajeSis('El Crédito esta Cancelado.');
							break;
						case 'B':
							$('#estatusCre').val('VENCIDO');
							break;
						case 'K':
							$('#estatusCre').val('CASTIGADO');
							mensajeSis('El Crédito esta Castigado.');
							break;
						default: 
							$('#estatusCre').val(varEstatusCre);
							mensajeSis('El Crédito tiene un Estatus No Definido.');
							break;
					}// fin de switch de estatus credito
				}
			}
		}else{
			mensajeSis("El Producto de Crédito no Existe");
			$('#creditoID').focus().select();
			$('#creditoID').val("");
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('elimina', 'submit');
			limpiaCamposInversion();
		}
	}
	});
}

/* valida si las inversiones estan respaldando a un credito  */
function validaCreditoEnGarantia(numCre){
	varGarantizadoInv = 0;
	var bean={
		'creditoID':numCre
	};
	invGarantiaServicio.consulta(6,bean,function(inverGaran){
		if(inverGaran != null){
			mostraGridInversionesRelacionadas(numCre);
		}else{
			mensajeSis("El Crédito no tiene un Estatus Permitido para relacionar una Inversión en Garantía");
			inicializaInvGarantia();
		}
	});
}

/* funcion para validar si esta parametrizado los estatus del creditos permitidos */
function validaParametroEstatus(numCre) {
	setTimeout("$('#cajaLista').hide();", 200);
	var numEmpresaID = 1;
	var tipoCon = 1;
	var ParametrosSisBean = {
			'empresaID'	:numEmpresaID
	};
	parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			if($.trim(parametrosSisBean.estCreAltInvGar)==""){
				mensajeSis("Los Estatus Permitidos del Crédito, no estan definidos.");
				inicializaInvGarantia();
			}else{
				validaCreditoEnGarantia(numCre);
				habilitaControl('montoEnGar');
				$('#inversionID').focus().select();
			}
		}else {
			mensajeSis("No hay parámetros definidos.");
		}
	});
}//fin funcion para validar si esta parametrizado los estatus del creditos permitidos 

/* funcion para comparar fechas*/
function comparaFechas(fechaIni,fechaVen, varReinversionAut){
	if(varReinversionAut == "N"){
		if(fechaIni == '' || fechaVen == ''){
			mensajeSis('Error en las Fechas Verifique sus datos.');
			resultado = false;
		}else{
			var xYear=fechaIni.substring(0,4);
			var xMonth=fechaIni.substring(5, 7);
			var xDay=fechaIni.substring(8, 10);
			var yYear=fechaVen.substring(0,4);
			var yMonth=fechaVen.substring(5, 7);
			var yDay=fechaVen.substring(8, 10);
			if (yYear<xYear ){
				resultado = false;
			}else{
				if (xYear == yYear){
					if (yMonth<xMonth){
						resultado = false;
					}else{
						if (xMonth == yMonth){
							if(esAutomatico == 'S' && tipoAutomatico == 'I'){
								if (yDay<xDay){
									resultado = false;
								}else{
									resultado = true;
								}
							}else{
								if (yDay<xDay||yDay==xDay){
								resultado = false;
								}else{
									resultado = true;
								}
							}
						}else{
							resultado = true;
						}
					}
				}else{
					resultado = true;
				}
			}
		}
	}else{
		resultado = true;
	}
	return resultado;
}

/* funcion para mostrar el grid de beneficiarios de la solicitud de cancelacion del socio */
function mostraGridInversionesRelacionadas(varCreditoID){	
	var params = {};
	params['tipoLista']		= 2;
	params['creditoID']		= varCreditoID;
	params['inversionID']	= 0;
	params['clienteID']		= 0;
	$.post("listaInvGarantia.htm", params, function(data){
		if(data.length >0) {		
			$('#gridInversionesRelacionadas').html(data);
			$('#gridInversionesRelacionadas').show();
			funcionValidaSeleccionEliminarInvCre();
		}else{				
			$('#gridInversionesRelacionadas').html("");
			$('#gridInversionesRelacionadas').hide();
		}		
	});
}

function funcionValidaSeleccionEliminarInvCre(){
	setTimeout("$('#cajaLista').hide();", 200);
	var jqradioID			= "";
	var jqCreditoInvGarID	= "";
	var jqinversionIDGrid	= "";
	var numero				= 0;
	var algunoSeleccionado	= false;
	$('tr[name=renglon]').each(function() {
		numero				= this.id.substr(7,this.id.length);
		jqradioID 			= eval("'#radioEliminar" + numero+ "'");
		jqCreditoInvGarID	= eval("'#gridCreditoInvGarID" + numero+ "'");		
		jqinversionIDGrid	= eval("'#listaInversionID" + numero+ "'");		 
		if($(jqradioID).attr('checked')==true){
			$(jqradioID).val("S");			
			algunoSeleccionado = true;
			$('#creditoInvGarID').val($(jqCreditoInvGarID).val());
			$('#inversionID').val($(jqinversionIDGrid).val());
			consultaInversion($(jqinversionIDGrid).val());
		}else{
			$(jqradioID).val("N");
		}		
	});	
	if($('#estatus').val()== "I"){
		if(algunoSeleccionado == true ){
			habilitaBoton('elimina', 'submit');
		}
		$('tr[name=renglon]').each(function() {
			numero				= this.id.substr(7,this.id.length);
			jqradioID 			= "radioEliminar" + numero;
			habilitaControl(jqradioID);
		});	
	}else{
		deshabilitaBoton('elimina', 'submit');
		$('tr[name=renglon]').each(function() {
			numero				= this.id.substr(7,this.id.length);
			jqradioID 			= "radioEliminar" + numero;
			deshabilitaControl(jqradioID);
		});	
	}
}

/* funcion para limpiar el formulario */
function inicializaInvGarantia(){
	$('#creditoID').focus().select();
	
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('elimina', 'submit');
	limpiaCamposInversion();
	limpiaCamposCredito();
}

/* funcion que se ejecuta con una transaccion exitosa*/
function funcionExitoCreditoInv(){
	mostraGridInversionesRelacionadas($('#creditoID').val());
	$('#inversionID').val("");	
	$('#montoInversion').val("");	
	$('#tasa').val("");	
	$('#fechaVencimiento').val("");	
	$('#reinvertir').val("");	
	$('#reinvertirDes').val("");
	$('#montoEnGar').val("");	
	$('#etiqueta').val("");
	$('#montoGarantizado').val("");	
	$('#montoDisponible').val("");

	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('elimina', 'submit');
}

/* funcion que se ejecuta con una transaccion fallida*/
function funcionErrorCreditoInv(){
}

function validaAgregarEliminarInverGar(){
	if($('#tipoTransaccion').val()==catTipoTransaccionInversion.actualiza){ // si se trata de una eliminacion 
		if($('#estatus').val() == "I"){
			procede = true;
		}else{
			mensajeSis('Solo se pueden Eliminar Inversiones en Garantía de Créditos Inactivos.');
			procede = false;
		}
	}else{
		procede = true;
	}
	return procede; 
}


function validaMontos(){
	var bean={
		'inversionID':$('#inversionID').val()
	};
	invGarantiaServicio.consulta(3,bean,function(inverGaran){
		if(inverGaran != null){
			$('#montoGarantizado').val(parseFloat(inverGaran.totalGarInv));
			$('#montoDisponible').val(parseFloat(parseFloat($('#montoInversion').asNumber())-parseFloat(inverGaran.totalGarInv)));
			$('#montoGarantizado').formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
				});
			$('#montoDisponible').formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
				});
		}else{
			$('#montoGarantizado').val("");
			$('#montoDisponible').val("");
		}
	});
}