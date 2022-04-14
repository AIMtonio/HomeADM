$(document).ready(function() {
	
	agregaFormatoControles('formaGenerica2');

});//fin

	//Definicion de Constantes y Enums  
	var catTipoTranOrgano = {
	  		'alta':1,
	  	};
	
	$.validator.setDefaults({
	    submitHandler: function(event) {    	  
	  	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje','false','producCreditoID',
	  			  				'exitoOrganoAutorizacion', 'falloOrganoAutorizacion');
	  	  
	    }
	 });	
		
	$('#formaGenerica2').validate({
		rules: {
			productoCredID: 'required'				
		},
		
		messages: {
			productoCredID: 'Especifique producto de credito',		
		}		
	});
	
	$('#grabarOrgano').click(function() {	
		$('#tipoTransaccionOrgano').val(catTipoTranOrgano.alta);
		guardaGridOrganoAutoriza();
		mensajeSis($('#datosGridOrganoAutoriza').val());
		mensajeSis($('#tipoTransaccionOrgano').val());
		event.preventDefault();
		
	});
	

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	//función Para Modificar y agregar nuevo esquema-
	
function guardaGridOrganoAutoriza(){		
	 var mandar=0;
	if(mandar!=1){   		  		
		var numOrgano = $('input[name=consecutivo]').length;
		$('#datosGridOrganoAutoriza').val("");
		$('#datosGridModificaOrgano').val("");
		for(var i = 1; i <= numOrgano; i++){
			var valorNuevo=document.getElementById("nuevo"+i+"").value;
			if(valorNuevo=='0'){
				if(i == 1){
					$('#datosGridOrganoAutoriza').val($('#datosGridOrganoAutoriza').val() +
					document.getElementById("esquema"+i+"").value + ']' +
					document.getElementById("numeroFirma"+i+"").value + ']' +
					document.getElementById("organoID"+i+"").value + ']' +					
					$('#productoCredID').val());
				}else{
					$('#datosGridOrganoAutoriza').val($('#datosGridOrganoAutoriza').val() + '[' +
					document.getElementById("esquema"+i+"").value + ']' +
					document.getElementById("numeroFirma"+i+"").value + ']' +
					document.getElementById("organoID"+i+"").value + ']' +					
					$('#productoCredID').val());
				}	
			}
			if(valorNuevo!='0'){

				var valEsquemaModificado =document.getElementById("esquema"+i+"").value;
				var valFirmaModificado=document.getElementById("numeroFirma"+i+"").value ;
				var valOrganoModificado=document.getElementById("organoID"+i+"").value ;
				
				var valEsquema =$('#esquemas'+i).val();
				var valFirma=$('#numeroFirmas'+i).val() ;
				var valOrgano=$('#organosID'+i).val() ;
				if(valEsquema !=valEsquemaModificado||valFirma!=valFirmaModificado||valOrgano!=valOrganoModificado){
					if(i == 1){
						$('#datosGridModificaOrgano').val($('#datosGridModificaOrgano').val() +
								valEsquemaModificado+ ']' +
								valFirmaModificado + ']' +
								valOrganoModificado +']'+
								$('#productoCredID').val()+']'+
								valEsquema+']'+
								valFirma+']'+
								valOrgano);
					}else{
						$('#datosGridModificaOrgano').val($('#datosGridModificaOrgano').val() + '[' +
								valEsquemaModificado + ']' +
								valFirmaModificado + ']' +
								valOrganoModificado +']'+
								$('#productoCredID').val()+']'+
								valEsquema+']'+
								valFirma+']'+
								valOrgano);
					}		
				}
			}
			
			
		}
		
	}
	else{
		mensajeSis("Faltan Datos");
		event.preventDefault();
	}
}	






