$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionTasaInvrro = {
  		'graba':'1',
  		'modifica':'2',
  		'elimina':'3'
	};
	
	var catTipoConsultaTasaInvrro = {
  		'principal':'1',
  		'foranea':'2'
	};	

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
	 	esTab = false;
	});

	deshabilitaBoton('grabaCM', 'submit');     
	//deshabilitaBoton('grabaSP', 'submit');
	deshabilitaBoton('grabaTPR', 'submit');	
	deshabilitaBoton('grabaTPE', 'submit');	
	deshabilitaBoton('grabaSM', 'submit');		
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('modificaSP', 'submit');
	deshabilitaBoton('modificaTPR', 'submit');
	deshabilitaBoton('modificaTPE', 'submit');
	deshabilitaBoton('modificaSM', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	deshabilitaBoton('eliminaSP', 'submit');
	deshabilitaBoton('eliminaTPR', 'submit');
	deshabilitaBoton('eliminaTPE', 'submit');
	deshabilitaBoton('eliminaSM', 'submit');
	
	$('#tipoTransaccionCM').val(0);
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);

	
$.validator.setDefaults({	
      submitHandler: function(event) { 
      
      	if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2||$('#tipoTransaccionCM').val()==3){
      		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuenta');
   			$('#tipoTransaccionSP').val(0);
   			$('#tipoTransaccionTPR').val(0);
				$('#tipoTransaccionTPE').val(0);
				$('#tipoTransaccionSM').val(0);
				$('#tipoTransaccionCM').val(0);
				deshabilitaBoton('modificaCM', 'submit');
				deshabilitaBoton('eliminaCM', 'submit');
				habilitaBoton('grabaCM', 'submit')
   		}   

			if($('#tipoTransaccionSP').val()==1 || $('#tipoTransaccionSP').val()==2 || $('#tipoTransaccionSP').val()==3 ){
   			grabaFormaTransaccion(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'paga');
   			$('#tipoTransaccionCM').val(0);
   			$('#tipoTransaccionTPR').val(0);
				$('#tipoTransaccionTPE').val(0);
				$('#tipoTransaccionSM').val(0);
				$('#tipoTransaccionSP').val(0);
				habilitaBoton('modificaSP', 'submit');
				deshabilitaBoton('eliminaSP', 'submit');
				//habilitaBoton('grabaSP', 'submit');
   		}  
   		if($('#tipoTransaccionTPR').val()==1||$('#tipoTransaccionTPR').val()==2||$('#tipoTransaccionTPR').val()==3){
   			grabaFormaTransaccion(event, 'formaGenerica3', 'contenedorForma', 'mensaje', 'true', 'tipoProductoID');
   			$('#tipoTransaccionCM').val(0);
   			$('#tipoTransaccionSP').val(0);
				$('#tipoTransaccionTPE').val(0);
				$('#tipoTransaccionSM').val(0);
				$('#tipoTransaccionTPR').val(0);
				deshabilitaBoton('modificaTPR', 'submit');
				deshabilitaBoton('eliminaTPR', 'submit');
				habilitaBoton('grabaTPR', 'submit')
   		}  
   		if($('#tipoTransaccionTPE').val()==1||$('#tipoTransaccionTPE').val()==2||$('#tipoTransaccionTPE').val()==3){
   			grabaFormaTransaccion(event, 'formaGenerica4', 'contenedorForma', 'mensaje', 'true', 'fisica');
   			$('#tipoTransaccionCM').val(0);
   			$('#tipoTransaccionSP').val(0);
				$('#tipoTransaccionTPR').val(0);
				$('#tipoTransaccionSM').val(0);
				$('#tipoTransaccionTPE').val(0);
				deshabilitaBoton('modificaTPE', 'submit');
				deshabilitaBoton('eliminaTPE', 'submit');
				habilitaBoton('grabaTPE', 'submit')
   		}  
			if($('#tipoTransaccionSM').val()==1||$('#tipoTransaccionSM').val()==2||$('#tipoTransaccionSM').val()==3){
				grabaFormaTransaccion(event, 'formaGenerica5', 'contenedorForma', 'mensaje', 'true', 'monedaID');
   			$('#tipoTransaccionCM').val(0);
   			$('#tipoTransaccionSP').val(0);
				$('#tipoTransaccionTPR').val(0);
				$('#tipoTransaccionTPE').val(0);
				$('#tipoTransaccionSM').val(0);
				deshabilitaBoton('modificaSM', 'submit');
				deshabilitaBoton('eliminaSM', 'submit');
				habilitaBoton('grabaSM', 'submit')
   		}  
      }
   });		


	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionTasaInvrro.graba);
	});
	$('#grabaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionTasaInvrro.graba); 
	});
	$('#grabaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionTasaInvrro.graba);
	}); 
	$('#grabaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionTasaInvrro.graba);
	});
	$('#grabaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionTasaInvrro.graba);
	});
	
	$('#modificaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionTasaInvrro.modifica);
	});
	$('#modificaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionTasaInvrro.modifica); 
	}); 
	$('#modificaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionTasaInvrro.modifica);
	});
	$('#modificaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionTasaInvrro.modifica);
	});
	$('#modificaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionTasaInvrro.modifica);
	});
	
	$('#eliminaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionTasaInvrro.elimina);
	});
	$('#eliminaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionTasaInvrro.elimina); 
	}); 
	$('#eliminaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionTasaInvrro.elimina);
	});
	$('#eliminaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionTasaInvrro.elimina);
	});
	$('#eliminaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionTasaInvrro.elimina);
	}); 
	
	
	$('#conceptoInvID').change(function() {	
		validaConcepto('conceptoInvID');	
		$('#conceptoInvID2').val($('#conceptoInvID').val());
		$('#conceptoInvID3').val($('#conceptoInvID').val());
		$('#conceptoInvID4').val($('#conceptoInvID').val());
		$('#conceptoInvID5').val($('#conceptoInvID').val());
		consultaPlazo();
	});	
	
	$('#tipoProductoID').change(function() {	
		consultaSubTipoPro($('#conceptoInvID').val());
	});
	
	$('#monedaID').change(function() {	
		consultaSubCuentaM($('#conceptoInvID').val());	
	});
	
	$('#subCtaPlazoInvID').change(function() {	
		consultaSubPlazo($('#conceptoInvID').val());	
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

  	consultaConceptosInversiones();
  	consultaTiposInversion();
  	consultaMoneda();
  	

	//------------ Validaciones de la Forma -------------------------------------
	
	
	$('#formaGenerica').validate({
		rules: {
			conceptoInvID: 'required',
			cuenta		: {
				maxlength	: 	4
			}
		},
		
		messages: {
			conceptoInvID: 'Especifique Concepto',
			cuenta		: {
				maxlength	: 	'Maximo Cuatro Digitos'
			}
		}		
	});

	$('#formaGenerica2').validate({
		rules: {
			conceptoInvID2: 'required'
		},
		
		messages: {
			conceptoInvID2: 'Especifique Concepto'
		}		
	}); 
	
	$('#formaGenerica3').validate({
		rules: {
			conceptoInvID3	: 'required',
			subCuenta		: {
				maxlength	: 	2
			}

		},
		
		messages: {
			conceptoInvID3: 'Especifique Concepto',
			subCuenta		: {
				maxlength	: 	'Como maximo Dos Digitos'
			}

		
		}		
	}); 
	
	$('#formaGenerica4').validate({
		rules: {
			conceptoInvID4: 'required'
		},
		
		messages: {
			conceptoInvID4: 'Especifique Concepto'
		}		
	}); 
	
	$('#formaGenerica5').validate({
		rules: {
			conceptoInvID5: 'required',
			subCuenta2		: {
				maxlength	: 	2
			}
		},
		
		messages: {
			conceptoInvID5: 'Especifique Concepto',
			subCuenta2		: {
				maxlength	: 	'Como maximo Dos Digitos'
			}
		}		
	});
	
	
	
	//------------ Validaciones de Controles -------------------------------------
	
	function validaConcepto(idControl) {
		var jqConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();	
		var tipConPrincipal = 1;
		var CuentaMayorBeanCon = {
			'conceptoInvID'	:numConcepto
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){	
			if(numConcepto=='-1'){

				deshabilitaBoton('grabaCM', 'submit');     
				//deshabilitaBoton('grabaSP', 'submit');
				deshabilitaBoton('grabaTPR', 'submit');	
				deshabilitaBoton('grabaTPE', 'submit');	
				deshabilitaBoton('grabaSM', 'submit');		
				deshabilitaBoton('modificaCM', 'submit');
				deshabilitaBoton('modificaSP', 'submit');
				deshabilitaBoton('modificaTPR', 'submit');
				deshabilitaBoton('modificaTPE', 'submit');
				deshabilitaBoton('modificaSM', 'submit');
				deshabilitaBoton('eliminaCM', 'submit');
				deshabilitaBoton('eliminaSP', 'submit');
				deshabilitaBoton('eliminaTPR', 'submit');
				deshabilitaBoton('eliminaTPE', 'submit');
				deshabilitaBoton('eliminaSM', 'submit');
				inicializaForma('formaGenerica','conceptoID');	
				
			} else {
				cuentasMayorInvServicio.consulta(tipConPrincipal, CuentaMayorBeanCon,function(cuentaM) {
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
							$('#subCuentaP').val('');
							$('#nomenclaturaCR').val('');									
						}
				});														
			}												
		}
	}
	
	function consultaSubCuentas(numConcepto) {	
		consultaSubPlazo(numConcepto);
		consultaSubTipoPro(numConcepto);
		consultaSubTipoPer(numConcepto);
		consultaSubCuentaM(numConcepto);
	}
	
	function consultaSubPlazo(numConcepto){	
		var tipConPrincipal = 1;
		var SubPlazoBeanCon = {
			'conceptoInvID'	:numConcepto,
			'subCtaPlazoInvID': $('#subCtaPlazoInvID').val() 
		};;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaPlazoInvServicio.consulta(tipConPrincipal, SubPlazoBeanCon,function(subCuentaSP) {
				if(subCuentaSP!=null){
					$('#conceptoInvID2').val(subCuentaSP.conceptoInvID);
					$('#subCuentaP').val(subCuentaSP.subCuenta);
					//deshabilitaBoton('grabaSP', 'submit');
					habilitaBoton('modificaSP', 'submit');
					habilitaBoton('eliminaSP', 'submit');										
				}else{
					habilitaBoton('modificaSP', 'submit');
					deshabilitaBoton('eliminaSP', 'submit');
					//habilitaBoton('grabaSP', 'submit');
					$('#subCuentaP').val('');
				}
			});											
		}
	}
	function consultaSubTipoPro(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoInvID'	:numConcepto,
			'tipoProductoID': $('#tipoProductoID').val() 
		};;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaTiProInvServicio.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoInvID3').val(subCuentaTP.conceptoInvID);
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
			'conceptoInvID'	:numConcepto
		};
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaTiPerInvServicio.consulta(tipConPrincipal, SubTipoPerBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoInvID4').val(subCuentaTP.conceptoInvID);
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
			'conceptoInvID'	:numConcepto,
			'monedaID'		:$('#monedaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaMonedaInvServicio.consulta(tipConPrincipal, SubMonedaBeanCon,function(subCuentaM) {
				if(subCuentaM!=null){
					$('#conceptoInvID5').val(subCuentaM.conceptoInvID);
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
	
	
	
	function consultaConceptosInversiones() {	
  		dwr.util.removeAllOptions('conceptoInvID'); 
  		dwr.util.addOptions('conceptoInvID', {0:'SELECCIONAR'}); 
		conceptosInverServicio.listaCombo(1, function(conceptosInv){
			dwr.util.addOptions('conceptoInvID', conceptosInv, 'conceptoInvID', 'descripcion');
		});
	}
	
	function consultaPlazo() {			
  		dwr.util.removeAllOptions('subCtaPlazoInvID');
  		
  		dwr.util.addOptions('subCtaPlazoInvID', {0:'SELECCIONAR'}); 
  		var plazoB = {
			'conceptoInvID'	:$('#conceptoInvID').val()
		};	
		subCtaPlazoInvServicio.listaCombo(1,plazoB, function(plazo){
			dwr.util.addOptions('subCtaPlazoInvID', plazo, 'subCtaPlazoInvID', 'plazoInferior');
		});
	}
	
	function consultaMoneda() {			
  		dwr.util.removeAllOptions('monedaID');
  		
  		dwr.util.addOptions('monedaID', {0:'SELECCIONAR'}); 
	
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}
	
	function consultaTiposInversion() {			
  		dwr.util.removeAllOptions('tipoProductoID'); 
  		
  		dwr.util.addOptions('tipoProductoID', {0:'SELECCIONAR'}); 
		
		var tipoInverBean = {
			'descripcion'	:"",
			'monedaId'		:0
		};
		
		tipoInversionesServicio.listaCombo(6, tipoInverBean, function(tiposInversion){
		dwr.util.addOptions('tipoProductoID', tiposInversion, 'tipoInvercionID', 'descripcion');
		});
	}
	
	
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
					'<td id="encabezadoLista" >&TD</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Plazo</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TP</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Tipo de Producto</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TC</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Tipo de Persona</b></td>'+ 
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
					'<td id="contenidoAyuda" colspan="8">2105</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" colspan="9"><b>Nomenclatura:</b></td>'+ 
				'</tr>'+
				'<tr align="center" id="contenidoAyuda" >'+
					'<td>&CM</td><td>-</td><td>&TP</td>'+
					'<td>-</td><td>&TM</td><td>-</td>'+
					'<td>&TC</td><td>-</td><td>&TD</td>'+
				'</tr>'+
				'<tr>'+
					'<td colspan="9" id="encabezadoAyuda"><b>Cuenta Completa:</b></td>'+ 
				'</tr>'+
				'<tr align="center" id="contenidoAyuda">'+
					'<td>2105</td><td>-</td><td>01</td>'+
					'<td>-</td><td>01</td><td>-</td>'+
					'<td>01</td><td>-</td><td>01</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Descripci&oacute;n:</b></td>'+ 
					'<td colspan="8" id="contenidoAyuda"><i>INVERSION PAGA MAS PARA PERSONA FISICA PLAZO DE 1 - 7 D&Iacute;AS</i></td>'+
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