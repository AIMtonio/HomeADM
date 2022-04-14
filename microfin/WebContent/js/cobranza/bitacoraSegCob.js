$(document).ready(function() {
	esTab = false;
		
	var catTipoTransaccion = { 
		'grabar'	: '1'
	};
	
	/********** METODOS Y MANEJO DE EVENTOS ************/
	agregaFormatoControles('formaGenerica');
	inicializaParametros();
	$('#creditoID').focus();	
		
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
			if(consultaFilasNuevas() == 0){
				alert('Agregar al menos una Promesa de Pago');
			}else{
				var mandar = verificarVacios(); 
				if(mandar != 1){
					var confirmar = false;
					confirmar=confirm("¿Esta seguro de guardar Registro en la Bitácora?"); 
					if (confirmar == true) {
					   	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','exito','fallo');
					}else{
						$('#creditoID').focus();
					}				
				}			 
			}            	
	   }
	});	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {		
			creditoID: {
				required: true
			},		
			accionID: {
				required: true
			},		
			respuestaID: {
				required: true
			}
		},
		messages: {
			creditoID: {
				required: 'Especificar Crédito'
			},
			accionID: {
				required: 'Especificar Tipo de Acción'
			},
			respuestaID: {
				required: 'Especificar Tipo de Respuesta'
			}			
		}		
	});
	
	$('#creditoID').blur(function(){
		if(esTab){
			consultaCredito(this.id);
		}
	});		
		
	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '2', '9', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});
	
	$('#grabar').click(function() { 					
		$('#tipoTransaccion').val(catTipoTransaccion.grabar);	
	}); 	
	
	$('#agregar').click(function() {		
		agregaNuevoParametro();
	});
	
	$('#fechaEntregaDoc').change(function(){
		var Xfecha= $('#fechaEntregaDoc').val();
		var fechaSis= $('#fechaSis').val();
		
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaEntregaDoc').val(fechaSis);
				$('#fechaEntregaDoc').focus();						
			
		}else{
				$('#fechaEntregaDoc').val(fechaSis);
			$('#fechaEntregaDoc').focus();
		}
	});
	
	$('#accionID').change(function(){
		var accion = $('#accionID').val();
		if(accion == ''){
			dwr.util.removeAllOptions('respuestaID');
			dwr.util.addOptions('respuestaID', {'':'SELECCIONAR'});	
		}else{
			funcionCargaComboTipoRespuesta(accion);
		}		
	});
		
	// Funcion para consultar las promesas del credito
	function consultaPromesas(){			
		var params = {};
		params['tipoLista'] = 2;
		params['creditoID'] = $('#creditoID').val();
		$.post("promesaSegCobGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divListaPromesas').html(data);
				habilitaBoton('grabar', 'submit');	
				agregaFormatoGrid();
				
			}else{				
				$('#divListaPromesas').html("");
			} 
			
		});
	}
	
	// Funcion principal consulta creditos
	function consultaCredito(controlID){
		var numCredito = $('#'+controlID).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && numCredito>0){
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val()
				}; 
			creditosServicio.consulta(18, creditoBeanCon,function(credito){
				if(credito!=null){
					var estatus = credito.estatus;
					if(estatus == 'V' || estatus == 'B'){
						$('#clienteID').val(credito.clienteID);
						consultaCliente('clienteID');
						if(estatus == 'V'){
							$('#estatus').val('VIGENTE');
						}else{
							if(estatus == 'B'){
								$('#estatus').val('VENCIDO');							
							}
						}
						consultaPromesas();
						habilitaBoton('agregar', 'submit');
					}else{
						$('#estatus').val('');
						$('#clienteID').val('');
						$('#nombreCliente').val('');
						$('#divListaPromesas').html("");
						deshabilitaBoton('agregar', 'submit');
	
						$('#creditoID').focus();
						alert('El estatus del Crédito debe ser Vigente o Vencido');						
					}					 
				}else{
					alert("No Existe el Crédito");
					$('#creditoID').val('');
					$('#creditoID').focus();
					$('#creditoID').select();	
					$('#estatus').val('');
					$('#clienteID').val('');
					$('#nombreCliente').val('');
					$('#divListaPromesas').html("");
					deshabilitaBoton('agregar', 'submit');
				}
			});
		}else{
			if(isNaN(numCredito)){
				alert("No Existe el Crédito");
				$('#creditoID').val('');
				$('#creditoID').focus();
				$('#creditoID').select();
				$('#estatus').val('');
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				$('#divListaPromesas').html("");
				deshabilitaBoton('agregar', 'submit');
			}else{
				if(numCredito =='' || numCredito == 0){
					$('#creditoID').val('');
	
					$('#estatus').val('');
					$('#clienteID').val('');
					$('#nombreCliente').val('');
					$('#divListaPromesas').html("");
					deshabilitaBoton('agregar', 'submit');
			}
			}
		}
	}
		
	// Funcion que consulta el nombre del cliente 
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)  && numCliente>0){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);				
					$('#nombreCliente').val(cliente.nombreCompleto);
				}else{
					alert("No Existe el Cliente");
					$('#clienteID').val('');	
					$('#nombreCliente').val('');
					$('#clienteID').focus();
					$('#clienteID').select();	
				}    	 						
			});
		}else{
			if(isNaN(numCliente)){
				alert("No Existe el Cliente");
				$('#clienteID').val('');	
				$('#nombreCliente').val(cliente.nombreCompleto);
				$('#clienteID').focus();
				$('#clienteID').select();				
			}else{
				if(numCliente =='' || numCliente == 0){
					$('#clienteID').val('');	
					$('#nombreCliente').val(cliente.nombreCompleto);
				}
			}				
		}
	}		
}); //fin document ready
	
