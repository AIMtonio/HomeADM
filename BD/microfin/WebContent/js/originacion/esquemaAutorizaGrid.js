$(document).ready(function() {
	
  
	
});// cerrar

parametros = consultaParametrosSession();

	//Declaración de constantes
	var catTipoTranEsquema = { 
			'alta'			: 1,
			
		};	
	
	agregaFormatoControles('formaGenerica1');
	
	$.validator.setDefaults({
	    submitHandler: function(event) {    	  
	  	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje','false','producCreditoID',
	  			  				'exitoEsquemaAutorizacion', 'falloEsquemaAutorizacion');
	  	  
	    }
	 });	
	
	$('#formaGenerica1').validate({
		rules: {
			producID: 'required'				
		},
		
		messages: {
			producID: 'Especifique producto de credito',		
		}		
	});
	
		
	
		

function guardaGridEsquema(){
	
	 var mandar=0;
	if(mandar!=1){   		  		
		var numEsquema = $('input[name=consecutivoID]').length;
		quitaFormatoControles('divGridEsquema');
		$('#datosGridEsquema').val("");
		for(var i = 1; i <= numEsquema; i++){			
			var valorEsquema=document.getElementById("esquemaID"+i+"").value;
			if(valorEsquema==0){									
				if(i == 1){
						
					$('#datosGridEsquema').val($('#datosGridEsquema').val() +
					document.getElementById("esquemaID"+i+"").value + ']' +
					document.getElementById("cicloInicial"+i+"").value + ']' +
					document.getElementById("cicloFinal"+i+"").value + ']' +
					document.getElementById("montoInicial"+i+"").value + ']' +
					document.getElementById("montoFinal"+i+"").value + ']' +
					document.getElementById("montoMaximo"+i+"").value + ']' +
					document.getElementById("producID").value);
				}else{
					$('#datosGridEsquema').val($('#datosGridEsquema').val() + '[' +
					document.getElementById("esquemaID"+i+"").value + ']' +
					document.getElementById("cicloInicial"+i+"").value + ']' +
					document.getElementById("cicloFinal"+i+"").value + ']' +
					document.getElementById("montoInicial"+i+"").value + ']' +
					document.getElementById("montoFinal"+i+"").value + ']' + +
					document.getElementById("montoMaximo"+i+"").value + ']' + +
					document.getElementById("producID").value);
				}	
			}
		}						
	}
	else{
		mensajeSis("Faltan Datos");
		event.preventDefault();
	}
}	




function agregaNuevoEsquema(){
	var numeroFila = document.getElementById("numeroEsquema").value;
	var nuevaFila = parseInt(numeroFila) + 1;			
  var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
 	 	  
	if(numeroFila == 0){
		tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
		tds += '<input id="esquemaID'+nuevaFila+'" name="esquemaID" size="6" value="0" autocomplete="off"  readOnly="true"/></td>';		
		tds += '<td><input type="text" id="cicloInicial'+nuevaFila+'" name="cicloInicial" size="6"  value=""  onkeyPress="return Validador(event,this);"/></td>';	
		tds += '<td><input type="text" id="cicloFinal'+nuevaFila+'" name="cicloFinal" size="6" value="" onkeyPress="return Validador(event,this);" /></td>';	
		tds += '<td><input type="text" id="montoInicial'+nuevaFila+'" name="montoInicial" size="15" value="" onkeyPress="return Validador(event,this);" esMoneda="true" style="text-align:right;" onBlur="agregaFormato(this.id)"/></td>';
		tds += '<td><input type="text" id="montoFinal'+nuevaFila+'" name="montoFinal" size="15" value=""  onkeyPress="return Validador(event,this);" esMoneda="true" style="text-align:right;"  onBlur="agregaFormato(this.id)"/></td>';
		tds += '<td><input type="text" id="montoMaximo'+nuevaFila+'" name="montoMaximo" size="15" value=""  onkeyPress="return Validador(event,this);" esMoneda="true" style="text-align:right;" onBlur="agregaFormato(this.id)"/></td>';
	} else{    		
		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
		tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off"  type="hidden"/>';
		tds += '<input id="esquemaID'+nuevaFila+'" name="esquemaID" size="6" value="0" autocomplete="off"  readOnly="true"  /></td>';
		tds += '<td><input type="text" id="cicloInicial'+nuevaFila+'" name="cicloInicial" size="6"  value=""  autocomplete="off" onkeyPress="return Validador(event,this);"/></td>';	
		tds += '<td><input type="text" id="cicloFinal'+nuevaFila+'" name="cicloFinal" size="6" value=""  autocomplete="off" onkeyPress="return Validador(event,this);"/></td>';	
		tds += '<td><input type="text" id="montoInicial'+nuevaFila+'" name="montoInicial" size="15" value="" autocomplete="off"  onkeyPress="return Validador(event,this);"esMoneda="true" style="text-align:right;" onBlur="agregaFormato(this.id)"/></td>';
		tds += '<td><input type="text" id="montoFinal'+nuevaFila+'" name="montoFinal" size="15" value="" autocomplete="off" onkeyPress="return Validador(event,this);"esMoneda="true" style="text-align:right;"  onBlur="agregaFormato(this.id)"/></td>';
		tds += '<td><input type="text" id="montoMaximo'+nuevaFila+'" name="montoMaximo" size="15" value=""  autocomplete="off" onkeyPress="return Validador(event,this);"esMoneda="true" style="text-align:right;" onBlur="agregaFormato(this.id)"/></td>';
		
	}
	tds += '<td ><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarEsquema(this.id)"  />';
	tds += '<input type="button" name="agregaE" id="agregaE'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoEsquema()" /></td>';
	tds += '</tr>';
   
   
	document.getElementById("numeroEsquema").value = nuevaFila;    	
	$("#miTabla").append(tds);
	
	return false;		
}


