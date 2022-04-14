var parametroBean = consultaParametrosSession();
var claveUsuario = parametroBean.numeroUsuario;
var promotor = parametroBean.promotorID;
var nomUsuario = parametroBean.nombreUsuario;

$('#claveUsuario').val(claveUsuario);

$('#sucursal').focus();
 
$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var atrasoInicial = 0;
	var atrasoFinal = 99999;
	var parametroBean = consultaParametrosSession();   
	consultaUsuario();

	var catTipoConsultaInstitucion = {
			'principal':1 
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
		$(':text').focus(function() {	
		 	esTab = false;
		});
	
		$.validator.setDefaults({
	      submitHandler: function(event) {	          
 				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','SolicitudCreditoID','funcionExito','funcionError');	    
	      }
		});		
	     
		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});	
	
	consultaSucursal();
	
	$('#promotorID').val(0);
	$('#sucursal').val(0);
	$('#productoCreditoID').val(0);
	$('#nombrePromotor').val('TODOS');	
	$('#nombreSucursal').val('TODAS');
	$('#nomProducto').val('TODOS');

	$('#atrasoInicial').val(atrasoInicial);
	$('#atrasoFinal').val(atrasoFinal);
	
	$('#pdf').attr("checked",true) ; 
	$('#detallado').attr("checked",true) ; 
	validaPromotor(promotor);


	$(':text').focus(function() {	
		esTab = false;
	});

	$('#sucursal').bind('keyup',function(e){
		lista('sucursal', '2', '4', 'nombreSucurs', $('#sucursal').val(), 'listaSucursales.htm');
	});

	$('#sucursal').blur(function() {
		consultaSucursal(this.id);
	});

	$('#productoCreditoID').bind('keyup',function(e) {
		lista('productoCreditoID', '2', '1','descripcion', $('#productoCreditoID').val(),'listaProductosCredito.htm');
	});

	
	$('#promotorID').bind('keyup',function(e){
		lista('promotorID', '1', '1', 'nombrePromotor',
				$('#promotorID').val(), 'listaPromotores.htm');
	});		

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresenacion').show('slow');
		}
	});

	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

	$('#productoCreditoID').blur(function() {
		if($('#productoCreditoID').val()=="0" || $('#productoCreditoID').val()==""){
			$('#productoCreditoID').val("0");
			$('#nomProducto').val("TODOS");

		}else{
			esTab=true;
			consultaProducCredito(this.id);
		}
		
	});

	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		var fechaAplicacion = parametroBean.fechaAplicacion;
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

		if (Yfecha > fechaAplicacion && Yfecha != '') {
						mensajeSis('La fecha Fin no puede ser mayor a la del sistema');
						$('#fechaFin').focus();
						$('#fechaFin').select();
						$('#fechaFin').val('');
					}
	});

	

	$('#generar').click(function(){				
		consultaSolicitudes(function(){
		consultaCanalIngreso();
		});		
		
	});	

	
	$('#formaGenerica').validate({
		rules: {
			fechaInicio :{
				required: true
			},
			fechaFin :{
				required: true
			}
		},
		
		messages: {
			fechaInicio :{
				required: 'Especifica Fecha Inicio.'
			}
			,fechaFin :{
				required: 'Especifica Fecha Fin.'
			}
		}
	});

	// ***********  Inicio  validacion Promotor, Estado, Municipio  ***********

	function validaPromotor(promotor){
		if(promotor!=0){
			$('#promotorID').val(promotor);
			var promotorID = 'promotorID';
			consultaPromotorI(promotorID);
			$("#promotorID").attr('disabled','disabled');			
		}else{
			$('#promotorID').val(0);
			$('#nombrePromotor').val('TODOS');
		}
	}
	function consultaPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'"); 
		var numPromotor = $(jqPromotor).val();	
		var tipConForanea = 2;	
		var promotor = {
				'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor == '' || numPromotor==0){
			$(jqPromotor).val(0);
			$('#nombrePromotor').val('TODOS');
		}
		else	

			if(numPromotor != '' && !isNaN(numPromotor) ){ 
				promotoresServicio.consulta(tipConForanea,promotor,function(promotor) { 
					if(promotor!=null){							
						$('#nombrePromotor').val(promotor.nombrePromotor); 

					}else{
						mensajeSis("No Existe el Promotor");
						$(jqPromotor).val(0);
						$('#nombrePromotor').val('TODOS');
					}    	 						
				});
			}
			else{
					$(jqPromotor).val(0);
					$('#nombrePromotor').val('TODOS');
			}  
	}


	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && numSucursal != 0) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#nombreSucursal').val(sucursal.nombreSucurs);
						} else {							
							mensajeSis("No Existe la Sucursal");
							$('#sucursal').val('0');
							$('#nombreSucursal').val('TODAS');
						}
					});
		}
		else{
			$('#sucursal').val('0');
			$('#nombreSucursal').val('TODAS');
		}
	}

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);


	function consultaProducCredito(idControl) {				
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();		
		var tipConPrincipal = 1;		
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);


		if(ProdCred != '' && !isNaN(ProdCred)){		
			productosCreditoServicio.consulta(tipConPrincipal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){				
					$('#nomProducto').val(prodCred.descripcion);							
				}else{
					mensajeSis("No Existe el Producto de Crédito");
					$('#productoCreditoID').val('0');	
					$('#nomProducto').val('TODOS');	
					$(jqProdCred).focus();	
				}
			});
		}	
		else{
			$('#productoCreditoID').val('0');	
					$('#nomProducto').val('TODOS');	
		}			 					
	}  
	
	function consultaSolicitudes(funcionExito){					
		var params = {};
		params['tipoLista'] = 1;
		params['fechaInicio'] = $('#fechaInicio').val();
		params['fechaFin'] = $('#fechaFin').val();
		params['sucursalID'] = $('#sucursal').val();	
		params['promotorID'] =  $('#promotorID').val();	
		params['estatus'] = $('#estatus').val();	
		params['productoCreditoID'] = $('#productoCreditoID').val();
		params['usuarioID'] = $('#claveUsuario').val();;	
		
			$.post("monitorCantidadSolicitudesGridVista.htm", params, function(data){

				if(data.length >0) {
				bloquearPantallaCarga();	
					$('#divListaEstatus').html(data);
					$('#divListaEstatus').show();	
					$('#fieldsetLisTotal').show();
					$('#fieldsetSolEst').show();
					calculaTotal();

					var numFilas=consultaFilas();
					$('#contenedorForma').unblock(); // desbloquear		
					if(numFilas == 0 ){
						$('#divListaEstatus').html("");
						$('#divListaEstatus').hide();	
						$('#fieldsetLisTotal').hide();
						$('#fieldsetSolEst').hide();
						$('#fieldsetEstSol').show();
						mensajeSis('No se Encontraron Coincidencias');
					}
					else{
						$('#fieldsetEstSol').hide();
					}

							
				}else{				
					$('#divListaEstatus').html("");
					$('#divListaEstatus').hide();
					$('#fieldsetLisTotal').hide();	
					$('#fieldsetSolEst').hide();
					mensajeSis('No se Encontraron Coincidencias');
				}

				
				funcionExito();
				
			});

			
		
	}	

	function consultaCanalIngreso(){					
		var params = {};
		params['tipoLista'] = 3;
		params['fechaInicio'] = $('#fechaInicio').val();
		params['fechaFin'] = $('#fechaFin').val();
		params['sucursalID'] = $('#sucursal').val();	
		params['promotorID'] =  $('#promotorID').val();	
		params['estatus'] = $('#estatus').val();	
		params['productoCreditoID'] = $('#productoCreditoID').val();
		params['usuarioID'] = $('#claveUsuario').val();;						

			$.post("monitorCantidadSolicitudesGridVista.htm", params, function(data){
				if(data.length >0) {	
					$('#divListaCanalIngreso').html(data);
					$('#divListaCanalIngreso').show();	
					$('#fieldsetCanalIngreso').show();
					$('#fieldsetCanalIng').show();
					calculaTotalCI();							
				}else{				
					$('#divListaEstatus').html("");
					$('#divListaCanalIngreso').hide();
					$('#fieldsetCanalIngreso').hide();	
					$('#fieldsetCanalIng').hide();
					mensajeSis('No se Encontraron Coincidencias');
				}


			});
			

			
		
	}	
	
	
	function calculaTotal(){
		var totalSol = 0;
		$("input[name=totalEstUsuario]").each(function(i){			
			var jqSaldo = eval("'#" + this.id + "'");	
			totalSol += parseFloat($(jqSaldo).val());
	
			});
		$('#total').val(totalSol);
	}
	function calculaTotalCI(){
		var totalSol = 0;
		$("input[name=totalCanalIng]").each(function(i){			
			var jqSaldo = eval("'#" + this.id + "'");	
			totalSol += parseFloat($(jqSaldo).val());
	
			});
		$('#totalCI').val(totalSol);
	}
	

	function mayor(fecha, fecha2){

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
});

