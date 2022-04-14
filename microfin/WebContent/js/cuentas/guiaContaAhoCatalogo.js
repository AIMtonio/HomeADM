$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionTasaAhorro = {
  		'graba':'1',
  		'modifica':'2',
  		'elimina':'3'
	};
	
	var catTipoConsultaTasaAhorro = {
  		'principal':'1',
  		'foranea':'2'
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
	 	esTab = false;
	});

	deshabilitaBoton('grabaCM', 'submit');     
	deshabilitaBoton('grabaSR', 'submit');
	deshabilitaBoton('grabaTPR', 'submit');	
	deshabilitaBoton('grabaTPE', 'submit');	
	deshabilitaBoton('grabaSM', 'submit');		
	deshabilitaBoton('grabaSCT', 'submit');		
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('modificaSR', 'submit');
	deshabilitaBoton('modificaTPR', 'submit');
	deshabilitaBoton('modificaTPE', 'submit');
	deshabilitaBoton('modificaSM', 'submit');
	deshabilitaBoton('modificaSCT', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	deshabilitaBoton('eliminaSR', 'submit');
	deshabilitaBoton('eliminaTPR', 'submit');
	deshabilitaBoton('eliminaTPE', 'submit');
	deshabilitaBoton('eliminaSM', 'submit');
	deshabilitaBoton('eliminaSCT', 'submit');
	
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSR').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionSCT').val(0);

	
$.validator.setDefaults({	
      submitHandler: function(event) { 
      	if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2||$('#tipoTransaccionCM').val()==3){
      		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuenta','funcionExitoCM','funcionFalloGuiaConta');
   		}
		if($('#tipoTransaccionSR').val()==1 || $('#tipoTransaccionSR').val()==2 || $('#tipoTransaccionSR').val()==3 ){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'paga','funcionExitoSR','funcionFalloGuiaConta');
   		}
   		if($('#tipoTransaccionTPR').val()==1||$('#tipoTransaccionTPR').val()==2||$('#tipoTransaccionTPR').val()==3){
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje', 'true', 'tipoProductoID','funcionExitoTPR','funcionFalloGuiaConta');
   		}  
   		if($('#tipoTransaccionTPE').val()==1||$('#tipoTransaccionTPE').val()==2||$('#tipoTransaccionTPE').val()==3){
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica4', 'contenedorForma', 'mensaje', 'true', 'fisica','funcionExitoTPE','funcionFalloGuiaConta');
   		}        	
		if($('#tipoTransaccionSM').val()==1||$('#tipoTransaccionSM').val()==2||$('#tipoTransaccionSM').val()==3){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica5', 'contenedorForma', 'mensaje', 'true', 'monedaID','funcionExitoSM','funcionFalloGuiaConta');
   		}
		if($('#tipoTransaccionSCT').val()==1||$('#tipoTransaccionSCT').val()==2||$('#tipoTransaccionSCT').val()==3){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje', 'true', 'subCuenta3','funcionExitoSCT','funcionFalloGuiaConta');
   		}  
      }
   });		


	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionTasaAhorro.graba);
	});
	$('#grabaSR').click(function() {		
		$('#tipoTransaccionSR').val(catTipoTransaccionTasaAhorro.graba); 
	});
	$('#grabaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionTasaAhorro.graba);
	}); 
	$('#grabaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionTasaAhorro.graba);
	});
	$('#grabaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionTasaAhorro.graba);
	});
	$('#grabaSCT').click(function() {		
		$('#tipoTransaccionSCT').val(catTipoTransaccionTasaAhorro.graba);
	});
	
	$('#modificaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionTasaAhorro.modifica);
	});
	$('#modificaSR').click(function() {		
		$('#tipoTransaccionSR').val(catTipoTransaccionTasaAhorro.modifica); 
	}); 
	$('#modificaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionTasaAhorro.modifica);
	});
	$('#modificaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionTasaAhorro.modifica);
	});
	$('#modificaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionTasaAhorro.modifica);
	});
	$('#modificaSCT').click(function() {		
		$('#tipoTransaccionSCT').val(catTipoTransaccionTasaAhorro.modifica);
	});
	
	$('#eliminaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionTasaAhorro.elimina);
	});
	$('#eliminaSR').click(function() {		
		$('#tipoTransaccionSR').val(catTipoTransaccionTasaAhorro.elimina); 
	}); 
	$('#eliminaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionTasaAhorro.elimina);
	});
	$('#eliminaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionTasaAhorro.elimina);
	});
	$('#eliminaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionTasaAhorro.elimina);
	}); 
	$('#eliminaSCT').click(function() {		
		$('#tipoTransaccionSCT').val(catTipoTransaccionTasaAhorro.elimina);
	});
	
	
	$('#conceptoAhoID').change(function() {	
		validaConcepto('conceptoAhoID');	
		$('#conceptoAhoID2').val($('#conceptoAhoID').val());
		$('#conceptoAhoID3').val($('#conceptoAhoID').val());
		$('#conceptoAhoID4').val($('#conceptoAhoID').val());
		$('#conceptoAhoID5').val($('#conceptoAhoID').val());
		$('#conceptoAhoID1').val($('#conceptoAhoID').val());
	});	
	
	$('#conceptoAhoID').blur(function() {	
		validaConcepto('conceptoAhoID');	
		$('#conceptoAhoID2').val($('#conceptoAhoID').val());
		$('#conceptoAhoID3').val($('#conceptoAhoID').val());
		$('#conceptoAhoID4').val($('#conceptoAhoID').val());
		$('#conceptoAhoID5').val($('#conceptoAhoID').val());
		$('#conceptoAhoID1').val($('#conceptoAhoID').val());
	});	
	
	
	$('#tipoProductoID').change(function() {	
		consultaSubTipoPro($('#conceptoAhoID').val());
	});
	
	$('#monedaID').change(function() {	
		consultaSubCuentaM($('#conceptoAhoID').val());	
	});
	
	$('#tipoProductoID').blur(function() {	
		consultaSubTipoPro($('#conceptoAhoID').val());
	});
	
	$('#monedaID').blur(function() {	
		consultaSubCuentaM($('#conceptoAhoID').val());	
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
	
	$('#clasificacionContaV').click(function() {
		$('#clasificacionContaV').attr('checked', true);
		$('#clasificacionContaA').attr('checked', false);
		$('#clasificacion').val("V");
		$('#clasificacionContaV').focus();
		consultaSubCuentaClasificacion($('#conceptoAhoID1').val());
	});
	
	$('#clasificacionContaA').click(function() {
		$('#clasificacionContaA').attr('checked', true);
		$('#clasificacionContaV').attr('checked', false);
		$('#clasificacion').val("A");
		$('#clasificacionContaA').focus();
		consultaSubCuentaClasificacion($('#conceptoAhoID1').val());
	});


  	consultaConceptosAhorro();
  	consultaTiposCuenta();
  	consultaMoneda();

	//------------ Validaciones de la Forma -------------------------------------
	
	
	$('#formaGenerica').validate({
		rules: {
			conceptoAhoID: 'required',
			cuenta		: {
				maxlength	: 	4
			},
			subCuenta3		: {
				maxlength	: 	2
			}
		},
		
		messages: {
			conceptoAhoID: 'Especifique Concepto',
			cuenta		: {
				maxlength	: 	'Maximo Cuatro Digitos'
			},
			subCuenta3		: {
				maxlength	: 	'Como máximo Dos Digitos'
			}
		}		
	});

	$('#formaGenerica2').validate({
		rules: {
			conceptoAhoID2: 'required'
		},
		
		messages: {
			conceptoAhoID2: 'Especifique Concepto'
		}		
	}); 
	
	$('#formaGenerica3').validate({
		rules: {
			conceptoAhoID3	: 'required',
			subCuenta		: {
				maxlength	: 	2
			}

		},
		
		messages: {
			conceptoAhoID3: 'Especifique Concepto',
			subCuenta		: {
				maxlength	: 	'Como maximo Dos Dígitos'
			}

		
		}		
	}); 
	
	$('#formaGenerica4').validate({
		rules: {
			conceptoAhoID4: 'required'
		},
		
		messages: {
			conceptoAhoID4: 'Especifique Concepto'
		}		
	}); 
	
	$('#formaGenerica5').validate({
		rules: {
			conceptoAhoID5: 'required',
			subCuenta2		: {
				maxlength	: 	2
			}
		},
		
		messages: {
			conceptoAhoID5: 'Especifique Concepto',
			subCuenta2		: {
				maxlength	: 	'Como máximo Dos Digitos'
			}
		}		
	});
	
	$('#formaGenerica1').validate({
		rules: {
			conceptoAhoID1: 'required',
			subCuenta3		: {
				maxlength	: 	2
			}
		},
		
		messages: {
			conceptoAhoID1: 'Especifique Concepto',
			subCuenta3		: {
				maxlength	: 	'Como máximo Dos Digitos'
			}
		}		
	});
	
	
	
	//------------ Validaciones de Controles -------------------------------------
	
	
	function consultaConceptosAhorro() {	
  		dwr.util.removeAllOptions('conceptoAhoID'); 
  		dwr.util.addOptions('conceptoAhoID', {"0":'SELECCIONAR'}); 
		conceptosAhorroServicio.listaCombo(1, function(conceptosAho){
			dwr.util.addOptions('conceptoAhoID', conceptosAho, 'conceptoAhoID', 'descripcion');
		});
	}
	
	function consultaMoneda() {			
  		dwr.util.removeAllOptions('monedaID');
  		
  		dwr.util.addOptions('monedaID', {"0":'SELECCIONAR'}); 
	
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}
	
	function consultaTiposCuenta() {			
  		dwr.util.removeAllOptions('tipoProductoID'); 
  		
  		dwr.util.addOptions('tipoProductoID', {"0":'SELECCIONAR'}); 
	
		tiposCuentaServicio.listaCombo(9, function(tiposCuenta){
		dwr.util.addOptions('tipoProductoID', tiposCuenta, 'tipoCuentaID', 'descripcion');
		});
	}
	
	
});