// onBlur="agregaFormato(this.id)"
function eliminarEsquema(control){			
	var contador = 0 ;
	var numeroID = control;
		
	var datosBajaEsquema=$('#datosGridBajaEsquema').val();	
	var valorEsquema=document.getElementById("esquemaID"+numeroID+"").value;
	if(valorEsquema!=0){	
		if(datosBajaEsquema =='' ){						
			$('#datosGridBajaEsquema').val($('#datosGridBajaEsquema').val() +
			document.getElementById("esquemaID"+numeroID+"").value + ']' +
			document.getElementById("cicloInicial"+numeroID+"").value + ']' +
			document.getElementById("cicloFinal"+numeroID+"").value + ']' +
			document.getElementById("montoInicial"+numeroID+"").value + ']' +
			document.getElementById("montoFinal"+numeroID+"").value + ']' +
			document.getElementById("montoMaximo"+numeroID+"").value + ']' +
			document.getElementById("producID").value);
		}else{
			$('#datosGridBajaEsquema').val($('#datosGridBajaEsquema').val() + '[' +
			document.getElementById("esquemaID"+numeroID+"").value + ']' +
			document.getElementById("cicloInicial"+numeroID+"").value + ']' +
			document.getElementById("cicloFinal"+numeroID+"").value + ']' +
			document.getElementById("montoInicial"+numeroID+"").value + ']' +
			document.getElementById("montoFinal"+numeroID+"").value + ']' + 
			document.getElementById("montoMaximo"+numeroID+"").value + ']' + 
			document.getElementById("producID").value);
		}	
	}
										
	
	
	//mensajeSis("control:"+ numeroID);
	var jqRenglon = eval("'#renglon" + numeroID + "'");
	var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
	var jqEsquemaID = eval("'#esquemaID	" + numeroID + "'");		
	var jqCicloInicial = eval("'#cicloInicial" + numeroID + "'");
	var jqCicloFinal = eval("'#cicloFinal" + numeroID + "'");
	var jqMontoInicial= eval("'#montoInicial" + numeroID + "'");
	var jqMontoFinal = eval("'#montoFinal" + numeroID + "'");
	var jqMontoMaximo = eval("'#montoMaximo" + numeroID + "'");

	var jqElimina = eval("'#" + numeroID + "'");
	var jqAgregaE = eval("'#agregaE" + numeroID +"'");
	// se elimina la fila seleccionada
	
	$(jqConsecutivoID).remove();
	$(jqEsquemaID).remove();
	$(jqCicloInicial).remove();
	$(jqCicloFinal).remove();
	$(jqMontoInicial).remove();
	$(jqMontoFinal).remove();
	$(jqMontoMaximo).remove();
	$(jqElimina).remove();
	$(jqRenglon).remove();
	$(jqAgregaE).remove();
	
				
	// se asigna el numero de 
	var elementos = document.getElementsByName("renglon");
	$('#numeroEsquema').val(elementos.length);	

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	
	$('input[name=esquemaID]').each(function() {
		numero= this.id.substr(9,this.id.length);				
		var jqRenglonCiclo = eval("'renglon" + numero+ "'");	
		var jqNumeroCiclo = eval("'consecutivoID" + numero + "'");
		var jqEsquemaIDCiclo = eval("'esquemaID" + numero + "'");	
		
		var jqCicloInicialCiclo = eval("'cicloInicial" + numero + "'");
		var jqCicloFinalCiclo = eval("'cicloFinal" + numero + "'");	
		
		var jqMontoInicialCiclo = eval("'montoInicial" + numero + "'");	
		var jqMontoFinalCiclo = eval("'montoFinal" + numero + "'");	
		var jqMontoMaximoCiclo = eval("'montoMaximo" + numero + "'");

		var jqEliminaCiclo = eval("'" + numero + "'");
		var jqAgregaECiclo = eval("'agregaE" + numero +"'");
		document.getElementById(jqNumeroCiclo).setAttribute('value',  contador);		
		document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);		
		document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivoID" + contador);
		
		document.getElementById(jqEsquemaIDCiclo).setAttribute('id', "esquemaID" + contador);
		document.getElementById(jqCicloInicialCiclo).setAttribute('id', "cicloInicial" + contador);
		document.getElementById(jqCicloFinalCiclo).setAttribute('id', "cicloFinal" + contador);
		
		document.getElementById(jqMontoInicialCiclo).setAttribute('id', "montoInicial" + contador);
		document.getElementById(jqMontoFinalCiclo).setAttribute('id', "montoFinal" + contador);
		document.getElementById(jqMontoMaximoCiclo).setAttribute('id', "montoMaximo" + contador);
		document.getElementById(jqEliminaCiclo).setAttribute('id',  contador);	
		document.getElementById(jqAgregaECiclo).setAttribute('id',"agregaE" +  contador);	

		contador = parseInt(contador + 1);	
	});
	//Reordenamiento de Controles
	contador = 1;
	numero= 0;
	
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);				
		var jqRenglonCiclo = eval("'renglon" + numero+ "'");	
		var jqNumeroCiclo = eval("'consecutivoID" + numero + "'");
		var jqEsquemaIDCiclo = eval("'esquemaID" + numero + "'");	
		
		var jqCicloInicialCiclo = eval("'cicloInicial" + numero + "'");
		var jqCicloFinalCiclo = eval("'cicloFinal" + numero + "'");	
		
		var jqMontoInicialCiclo = eval("'montoInicial" + numero + "'");	
		var jqMontoFinalCiclo = eval("'montoFinal" + numero + "'");	
		var jqMontoMaximoCiclo = eval("'montoMaximo" + numero + "'");

		var jqEliminaCiclo = eval("'" + numero + "'");
		var jqAgregaECiclo = eval("'agregaE" + numero +"'");
		
		document.getElementById(jqNumeroCiclo).setAttribute('value',  contador);		
		document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);		
		document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivoID" + contador);
		
		document.getElementById(jqEsquemaIDCiclo).setAttribute('id', "esquemaID" + contador);
		document.getElementById(jqCicloInicialCiclo).setAttribute('id', "cicloInicial" + contador);
		document.getElementById(jqCicloFinalCiclo).setAttribute('id', "cicloFinal" + contador);
		
		document.getElementById(jqMontoInicialCiclo).setAttribute('id', "montoInicial" + contador);
		document.getElementById(jqMontoFinalCiclo).setAttribute('id', "montoFinal" + contador);
		document.getElementById(jqMontoMaximoCiclo).setAttribute('id', "montoMaximo" + contador);
		document.getElementById(jqEliminaCiclo).setAttribute('id',  contador);	
		document.getElementById(jqAgregaECiclo).setAttribute('id',"agregaE"+  contador);	
		
		contador = parseInt(contador + 1);	
	});
}