function consultaDetalle(idControl){
	bloquearPantallaCarga();
	var id = idControl.replace(/\D/g,'');
	var jqValor = eval("'#estatusValor" + id + "'");	
	
	
	var nomValor = $(jqValor).val();	
	$('#estatusSol').val(nomValor);	

	
	if(nomValor == 'SI'){
		$('#textoDetalle').html('Solicitudes Registradas');
	}

	if(nomValor == 'SL'){
		$('#textoDetalle').html('Solicitudes Liberadas');
	}

	if(nomValor == 'SR'){
		$('#textoDetalle').html('Solicitudes Rechazadas');
	}

	if(nomValor == 'SM'){
		$('#textoDetalle').html('Solicitudes en Actualización de Datos');
	}

	if(nomValor == 'SA'){
		$('#textoDetalle').html('Solicitudes Autorizadas');
	}

	if(nomValor == 'SC'){
		$('#textoDetalle').html('Solicitudes Canceladas');
	}

	if(nomValor == 'CI'){
		$('#textoDetalle').html('Créditos Registrados');
	}

	if(nomValor == 'CC'){
		$('#textoDetalle').html('Créditos Condicionados');
	}

	if(nomValor == 'CA'){
		$('#textoDetalle').html('Créditos Autorizados');
	}

	if(nomValor == 'CD'){
		$('#textoDetalle').html('Créditos Desembolsados');
	}


	


		if(nomValor == 'CC'){
			var params = {};
			params['tipoLista'] = 4;
			params['fechaInicio'] = $('#fechaInicio').val();
			params['fechaFin'] = $('#fechaFin').val();
			params['sucursalID'] = $('#sucursal').val();	
			params['promotorID'] =  $('#promotorID').val();	
			params['estatus'] = nomValor;	
			params['productoCreditoID'] = $('#productoCreditoID').val();	
					

				$.post("monitorCantidadSolicitudesGridVista.htm", params, function(data){
					
					if(data.length >0) {	
						$('#divListaDetalle').html(data);
						$('#divListaDetalle').show();	
						$('#fieldsetLisDetalle').show();
						$('#solventar').show();
						$('#guardar').hide();
						verificaSeleccion();

				
								
					}else{				
						$('#divListaDetalle').html("");
						$('#divListaDetalle').hide();
						$('#fieldsetLisDetalle').hide();	
						mensajeSis('No se Encontraron Coincidencias');
					}
					$('#contenedorForma').unblock(); // desbloquear
					$('#fieldsetLisTotal').hide();
				});
		}
		else{
			var params = {};
			params['tipoLista'] = 2;
			params['fechaInicio'] = $('#fechaInicio').val();
			params['fechaFin'] = $('#fechaFin').val();
			params['sucursalID'] = $('#sucursal').val();	
			params['promotorID'] =  $('#promotorID').val();	
			params['estatus'] = nomValor;	
			params['productoCreditoID'] = $('#productoCreditoID').val();	
					
				$.post("monitorCantidadSolicitudesGridVista.htm", params, function(data){
					if(data.length >0) {	
						$('#divListaDetalle').html(data);
						$('#divListaDetalle').show();	
						$('#fieldsetLisDetalle').show();
						$('#solventar').hide();
						consultaComentario();
		                   if(nomValor == 'SL'){
							  $('#guardar').show();
		                   }
		                   else{
							  $('#guardar').hide();
		                   }
								
					}else{				
						$('#divListaDetalle').html("");
						$('#divListaDetalle').hide();
						$('#fieldsetLisDetalle').hide();	
						mensajeSis('No se Encontraron Coincidencias');
					}

					$('#contenedorForma').unblock(); // desbloquear
					$('#fieldsetLisTotal').hide();
				});
		}
		

			
		
	}

	function mostrarFiltros(){
		$('#fieldsetEstSol').show();
		$('#fieldsetLisTotal').hide();
	}

	function mostrarListaEstatus(){

		$('#fieldsetLisTotal').show();
		$('#fieldsetLisDetalle').hide();
	}

	function consultaID(){

		$("input[name=usuarioID]").each(function(i){			
			var jqID = eval("'#" + this.id + "'");	
			var nomValor = $(jqID).val();	
			mensajeSis(nomValor);
	
			});
	}

	function validar(){
		$("input[name=lusuarioID]").each(function(i){			
			var jqID = eval("'#" + this.id + "'");	
			var nomValor = $(jqID).val();	

			var id = jqID.replace(/\D/g,'');

			var renglon = eval("'#renglonSol"+ id+"'");
			
			if(nomValor != claveUsuario){

			 $(renglon).children('td, th').css('background-color','gray');

			}
		});
	}

	$('#solventar').click(function() {		
		var numero = 1;
		$('#tipoTransaccion').val(numero);	
	});

	$('#guardar').click(function() {		
		var numero = 2;
		$('#tipoTransaccion').val(numero);	
		if(llenarDetalle('miTabla')){
 		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','SolicitudCreditoID','funcionExitoAnalista','funcionError');	  
		}
	});

	function verificaSeleccion(){
		var NumSeleccionados = 0;
		NumSeleccionados = cuentaSeleccionados();
		if(NumSeleccionados>=1){
			habilitaBoton('solventar', 'submit');
		}else{
			deshabilitaBoton('solventar', 'submit');
		}	
	}

	function cuentaSeleccionados(){
		var numero = 0;
		$("input[name=checkSol]").each(function(i){		

				var jqValida = eval("'#" + this.id + "'");	
				var id = jqValida.replace(/\D/g,'');			
				if ($(jqValida).is(':checked')) {
					numero = numero+1;
					$('#valorSolventar'+id).val('S');
				}else{
				
					$('#valorSolventar'+id).val('N');
				}
				
			});
		return numero;
	}

	function bloquearPantallaCarga() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});

}


