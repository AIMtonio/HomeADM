$(document).ready(function(){
	esTab = false;
	
	var catTipoTransaccionEmisionNoti = {
	  		'emitir':'1'
	};	
	
	agregaFormatoControles('formaGenerica');
	inicializaParametros();
	
	$('#sucursalID').focus();
	
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
	    	 if(consultaNumFilasSelec()>0){
	    		 grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','sucursalID','funcionExito','funcionError');	
	  		}else{			
	  			alert('No selecciono un Crédito');
	  		}
	     
	      }
	   });	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {				
		},
		messages: {				
		}		
	});
	
	$('#sucursalID').blur(function() {
		if(esTab){
			validaSucursal();
		}
  		
	});

	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '3', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	
	$('#diasAtrasoIni').blur(function(){
		if(esTab){
			if($('#diasAtrasoFin').asNumber() > 0 && $('#diasAtrasoIni').asNumber() > $('#diasAtrasoFin').asNumber()){
				alert('El número de días de  Atraso Inicial no pueden ser Mayor a el número días de Atraso Final');
				$('#diasAtrasoIni').val('0');
				$('#diasAtrasoIni').focus();
			}
		}
	});
	
	$('#diasAtrasoFin').blur(function(){
		if(esTab){
			if($('#diasAtrasoIni').asNumber() > 0  && $('#diasAtrasoFin').asNumber() < $('#diasAtrasoIni').asNumber()){
				alert('El número de días de  Atraso Final no pueden ser Menor a el número de días de Atraso Inicial');
				$('#diasAtrasoFin').val('');
				$('#diasAtrasoFin').focus();
			}
		}
		
	});
		
	$('#buscar').click(function(){
		$('#divListaCreditos').html("");
		$('#divListaCreditos').hide();	
		$('#fieldsetLisCred').hide();
		
		if($('#estCredBusq').val() == ''){
			$('#estCredBusq').focus();
			alert('Seleccione un Estatus');
		}else{
			if($('#diasAtrasoFin').asNumber() < $('#diasAtrasoIni').asNumber()){
				$('#diasAtrasoFin').focus();
				$('#diasAtrasoFin').val('');
				alert('El número de días de  Atraso Final deben ser Mayor o Igual a el número de días de Atraso Inicial');
			}else{
				if($('#limiteRenglones').asNumber() <= 0 || $('#limiteRenglones').val() == ''){
					$('#limiteRenglones').focus();
					$('#limiteRenglones').val('');
					alert('Especifique un Límite de Renglones');
				}else{

					bloquearPantallaCarga();
					consultaGridCreditos();
				}						
			}
		}		
	});
	
	$('#emitir').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionEmisionNoti.emitir);		
	});
	
	
	//********************
	
	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});
	
	$('#estadoID').blur(function() {
		if(esTab){
			consultaEstado(this.id);
		}
  		
	});
	
	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		
		if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0 ){
			lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
		}else{
			if($('#municipioID').val().length >= 3){
				$('#estadoID').focus();
				$('#municipioID').val('0');
				$('#nombreMunicipio').val('TODOS');
				alert('Especificar Estado');
			}			
		}		
	});
	
	$('#municipioID').blur(function() {
		if(esTab){
			consultaMunicipio(this.id);
		}
  		
	});
	
	$('#localidadID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#localidadID').val();
		
		if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0){
			if($('#municipioID').val() != '' && $('#municipioID').asNumber() > 0){
				lista('localidadID', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
			}else{
				if($('#localidadID').val().length >= 3){
					$('#municipioID').focus();
					$('#localidadID').val('0');
					$('#nombreLocalidad').val('TODAS');
					alert('Especificar Municipio');
				}
			}
		}else{
			if($('#localidadID').val().length >= 3){
				$('#estadoID').focus();
				$('#localidadID').val('0');
				$('#nombreLocalidad').val('TODAS');
				alert('Especificar Estado');
			}
		}
		
		
	});

	$('#localidadID').blur(function() {
		if(esTab){
			consultaLocalidad(this.id);
		}
		
	});
	
	$('#coloniaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "asentamiento";		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#coloniaID').val();
		
		if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0){
			if($('#municipioID').val() != '' && $('#municipioID').asNumber() > 0){
				lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
			}else{
				if($('#coloniaID').val().length >= 3){
					alert('Especificar Municipio');
					$('#municipioID').focus();
					$('#coloniaID').val('0');
					$('#nombreColonia').val('TODAS');
				}
			}
		}else{
			if($('#coloniaID').val().length >= 3){
				alert('Especificar Estado');
				$('#estadoID').focus();
				$('#coloniaID').val('0');
				$('#nombreColonia').val('TODAS');
			}
		}
		
		
	});
	
	$('#coloniaID').blur(function() {
		if(esTab){
			consultaColonia(this.id);			
		}
	});
	
	
	//Función que consulta los datos del estado 
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && numEstado > 0){
			estadosServicio.consulta(tipConForanea,numEstado,{ async: false, callback: function(estado) {
				if(estado!=null){							
					$('#nombreEstado').val(estado.nombre);
				}else{
					$('#nombreEstado').val("TODOS");
					$('#estadoID').val("0");
					$('#estadoID').focus();
					$('#estadoID').select();
					alert("No Existe el Estado");
				}    	 						
			}});
		}else{
			if(isNaN(numEstado)){
				$('#nombreEstado').val("TODOS");
				$('#estadoID').val("0");
				$('#estadoID').focus();
				$('#estadoID').select();
				alert("No Existe el Estado");
			}else{
				if(numEstado == '' || numEstado == 0){
					$('#nombreEstado').val("TODOS");
					$('#estadoID').val("0");					
				}
			}
		}
	}	
	
	//Función que consulta los datos del municipio
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
					
		if(numMunicipio != '' && !isNaN(numMunicipio) && numMunicipio > 0){	
			if(numEstado !='' && numEstado > 0 ){
					municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,{ async: false, callback: function(municipio) {
						if(municipio!=null){							
							$('#nombreMunicipio').val(municipio.nombre);
						}else{
							alert("No Existe el Municipio");
							$('#nombreMunicipio').val("TODOS");
							$('#municipioID').val("0");
							$('#municipioID').focus();
							$('#municipioID').select();
						}    	 						
					}});	

			}else{
				$('#nombreMunicipio').val("TODOS");
				$('#municipioID').val("0");
				$('#estadoID').focus();
				alert("Especificar Estado");
			}
		}else{
			if(isNaN(numMunicipio)){
				alert("No Existe el Municipio");
				$('#nombreMunicipio').val("TODOS");
				$('#municipioID').val("0");
				$('#municipioID').focus();
				$('#municipioID').select();
					
			}else{
				if(numMunicipio == '' || numMunicipio == 0){
					$('#nombreMunicipio').val("TODOS");
					$('#municipioID').val("0");			
				}
			}
		}
	}	
	
	//Función que consulta los datos de la localidad
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numLocalidad != '' && !isNaN(numLocalidad) && numLocalidad > 0){
			if(numEstado != '' && numEstado > 0 ){
				if(numMunicipio !='' && numMunicipio > 0){
					localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,{ async: false, callback: function(localidad) {
						if(localidad!=null){							
							$('#nombreLocalidad').val(localidad.nombreLocalidad);
						}else{
							$('#nombreLocalidad').val("TODAS");
							$('#localidadID').val("0");
							$('#localidadID').focus();
							$('#localidadID').select();
							alert("No Existe la Localidad");
						}    	 						
					}});
				}else{
					$('#nombreLocalidad').val("TODAS");
					$('#localidadID').val("0");
					$('#municipioID').focus();
					alert("Especificar Municipio");
				}
			}else{
				$('#nombreLocalidad').val("TODAS");
				$('#localidadID').val("0");
				$('#estadoID').focus();	
				alert("Especificar Estado");										
			}	
		}else{
			if(isNaN(numLocalidad)){
				alert("No Existe la Localidad");
				$('#nombreLocalidad').val("TODAS");
				$('#localidadID').val("0");
				$('#localidadID').focus();
				$('#localidadID').select();
			}else{
				if(numLocalidad == '' || numLocalidad == 0){
					$('#nombreLocalidad').val("TODAS");
					$('#localidadID').val("0");		
				}
			}
		}
		
		
			
		
	}
	//Función que consulta los datos de la Colonia
	function consultaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#estadoID').val();	
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
				
		if(numColonia != '' && !isNaN(numColonia) && numColonia > 0){
			if(numEstado != '' && numEstado > 0 ){
				if(numMunicipio !='' && numMunicipio > 0){
					coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
							if(colonia!=null){							
								$('#nombreColonia').val(colonia.asentamiento);
							}else{
								alert("No Existe la Colonia");
								$('#nombreColonia').val("TODAS");
								$('#coloniaID').val("0");
								$('#coloniaID').focus();
								$('#coloniaID').select();
							}    	 						
						}});
				}else{
					$('#nombreColonia').val("TODAS");
					$('#coloniaID').val("0");
					$('#municipioID').focus();
					alert("Especificar Municipio");
				}
			}else{
				$('#nombreColonia').val("TODAS");
				$('#coloniaID').val("0");
				$('#estadoID').focus();	
				alert("Especificar Estado");										
			}			
		}else{
			if(isNaN(numColonia)){
				alert("No Existe la Colonia");
				$('#nombreColonia').val("TODAS");
				$('#coloniaID').val("0");
				$('#coloniaID').focus();
				$('#coloniaID').select();				
			}else{
				if(numColonia == '' || numColonia == 0){
					$('#nombreColonia').val("TODAS");
					$('#coloniaID').val("0");
				}
			}
		}
	}
	
	//***************************** 
	
	//Función muestra en el grid  el listado de los creditos de acuerdo a la búsqueda 
	function consultaGridCreditos(){		
		var params = {};
		params['tipoLista'] = 1;
		params['sucursalID'] = $('#sucursalID').val();	
		params['estCredBusq'] =  $('#estCredBusq').val();	
		params['estadoID'] = $('#estadoID').val();	
		params['diasAtrasoIni'] = $('#diasAtrasoIni').val();	
		params['municipioID'] = $('#municipioID').val();
		params['diasAtrasoFin'] = $('#diasAtrasoFin').val(); 	
		params['localidadID'] = $('#localidadID').val();
		params['limiteRenglones'] = $('#limiteRenglones').val();	
		params['coloniaID'] = $('#coloniaID').val();
				
		$.post("emisionNotiCobGridVista.htm", params, function(data){
			if(data.length >0) {	
				$('#divListaCreditos').html(data);
				$('#divListaCreditos').show();	
				$('#fieldsetLisCred').show();
				
				var numFilas=consultaFilas();		
				if(numFilas == 0 ){
					$('#divListaCreditos').html("");
					$('#divListaCreditos').hide();	
					$('#fieldsetLisCred').hide();
					alert('No se Encontraron Coincidencias');
				}else{	
					deshabilitaChecks(); // se deshabilita los checks de los creditoas que ya se les realizo un notificacion en el dia
				}				
			}else{				
				$('#divListaCreditos').html("");
				$('#divListaCreditos').hide();
				$('#fieldsetLisCred').hide();	
				alert('No se Encontraron Coincidencias');
			}

			$('#contenedorForma').unblock(); // desbloquear
		});
	}
	
	//Función consulta los datos de la sucursal
	function validaSucursal() {
		var numSucursal = $('#sucursalID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) && numSucursal > 0){
			sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) { 
				if(sucursal!=null){
					$('#nombreSucursal').val(sucursal.nombreSucurs);				
				}else{
					$('#sucursalID').val('0');
					$('#nombreSucursal').val('TODAS');
					$('#sucursalID').focus();
					alert('No existe la Sucursal');
				}
			});
		}else{
			if(isNaN(numSucursal)){
				alert('No existe la Sucursal');
				$('#sucursalID').val('0');
				$('#nombreSucursal').val('TODAS');
				$('#sucursalID').focus();
				$('#sucursalID').select();				
			}else{
				if(numSucursal == '' || numSucursal == 0){
					$('#sucursalID').val('0');
					$('#nombreSucursal').val('TODAS');
				}
			}
		}
	}
});

