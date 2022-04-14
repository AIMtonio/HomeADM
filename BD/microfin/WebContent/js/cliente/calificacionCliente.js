var concepto;
var clasificacion;
$(document).ready(function() {
	var tipoTransaccionConceptos= {
			'modifica' : '1',
		};
	var tipoTransaccionClasifica= {
			'modifica' : '1',
		};
	
	var tipoListaConceptos= {
			'principal' : 1,
		};
	var tipoListaClasificacion= {
			'principal' : 1,
		};
	
	

	esTab = true;
	
	/*pone tap falso cuando toma el foco input text */
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	/*pone tab en verdadero cuando se presiona tab */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	

	
	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */	   
	
	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('formaGenerica1');
	agregaFormatoControles('formaGenerica2');
	
	$("#formaGenerica1").hide();
	
	/*consultamos los puntajes de los conceptos */
	listaConceptos(); 		
	/* consulta los rangos de las clasificaciones */
	listaClasificaciones();
	
	$("#grabarConceptos").click(function (){
		$("#tipoTransaccionConceptos").val(tipoTransaccionConceptos.modifica);
		$("#tipoTransaccionClasifica").val(0);
	});
	
	$("#grabarClasificacion").click(function (){
		$("#tipoTransaccionClasifica").val(tipoTransaccionClasifica.modifica);
		$("#tipoTransaccionConceptos").val(0);
	});
	
	
	/*esta funcion esta en forma.js, verifica que el mensaje d error o exito aparezcan correctamente y que realizara despues de cada caso */
	$.validator.setDefaults({		
	    submitHandler: function(event) { 
	    	if($("#tipoTransaccionConceptos").val() != 0){	    	
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','conceptoCalifID',
		    			'funcionExitoConceptosCalif','funcionFalloConceptosCalif'); 
	    	}
	    	else if($("#tipoTransaccionClasifica").val() != 0){	    	
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje','true','clasificaCliID',
		    			'funcionExitoClasficacionCli','funcionFalloClasificacionCli'); 
	    	}
	    	else if($("#tipoTransaccionPuntos").val() != 0){	 
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje','true','conceptoCalifID',
		    			'funcionExitoPuntosConcepto','funcionFalloPuntosConcepto'); 
	    	}
	    }
	 });
	
	/* Mostrar el grid correspondiente */
	$('#A1').click(function() {
		listaPuntosConcepto();
		$("#puntajeMax").val($('#puntosA1').val());
	});
	$('#A2').click(function() {
		listaPuntosConcepto();
		$("#puntajeMax").val($('#puntosA2').val());
	});
	$('#A3').click(function() {
		listaPuntosConcepto();
		$("#puntajeMax").val($('#puntosA3').val());
	});
	$('#A4').click(function() {
		listaPuntosConcepto();
		$("#puntajeMax").val($('#puntosA4').val());
	});
	$('#M1').click(function() {
		listaPuntosConcepto();
		$("#puntajeMax").val($('#puntosM1').val());
	});
	$('#M2').click(function() {
		listaPuntosConcepto();
		$("#puntajeMax").val($('#puntosM2').val());
	});
	$('#B1').click(function() {
		listaPuntosConcepto();
		$("#puntajeMax").val($('#puntosB1').val());
	});
	$('#B2').click(function() {
		listaPuntosConcepto();
		$("#puntajeMax").val($('#puntosB2').val());
	});
	$('#B3').click(function() {
		listaPuntosConcepto();
		$("#puntajeMax").val($('#puntosB3').val());
	});
	
	/* Validaciones al ingresar un concepto */
	$('#puntosA1').blur(function() {
		validaCampo(this.id);
		sumaPuntosConceptos();
	});
	$('#puntosA2').blur(function() {	
		validaCampo(this.id);
		sumaPuntosConceptos();
	});
	$('#puntosA3').blur(function() {	
		validaCampo(this.id);
		sumaPuntosConceptos();
	});
	$('#puntosA4').blur(function() {
		validaCampo(this.id);
		sumaPuntosConceptos();
	});
	$('#puntosM1').blur(function() {	
		validaCampo(this.id);
		sumaPuntosConceptos();
	});
	$('#puntosM2').blur(function() {
		validaCampo(this.id);
		sumaPuntosConceptos();
	});
	$('#puntosB1').blur(function() {
		validaCampo(this.id);
		sumaPuntosConceptos();
	});
	$('#puntosB2').blur(function() {	
		validaCampo(this.id);
		sumaPuntosConceptos();
	});
	$('#puntosB3').blur(function() {	
		validaCampo(this.id);
		sumaPuntosConceptos();
	});
	
	
	/* Validaciones al ingresar un rango para clasificacion */
	$('#rangoInfA').blur(function() {	
		validaCampo(this.id);
		validaRango(this.id);
	});
	$('#rangoSupA').blur(function() {	
		validaCampo(this.id);
		validaRango(this.id);
	});
		
	$('#rangoInfB').blur(function() {	
		validaCampo(this.id);
		validaRango(this.id);
	});
	$('#rangoSupB').blur(function() {	
		validaCampo(this.id);
		validaRango(this.id);
	});	
	
	$('#rangoInfC').blur(function() {	
		validaCampo(this.id);
		validaRango(this.id);
	});
	$('#rangoSupC').blur(function() {	
		validaCampo(this.id);
		validaRango(this.id);
	});
	
	
	
	/* =============== VALIDACIONES DE LA FORMA ================= */
	$('#formaGenerica').validate({			
		rules: {
			
		},		
		messages: {
		
		}		
	});
	
	$('#formaGenerica1').validate({			
		rules: {
			
		},		
		messages: {
		
		}		
	});
	
	$('#formaGenerica2').validate({			
		rules: {
			rangoInfA : {
				required: true,
				number: true
			},
			rangoInfB : {
				required: true,
				number: true
			},
			rangoInfC : {
				required: true,
				number: true
			},
			rangoSupA : {
				required: true,
				number: true
			},
			rangoSupB : {
				required: true,
				number: true
			},
			rangoSupC : {
				required: true,
				number: true
			}
		},		
		messages: {
		
		}		
	});

	
	
	/* =================== FUNCIONES ========================= */	
	//consulta los conceptos en forma de una lista */
	function listaConceptos(){

		conceptosCalifServicio.lista(tipoListaConceptos.principal, function(conceptos) {
			if (conceptos != null && conceptos.length>0) {
				
				concepto = conceptos;
					$("#puntosA1").val(conceptos[0].puntos);
					$("#puntosA2").val(conceptos[1].puntos);
					$("#puntosA3").val(conceptos[2].puntos);
					$("#puntosA4").val(conceptos[3].puntos);
					$("#puntosM1").val(conceptos[4].puntos);
					$("#puntosM2").val(conceptos[5].puntos);
					$("#puntosB1").val(conceptos[6].puntos);
					$("#puntosB2").val(conceptos[7].puntos);
					$("#puntosB3").val(conceptos[8].puntos);
					
					sumaPuntosConceptos();	
					$('#puntosTotales').val($('#totalConceptos').val());	
					$('#puntosTotales').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});				
					
			}
		});
	}
	
	//consulta las clasificaciones de cliente en forma de una lista */
	function listaClasificaciones(){

		clasificacionCliServicio.lista(tipoListaClasificacion.principal, function(clasificaciones) {
			if (clasificaciones != null && clasificaciones.length>0) {
					$("#rangoInfA").val(clasificaciones[0].rangoInferior);
					$("#rangoSupA").val(clasificaciones[0].rangoSuperior);
					$("#rangoInfB").val(clasificaciones[1].rangoInferior);
					$("#rangoSupB").val(clasificaciones[1].rangoSuperior);
					$("#rangoInfC").val(clasificaciones[2].rangoInferior);
					$("#rangoSupC").val(clasificaciones[2].rangoSuperior);					
					
					clasificacion = clasificaciones;
			}
		});	
	}
	
	/* Calcular los puntos totales */
	function sumaPuntosConceptos () {				
		var puntosTotales =	parseFloat($('#puntosA1').val()) 
				+ parseFloat(parseFloat($('#puntosA2').val()))
				+ parseFloat(parseFloat($('#puntosA3').val()))
				+ parseFloat(parseFloat($('#puntosA4').val()))
				+ parseFloat(parseFloat($('#puntosM1').val()))
				+ parseFloat(parseFloat($('#puntosM2').val()))
				+ parseFloat(parseFloat($('#puntosB1').val()))
				+ parseFloat(parseFloat($('#puntosB2').val()))
				+ parseFloat(parseFloat($('#puntosB3').val())); 
						
		$('#totalConceptos').val(puntosTotales);		
		$('#totalConceptos').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});	
				
	}
	
	
	/* Valida que el campo tenga un valor numerico */
	function validaCampo(idControl){
		var campo = eval("'#"+idControl + "'");
		var valor = $(campo).val();
		
		if(valor =='' || isNaN(valor)){
			$(campo).val("0.00");
		}
	}
	/* Valida que el rango no tenga un valor mayo al puntaje total*/
	function validaRango(idControl){
		var campo = eval("'#"+idControl + "'");
		var rango = $(campo).val();
		var puntosTotal = $("#puntosTotales").val();
		
		if(parseFloat(puntosTotal) < parseFloat(rango)){
			mensajeSis("El valor del Rango NO puede ser mayor a: " + puntosTotal);
			$(campo).val(puntosTotal);
			$(campo).focus();
		}
	}
	
	
}); /* Fin de jquery */