function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;
		
	});
	return totales;
}


//Función de éxito en la transación
function funcionExito(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert);
			$('#fieldsetLisTotal').hide();
			$('#fieldsetLisDetalle').hide(); 
			$('#fieldsetEstSol').show(); 
			limpiarPantalla();
			$('#fieldsetEstSol').show();
			
			
		}
        }, 50);
	}

}
function funcionExitoAnalista(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert);
		}
        }, 50);
	}

}

//función de error en la transacción
function funcionError(){
	var mensajeError = $('#numeroMensaje').val(); 	
}

function limpiarPantalla(){
	inicializa();
	 var removertabla = document.getElementById("miTabla"); 
	   if(removertabla.rows.length>=1){ 
	   		var conta=removertabla.rows.length; 
	   		for(var i=0;i<conta; i++){
	   			document.getElementById("miTabla").deleteRow(0);
	   		}
	   	}
		
}

function inicializa(){

	$('#promotorID').val(0);
	$('#sucursal').val(0);
	$('#productoCreditoID').val(0);
	$('#nombrePromotor').val('TODOS');	
	$('#nombreSucursal').val('TODAS');
	$('#nomProducto').val('TODOS');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#fieldsetLisTotal').hide();
	$('#fieldsetLisDetalle').hide(); 
	$('#fieldsetEstSol').hide();

}