//Función que inicializa todos los campos de la pantalla
function inicializaParametros(){
	inicializaForma('formaGenerica','sucursalID');
	$('#sucursalID').val('0');
	$('#nombreSucursal').val('TODAS');
	
	$('#estadoID').val("0");
	$('#nombreEstado').val("TODOS");
	$('#municipioID').val('0');
	$('#nombreMunicipio').val('TODOS');
	$('#localidadID').val('0');
	$('#nombreLocalidad').val('TODAS');
	$('#coloniaID').val('0');
	$('#nombreColonia').val('TODAS');

	$('#diasAtrasoIni').val('0');
	$('#diasAtrasoFin').val('0');
		
	var parametroBean = consultaParametrosSession();
	$('#usuarioID').val(parametroBean.numeroUsuario);
	$('#fechaSis').val(parametroBean.fechaSucursal);
	$('#claveUsuario').val(parametroBean.claveUsuario);
	$('#sucursalUsuID').val(parametroBean.sucursal);
	$('#nombreInsti').val(parametroBean.nombreInstitucion);
	
	//Se oculta seccion de creditos
	$('#divListaCreditos').html("");
	$('#divListaCreditos').hide();
	$('#fieldsetLisCred').hide();	
}

//Funcion solo Enteros sin Puntos ni Caracteres Especiales 
function validaSoloNumero(e,elemento){//Recibe al evento 
	var key;
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}
	
	 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
	    return false;
	 return true;
}

