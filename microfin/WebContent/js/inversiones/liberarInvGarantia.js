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
var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	// Definicion de Constantes y Enums	
	catTipoTransaccionInversion = {
	  		'agrega'	:1,
	  		'actualiza': 2
	};
	
	catTipoActualizacionInversion = {
			'elimina'	:1,
			'libera'	:2,
	};


	catTipoConsultaInversion = {
			'principal' : 1
	};
	resultado	= false;
	procede		= false;

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	/* se manda a llamar funcion para inicializar el formulario */
	inicializaLiberaInvGarantia();
	
	//-- Haciendo la transaccion
	$.validator.setDefaults({
		submitHandler: function(event) {
			if(validarSubmitLiberar() &&  funcionValidaSeleccionLiberarInvCre()){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'funcionExitoLiberaInvGar', 'funcionErrorLiberaInvGar');
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
	
	$('#elimina').click(function(  ){
		$('#tipoTransaccion').val(catTipoTransaccionInversion.actualiza);
		$('#tipoActualizacion').val(catTipoActualizacionInversion.libera);
	});
	
	$('#radioCredito').click(function(){		
		$('#radioCredito').focus();
		$('#radioCredito').attr("checked",true);
		$('#radioInversion').attr("checked",false);
		$('#creditoInversion').val("C");		
		mostrarSeccionCreditos();
	});
	
	$('#radioInversion').click(function(){		
		$('#radioInversion').focus();
		$('#radioInversion').attr("checked",true);
		$('#radioCredito').attr("checked",false);
		$('#creditoInversion').val("I");
		mostrarSeccionInversiones();
	});
		
	$('#creditoID').bind('keyup',function(e){
		/* lista los creditos: AUTORIZADOS, VIGENTES O VENCIDOS, que su producto de credito indique que requiere garantia liquida
		y que tengan alguna inversion en garantia . */
		var tipoListaPrincipal = 4;
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "creditoID";
		camposLista[1] = "inversionID";
		camposLista[2] = "nombreCliente";
		camposLista[3] = "clienteID";
		parametrosLista[0] = 0;
		parametrosLista[1] = 0;	
		parametrosLista[2] = $('#creditoID').val();
		parametrosLista[3] = 0;	
		lista('creditoID', 0, tipoListaPrincipal, camposLista, parametrosLista, 'listaInvGarantia.htm');
	});
	
	$('#creditoID').blur(function (){
		consultaCredito($('#creditoID').val()); // funcion para consultar el credito 
	});
	
	$('#inversionID').bind('keyup',function(e){
		/* lista las inversiones que tengan relacionado algun credito  en garantia . */
		var tipoListaPrincipal = 5;
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "creditoID";
		camposLista[1] = "inversionID";
		camposLista[2] = "nombreCliente";
		camposLista[3] = "clienteID";
		parametrosLista[0] = 0;
		parametrosLista[1] = 0;	
		parametrosLista[2] = $('#inversionID').val();
		parametrosLista[3] = 0;	
		lista('inversionID', 0, tipoListaPrincipal, camposLista, parametrosLista, 'listaInvGarantia.htm');
	});

	$('#inversionID').blur(function (){
		consultaInversion($('#inversionID').val());// funcion para consultar la inversion 
	});
	
	$('#liberar').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionInversion.actualiza);
		$('#tipoActualizacion').val(catTipoActualizacionInversion.libera);
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			inversionID : {
				required : function() {return $('#radioInversion').is(':checked'); }
			},
			creditoID : {
				required : function() {return $('#radioCredito').is(':checked'); }
			}
		},
		messages: {
			inversionID: 'Especifique número de Inversión',
			creditoID: 'Especifique número de Crédito'
		}
	});
	

});

/* valida si el credito tiene inversiones en garantia */
function validaCreditoEnGarantia(numCredito){
	varGarantizadoInv = 0;
	var bean={
		'creditoID':numCredito
	};
	invGarantiaServicio.consulta(4,bean,function(inverGaran){
		if(inverGaran != null){
			mostraGridInversionesRelacionadas(numCredito);
		}else{
			mensajeSis("El Crédito Indicado no tiene Inversiones en Garantía.");

			$('#gridCreditosRelacionados').hide();	
			$('#gridCreditosRelacionados').html("");
			$('#gridInversionesRelacionadas').hide();	
			$('#gridInversionesRelacionadas').html("");	
		}
	});
}