function consultaFilasEsquema(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
		
	});
	return totales;
}




function exitoEsquemaAutorizacion() {
	agregaFormatoControles('divGridEsquema');
	$('#divGridFirmas').html("");
	$('#divGridFirmas').hide();
	consultaGridEsquema();
	consultaGridOrganoAutoriza();

	
 }

function falloEsquemaAutorizacion() {
	agregaFormatoControles('divGridEsquema');
}

//función para ingresar sólo números válido para diferentes tipos de Navegadores --- Omar Hdez
function Validador(e,elemento) {
	var key;
	if(window.event){//IE, chromium
		key = e.keyCode;
		}
	else if(e.which){//funciona para firefox opera netscape
		key = e.which;
		}

	if (key < 48 || key > 57) {
	    if(key == 46 || key == 8){ // Detecta . (punto) y backspace (retroceso)
	    	return true; 
	    	}
	    else {
	    	mensajeSis("Sólo se pueden ingresar números"); //Manda el mensajeSis de prevención
	    	return false; 
	    	}
	    }
	return true;
	}



 
	 
function agregaFormato(idControl){

	var jControl = eval("'#" + idControl + "'"); 

	$(jControl).bind('keyup',function(){
		$(jControl).formatCurrency({
			colorize: true,
			positiveFormat: '%n', 
			roundToDecimalPlace: -1
		});
	});
	
	$(jControl).blur(function() {
		$(jControl).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
	});
	
	$(jControl).formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});			
}

 

	
	