function mostrarPantalla(idControl){
	var id = idControl.replace(/\D/g,'');	
	var solID = eval("'#solicitudCreditoID" + id + "'"); 
	var credID = eval("'#creditoID" + id + "'"); 
		
	var solicitudCreditoID = $(solID).val();
	var creditoID = $(credID).val();
	
	
	var estatus = $('#estatusSol').val();

	
	
	if(estatus == 'SI'){
		if ($(this).attr("href") != undefined ){ 
			$('#numSolicitud').val(solicitudCreditoID);
			consultaSolicitudCredito();
			limpiarPantalla();
		}
		$(this).removeAttr("href");
	}

	if(estatus == 'SL'){

		if ($(this).attr("href") != undefined ){ 
			$('#numSolicitud').val(solicitudCreditoID);
			autorizaSolicitudCredito();
			limpiarPantalla();
		}
		$(this).removeAttr("href");
	}
	
	if(estatus == 'SM'){
		if ($(this).attr("href") != undefined ){ 
			$('#numSolicitud').val(solicitudCreditoID);
			consultaSolicitudCredito();
			limpiarPantalla();
		}
		$(this).removeAttr("href");
	}
	
	if(estatus == 'SR'){
		if ($(this).attr("href") != undefined ){ 
			$('#numSolicitud').val(solicitudCreditoID);
			consultaSolicitudCredito();
			limpiarPantalla();
		}
		$(this).removeAttr("href");
	}
	
	if(estatus == 'SC'){
		if ($(this).attr("href") != undefined ){ 
			$('#numSolicitud').val(solicitudCreditoID);
			consultaSolicitudCredito();
			limpiarPantalla();
		}
		$(this).removeAttr("href");
	}
	
	if(estatus == 'SA'){

		if ($(this).attr("href") != undefined ){ 
			$('#numSolicitud').val(solicitudCreditoID);
			registroCredito();
			limpiarPantalla();
		}
		$(this).removeAttr("href");
	}
	if(estatus == 'CI'){

		if ($(this).attr("href") != undefined ){ 
			$('#numSolicitud').val(creditoID);
			mesaControl();
			limpiarPantalla();
		}
		$(this).removeAttr("href");
	}
	if(estatus == 'CA'){

		if ($(this).attr("href") != undefined ){ 
			$('#numSolicitud').val(creditoID);
			desembolsoCredito();
			limpiarPantalla();
		}
		$(this).removeAttr("href");
	}
	if(estatus == 'CD'){

		if ($(this).attr("href") != undefined ){ 
			$('#numSolicitud').val(creditoID);
			consultaCredito();
			limpiarPantalla();
		}
		$(this).removeAttr("href");
	}
}