function setTipoTransaccion(){
		$("#tipoTransaccionConceptos").val(0);
		$("#tipoTransaccionClasifica").val(0);
		$("#tipoTransaccionPuntos").val(1);
}


/* lista en el grid el detalle de puntos para el concepto seleccionado */
function listaPuntosConcepto(){
	$("#formaGenerica1").show();
		var concepto = $('input:radio[name=conceptos]:checked').val();		
		
		var params = {};
		params['tipoLista'] = 1;
		params['conceptoCalifID'] = concepto;
		        
		$.post("gridPuntosConcepto.htm", params, function(rangos){			   
			if(rangos.length >0) {				
				$('#gridPuntosConceptoDiv').html(rangos);
				$('#gridPuntosConceptoDiv').show();	
				agregaFormatoControles('formaGenerica1');
				$("#concepto").val(concepto);
			}else{
				$('#gridPuntosConceptoDiv').html("");
				$('#gridPuntosConceptoDiv').hide();
			}
		});
}


function listaConceptosPost(){
	$("#puntosA1").val(concepto[0].puntos);
	$("#puntosA2").val(concepto[1].puntos);
	$("#puntosA3").val(concepto[2].puntos);
	$("#puntosA4").val(concepto[3].puntos);
	$("#puntosM1").val(concepto[4].puntos);
	$("#puntosM2").val(concepto[5].puntos);
	$("#puntosB1").val(concepto[6].puntos);
	$("#puntosB2").val(concepto[7].puntos);
	$("#puntosB3").val(concepto[8].puntos);
	
	$('#totalConceptos').val($('#puntosTotales').val());		
	$('#totalConceptos').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});	
}