/* funcion para consultar el crédito*/
function consultaCredito(numCre){ 
	if(numCre > 0 && !isNaN(numCre) &&  numCre.length <= 9 ){
		var bean={
				'creditoID':numCre
		};
		var tipoConsultaCreditoPrincipal = 1;
		creditosServicio.consulta(tipoConsultaCreditoPrincipal, bean, function(credito){
			if(credito!=null){
				$('#creditoID').val(credito.creditoID);
				$('#proCre').val(credito.producCreditoID);
				$('#montoCredito').val(credito.montoCredito);
				$('#montoCredito').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});
				$('#fechaIniCre').val(credito.fechaInicio);
				$('#fechaVenCre').val(credito.fechaVencimien);
				$('#clienteID').val(credito.clienteID);
				$('#estatusCre').val(credito.estatus).selected = true;
				
				$('#porcentajeGarantia').val(credito.porcGarLiq);
				$('#garantiaRequerida').val(credito.aporteCliente);
				$('#ahorroGarantia').val(credito.montoGLAho);
				$('#inverGarantia').val(credito.montoGLInv);

				$('#totalGarantizado').val(credito.montoGarLiq);	
				 
				$('#porcentajeGarantia').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 4	
				});
				$('#montoGarantia').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});
				$('#ahorroGarantia').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});
				$('#inverGarantia').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});
				$('#totalGarantizado').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});
				consultaProductoCredito(credito.producCreditoID);
				consultaNombreCliente(credito.clienteID); // /* consulta nombre del cliente*/
				validaCreditoEnGarantia(credito.creditoID);
			}else{
				mensajeSis('El Crédito No Existe.');
				limpiaSeccionCreditos();
				limpiaSeccionSocio();
				limpiaSeccionInversion();
				$('#creditoID').val("");
				$('#creditoID').focus();
				$('#gridCreditosRelacionados').hide();	
				$('#gridCreditosRelacionados').html("");
				$('#gridInversionesRelacionadas').hide();	
				$('#gridInversionesRelacionadas').html("");	
			}
		});
	}else{
		if(!isNaN(numCre) && numCre!=''){
			inicializaLiberaInvGarantia();
			$('#gridCreditosRelacionados').hide();	
			$('#gridCreditosRelacionados').html("");
			$('#gridInversionesRelacionadas').hide();	
			$('#gridInversionesRelacionadas').html("");	
		}
	}
}


/* funcion para consultar el producto de credito*/
function consultaProductoCredito(varProductoCredito){
	var beanprocre={
			'producCreditoID':varProductoCredito
	};
	var tipoConsultaProCrePincipal = 1;
	productosCreditoServicio.consulta(tipoConsultaProCrePincipal,beanprocre,function(proCre){
		if(proCre != null){
			$('#nombreProCre').val(proCre.descripcion);
		}
	});
}


/* consulta nombre del cliente*/
function consultaNombreCliente(varClienteID){
	clienteServicio.consulta(1,varClienteID,"",function(cliente){
		if(cliente != null){
			if(Number(cliente.numero) >= 0){
				$('#nombreCli').val(cliente.nombreCompleto);
				$('#fechaNacimiento').val(cliente.fechaNacimiento);
				$('#sucursalID').val(cliente.sucursalOrigen);
				$('#rfc').val(cliente.RFC);
				$('#fechaIngreso').val(cliente.fechaAlta);
				if(cliente.tipoPersona == 'F'){
					$('#tipoPersona').val('FÍSICA');
				}else{
					if(cliente.tipoPersona == 'A'){
						$('#tipoPersona').val('FÍSICA ACT. EMP.');
					}else{
						$('#tipoPersona').val('MORAL');
					}
				}	
				$('#curp').val(cliente.CURP);
				$('#edad').val(cliente.edad);
				consultaSucursal(cliente.sucursalOrigen);
			}
		}
	});
}

/* valida si las inversiones estan respaldando a un credito  */
function validaInversionEnGarantia(numInversion){
	varGarantizadoInv = 0;
	var bean={
		'inversionID':numInversion
	};
	invGarantiaServicio.consulta(5,bean,function(inverGaran){
		if(inverGaran != null){

			mostraGridCreditosRelacionados(numInversion);
		}else{
			mensajeSis("La Inversión Indicada no esta Respaldando Créditos");

			$('#gridCreditosRelacionados').hide();	
			$('#gridCreditosRelacionados').html("");
			$('#gridInversionesRelacionadas').hide();	
			$('#gridInversionesRelacionadas').html("");	
		}
	});
}

