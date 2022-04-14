$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionDivisas = {
  		'graba':'1',
  		'modifica':'2',
  		'elimina':'3'
	};
	
	var catTipoConsultaDivisas = {
  		'principal':1,
  		'foranea':2
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
	 	esTab = false;
	});

	// -----------DESHABILITA BOTONES -----------
	deshabilitaBoton('grabaCM', 'submit');     
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	
	deshabilitaBoton('grabaSuc', 'submit');	
	deshabilitaBoton('modificaSuc', 'submit');
	deshabilitaBoton('eliminaSuc', 'submit');		
	
	deshabilitaBoton('grabaTC', 'submit');
	deshabilitaBoton('modificaTC', 'submit');
	deshabilitaBoton('eliminaTC', 'submit');
	
	deshabilitaBoton('grabaC', 'submit');	
	deshabilitaBoton('modificaC', 'submit');	
	deshabilitaBoton('eliminaC', 'submit');	
	
	deshabilitaBoton('grabaMDiv', 'submit');		
	deshabilitaBoton('modificaMDiv', 'submit');
	deshabilitaBoton('eliminaMDiv', 'submit');
	
	deshabilitaBoton('grabaTDiv', 'submit');
	deshabilitaBoton('modificaTDiv', 'submit');
	deshabilitaBoton('eliminaTDiv', 'submit');
	
	
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
	
	
	
	//------------------------ GRABA FORMA TRANSACCION -----------------------
	$.validator.setDefaults({	
      submitHandler: function(event) { 

    	  //cuentas Mayor
    	 if($('#conceptoMonID').asNumber() >0){
    		
				
	      	if($('#tipoTransaccionCM').asNumber()==1||$('#tipoTransaccionCM').asNumber()==2||$('#tipoTransaccionCM').asNumber()==3){
	      		$('#tipoTransaccionMDiv').val(0);
				$('#tipoTransaccionTDiv').val(0);
				$('#tipoTransaccionSuc').val(0);
				$('#tipoTransaccionTC').val(0);
				$('#tipoTransaccionC').val(0);
				
	      		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuenta','exitoCuentaMAyor','errorCuentaMayor');
	   				
		
	   		}   
	      	// Tipo de Moneda
			if($('#tipoTransaccionMDiv').asNumber()==1 || $('#tipoTransaccionMDiv').asNumber()==2 || $('#tipoTransaccionMDiv').asNumber()==3 ){				
				$('#tipoTransaccionTC').val(0);
				$('#tipoTransaccionC').val(0);				
				$('#tipoTransaccionSuc').val(0);				
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'monedaID',
	   														'exitoSubCtaTipoMoneda','errorSubCtaTipoMoneda');
	   			
	   		}  

			// tipo de Divisa
	   		if($('#tipoTransaccionTDiv').asNumber()==1||$('#tipoTransaccionTDiv').asNumber()==2||$('#tipoTransaccionTDiv').asNumber()==3){
	   			$('#tipoTransaccionTC').val(0);
				$('#tipoTransaccionC').val(0);				
				$('#tipoTransaccionSuc').val(0);	
	   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje', 'true', 'conceptoMonID3',
	   										'exitoSubCtatipoDiv','errorSubCtaTipoDiv');
	
	   		}     		   	
	   		// Por Sucursal
	   		if($('#tipoTransaccionSuc').asNumber()==1||$('#tipoTransaccionSuc').asNumber()==2||$('#tipoTransaccionSuc').asNumber()==3){
	   			$('#tipoTransaccionCM').val(0);			
				$('#tipoTransaccionTC').val(0);
				$('#tipoTransaccionC').val(0);
				$('#tipoTransaccionMDiv').val(0);
				$('#tipoTransaccionTDiv').val(0);
				
		
	   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica4', 'contenedorForma', 'mensaje', 'true', 'conceptoMonID4',
	   											 'exitoSubCtaSucursal','falloSubCtaSucursal');   			
	   		}

	   		// Por Tipo de Caja
	   		if($('#tipoTransaccionTC').asNumber() == 1 || $('#tipoTransaccionTC').asNumber() == 2 || $('#tipoTransaccionTC').asNumber() == 3){
	   			$('#tipoTransaccionCM').val(0);					
				$('#tipoTransaccionC').val(0);
				$('#tipoTransaccionMDiv').val(0);
				$('#tipoTransaccionSuc').val(0);
				$('#tipoTransaccionTDiv').val(0);
	   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica5', 'contenedorForma', 'mensaje', 'true', 'conceptoMonID5',
	   											'exitoSubCtaTipoCaja','errorSubCtaTipoCaja');
	
	   		}
	   		// por numero de Caja
	   		if($('#tipoTransaccionC').asNumber()==1||$('#tipoTransaccionC').asNumber()==2||$('#tipoTransaccionC').asNumber()==3){
	   			$('#tipoTransaccionCM').val(0);				
				$('#tipoTransaccionTC').val(0);
				$('#tipoTransaccionMDiv').val(0);
				$('#tipoTransaccionSuc').val(0);	
				$('#tipoTransaccionTDiv').val(0);
	   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje', 'true', 'conceptoMonID1',
	   											'exitoSubctaNumeroCaja','errorSubCtaNumeroCaja');
	   		}
	   		
    	 }else{
    		 alert("Seleccione un Concepto Contable");
    		 event.preventDefault();
    	 }
      }
   });		
	//------------------ EVENTOS DE LA FORMA--------------------------
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#monedaID').change(function(){
		if($('#conceptoMonID').val()!=0)
		consultaSubCuentaM($('#conceptoMonID').val());
	});
	// cuentas Mayor
	$('#grabaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionDivisas.graba);
	});
	$('#modificaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionDivisas.modifica);
	});
	$('#eliminaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionDivisas.elimina);
	});
	
	//Tipo de Moneda
	$('#grabaMDiv').click(function() {		
		$('#tipoTransaccionMDiv').val(catTipoTransaccionDivisas.graba); 
	});
	$('#modificaMDiv').click(function() {		
		$('#tipoTransaccionMDiv').val(catTipoTransaccionDivisas.modifica); 
	}); 
	$('#eliminaMDiv').click(function() {		
		$('#tipoTransaccionMDiv').val(catTipoTransaccionDivisas.elimina); 
	});
	
	// Tipo de Producto
	$('#grabaTDiv').click(function() {		
		$('#tipoTransaccionTDiv').val(catTipoTransaccionDivisas.graba);
	}); 
	$('#modificaTDiv').click(function() {		
		$('#tipoTransaccionTDiv').val(catTipoTransaccionDivisas.modifica);
	});
	$('#eliminaTDiv').click(function() {		
		$('#tipoTransaccionTDiv').val(catTipoTransaccionDivisas.elimina);
	});
	
	//----por tipo de Sucursal	
	$('#grabaSuc').click(function() {		
		$('#tipoTransaccionSuc').val(catTipoTransaccionDivisas.graba);
	});
	$('#modificaSuc').click(function() {		
		$('#tipoTransaccionSuc').val(catTipoTransaccionDivisas.modifica);
	});
	$('#eliminaSuc').click(function() {		
		$('#tipoTransaccionSuc').val(catTipoTransaccionDivisas.elimina);
	});
	
	// por Tipo de Caja
	$('#grabaTC').click(function() {		
		$('#tipoTransaccionTC').val(catTipoTransaccionDivisas.graba);
	});	
	
	$('#modificaTC').click(function() {	
		$('#tipoTransaccionTC').val(catTipoTransaccionDivisas.modifica);
	});
	$('#eliminaTC').click(function() {		
		$('#tipoTransaccionTC').val(catTipoTransaccionDivisas.elimina);
	});
	
	// por numero de Caja  
	$('#grabaC').click(function() {		
		$('#tipoTransaccionC').val(catTipoTransaccionDivisas.graba);
	});	
	
	$('#modificaC').click(function() {	
		$('#tipoTransaccionC').val(catTipoTransaccionDivisas.modifica);
	});
	$('#eliminaC').click(function() {		
		$('#tipoTransaccionC').val(catTipoTransaccionDivisas.elimina);
	});
	
	
	$('#conceptoMonID').change(function() {		
		validaConcepto('conceptoMonID');
		$('#conceptoMonID2').val($('#conceptoMonID').val());
		$('#conceptoMonID3').val($('#conceptoMonID').val());	
		$('#conceptoMonID1').val($('#conceptoMonID').val());//por Cajero
		$('#conceptoMonID4').val($('#conceptoMonID').val());//Sucursal
		$('#conceptoMonID5').val($('#conceptoMonID').val());//tipo de Caja				
	});	
	
	$('#cuenta').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#cuenta').val();
			listaAlfanumerica('cuenta', '1', '2', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	}); 
	
	
 	consultaConceptosDiv();
  	consultaMoneda();	
	
	function consultaConceptosDiv() {	
  		dwr.util.removeAllOptions('conceptoMonID'); 
  		dwr.util.addOptions('conceptoMonID', {0:'SELECCIONAR'}); 
		conceptosDivServicio.listaCombo(1, function(conceptosDiv){
			dwr.util.addOptions('conceptoMonID', conceptosDiv, 'conceptoMonID', 'descripcion');
		});
	}
	
	function consultaMoneda() {			
  		dwr.util.removeAllOptions('monedaID');
  		dwr.util.addOptions('monedaID', {0:'SELECCIONAR'}); 
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}
	
	
	// ---- Eventos SubCta por sucursal--
	
	$('#sucursalID').change(function() {
  		validaSubCtaSucursal(this.id);
  		if($('#sucursalID').asNumber()>0){
  			consultaCajasSucursales();
  		}  		
	});
	
	consultaSucursales();
	function consultaSucursales() {			
		dwr.util.removeAllOptions('sucursalID'); 		
		dwr.util.addOptions('sucursalID', {'':'SELECCIONAR'});						     
		sucursalesServicio.listaCombo(2, function(sucursal){
		dwr.util.addOptions('sucursalID', sucursal, 'sucursalID', 'nombreSucurs');
		});
	}
		
	//-----Por Caja		
	function consultaCajasSucursales() {			
		dwr.util.removeAllOptions('cajaID'); 	
		var cajaBean ={
			'sucursalID':$('#sucursalID').asNumber()				
		};
		dwr.util.addOptions('cajaID', {0:'SELECCIONAR'});						     
		cajasVentanillaServicio.listacomboCajasSucursal(7, cajaBean,function(cajas){
		dwr.util.addOptions('cajaID', cajas, 'cajaID', 'descripcionCaja');
		});
	}
	
	$('#cajaID').change(function() {		
  		validaSubCtaCaja(this.id);
	});
	//-----------Por tipo de Caja	
	$('#tipoCaja').change(function() {		
  		validaSubctaTipoCaja(this.id);
	});

	//---------- Validaciones de las Formas-------------
	//--- Cuentas del Mayor
	$('#formaGenerica').validate({
		rules: {
			conceptoMonID: 'required',
			cuenta		: {
				maxlength	: 	4
			}
			
		},
		
		messages: {
			conceptoMonID: 'Especifique Concepto',
			cuenta		: {
				maxlength	: 	'Maximo Cuatro Digitos'
			}
		}		
	});	
	
	// por Tipo de Moneda	
	$('#formaGenerica2').validate({
		rules: {
			conceptoMonID2: 'required',
			subCuenta		: {
				maxlength	: 	2
			},
			subCuenta: 'required'
		},
		
		messages: {
			conceptoMonID2: 'Especifique Concepto',
			subCuenta		: {
				maxlength	: 	'Como maximo Dos Digitos'
			},
			subCuenta: 'Especifique la SubCuenta'
		}		
	});
	// Por Tipo de Cambio
	$('#formaGenerica3').validate({
		rules: {
			conceptoMonID3: 'required',
			billetes: 'required',
			monedas: 'required'
		},
		
		messages: {
			conceptoMonID3: 'Especifique Concepto',
			billetes: 'Especifique la SubCuenta ',
			monedas: 'Especifique la SubCuenta '
		}		
	}); 
	//---- Por Caja 
	$('#formaGenerica1').validate({
		rules: {
			subCuenta03: 'required'
		},		
		messages: {
			subCuenta03: 'Especifique la SubCuenta '
		}		
	}); 
	//---- 	por sucursal
	$('#formaGenerica4').validate({
		rules: {
			subCuenta01: 'required'
		},		
		messages: {
			subCuenta01: 'Especifique la SubCuenta'
		}		
	}); 
	// Por Tipo de Caja
	$('#formaGenerica5').validate({
		rules: {
			subCuenta02: 'required'
		},		
		messages: {
			subCuenta02: 'Especifique la SubCuenta'
		}		
	}); 
 
	
	
	
	

	
	
	
});
			