function validaConcepto(idControl) {
	var jqConcepto = eval("'#" + idControl + "'");
	var numConcepto = $(jqConcepto).val();	
	var tipConPrincipal = 1;
	var CuentaMayorBeanCon = {
		'conceptoAhoID'	:numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){		
		if(numConcepto=='-1'){
			deshabilitaBoton('grabaCM', 'submit');     
			deshabilitaBoton('grabaSR', 'submit');
			deshabilitaBoton('grabaTPR', 'submit');	
			deshabilitaBoton('grabaTPE', 'submit');	
			deshabilitaBoton('grabaSM', 'submit');	
			deshabilitaBoton('grabaSCT', 'submit');	
			deshabilitaBoton('modificaCM', 'submit');
			deshabilitaBoton('modificaSR', 'submit');
			deshabilitaBoton('modificaTPR', 'submit');
			deshabilitaBoton('modificaTPE', 'submit');
			deshabilitaBoton('modificaSM', 'submit');
			deshabilitaBoton('modificaSM', 'submit');
			deshabilitaBoton('eliminaCM', 'submit');
			deshabilitaBoton('eliminaSR', 'submit');
			deshabilitaBoton('eliminaTPR', 'submit');
			deshabilitaBoton('eliminaTPE', 'submit');
			deshabilitaBoton('eliminaSM', 'submit');
			deshabilitaBoton('eliminaSM', 'submit');
			inicializaForma('formaGenerica','conceptoID');	
			
		} else {
			cuentasMayorAhoServicio.consulta(tipConPrincipal, CuentaMayorBeanCon,function(cuentaM) {
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
						$('#paga').val('');
						$('#noPaga').val('');
						$('#fisica').val('');
						$('#moral').val('');			
						$('#subCuenta').val('');							
					}
			});														
		}												
	}
} // fin validaConcepto