//funcion para consultar inversiones
function consultaInversion(invnumb){
	setTimeout("$('#tablaLista').hide()",200);
	if(invnumb > 0 && !isNaN(invnumb) &&  invnumb.length <= 9 ){
		var InversionBean = {
				'inversionID' :  $('#inversionID').val()
		};
		inversionServicioScript.consulta(1, InversionBean, function(inversionCon){
			if(inversionCon!=null){
				$('#montoInversion').val(inversionCon.monto);
				$('#fechaVencimientoInver').val(inversionCon.fechaVencimiento);
				$('#estatusInv').val(inversionCon.estatus).selected = true;
				$('#montoInversion').formatCurrency({
					positiveFormat: '%n', 
					roundToDecimalPlace: 2	
				});
				$('#clienteID').val(inversionCon.clienteID);
				consultaNombreCliente(inversionCon.clienteID); // /* consulta nombre del cliente*/
				validaInversionEnGarantia($('#inversionID').val());
			}else{	
				mensajeSis('La Inversión No Existe.');
				deshabilitaBoton('liberar', 'submit');
				$('#inversionID').focus();
				$('#inversionID').val("");
				limpiaSeccionCreditos();
				limpiaSeccionSocio();
				limpiaSeccionInversion();
				$('#creditoID').val("");
				$('#creditoID').focus();
				$('#gridCreditosRelacionados').hide();	
				$('#gridCreditosRelacionados').html("");
				$('#gridInversionesRelacionadas').hide();	
				$('#gridInversionesRelacionadas').html("");	
			}
		});
	}else{
		if(invnumb > 0 && !isNaN(invnumb) &&  invnumb.length >= 9 ){
			mensajeSis('La Inversión No Existe.');
			deshabilitaBoton('liberar', 'submit');
			$('#inversionID').focus();
			$('#inversionID').val("");
			limpiaSeccionCreditos();
			limpiaSeccionSocio();
			limpiaSeccionInversion();
			$('#creditoID').val("");
			$('#creditoID').focus();
			$('#gridCreditosRelacionados').hide();	
			$('#gridCreditosRelacionados').html("");
			$('#gridInversionesRelacionadas').hide();	
			$('#gridInversionesRelacionadas').html("");	
		}
	}
}

/* consulta la sucursal del socio*/
function consultaSucursal(numSucursal) {
	var conSucursal = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
		sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
			if (sucursal != null) {
				$('#nombreSucursal').val(sucursal.nombreSucurs);
			}
		});
	}
}

/* funcion para mostrar la seccion de los creditos */
function mostrarSeccionCreditos(){
	$('#divCredito').show();
	$('#situacionGarantia').show();
	$('#divInversion').hide();	
	$('#gridCreditosRelacionados').hide();	
	$('#gridCreditosRelacionados').html("");
	limpiaSeccionSocio();
	limpiaSeccionInversion();
}

/* funcion para mostrar la seccion de las inversiones */ 
function mostrarSeccionInversiones(){
	$('#divInversion').show();
	$('#divCredito').hide();
	$('#situacionGarantia').hide();
	limpiaSeccionSocio();
	limpiaSeccionCreditos();	
	$('#gridInversionesRelacionadas').hide();	
	$('#gridInversionesRelacionadas').html("");	
}

/* funcion para mostrar el grid de inversiones relacionadas a un credito */
function mostraGridInversionesRelacionadas(varCreditoID){	
	var params = {};
	params['tipoLista']		= 6;
	params['creditoID']		= varCreditoID;
	params['inversionID']	= 0;
	params['clienteID']		= 0;
	$.post("listaInvGarantia.htm", params, function(data){
		if(data.length >0) {		
			$('#gridInversionesRelacionadas').html(data);
			$('#gridInversionesRelacionadas').show();
			funcionValidaSeleccionLiberarInvCre();
		}else{				
			$('#gridInversionesRelacionadas').html("");
			$('#gridInversionesRelacionadas').hide();
		}		
	});
}

/* funcion para mostrar el grid de creditos relacionados a una inversion */
function mostraGridCreditosRelacionados(varInversion){	
	var params = {};
	params['tipoLista']		= 3;
	params['creditoID']		= 0;
	params['inversionID']	= varInversion;
	params['clienteID']		= 0;
	$.post("listaInvGarantia.htm", params, function(data){
		if(data.length >0) {		
			$('#gridCreditosRelacionados').html(data);
			$('#gridCreditosRelacionados').show();
			funcionValidaSeleccionLiberarInvCre();
		}else{				
			$('#gridCreditosRelacionados').html("");
			$('#gridCreditosRelacionados').hide();
		}		
	});
}


function funcionValidaSeleccionLiberarInvCre(){
	setTimeout("$('#cajaLista').hide();", 200);
	var jqCheckID			= "";
	var jqCreditoInvLis		= "";
	var jqCreditoInvGrid	= "";
	var jqMontoEnGar		= "";
	var numero				= 0;
	var montoEnGarTotal		= 0;
	var algunoSeleccionado	= false;
	$('tr[name=renglon]').each(function() {
		numero				= this.id.substr(7,this.id.length);
		jqCheckID 			= eval("'#listaCheckLiberar" + numero+ "'");
		jqCreditoInvGrid	= eval("'#gridCreditoInvGarID" + numero+ "'");
		jqCreditoInvLis		= eval("'#listaCreditoInvGarID" + numero+ "'");
		jqMontoEnGar		= eval("'#montoEnGar" + numero+ "'");
		
		if($(jqCheckID).attr('checked')==true){
			$(jqCheckID).val("S");			
			$(jqCreditoInvLis).val($(jqCreditoInvGrid).val());
			montoEnGarTotal = parseFloat(montoEnGarTotal)+parseFloat($(jqMontoEnGar).asNumber());
			algunoSeleccionado = true;
		}else{
			$(jqCheckID).val("N");
			$(jqCreditoInvLis).val(0);		
		}		
	});	
	
	if(algunoSeleccionado == true ){
		habilitaBoton('liberar', 'submit');
		$('#totalInver').val(montoEnGarTotal);
		$('#totalInver').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
	}else{
		deshabilitaBoton('liberar', 'submit');
	}
	return algunoSeleccionado;
		
}