//Funcion que verifica que los campos no esten vacios 
function verificarVacios(){	
	var exito = 0;	
	var numProm = consultaFilas();	
	
	for(var i = 1; i <= numProm; i++){
		if(document.getElementById('fechaPromPago'+i).disabled == false){
			var jqFechaProm =eval("'#fechaPromPago" + i + "'");
			var jqMontoProm=eval("'#montoPromPago" + i + "'");
			var jqComentarioProm=eval("'#comentarioProm" + i + "'");				
			
			if($(jqFechaProm).val() == ''){
				$(jqFechaProm).focus();
				alert('Especificar Fecha de Promesa de Pago');
				exito = 1;
				break;
			}else{
				if($(jqMontoProm).val() == ''){
					$(jqMontoProm).focus();
					alert('Especificar Monto de Pago');
						exito = 1;
					break;
				}else{
					if($(jqComentarioProm).val() == ''){
						$(jqComentarioProm).focus();
						alert('Especificar Comentario');
							exito = 1;
						break;
					}
				}					
			}
		}
			
	}
	return exito;			
}

// Funcion consulta el numero de filas
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;		
	});
	return totales;
}

// Funcion consulta el numero de filas que se agregaron y son editables
function consultaFilasNuevas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		numero= this.id.substr(8,this.id.length);
		if(document.getElementById('fechaPromPago'+numero).disabled == false){
			totales++;	
		}				
	});
	return totales;
}

// Funcion agrega formato moneda campos del grid que se consultaron
function agregaFormatoGrid(){
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);

		$('#montoPromPago'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});

		//Mostramos la descripcion del texarea 
		var jqdesComenProm = eval("'#desComenProm" + numero+ "'");
		var jqComentario = eval("'comentarioProm" + numero+ "'");
		document.getElementById(jqComentario).innerHTML = $(jqdesComenProm).val(); 
		
	});
}