function consultaSubCuentas(numConcepto) {	
	consultaSubCuentaR(numConcepto);
	consultaSubTipoPro(numConcepto);
	consultaSubTipoPer(numConcepto);
	consultaSubCuentaM(numConcepto);
	consultaSubCuentaClasificacion(numConcepto);
}

function consultaSubCuentaR(numConcepto) {	
	var tipConPrincipal = 1;
	var SubRendiBeanCon = {
		'conceptoAhoID'	:numConcepto
	};	
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subCtaRendiAhoServicio.consulta(tipConPrincipal, SubRendiBeanCon,function(subCuentaR) {
			if(subCuentaR!=null){					
				$('#conceptoAhoID2').val(subCuentaR.conceptoAhoID);
				$('#paga').val(subCuentaR.paga);				
				$('#noPaga').val(subCuentaR.noPaga);
				deshabilitaBoton('grabaSR', 'submit');
				habilitaBoton('modificaSR', 'submit');
				habilitaBoton('eliminaSR', 'submit');														
			}else{
				deshabilitaBoton('modificaSR', 'submit');
				deshabilitaBoton('eliminaSR', 'submit');
				habilitaBoton('grabaSR', 'submit');
				$('#paga').val('');
				$('#noPaga').val('');
			}
		});											
	}
}