//Función selecciona todos los checks del listado de creditos
function seleccionaTodos(control){
	var  si='S';
	 var no='N';
	if($('#'+control).attr('checked')==true){
		document.getElementById(control).value = si;
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var jqIdChecked = eval("'emitirCheck" + numero+ "'");	
			var jqIdEmitir = eval("'emitirNotiCob" + numero+ "'");	
			var valorChecked= document.getElementById(jqIdChecked).value;	
			var Nocheck='N';
			if(valorChecked==Nocheck){	
				$('#emitirCheck'+numero).attr('checked','true');
				document.getElementById(jqIdChecked).value = si;
				document.getElementById(jqIdEmitir).value = si;
			}
		});
	}else{
		document.getElementById(control).value = no;
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var jqIdChecked = eval("'emitirCheck" + numero+ "'");
			var jqIdEmitir = eval("'emitirNotiCob" + numero+ "'");	
			var valorChecked= document.getElementById(jqIdChecked).value;	
			var Sicheck='S';
			if(valorChecked==Sicheck){	
				$('#emitirCheck'+numero).attr('checked',false);	
				document.getElementById(jqIdChecked).value = no;
				document.getElementById(jqIdEmitir).value = no;
			}
		});
	}
}

//Función que al dar click en un check de la lista de creditos asigna valor si es seleccionado o no
function realiza(control){	
	var si='S';
	var no='N';

	var numero= control.substr(11,control.length);
	var jqIdEmitir = eval("'emitirNotiCob" + numero+ "'");	
	if($('#'+control).attr('checked')==true){
		document.getElementById(control).value = si;	
		document.getElementById(jqIdEmitir).value = si;	
	}else{
		document.getElementById(control).value = no;
		document.getElementById(jqIdEmitir).value = no;
	}
		
}