function listaClasificacionesPost(){
	if(clasificacion != null){
		$("#rangoInfA").val(clasificacion[0].rangoInferior);
		$("#rangoSupA").val(clasificacion[0].rangoSuperior);
		$("#rangoInfB").val(clasificacion[1].rangoInferior);
		$("#rangoSupB").val(clasificacion[1].rangoSuperior);
		$("#rangoInfC").val(clasificacion[2].rangoInferior);
		$("#rangoSupC").val(clasificacion[2].rangoSuperior);
	}
	
}


/*      Agregar una nueva fila en blanco para capturar nuevo rango de puntajes */ 
function agregarFila(){	
	var numeroFila=consultaFilas();
	
	var nuevaFila = parseInt(numeroFila) + 1;					
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';	 	 	  
			tds += '<td align="center"><input   type="hidden" id="consecutivoID'+nuevaFila+'" name="lPuntosConcepID"  size="6"  value="'+nuevaFila+'" />';	
			tds += '<td align="center"><input  type="text" id="rangoInferior'+nuevaFila+'" name="lRangoInferior" size="10" value="" autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarRangos(this.id)"/></td>';
			tds += '<td align="center"><input  type="text" id="rangoSuperior'+nuevaFila+'" name="lRangoSuperior" size="10" value="" autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarRangos(this.id)"/> </td>';					
			tds += '<td align="center"><input  type="text" id="puntos'+nuevaFila+'" name="lPuntos" size="10" value="" autocomplete="off" esMoneda="true" style="text-align:right;" onBlur="validarPuntos(this.id)"/></td>';			
		tds += '<td align="center"><input type="button" name="eliminar" id="'+nuevaFila+'"  value="" class="btnElimina" onclick="eliminarFila(this.id)" />';
		tds += '<input type="button" name="agrega" id="'+nuevaFila+'"  value="" class="btnAgrega" onclick="agregarFila()"/></td>';
		tds += '</tr>';	   	   
		 
		$("#miTabla").append(tds);
		habilitaBoton('grabar');
		
		return false;		
	}