function consultaSubTipoPro(numConcepto){	
	var tipConPrincipal = 1;
	var SubTipoProBeanCon = {
		'conceptoAhoID'	:numConcepto,
		'tipoProductoID': $('#tipoProductoID').val() 
	};;
	setTimeout("$('#cajaLista').hide();", 200);
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subCtaTiProAhoServicio.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
			if(subCuentaTP!=null){
				$('#conceptoAhoID3').val(subCuentaTP.conceptoAhoID);
				//$('#tipoProductoID').val(subCuentaTP.tipoProductoID).selected = true;	
				$('#subCuenta').val(subCuentaTP.subCuenta);
				deshabilitaBoton('grabaTPR', 'submit');
				habilitaBoton('modificaTPR', 'submit');
				habilitaBoton('eliminaTPR', 'submit');													
			}else{
				deshabilitaBoton('modificaTPR', 'submit');
				deshabilitaBoton('eliminaTPR', 'submit');
				habilitaBoton('grabaTPR', 'submit');
				$('#subCuenta').val('');
			}
		});											
	}
}

function consultaSubTipoPer(numConcepto) {	
	var tipConPrincipal = 1;
	var SubTipoPerBeanCon = {
		'conceptoAhoID'	:numConcepto
	};
	setTimeout("$('#cajaLista').hide();", 200);	
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subCtaTiPerAhoServicio.consulta(tipConPrincipal, SubTipoPerBeanCon,function(subCuentaTP) {
			if(subCuentaTP!=null){
				$('#conceptoAhoID4').val(subCuentaTP.conceptoAhoID);
				$('#fisica').val(subCuentaTP.fisica);				
				$('#moral').val(subCuentaTP.moral);
				deshabilitaBoton('grabaTPE', 'submit');
				habilitaBoton('modificaTPE', 'submit');
				habilitaBoton('eliminaTPE', 'submit');													
			}else{
				deshabilitaBoton('modificaTPE', 'submit');
				deshabilitaBoton('eliminaTPE', 'submit');
				habilitaBoton('grabaTPE', 'submit');
				$('#fisica').val('');
				$('#moral').val('');									
			}
		});											
	}
}

function consultaSubCuentaM(numConcepto) {	
	var tipConPrincipal = 1;
	var SubMonedaBeanCon = {
		'conceptoAhoID'	:numConcepto,
		'monedaID'		:$('#monedaID').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subCtaMonedaAhoServicio.consulta(tipConPrincipal, SubMonedaBeanCon,function(subCuentaM) {
			if(subCuentaM!=null){
				$('#conceptoAhoID5').val(subCuentaM.conceptoAhoID);
				//$('#monedaID').val(subCuentaM.monedaID).selected = true;				
				$('#subCuenta2').val(subCuentaM.subCuenta);
				deshabilitaBoton('grabaSM', 'submit');
				habilitaBoton('modificaSM', 'submit');
				habilitaBoton('eliminaSM', 'submit');													
			}else{
				deshabilitaBoton('modificaSM', 'submit');
				deshabilitaBoton('eliminaSM', 'submit');
				habilitaBoton('grabaSM', 'submit');	
				$('#subCuenta2').val('');						
			}
		});											
	}
}