function cargaListaOrganos(){
	var tipoConsulta = 1;	
	$('tr[name=filas]').each(function() {
		var numero= this.id.substr(5,this.id.length);
		var jsOrganoID = eval("'organoID" + numero+ "'");	
		var jsOrganoIDValor = eval("'valorOrganoID" + numero+ "'");	
		var valorOrgano= document.getElementById(jsOrganoIDValor).value;
		
		dwr.util.removeAllOptions(jsOrganoID); 
		dwr.util.addOptions(jsOrganoID, {0:'SELECCIONAR'});  
		organoDecisionServicio.listaCombo(tipoConsulta,  function(documento){
		dwr.util.addOptions(jsOrganoID, documento, 'organoID', 'descripcion');
		
		$('#organoID'+numero+' option[value='+ valorOrgano +']').attr('selected','true');
		$('#organosID'+numero).val(valorOrgano);
		});
	});
	
}


function cargaListaEsquemas(){
	var tipoConsulta = 2;	
	$('tr[name=filas]').each(function() {
		var numero= this.id.substr(5,this.id.length);
		var jsEsquemaID = eval("'esquema" + numero+ "'");	
		var jsEsquemaValorID = eval("'desEsquema" + numero+ "'");	
		var valorEsquema= document.getElementById(jsEsquemaValorID).value;

		var productoEnGridOrganoAutoriza=$("#productoCredID").val();
		
		var varProducoID = {
				'producCreditoID':productoEnGridOrganoAutoriza			
			};						
		dwr.util.removeAllOptions(jsEsquemaID); 
		dwr.util.addOptions(jsEsquemaID, {0:'SELECCIONAR'});  
		esquemaAutorizaServicio.listaCombo(tipoConsulta,varProducoID,  function(documento){
		dwr.util.addOptions(jsEsquemaID, documento, 'esquemaID','esquemaID');
		

		$('#esquema'+numero+' option[value='+ valorEsquema +']').attr('selected','true');
		$('#esquemas'+numero).val(valorEsquema);
			
		});
	});
	
}



function cargaListaFirmas(){
	$('tr[name=filas]').each(function() {
		var numero= this.id.substr(5,this.id.length);
		var jsNumFirmaID = eval("'numFirma" + numero+ "'");	
		var valorFirma= document.getElementById(jsNumFirmaID).value;
		
		$('#numeroFirma'+numero+' option[value='+ valorFirma +']').attr('selected','true');
		$('#numeroFirmas'+numero).val(valorFirma) ;
		});
}