function insertAtCaret(areaId,text) { 
	    var txtarea = document.getElementById(areaId); 
	    var scrollPos = txtarea.scrollTop; 
	    var strPos = 0;  
	    var br = ((txtarea.selectionStart || txtarea.selectionStart == '0') ?  
	    "ff" : (document.selection ? "ie" : false ) ); 
	    if (br == "ie") {  
	    txtarea.focus(); 
	    var range = document.selection.createRange(); 
	    range.moveStart ('character', -txtarea.value.length); 
	    strPos = range.text.length; 
	    }  
	    else if (br == "ff") strPos = txtarea.selectionStart; 
	    var front = (txtarea.value).substring(0,strPos);   
	    var back = (txtarea.value).substring(strPos,txtarea.value.length);  
	    txtarea.value=front+text+back; 
	    strPos = strPos + text.length; 
	    if (br == "ie") {  
	    txtarea.focus();  
	    var range = document.selection.createRange(); 
	    range.moveStart ('character', -txtarea.value.length); 
	    range.moveStart ('character', strPos); 
	    range.moveEnd ('character', 0); 
	    range.select(); 
	    } 
	    else if (br == "ff") { 
	    txtarea.selectionStart = strPos; 
	    txtarea.selectionEnd = strPos; 
	    txtarea.focus();  
	    } 
	    txtarea.scrollTop = scrollPos; 
	}