function consultaSubCuentaClasificacion(numConcepto) {	
	var tipConPrincipal = 1;
	var SubMonedaBeanCon = {
		'conceptoAhoID'	:numConcepto,
		'clasificacion'		:$('#clasificacion').val()
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numConcepto != '' && !isNaN(numConcepto) && esTab){
		subCtaClasifAhoServicio	.consulta(tipConPrincipal, SubMonedaBeanCon,function(subCuentaM) {
			if(subCuentaM!=null){
				$('#conceptoAhoID1').val(subCuentaM.conceptoAhoID);
				//alert("Sandra numConcepto "+numConcepto+"\n $('#clasificacion').val()" +$('#clasificacion').val() );
				if(subCuentaM.clasificacion=='V'){
					$('#clasificacionContaA').attr('checked', false);
					$('#clasificacionContaV').attr('checked', true);
					$('#clasificacion').val("V");
				}else{
					$('#clasificacionContaA').attr('checked', true);
					$('#clasificacionContaV').attr('checked', false);
					$('#clasificacion').val("A");
				}
				$('#subCuenta3').val(subCuentaM.subCuenta);
				habilitaBoton('modificaSCT', 'submit');
				habilitaBoton('eliminaSCT', 'submit');
				deshabilitaBoton('grabaSCT', 'submit');												
			}else{
				deshabilitaBoton('modificaSCT', 'submit');
				deshabilitaBoton('eliminaSCT', 'submit');
				habilitaBoton('grabaSCT', 'submit');
				$('#subCuenta3').val('');						
			}
		});											
	}
}

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
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura:</legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoLista">&CM</td><td id="contenidoAyuda" align="left"><b>Cuentas de Mayor</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista" >&TR</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Rendimiento</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TP</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Producto</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TC</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Persona</b></td>'+ 
				'</tr>'+
				'<tr>'+ 
					'<td id="encabezadoLista">&TM</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Moneda</b></td>'+
				'</tr>'+
			'</table>'+
			'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Cuenta de Pasivo</legend>'+
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Cuenta: </b></td>'+ 
					'<td colspan="6" id="contenidoAyuda">2101</td>'+
				'</tr>'+
				'<tr>'+
					'<td colspan="9" id="encabezadoAyuda"><b>Nomenclatura:</b></td>'+ 
				'</tr>'+
				'<tr id="contenidoAyuda">'+
					'<td>&CM</td><td>-</td><td>&TR</td>'+
					'<td>-</td><td>&TP</td><td>-</td>'+
					'<td>&TC</td><td>-</td><td>&TM</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" colspan="9"><b>Cuenta Completa:</b></td>'+ 
				'</tr>'+
				'<tr id="contenidoAyuda">'+
					'<td>2101</td><td>-</td><td>01</td>'+
					'<td>-</td><td>01</td><td>-</td>'+
					'<td>01</td><td>-</td><td>01</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Descripci&oacute;n:</b></td>'+ 
					'<td colspan="8" id="contenidoAyuda"><i>CUENTA DE AHORRO PARA PERSONA FISICA</i></td>'+
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

function funcionExitoSCT(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSR').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#subcuenta3').focus();
	consultaSubCuentaClasificacion($('#conceptoAhoID1').val());
	if($('#tipoTransaccionSCT').val()=="1"){
		habilitaBoton('modificaSCT', 'submit');
		habilitaBoton('eliminaSCT', 'submit');
		deshabilitaBoton('grabaSCT', 'submit');
		$('#tipoTransaccionSCT').val(0);
	}else{
		if($('#tipoTransaccionSCT').val()==2){
			habilitaBoton('modificaSCT', 'submit');
			habilitaBoton('eliminaSCT', 'submit');
			deshabilitaBoton('grabaSCT', 'submit');		
			$('#tipoTransaccionSCT').val(0);	
		}else{
			if($('#tipoTransaccionSCT').val()==3){
				deshabilitaBoton('modificaSCT', 'submit');
				deshabilitaBoton('eliminaSCT', 'submit');
				habilitaBoton('grabaSCT', 'submit');
				$('#tipoTransaccionSCT').val(0);
			}
		}
	}  
}

function funcionExitoCM(){
	esTab=true;
	$('#tipoTransaccionSR').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionSCT').val(0);
	validaConcepto('conceptoAhoID');
	if($('#tipoTransaccionCM').val()==1){
		deshabilitaBoton('grabaCM', 'submit'); 
		habilitaBoton('modificaCM', 'submit');
		habilitaBoton('eliminaCM', 'submit');	
		$('#tipoTransaccionCM').val(0);
	}else{
		if($('#tipoTransaccionCM').val()==2){
			deshabilitaBoton('grabaCM', 'submit'); 
			habilitaBoton('modificaCM', 'submit');
			habilitaBoton('eliminaCM', 'submit');	
			$('#tipoTransaccionCM').val(0);
		}else{
			if($('#tipoTransaccionCM').val()==3){
				habilitaBoton('grabaCM', 'submit'); 
				deshabilitaBoton('modificaCM', 'submit');
				deshabilitaBoton('eliminaCM', 'submit');
				$('#tipoTransaccionCM').val(0);	
			}
		}
	}
}