// Funcion para agregar nuevas Filas en el grid
function agregaNuevoParametro(){ 
	
	var numeroFila = ($('#miTabla >tbody >tr').length ) ;
	var nuevaFila = parseInt(numeroFila) + 1;
	
	var tds = '<tr id="renglons' + nuevaFila + '" name="renglons">';
	  
	tds += '<td><label id="fecha'+nuevaFila+'">Fecha '+nuevaFila+':</label></td> ';	 
	tds += '<td><input type="hidden" id="consecutivo'+nuevaFila+'" name="consecutivo" size="4"  value="'+nuevaFila+'" />';
	tds += '	<input type="hidden" id="numPromesa'+nuevaFila+'" name="lisNumPromesa" size="4" value="'+nuevaFila+'" />';
	tds += '	<input type="text" id="fechaPromPago'+nuevaFila+'" name="lisFechaPromPago" size="11" ';
	tds += '	 maxlength = "10" autocomplete="off" esCalendario="true" onChange="validaFecha(this.id)" tabindex="6"/></td>';	
	tds += '<td class="separador"></td> ';	

	tds += '<td><label id="monto'+nuevaFila+'">Monto '+nuevaFila+':</label></td> ';	 
	tds += '<td><input type="text" id="montoPromPago'+nuevaFila+'" name="lisMontoPromPago"  size="15" maxlength = "18" autocomplete="off" esMoneda="true" onkeypress="validaSoloNumero(event,this)" '; 
	tds += '	 style="text-align: right"  tabindex="6"/></td>';
	tds += '<td class="separador"></td> ';	

	tds += '<td><label id="comentario'+nuevaFila+'">Comentario '+nuevaFila+':</label></td> ';
	tds += '<td><textarea id="comentarioProm'+nuevaFila+'" name="lisComentarioProm" COLS="50" ROWS="2" onBlur=" ponerMayusculas(this)"  ';
	tds += '	maxlength = "300"  tabindex="6"/></td>';	 
	
	
	tds += '<td><input type="button" name="eliminar" id="'+nuevaFila +'" class="btnElimina" onclick="eliminarParametro(this.id)"  tabindex="6" /></td>';
	tds += '<td><input type="button" name="agregar" id="agregar'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoParametro()" tabindex="6" /></td>';
	tds += '</tr>';	   	   
	
	$("#miTabla").append(tds);
	$('#fechaPromPago'+nuevaFila).focus();
	agregaFormatoControles('formaGenerica');
	
	return false;
																														
}

// Funcion para eliminar Filas en el grid	
function eliminarParametro(control){
	var numeroID = control;
	
	var jqRenglon = eval("'#renglons" + numeroID + "'");
	var jqNumero = eval("'#consecutivo" + numeroID + "'");
	var jqNumPromesa = eval("'#numPromesa" + numeroID + "'");		
	var jqFechaPromPago =eval("'#fechaPromPago" + numeroID + "'");
	var jqMontoPromPago = eval("'#montoPromPago" + numeroID + "'");
	var jqComentarioProm =eval("'#comentarioProm" + numeroID + "'");
	
	var jqAgregar=eval("'#agregar" + numeroID + "'");
	var jqEliminar = eval("'#" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqRenglon).remove();
	$(jqNumero).remove();
	$(jqNumPromesa).remove();
	$(jqFechaPromPago).remove();
	$(jqMontoPromPago).remove();
	$(jqComentarioProm).remove();

	$(jqAgregar).remove();
	$(jqEliminar).remove();

	//Reordenamiento de Controles

	var contador = 1 ;
	var numero= 1;
	$('tr[name=renglons]').each(function() {	
		numero= this.id.substr(8,this.id.length);
		var jqRenglon1 = eval("'#renglons" + numero + "'");
		var jqNumero1 = eval("'#consecutivo" + numero + "'");
		var jqNumPromesa1 = eval("'#numPromesa" + numero + "'");		
		var jqFechaPromPago1 =eval("'#fechaPromPago" + numero + "'");
		var jqMontoPromPago1 = eval("'#montoPromPago" + numero + "'");
		var jqComentarioProm1 =eval("'#comentarioProm" + numero + "'");
		var jqFecha1 =eval("'#fecha" + numero + "'");
		var jqMonto1 = eval("'#monto" + numero + "'");
		var jqComentario1 =eval("'#comentario" + numero + "'");
		
		var jqAgregar1=eval("'#agregar" + numero + "'");
		var jqEliminar1 = eval("'#" + numero + "'");
		$(jqFechaPromPago1).datepicker("destroy");

		//renombran etiquetas
		document.getElementById('fecha'+numero).innerHTML ='Fecha '+contador;
		document.getElementById('monto'+numero).innerHTML ='Monto '+contador;
		document.getElementById('comentario'+numero).innerHTML ='Comentario '+contador;
		
		$(jqRenglon1).attr('id','renglons'+contador);
		$(jqNumero1).attr('id','consecutivo'+contador);
		$(jqNumPromesa1).attr('id','numPromesa'+contador);
		$(jqFechaPromPago1).attr('id','fechaPromPago'+contador);
		$(jqMontoPromPago1).attr('id','montoPromPago'+contador);
		$(jqComentarioProm1).attr('id','comentarioProm'+contador);
		$(jqFecha1).attr('id','fecha'+contador);
		$(jqMonto1).attr('id','monto'+contador);
		$(jqComentario1).attr('id','comentario'+contador);
		
		$(jqAgregar1).attr('id','agregar'+contador);		
		$(jqEliminar1).attr('id',contador);
		
		//solo se agrega el calendario a los campos editables
		if(document.getElementById('fechaPromPago'+contador).disabled == false){
			$('#fechaPromPago'+contador).datepicker({			
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yy-mm-dd',
				yearRange: '-100:+10',
				defaultDate: $('#fechaSis').val()			
			});
		}
		
		contador = parseInt(contador + 1);	
		
	});
	agregaFormatoControles('formaGenerica');

}