function ayuda(){	
	var data;			       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura:</legend>'+
			'<div id="ContenedorAyuda">'+ 			
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="encabezadoLista">&CM</td><td id="contenidoAyuda" align="left"><b>Cuentas de Mayor</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TP</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Tipo (Billetes o Monedas)</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TM</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Tipo de Moneda</b></td>'+ 
				'</tr>'+
				
			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Cuenta Divisa</legend>'+
			
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Cuenta: </b></td>'+ 
					'<td id="contenidoAyuda" colspan="8">1010</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" colspan="9"><b>Nomenclatura:</b></td>'+ 
				'</tr>'+
				'<tr align="center" id="contenidoAyuda" >'+
					'<td>&CM</td><td>-</td><td>01</td>'+
					'<td>-</td><td>&TM</td><td>-</td>'+
					'<td>&TP</td><td>-</td><td>00</td>'+
				'</tr>'+
				'<tr>'+
					'<td colspan="9" id="encabezadoAyuda"><b>Cuenta Completa:</b></td>'+ 
				'</tr>'+
				'<tr align="center" id="contenidoAyuda">'+
					'<td>1010</td><td>-</td><td>01</td>'+
					'<td>-</td><td>01</td><td>-</td>'+
					'<td>01</td><td>-</td><td>01</td>'+
				'</tr>'+
				'<tr>'+
			'</table>'+
			'</div></div>'+ 
			'</fieldset>'+
			'</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}	
	
function ayudaCR(){	
	var data;
	
				       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura Centro Costo:</legend>'+
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="encabezadoLista">&SO</td><td id="contenidoAyuda"><b>Sucursal Origen</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista" >&SC</td><td id="contenidoAyuda"><b>Sucursal Cliente</b></td>'+
				'</tr>'+ 
			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+  
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplos: </legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 1: </b></td>'+ 
					'<td id="contenidoAyuda">&SO</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 2:</b></td>'+ 
					'<td id="contenidoAyuda">&SC</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Ejemplo 3:</b></td>'+ 
					'<td id="contenidoAyuda">15</td>'+
				'</tr>'+
			'</table>'+
			'</div></div>'+  
			'</fieldset>'+
			'</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}	




//----------por Sucursal-----------------------------------
function exitoSubCtaSucursal(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
	$('#subCuenta01').val('');
	validaSubCtaSucursal('');

}
function falloSubCtaSucursal(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
}
//------- por tipo de Caja ---------------------------
function exitoSubCtaTipoCaja(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
	$('#subCuenta02').val('');
	
	validaSubctaTipoCaja('');

}
function errorSubCtaTipoCaja(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
}
//-------------- por Numero de Caja -----------------
function exitoSubctaNumeroCaja(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
	$('#subCuenta03').val('');
	validaSubCtaCaja('');

	
}
function errorSubCtaNumeroCaja(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
}
//-------------------Por tipo de moneda -------------
function exitoSubCtaTipoMoneda(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
	$('#subCuenta').val('');
	consultaSubCuentaM($('#conceptoMonID').val());
	
}
function errorSubCtaTipoMoneda(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
}
//-----------------------Por tipo de Producto-----------------
function exitoSubCtatipoDiv(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
	$('#monedas').val('');		
	$('#billetes').val('');	
	consultaSubCuentaT($('#conceptoMonID').val());

}
function errorSubCtaTipoDiv(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
	
}

//-------------------Cuentas del Mayor-----------------
function exitoCuentaMAyor(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
	$('#cuenta').val('');
	$('#nomenclatura').val('');
	$('#nomenclaturaCR').val('');
	validaConcepto('conceptoMonID');
	
	

}

function errorCuentaMayor(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSuc').val(0);	
	$('#tipoTransaccionTC').val(0);
	$('#tipoTransaccionC').val(0);
	$('#tipoTransaccionMDiv').val(0);
	$('#tipoTransaccionTDiv').val(0);
	
}



//---------------- Funciones SubCta Por Sucursal  ------------------	
function validaSubCtaSucursal(numConcepto) {	
	var tipConPrincipal = 1;
	numConcepto =$('#conceptoMonID4').val();
	var sucursal= $('#sucursalID').asNumber();
	var SubCtaSucursalDiv = {
			
		'conceptoMonID'	:numConcepto,
		'sucursalID'	:sucursal
	};	
	setTimeout("$('#cajaLista').hide();", 200);	
	if(numConcepto != '' && !isNaN(numConcepto) && sucursal > 0){
		subCtaSucursalDivisaServicio.consulta(tipConPrincipal, SubCtaSucursalDiv,function(subCtaSucursal) {
			if(subCtaSucursal != null){					
				$('#conceptoAhoID4').val(subCtaSucursal.conceptoAhoID);
				$('#sucursalID').val(subCtaSucursal.sucursalID);				
				$('#subCuenta01').val(subCtaSucursal.subCuenta);
				
				deshabilitaBoton('grabaSuc', 'submit');
				habilitaBoton('eliminaSuc', 'submit');
				habilitaBoton('modificaSuc', 'submit');														
			}else{
				$('#subCuenta01').val('');
				deshabilitaBoton('eliminaSuc', 'submit');
				deshabilitaBoton('modificaSuc', 'submit');
				habilitaBoton('grabaSuc', 'submit');					
			}
		});											
	}
	deshabilitaBoton('eliminaSuc', 'submit');
	deshabilitaBoton('modificaSuc', 'submit');
	deshabilitaBoton('grabaSuc', 'submit');
	$('#subCuenta01').val('');
}


//-------------------------Funciones Subcta por Tipo de Caja
function validaSubctaTipoCaja(numConcepto) {		
	var tipConPrincipal = 1;
	numConcepto =$('#conceptoMonID5').asNumber();
	var tipoCaja= $('#tipoCaja').val();
	var SubCtaTipoCaja = {				
		'conceptoMonID'	:numConcepto,
		'tipoCaja'	:tipoCaja
	};	

	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && tipoCaja != -1){
		subCtaTipoCajaDivisaServicio.consulta(tipConPrincipal, SubCtaTipoCaja,function(subCtaTipoCaja) {
			if(subCtaTipoCaja != null){				
				$('#conceptoAhoID5').val(subCtaTipoCaja.conceptoAhoID);
				$('#tipoCaja').val(subCtaTipoCaja.tipoCaja);				
				$('#subCuenta02').val(subCtaTipoCaja.subCuenta);
				
				deshabilitaBoton('grabaTC', 'submit');
				habilitaBoton('eliminaTC', 'submit');
				habilitaBoton('modificaTC', 'submit');														
			}else{
				$('#subCuenta02').val('');
				deshabilitaBoton('eliminaTC', 'submit');
				deshabilitaBoton('modificaTC', 'submit');
				habilitaBoton('grabaTC', 'submit');					
			}
		});											
	}
	deshabilitaBoton('eliminaTC', 'submit');
	deshabilitaBoton('modificaTC', 'submit');
	deshabilitaBoton('grabaTC', 'submit');
	$('#subCuenta02').val('');
}



//por numero de Caja
function validaSubCtaCaja(numConcepto) {		
	var tipConPrincipal = 1;
	numConcepto =$('#conceptoMonID1').asNumber();
	var cajaID= $('#cajaID').asNumber();
	var subctaCaja = {				
		'conceptoMonID'	:numConcepto,
		'cajaID'	:cajaID
	};	

	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && cajaID >0){
		subCtaCajeroDivisaServicio.consulta(tipConPrincipal, subctaCaja,function(subCtaTipoCaja) {
			if(subCtaTipoCaja != null){				
				$('#conceptoAhoID1').val(subCtaTipoCaja.conceptoAhoID);
				$('#cajaID').val(subCtaTipoCaja.cajaID);				
				$('#subCuenta03').val(subCtaTipoCaja.subCuenta);
				
				deshabilitaBoton('grabaC', 'submit');
				habilitaBoton('eliminaC', 'submit');
				habilitaBoton('modificaC', 'submit');														
			}else{
				$('#subCuenta03').val('');
				deshabilitaBoton('eliminaC', 'submit');
				deshabilitaBoton('modificaC', 'submit');
				habilitaBoton('grabaC', 'submit');					
			}
		});											
	}
	deshabilitaBoton('eliminaC', 'submit');
	deshabilitaBoton('modificaC', 'submit');
	deshabilitaBoton('grabaC', 'submit');
	$('#subCuenta03').val('');
}