//Función consulta el total de creditos en la lista
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;
		
	});
	return totales;
}

//Función que deshabilita todos los creditos que ya se les emitio una notificacion
function deshabilitaChecks(){
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var jqIdChecked = eval("'emitirCheck" + numero+ "'");
		var jqIdEmitir = eval("'emitirNotiCob" + numero+ "'");
		var jqIdFecha = eval("'fechaCita" + numero+ "'");
		var jqIdHora = eval("'horaCita" + numero+ "'");	
		var valorChecked= document.getElementById(jqIdChecked).value;	
		var emitirNoti='S';
		if(valorChecked==emitirNoti){
			deshabilitaControl(jqIdChecked);
			document.getElementById(jqIdFecha).readOnly=true;
			document.getElementById(jqIdHora).readOnly=true;

			document.getElementById(jqIdChecked).value='E';
			document.getElementById(jqIdEmitir).value='E';
		}else{
			$('#'+jqIdFecha).datepicker({
			    			showOn: "button",
			    			buttonImage: "images/calendar.png",
			    			buttonImageOnly: true,
							changeMonth: true, 
							changeYear: true,
							dateFormat: 'yy-mm-dd',
							yearRange: '-100:+10',
							defaultDate: $('#fechaSis').val()
						
						});

			$("#"+jqIdHora).setMask('time').val('');
		}

		$('#saldoTotalCap'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});	


	});
}

//Función consulta el número de creditos que se seleccionaron
function consultaNumFilasSelec(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var asignar= eval("'#emitirCheck" + numero + "'");   
		
		if ($(asignar).attr('checked')==true){
			totales++;
		}			
	});
	return totales;
}

//funcion que bloquea la pantalla mientras se cargan los datos
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

//funcion valida fecha de cita
function validaFecha(control){

	var Xfecha= $('#'+control).val();   // fecha ingresada en el campo
	var Yfecha=  $('#fechaSis').val();	// fecha del sistema
	if(esFechaValida(Xfecha) && Xfecha != ''){
		if(Xfecha=='')$('#'+control).val(Yfecha);

		if ( mayor(Yfecha, Xfecha) )
		{
			alert("La Fecha Capturada es Menor a la de Hoy")	;
			$('#'+control).val(Yfecha);
		
		}
	}else{
		$('#'+control).val(Yfecha);		
	}
}

/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			alert("Formato de Fecha No Válido (aaaa-mm-dd)");
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
			alert("Fecha introducida errónea");
		return false;
		}
		if (dia>numDias || dia==0){
			alert("Fecha introducida errónea");
			return false;
		}
		return true;
	}
}

//valida si fecha > fecha2: true else false
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

//Función de éxito en la transación
function funcionExito(){

	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 
			
			inicializaParametros();
			$('#sucursalID').focus();
			$('#estCredBusq').val('');					
		}
        }, 50);
	}					
	
	
	
}

//función de error en la transacción
function funcionError(){
	
}