// Funcion valida fecha 
function validaFecha(control){

	var Xfecha= $('#'+control).val();   // fecha ingresada en el campo
	var Yfecha=  $('#fechaSis').val();	// fecha del sistema
	if(esFechaValida(Xfecha) && Xfecha != ''){
		if(Xfecha=='')$('#'+control).val(Yfecha);

		if ( mayor(Yfecha, Xfecha) )
		{
			alert("La Fecha Capturada es Menor a la de Hoy");
			$('#'+control).val(Yfecha);
			$('#'+control).focus();
		
		}else{
			$('#'+control).focus();		
		}
	}else{
		$('#'+control).val(Yfecha);
		$('#'+control).focus();		
	}
}

// Funcion valida fecha formato (yyyy-MM-dd)
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

// Valida si fecha > fecha2: true else false
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

//Función solo Enteros sin Puntos ni Caracteres Especiales 
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

// Función que inicializa todos los campos de la pantalla
function inicializaParametros(){
	inicializaForma('formaGenerica','creditoID');
	
	var parametroBean = consultaParametrosSession();
	$('#usuarioID').val(parametroBean.numeroUsuario);
	$('#nombreUsuario').val(parametroBean.nombreUsuario);
	
	$('#sucursalID').val(parametroBean.sucursal);
	$('#nombreSucursal').val(parametroBean.nombreSucursal);
	$('#fechaSis').val(parametroBean.fechaSucursal);

	$('#estatus').val('');
	$('#clienteID').val('');
	$('#nombreCliente').val('');

	funcionCargaComboTipoAccion();	
	dwr.util.removeAllOptions('respuestaID'); 
	dwr.util.addOptions('respuestaID', {'':'SELECCIONAR'});	

	//Se oculta seccion del grid
	$('#divListaPromesas').html("");
		
	funcionCargaComboEtapaCobranza();
	$('#etapaCobranza').val('');
	
	$('#fechaEntregaDoc').val('');	

	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('agregar', 'submit');
}

// Función carga todas las opciones en el combo etapa cobranza
function funcionCargaComboEtapaCobranza(){
	dwr.util.removeAllOptions('etapaCobranza'); 
	esquemaNotificaServicio.listaComboEtapas(2, function(etapas){
		dwr.util.addOptions('etapaCobranza', {'':'SELECCIONAR'});	
		dwr.util.addOptions('etapaCobranza', etapas, 'etiquetaEtapa', 'etiquetaEtapa');
	});
}

// Función carga todas las opciones en el combo tipo de accion
function funcionCargaComboTipoAccion(){
	dwr.util.removeAllOptions('accionID'); 
	tipoAccionCobServicio.listaCombo(2, function(tipoAacciones){
		dwr.util.addOptions('accionID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('accionID', tipoAacciones, 'accionID', 'descripcion');
	});
}

// Función carga todas las opciones en el combo tipo de respuestas
function funcionCargaComboTipoRespuesta(accion){
	var beanCon ={
		'accionID' : accion 
	};
	dwr.util.removeAllOptions('respuestaID'); 
	tipoRespuestaCobServicio.listaCombo(2,beanCon, function(tipoAacciones){
		dwr.util.addOptions('respuestaID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('respuestaID', tipoAacciones, 'respuestaID', 'descripcion');
	});
}	

// Funcion de exito al realizar una transaccion
function exito(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 
			
			inicializaParametros();					
		}
        }, 50);
	}
	
}

// Funcion de error al realizar una transaccion
function fallo(){
	
}