//--------------Consulta por tipo de Moneda

function consultaSubCuentaM(numConcepto) {	
	
	var SubMonedaBeanCon = {
		'conceptoMonID'	:numConcepto,
		'monedaID'		:$('#monedaID').asNumber()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab && $('#monedaID').asNumber() > 0 ){
		subCtaMonedaDivServicio.consulta(1, SubMonedaBeanCon,function(subCuentaM) {
			if(subCuentaM!=null){
				$('#conceptoMonID2').val(subCuentaM.conceptoMonID);			
				$('#subCuenta').val(subCuentaM.subCuenta);
				deshabilitaBoton('grabaMDiv', 'submit');
				habilitaBoton('modificaMDiv', 'submit');
				habilitaBoton('eliminaMDiv', 'submit');													
			}else{
				deshabilitaBoton('modificaMDiv', 'submit');
				deshabilitaBoton('eliminaMDiv', 'submit');
				habilitaBoton('grabaMDiv', 'submit');	
				$('#subCuenta').val('');						
			}
		});											
	}
	deshabilitaBoton('modificaMDiv', 'submit');
	deshabilitaBoton('eliminaMDiv', 'submit');
	deshabilitaBoton('grabaMDiv', 'submit');
	$('#subCuenta').val('');
	
}


//------------por tipo de Producto----------------------