function consultaSolicitudCredito(){		
		$('#solicitud').load("catalogoSolicitudCredito.htm");		
		
}	

function autorizaSolicitudCredito(){

		$('#solicitud').load("autorizaSolicitudCredito.htm");
		
}
function registroCredito(){

		$('#solicitud').load("catalogoCreditos.htm");
		
}
function mesaControl(){

		$('#solicitud').load("autorizaCreditos.htm");
		
}
function desembolsoCredito(){

		$('#solicitud').load("catalogoDesembolsoCredito.htm");
		
}
function consultaCredito(){

	$('#solicitud').load("consultaCreditos.htm");
	
}
function muestraComentario(idControl){	
	var id = idControl.replace(/\D/g,'');	
	var idComentario = eval("'#comentarioSol" + id + "'");
	var valorComentario =	$(idComentario).val();

	if(valorComentario != ''){
		if( $(idComentario).is(":visible")){
   			$(idComentario).hide();
		}else{
    		$(idComentario).show();
		}
	}

	


}

function seleccionaTodas(){
	$('input[name=checkSol]').each(function() {		
		var menuID = eval("'#" + this.id + "'");	
		var numMenuID= $(menuID).val();					
		var checked = eval("'#checkSol" + numMenuID + "'");					
		if( $('#selecTodas').is(":checked") ){
		   	$(menuID).attr('checked','true');
		   	$(menuID).val('S'); 
          	$("input[name=valorSolventar]").each(function(i){			
			var jqEstatus = eval("'#" + this.id + "'");	
			$(jqEstatus).val('S');						
		});
          	habilitaBoton('procesar', 'submit');
       	}else{
		   $(menuID).removeAttr('checked');
      		$(menuID).val('N'); 
       		$("input[name=valorSolventar]").each(function(i){			
			var jqEstatus = eval("'#" + this.id + "'");	
			$(jqEstatus).val('N');						
		});
       	deshabilitaBoton('procesar', 'submit');
   	}
});
	verificaSeleccion();
			
			
}