function agregaNuevoOrgano(){	
	 habilitaBoton('grabarOrgano', 'submit');
	var numeroFila = document.getElementById("numeroOrganoAutoriza").value;
	var nuevaFila = parseInt(numeroFila) + 1;	
    var tds = '<tr id="filas' + nuevaFila + '" name="filas">';
	if(numeroFila == 0){
		tds += '<td><input  id="consecutivo'+nuevaFila+'" name="consecutivo"  size="6"  value="1" autocomplete="off"  type="hidden" />';
		tds += '<input  id="nuevo'+nuevaFila+'" name="nuevo"  size="6"  value="0" autocomplete="off"  type="hidden" />';								
		tds += '<input type="hidden"  id="desEsquema'+nuevaFila+'" name="desEsquema" size="6" value="0" autocomplete="off"  readOnly="true"  />';
		tds += '<select type="select" id="esquema'+nuevaFila+'" name="esquema"   ></select></td>';	
		
		tds += '<td><input  id="numFirma'+nuevaFila+'" name="numFirma"  size="6"  autocomplete="off"  type="hidden" />';
		tds += '<select type="select" id="numeroFirma'+nuevaFila+'" name="numeroFirma" ><option value="1">Firma A</option><option value="2">Firma B</option>';
		tds +='<option value="3">Firma C</option><option value="4">Firma D</option><option value="5">Firma E</option></select></td>';  
		tds += '<td><input type="hidden" id="valorOrganoID'+nuevaFila+'" name="valorOrganoID" size="6" value=""  />';
		tds += '<select type="select" id="organoID'+nuevaFila+'" name="organoID"  ></select></td>';

	
	} else{    		
		var valor = parseInt(document.getElementById("consecutivo"+numeroFila+"").value) + 1;
		tds += '<td><input  id="consecutivo'+nuevaFila+'" name="consecutivo" size="6" value="'+valor+'" autocomplete="off"  type="hidden"/>';
		tds += '<input  id="nuevo'+nuevaFila+'" name="nuevo"  size="6"  value="0" autocomplete="off"  type="hidden" />';
		tds +='<input type="hidden"  id="desEsquema'+nuevaFila+'" name="desEsquema"  value="0" autocomplete="off"  readOnly="true"  />';
		tds +='<select type="select" id="esquema'+nuevaFila+'" name="esquema" > </select></td>';	
		
		tds += '<td><input  id="numFirma'+nuevaFila+'" name="numFirma"  size="6"  autocomplete="off"  type="hidden" />';
		tds +=	'<select type="select" id="numeroFirma'+nuevaFila+'" name="numeroFirma" ><option value="1">Firma A</option><option value="2">Firma B</option>';
		tds += '<option value="3">Firma C</option><option value="4">Firma D</option><option value="5">Firma E</option></select></td>';  
		tds += '<td><input  type="hidden" id="valorOrganoID'+nuevaFila+'" name="valorOrganoID"  value=""  />';
		tds +=	'<select type="select" id="organoID'+nuevaFila+'" name="organoID" ></select></td>';
	}
	tds += '<td ><input type="button" name="eliminar" id="eliminar'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarOrgano(this.id)"/>';
	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoOrgano()"/></td>';
    tds += '</tr>';
   
   
	document.getElementById("numeroOrganoAutoriza").value = nuevaFila;    
	$("#tablaOrgano").append(tds);
	cargaListaEsquemaAutoriza("esquema"+nuevaFila);
	cargaListaOrganosAutoriza("organoID"+nuevaFila);
	
	return false;		
}

function cargaListaEsquemaAutoriza(control){
	var tipoConsulta = 2;			
		var productoEnGridOrganoAutoriza=$("#productoCredID").val();	
		var varProducoID = {
				'producCreditoID':productoEnGridOrganoAutoriza			
			};						
		dwr.util.removeAllOptions(control); 
		dwr.util.addOptions(control, {0:'SELECCIONAR'});  
		esquemaAutorizaServicio.listaCombo(tipoConsulta,varProducoID,  function(documento){
		dwr.util.addOptions(control, documento, 'esquemaID','esquemaID');
		
		});
		
}


function cargaListaOrganosAutoriza(control){
	var tipoConsulta = 1;			
		dwr.util.removeAllOptions(control); 
		dwr.util.addOptions(control, {0:'SELECCIONAR'});  
		organoDecisionServicio.listaCombo(tipoConsulta,  function(documento){
		dwr.util.addOptions(control, documento, 'organoID', 'descripcion');				
		});
		
}



