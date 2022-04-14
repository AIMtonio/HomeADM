$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/
	esTab = false;
	
	var catTipoTransaccion = { 
			'grabar'	: '1'
	};
	
	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/
	inicializaPantalla();
	$('#agregar').focus();
	
    /******* VALIDACIONES DE LA FORMA *******/
	
	$.validator.setDefaults({
		submitHandler: function(event) {             	
       	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','agregar','exito','fallo');
		}
	});	

	$('#formaGenerica').validate({
		rules: {				
		},
		messages: {				
		}		
	});
	
	/********** METODOS Y MANEJO DE EVENTOS ************/
		
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	
	$('#grabar').click(function() { 
			var mandar = verificarVacios(); 
			if(mandar){
				$('#tipoTransaccion').val(catTipoTransaccion.grabar);
			}			 
		
	}); 
	
	$('#agregar').click(function() {		
		agregaNuevoParametro();
	});	

	
}); /** FIN DOCUMENT READY **/

/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/

// FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	inicializaForma('formaGenerica','lineaCreditoID');
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
		
	consultaNivelesCredito();
}

// FUNCION PARA CONSULTAR LOS NIVELES DE CREDITOS REGISTRADOS
function consultaNivelesCredito(){
	bloquearPantallaCarga();
	var params = {};
	params['tipoLista'] = 1;
	$.post("nivelCreditoGridVista.htm", params, function(data){
		if(data.length >0) {
			$('#divGridNivelesCredito').html(data);
			habilitaBoton('grabar', 'submit');	
		}else{				
			$('#divGridNivelesCredito').html("");
		}
		$('#contenedorForma').unblock(); // desbloquear
	});
}

// FUNCION QUE VERIFICA QUE LOS CAMPOS NO ESTEN VACIOS
function verificarVacios(){	
	var exito = true;	
	var numRenglones = consultaFilas();	
	
	for(var i = 1; i <= numRenglones; i++){
		var jqNivel = eval("'#nivelID" + i + "'");
		var jqDescripcion = eval("'#descripcion" + i + "'");
				
		if($(jqNivel).val() == ''){
			$(jqNivel).focus();
			exito = false;
			mensajeSis('Especificar ID Nivel ');
			break;
		}else{
			if($(jqDescripcion).val() == ''){
				$(jqDescripcion).focus();
				exito = false;
				mensajeSis('Especificar Descripción');
				break;
			}			
		}
	}
	return exito;
		
}

// FUNCION CONSULTA EL NUMERO DE FILAS
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;		
	});
	return totales;
}

// FUNCION PARA VALIDAR QUE NO SE REPITA EL ID DE NIVEL
function validaNivelID(idControl){
	var jqNivelIDValida = eval("'#" + idControl + "'");	
	
	if($(jqNivelIDValida).val() != '' && !isNaN($(jqNivelIDValida).val()) && $(jqNivelIDValida).val() > 0){
		$('tr[name=renglons]').each(function() {	
			numero= this.id.substr(8,this.id.length);
			var IDNivel = eval("'nivelID" + numero + "'");	
			
			if(idControl != IDNivel){
				var jqNivelID1 = eval("'#nivelID" + numero + "'");	
				if($(jqNivelID1).val() == $(jqNivelIDValida).val()){
					$(jqNivelIDValida).val('');
					$(jqNivelIDValida).focus();
					mensajeSis("El número ya existe");
					return false;
				}
			}							
		});		
	}else{
		if($(jqNivelIDValida).asNumber() == 0 && $(jqNivelIDValida).val() != ''){
			$(jqNivelIDValida).val('');
			$(jqNivelIDValida).focus();
			mensajeSis("El número debe ser mayor a 0");			
		}
	}
	
}

// FUNCION QUE BLOQUEA LA PANTALLA MIENTRAS SE CARGAN LOS DATOS
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

// FUNCION PARA AGREGAR NUEVAS FILAS EN EL GRID
function agregaNuevoParametro(){ 
	
	var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
	var nuevaFila = parseInt(numeroFila) + 1;					
	var tds = '<tr id="renglons' + nuevaFila + '" name="renglons">';	
	tds += '<td><input type="text" id="nivelID'+nuevaFila+'" name="lisNivelID" maxlength="6" size="6" tabindex="'+nuevaFila+'" onBlur="validaNivelID(this.id)" onkeyPress="return validador(event)"/></td>';			
	tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="lisDescripcion" maxlength="20" size="30" tabindex="'+nuevaFila+'"/></td>';	
	tds += '<td><input type="button" name="eliminar" id="'+nuevaFila +'" class="btnElimina" onclick="eliminarParametro(this.id)"  tabindex="'+nuevaFila+'" /></td>';
	tds += '<td><input type="button" name="agregar" id="agregar'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoParametro()" tabindex="'+nuevaFila+'" /></td>';
	tds += '</tr>';	   	   
	
	$("#miTabla").append(tds);
	$('#nivelID'+nuevaFila).focus();
	
	return false;
																														
}

// FUNCION PARA ELIMINAR FILAS EN EL GRID	
function eliminarParametro(control){
	var numeroID = control;
	
	var jqRenglon = eval("'#renglons" + numeroID + "'");

	// SE ELIMINA LA FILA SELECCIONADA
	$(jqRenglon).remove();

	// REORDENAMIENTO DE CONTROLES
	var contador = 1 ;
	var numero= 0;
	$('tr[name=renglons]').each(function() {	
		numero= this.id.substr(8,this.id.length);
		var jqRenglon1 = eval("'#renglons" + numero + "'");
		var jqNivelID1 = eval("'#nivelID" + numero + "'");		
		var jqDescripcion =eval("'#descripcion" + numero + "'");		
		var jqAgregar1=eval("'#agregar" + numero + "'");
		var jqEliminar1 = eval("'#" + numero + "'");

		// REORDENAMIENTO INDICES
		$(jqNivelID1).attr('tabindex',contador);
		$(jqDescripcion).attr('tabindex',contador);		
		$(jqAgregar1).attr('tabindex',contador);		
		$(jqEliminar1).attr('tabindex',contador);
		
		$(jqRenglon1).attr('id','renglons'+contador);
		$(jqNivelID1).attr('id','nivelID'+contador);
		$(jqDescripcion).attr('id','descripcion'+contador);		
		$(jqAgregar1).attr('id','agregar'+contador);		
		$(jqEliminar1).attr('id',contador);

		
		contador = parseInt(contador + 1);	
		
	});
	
}

// FUNCION VALIDA SOLO NUMEROS
function validador(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else 
  		return false;
	}
}

// FUNCION DE EXITO AL REALIZAR UNA TRANSACCION
function exito(){
	
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
		mensajeAlert=setInterval(function() { 
			if($(jQmensaje).is(':hidden')) { 	
				clearInterval(mensajeAlert); 
				
				consultaNivelesCredito();								
			}
        }, 50);
	}
	
}

// FUNCION DE ERROR AL REALIZAR UNA TRASACCION
function fallo(){	
}