function consultaSubCuentaT(numConcepto) {		
	var SubTipoBeanCon = {
		'conceptoMonID'	:numConcepto,
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subCtaTipoDivServicio.consulta(1, SubTipoBeanCon,function(subCuentaT) {
			if(subCuentaT!=null){
				$('#conceptoMonID3').val(subCuentaT.conceptoMonID);			
				$('#billetes').val(subCuentaT.billetes);
				$('#monedas').val(subCuentaT.monedas);
				deshabilitaBoton('grabaTDiv', 'submit');
				habilitaBoton('modificaTDiv', 'submit');
				habilitaBoton('eliminaTDiv', 'submit');													
			}else{
				deshabilitaBoton('modificaTDiv', 'submit');
				deshabilitaBoton('eliminaTDiv', 'submit');
				habilitaBoton('grabaTDiv', 'submit');	
				$('#monedas').val('');		
				$('#billetes').val('');					
			}
		});											
	}
}




//------------ Validaciones de Controles -------------------------------------	
function validaConcepto(idControl) {
	var jqConcepto = eval("'#" + idControl + "'");
	var numConcepto = $(jqConcepto).val();	
	var tipConPrincipal = 1;
	var CuentaMayorBeanCon = {
		'conceptoMonID'	:numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 50);		
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){		
		if($('#conceptoMonID').val()==0){
			$('#cuenta').focus();
			$('#cuenta').val('');
			$('#nomenclatura').val('');
			$('#nomenclaturaCR').val('');								
			$('#subCuenta').val('');
			$('#billetes').val('');
			$('#monedas').val('');	
			deshabilitaBoton('grabaCM', 'submit');     
			deshabilitaBoton('grabaMDiv', 'submit');	
			deshabilitaBoton('grabaTDiv', 'submit');	
	
			deshabilitaBoton('modificaCM', 'submit');
			deshabilitaBoton('modificaMDiv', 'submit');
			deshabilitaBoton('modificaTDiv', 'submit');
			
			deshabilitaBoton('eliminaCM', 'submit');
			deshabilitaBoton('eliminaMDiv', 'submit');
		   deshabilitaBoton('eliminaTDiv', 'submit');
		
			inicializaForma('formaGenerica','conceptoMonID');
															
		} else {
			cuentasMayorMonServicio.consulta(tipConPrincipal, CuentaMayorBeanCon,function(cuentaM) {
					if(cuentaM!=null){
						
						$('#cuenta').val(cuentaM.cuenta);
						$('#nomenclatura').val(cuentaM.nomenclatura);
						$('#nomenclaturaCR').val(cuentaM.nomenclaturaCR);
						consultaSubCuentas(numConcepto);
						deshabilitaBoton('grabaCM', 'submit'); 
						habilitaBoton('modificaCM', 'submit');
						habilitaBoton('eliminaCM', 'submit');
						
					}else{
						consultaSubCuentas(numConcepto);
						deshabilitaBoton('modificaCM', 'submit');
						deshabilitaBoton('eliminaCM', 'submit');
						habilitaBoton('grabaCM', 'submit');
						$('#cuenta').focus();
						$('#cuenta').val('');
						$('#nomenclatura').val('');
						$('#nomenclaturaCR').val('');								
						$('#subCuenta').val('');
						$('#billetes').val('');
						$('#monedas').val('');	
														
					}
			});														
		}												
	}
}

function consultaSubCuentas(numConcepto) {	
	consultaSubCuentaM(numConcepto);
	consultaSubCuentaT(numConcepto);
}