function eliminarFila(control){	
	var contador = 0 ;
	var numeroID = control;
	
	var jqRenglon = eval("'#renglon" + numeroID + "'");
	$(jqRenglon).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {		
		numero= this.id.substr(7,this.id.length);
		var jqRenglon = eval("'#renglon"+numero+"'");
		var jqNumero = eval("'#consecutivoID"+numero+"'");
		var jqRangoInferior = eval("'#rangoInferior"+numero+"'");		
		var jqRangoSuperior= eval("'#rangoSuperior"+numero+"'");
		var jqPuntos=eval("'#puntos"+ numero+"'");
		var jqAgrega=eval("'#agrega"+ numero+"'");
		var jqElimina = eval("'#"+numero+ "'");
	
		$(jqNumero).attr('id','consecutivoID'+contador);
		$(jqRangoInferior).attr('id','rangoInferior'+contador);
		$(jqRangoSuperior).attr('id','rangoSuperior'+contador);
		$(jqPuntos).attr('id','puntos'+contador);
		$(jqAgrega).attr('id','agrega'+contador);
		$(jqElimina).attr('id',contador);
		$(jqRenglon).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);	
		
	});
	
}

/*    cuenta las filas de la tabla del grid       */
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;
}

/* valida los rangos por concepto */
function validarRangos(campo) {
	var jqCampo = eval("'#" + campo + "'");
	var valor = $(jqCampo).val();
	if(isNaN(valor) || valor == ''){
		mensajeSis("Solo dígitos numéricos");
		$(jqCampo).val("0.00");
		$(jqCampo).focus();
		$(jqCampo).select();
	}
	else{	
		$(jqCampo).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
	}
}

/* valida los puntajes por concepto */
function validarPuntos(campo) {
	var jqCampo = eval("'#" + campo + "'");
	var valor = $(jqCampo).val();
	if(isNaN(valor) || valor == ''){
		mensajeSis("Solo dígitos numéricos");
		$(jqCampo).val("0.00");
		$(jqCampo).focus();
		$(jqCampo).select();
	}
	else{	
		var puntajeMax = $("#puntajeMax").val();
		
		if(parseFloat(puntajeMax) < parseFloat($(jqCampo).val())){
			mensajeSis("Los Puntos NO pueden ser mayor: " + puntajeMax);
			$(jqCampo).val(puntajeMax);
			$(jqCampo).focus();
			$(jqCampo).select();			
		}
		else{
			$(jqCampo).formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
			});
		}
		
	}
}


/* =========== Manejo de pos Transacciones ================= */

function funcionExitoConceptosCalif(){	
	setFormatoDecimalConceptos();
	$('#puntosTotales').val($('#totalConceptos').val());	
		$('#puntosTotales').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
}

function funcionFalloConceptosCalif(){
	listaConceptosPost();
	$('#rangoSupA').focus();
}

function funcionExitoPuntosConcepto (){
	listaPuntosConcepto();
}

function funcionFalloPuntosConcepto () {
	listaPuntosConcepto();
}


function funcionExitoClasficacionCli(){
	setFormatoDecimalClasificacion();
}

function funcionFalloClasificacionCli(){
	listaClasificacionesPost();
	setFormatoDecimalClasificacion();
}



function setFormatoDecimalConceptos() {
	$('#puntosA1').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#puntosA2').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#puntosA3').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#puntosA4').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#puntosM1').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#puntosM2').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#puntosB1').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#puntosB2').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#puntosB3').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
}


function setFormatoDecimalClasificacion (){
	$('#rangoInfA').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#rangoSupA').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#rangoInfB').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#rangoSupB').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#rangoInfC').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#puntosB3').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	$('#rangoSupC').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
}