function eliminarOrgano(control){			
	//var numeroID = control;
	//var numeroID= this.id.substr(8,this.id.length);
	var numeroID= control.substr(8,control.length);
	var datosBajaOrgano=$('#datosGridBajaOrgano').val();
	var valorNuevo=document.getElementById("nuevo"+numeroID+"").value;
	
	if(valorNuevo!='0'){
		
		if(datosBajaOrgano =='' ){						
			$('#datosGridBajaOrgano').val($('#datosGridBajaOrgano').val() +
			document.getElementById("esquema"+numeroID+"").value + ']' +
			document.getElementById("numeroFirma"+numeroID+"").value + ']' +
			document.getElementById("organoID"+numeroID+"").value + ']' +					
			document.getElementById("productoCredID").value);
		}else{
			$('#datosGridBajaOrgano').val($('#datosGridBajaOrgano').val() + '[' +
			document.getElementById("esquema"+numeroID+"").value + ']' +
			document.getElementById("numeroFirma"+numeroID+"").value + ']' +
			document.getElementById("organoID"+numeroID+"").value + ']' +					
			document.getElementById("productoCredID").value);
		}	
	}
		

		//mensajeSis("control:"+ numeroID);
		var jqEliminar1 = eval("'#filas" + numeroID + "'");
		var jqEliminar2 = eval("'#consecutivo" + numeroID + "'");
		var jqEliminar3 = eval("'#nuevo	" + numeroID + "'");				
		var jqEliminar4 = eval("'#desEsquema" + numeroID + "'");				
		var jqEliminar5 = eval("'#esquema" + numeroID + "'");				
		var jqEliminar6 = eval("'#numFirma" + numeroID + "'");	
		var jqEliminar7 = eval("'#numeroFirma" + numeroID + "'");	
		var jqEliminar8 = eval("'#valorOrganoID" + numeroID + "'");
		var jqEliminar9 = eval("'#organoID" + numeroID + "'");		
		var jqEliminar10= eval("'#eliminar" + numeroID + "'");
		var jqEliminar11= eval("'#agrega" + numeroID + "'");
		  
	
		
		
		// se elimina la fila seleccionada		
		$(jqEliminar1).remove();
		$(jqEliminar2).remove();
		$(jqEliminar3).remove();
		$(jqEliminar4).remove();
		$(jqEliminar5).remove();
		$(jqEliminar6).remove();
		$(jqEliminar7).remove();
		$(jqEliminar8).remove();
		$(jqEliminar9).remove();
		$(jqEliminar10).remove();
		$(jqEliminar11).remove();
		
		
		
		// se asigna el numero de 
		var elementos = document.getElementsByName("filas");
		$('#numeroOrganoAutoriza').val(consultaFilasOrganoAutoriza());	

		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		
	
		$('tr[name=filas]').each(function() {
			numero= this.id.substr(5,this.id.length);
			var jqCiclo1  = eval("'filas" + numero+ "'");	
			var jqCiclo2  = eval("'consecutivo" + numero + "'");
			var jqCiclo3  = eval("'nuevo" + numero + "'");		
			var jqCiclo4  = eval("'desEsquema" + numero + "'");	
			var jqCiclo5  = eval("'esquema" + numero + "'");
			var jqCiclo6  = eval("'numFirma" + numero + "'"); 
			var jqCiclo7  = eval("'numeroFirma" + numero + "'");  
			var jqCiclo8  = eval("'valorOrganoID" + numero + "'");
			var jqCiclo9  = eval("'organoID" + numero + "'");			
			var jqCiclo10 = eval("'eliminar" + numero + "'");
			var jqCiclo11 = eval("'agrega" + numeroID + "'");
			document.getElementById(jqCiclo2).setAttribute('value',  contador);
			
			document.getElementById(jqCiclo1).setAttribute('id', "filas" + contador);
			document.getElementById(jqCiclo2).setAttribute('id', "consecutivo" + contador);
			document.getElementById(jqCiclo3).setAttribute('id', "nuevo" + contador);
			document.getElementById(jqCiclo4).setAttribute('id', "desEsquema" + contador);
			document.getElementById(jqCiclo5).setAttribute('id', "esquema" + contador);
			document.getElementById(jqCiclo6).setAttribute('id', "numFirma" + contador);
			document.getElementById(jqCiclo7).setAttribute('id', "numeroFirma" + contador);
			
			document.getElementById(jqCiclo8).setAttribute('id', "valorOrganoID" + contador);
			document.getElementById(jqCiclo9).setAttribute('id', "organoID" + contador);			
			document.getElementById(jqCiclo10).setAttribute('id', "eliminar"+ contador);	
			document.getElementById(jqCiclo11).setAttribute('id', "agrega"+ contador);	

			contador = parseInt(contador + 1);	
		});
				
	}


function consultaFilasOrganoAutoriza(){
	var totales=0;
	$('tr[name=filas]').each(function() {
		totales++;
		
	});
	return totales;
}


function exitoOrganoAutorizacion() {

	$('#datosGridBajaOrgano').val('');
	$('#datosGridOrganoAutoriza').val('');
	consultaGridOrganoAutoriza();

	
 }

function falloOrganoAutorizacion() {
}