function consultaComentario(){
	$('textarea[name=lcomentario]').each(function() {		
		var valorID = eval("'#" + this.id + "'");
		var id = valorID.replace(/\D/g,'');	
		var comentarioID= $(valorID).val();		

		var imgComentario = eval("'#imgComentario" + id + "'");
		if(comentarioID != "")	{
			$(imgComentario).show();
		}
		else{
			$(imgComentario).hide();
		}
		
        
   	});
			
			
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


/**
 * Función arma la cadena con los detalles del grid.
 * @param idControl : ID de algún campo para obtener el ID de la tabla.
 * @returns {Boolean}
 * @author ctomas
 */
function llenarDetalle(idControl){

	var idTablaParametrizacion ='miTabla';
	var idDetalle = '';
	var validar = true;

		idDetalle ='#detalleEstatus';

	$('#detalleEstatus').val('');
    $('.rfinal').each(function(index){  	
		if(index>=0){
			var solicitudCreID = "#"+$(this).find("input[name^='solicitudCreditoID']").attr("id");
			var estatus = "#"+$(this).find("select[name^='estatusSolicitud']").attr("id");
            var solCreID = $(solicitudCreID).val();
			var tipoEstatus = $(estatus).val();
			if (index == 1) {
				$(idDetalle).val( $(idDetalle).val()+
				solCreID+']'+ tipoEstatus+']');
			} else{
				$(idDetalle).val( $(idDetalle).val()+'['+
				solCreID+']'+ tipoEstatus+'][');
			}
		}
	});
	return true;
}

function consultaUsuario(){
		var numUsuario = parametroBean.numeroUsuario;
		if(numUsuario != '' && !isNaN(numUsuario)){
		
				var usuarioBeanCon = {
						'usuarioID':numUsuario
				};
				usuarioServicio.consulta(20,usuarioBeanCon,{ async: false, callback:function(usuario) {
					if(usuario!=null){
						desOcultarBotonGuardar();
					}else{
						ocultarBotonGuardar();
					}
				}});
			  
		}
}

	//funcion para ocultar boton
function ocultarBotonGuardar(){
		$('#guardar').hide();
		deshabilitaBoton('guardar', 'submit');
}
	//funcion para ocultar boton
function desOcultarBotonGuardar(){
		$('#guardar').show();
	habilitaBoton('guardar', 'submit');
}