function funcionValidaSeleccionLiberarCre(){
	
}

/* funcion para limpiar el formulario */
function inicializaLiberaInvGarantia(){
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('liberar', 'submit');
	limpiaSeccionCreditos();
	
	/* se ocultan las secciones */
	$('#radioCredito').focus();
	$('#radioCredito').attr("checked",true);
	$('#radioInversion').attr("checked",false);
	$('#creditoInversion').val("C");		
	mostrarSeccionCreditos();

	parametroBean = consultaParametrosSession();
	$('#fechaOperacion').val(parametroBean.fechaSucursal);	
}

/* funcion para limpiar la seccion de creditos*/
function limpiaSeccionCreditos(){
	$('#creditoID').val("");
	$('#estatusCre').val("").selected = true;
	$('#fechaIniCre').val("");
	$('#fechaVenCre').val("");
	$('#proCre').val("");
	$('#nombreProCre').val("");
	$('#montoCredito').val("");
	$('#ahorroGarantia').val("");
	$('#porcentajeGarantia').val("");
	$('#inverGarantia').val("");
	$('#garantiaRequerida').val("");
	$('#totalGarantizado').val("");
}

/* funcion para limpiar la seccion de socios*/
function limpiaSeccionSocio(){
	$('#clienteID').val("");
	$('#nombreCli').val("");
	$('#fechaNacimiento').val("");
	$('#sucursalID').val("");
	$('#nombreSucursal').val("");
	$('#rfc').val("");
	$('#fechaIngreso').val("");
	$('#tipoPersona').val("");
	$('#curp').val("");
	$('#edad').val("");
}

/* funcion para limpiar la seccion de inversiones*/
function limpiaSeccionInversion(){
	$('#inversionID').val("");
	$('#montoInversion').val("");
	$('#fechaVencimientoInver').val("");
	$('#estatusInv').val("").selected = true;
}

/* funcion que se ejecuta con una transaccion exitosa*/
function funcionExitoLiberaInvGar(){
	if($('#radioCredito').attr('checked')==true){
		$('#creditoID').focus();
		$('#radioCredito').attr("checked",true);
		$('#radioInversion').attr("checked",false);
		$('#creditoInversion').val("C");		
		mostrarSeccionCreditos();
		consultaCredito($('#creditoID').val()); // funcion para consultar el credito 
	}else{
		if($('#radioInversion').attr('checked')==true){
			$('#inversionID').focus();
			$('#radioInversion').attr("checked",true);
			$('#radioCredito').attr("checked",false);
			$('#creditoInversion').val("I");
			mostrarSeccionInversiones();
			consultaInversion($('#inversionID').val());// funcion para consultar la inversion 
		}		
	}		
}

/* funcion que se ejecuta con una transaccion fallida*/
function funcionErrorLiberaInvGar(){
	
}

/* Funcion para validar los datos al liberar */
function validaLiberarInversion(){
	var procedeSubmit = false;
	var confirmar=confirm("¿Realmente Desea Liberar la(s) Garantía(s) Seleccionada(s)?\nEl(los) Crédito(s) Quedará(n) Desprotegido(s).");
	if (confirmar == true) {
		// si pulsamos en aceptar
		procedeSubmit = true;
	}else{
		procedeSubmit = false; 
	} 	
	return procedeSubmit;
}


/* Funcion para validar los datos al liberar */
function validaLiberarCredito(){
	var procedeSubmit = false;
	var confirmar=confirm("¿Realmente Desea Liberar el Monto:$"+$('#totalInver').val()+"? \nEl Crédito Quedará Desprotegido.");
	if (confirmar == true) {
		// si pulsamos en aceptar
		procedeSubmit = true;
	}else{
		procedeSubmit = false; 
	} 	
	return procedeSubmit;
}

function validarSubmitLiberar(){
	var procedeSubmit = false;
	if($('#radioCredito').attr('checked')==true){
		procedeSubmit= validaLiberarCredito();
	}else{
		if($('#radioInversion').attr('checked')==true){
			procedeSubmit= validaLiberarInversion();
		}		
	}
	return procedeSubmit;
} 