function funcionExitoSR(){
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionSCT').val(0);
	esTab=true;
	consultaSubCuentas('conceptoAhoID');
	if($('#tipoTransaccionSR').val()==1){
		deshabilitaBoton('grabaSR', 'submit');
		habilitaBoton('modificaSR', 'submit');
		habilitaBoton('eliminaSR', 'submit');	
		$('#tipoTransaccionSR').val(0);
	}else{
		if($('#tipoTransaccionSR').val()==2){
			deshabilitaBoton('grabaSR', 'submit');
			habilitaBoton('modificaSR', 'submit');
			habilitaBoton('eliminaSR', 'submit');
			$('#tipoTransaccionSR').val(0);
		}else{
			if($('#tipoTransaccionSR').val()==3 ){
				habilitaBoton('grabaSR', 'submit');
				deshabilitaBoton('modificaSR', 'submit');
				deshabilitaBoton('eliminaSR', 'submit');
				$('#tipoTransaccionSR').val(0);
				$('#paga').val("");
				$('#noPaga').val("");				
			}
		}
	}
}

function funcionExitoTPR(){
	esTab=true;
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionSCT').val(0);
	consultaSubTipoPro('conceptoAhoID');
	$('#tipoProductoID').focus();
	if($('#tipoTransaccionTPR').val()==1){
		deshabilitaBoton('grabaTPR', 'submit');
		habilitaBoton('modificaTPR', 'submit');
		habilitaBoton('eliminaTPR', 'submit');	
		$('#tipoTransaccionTPR').val(0);
	}else{
		if($('#tipoTransaccionTPR').val()==2){
			deshabilitaBoton('grabaTPR', 'submit');
			habilitaBoton('modificaTPR', 'submit');
			habilitaBoton('eliminaTPR', 'submit');
			$('#tipoTransaccionTPR').val(0);
		}else{
			if($('#tipoTransaccionTPR').val()==3){
				habilitaBoton('grabaTPR', 'submit');
				deshabilitaBoton('modificaTPR', 'submit');
				deshabilitaBoton('eliminaTPR', 'submit');
				$('#tipoTransaccionTPR').val(0);
				$('#subCuenta').val("");
				$('#tipoProductoID').val(0);				
			}
		}
	}
}

function funcionExitoTPE(){
	esTab=true;
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSR').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionSCT').val(0);
	consultaSubTipoPer('conceptoAhoID');
	$('#fisica').focus();
	if($('#tipoTransaccionTPE').val()==1){
		deshabilitaBoton('grabaTPE', 'submit');
		habilitaBoton('modificaTPE', 'submit');
		habilitaBoton('eliminaTPE', 'submit');	
		$('#tipoTransaccionTPE').val(0);
	}else{
		if($('#tipoTransaccionTPE').val()==2){
			deshabilitaBoton('grabaTPE', 'submit');
			habilitaBoton('modificaTPE', 'submit');
			habilitaBoton('eliminaTPE', 'submit');
			$('#tipoTransaccionTPE').val(0);
		}else{
			if($('#tipoTransaccionTPE').val()==3){
				habilitaBoton('grabaTPE', 'submit');
				deshabilitaBoton('modificaTPE', 'submit');
				deshabilitaBoton('eliminaTPE', 'submit');
				$('#tipoTransaccionTPE').val(0);
				$('#fisica').val("");
				$('#moral').val("");
			}
		}
	}
}

function funcionExitoSM(){
	esTab=true;
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSR').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSCT').val(0);
	consultaSubCuentas('conceptoAhoID');
	$('#monedaID').focus();
	if($('#tipoTransaccionSM').val()==1){
		deshabilitaBoton('grabaSM', 'submit');
		habilitaBoton('modificaSM', 'submit');
		habilitaBoton('eliminaSM', 'submit');	
		$('#tipoTransaccionSM').val(0);
	}else{
		if($('#tipoTransaccionSM').val()==2){
			deshabilitaBoton('grabaSM', 'submit');
			habilitaBoton('modificaSM', 'submit');
			habilitaBoton('eliminaSM', 'submit');
			$('#tipoTransaccionSM').val(0);
			
		}else{
			if($('#tipoTransaccionSM').val()==3){
				habilitaBoton('grabaSM', 'submit');
				deshabilitaBoton('modificaSM', 'submit');
				deshabilitaBoton('eliminaSM', 'submit');
				$('#tipoTransaccionSM').val(0);
				$('#subCuenta2').val("");
				$('#monedaID').val("");
			}
		}
	}
	
}	
	
/* funcion cuando fallo el formulario */
function funcionFalloGuiaConta(){
}