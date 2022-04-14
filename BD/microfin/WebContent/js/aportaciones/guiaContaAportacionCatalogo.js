$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionGuiaAportacion = {
  		'graba':'1',
  		'modifica':'2',
  		'elimina':'3'
	};

 
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
	 	esTab = false;
	});
	$('#conceptoAportacionID').focus();
	
	deshabilitaBoton('grabaCM', 'submit');     
	deshabilitaBoton('grabaSP', 'submit');
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
    	  if($('#conceptoAportacionID').asNumber() >0){
    		  
    		  if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2||$('#tipoTransaccionCM').val()==3){
    			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuenta','exitoCuentaMAyor','errorCuentaMayor');
	   				$('#tipoTransaccionSP').val(0);
	   				$('#tipoTransaccionTPR').val(0);
					$('#tipoTransaccionTPE').val(0);
					$('#tipoTransaccionSM').val(0);
					$('#tipoTransaccionCM').val(0);
    		  	}   

    		  if($('#tipoTransaccionSP').val()==1 || $('#tipoTransaccionSP').val()==2 || $('#tipoTransaccionSP').val()==3 ){
    			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'subCtaPlazoAportacionID','exitoSubCtaPlazo','errorSubCtaPlazo');
	   				$('#tipoTransaccionCM').val(0);
	   				$('#tipoTransaccionTPR').val(0);
					$('#tipoTransaccionTPE').val(0);
					$('#tipoTransaccionSM').val(0);
					$('#tipoTransaccionSP').val(0);
				}  
    		  if($('#tipoTransaccionTPR').val()==1||$('#tipoTransaccionTPR').val()==2||$('#tipoTransaccionTPR').val()==3){
    			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje', 'true', 'tipoProductoID','exitoSubCtaTipoProd','errorSubCtaTipoProd');
		   				$('#tipoTransaccionCM').val(0);
		   				$('#tipoTransaccionSP').val(0);
						$('#tipoTransaccionTPE').val(0);
						$('#tipoTransaccionSM').val(0);
						$('#tipoTransaccionTPR').val(0);
		
		   		}  
    		  if($('#tipoTransaccionTPE').val()==1||$('#tipoTransaccionTPE').val()==2||$('#tipoTransaccionTPE').val()==3){
    			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica4', 'contenedorForma', 'mensaje', 'true', 'fisica','exitoSubCtaTipoPE','errorSubCtaTipoPE');
	   				$('#tipoTransaccionCM').val(0);
	   				$('#tipoTransaccionSP').val(0);
					$('#tipoTransaccionTPR').val(0);
					$('#tipoTransaccionSM').val(0);
					$('#tipoTransaccionTPE').val(0);
    		  }  
    		  if($('#tipoTransaccionSM').val()==1||$('#tipoTransaccionSM').val()==2||$('#tipoTransaccionSM').val()==3){
    			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica5', 'contenedorForma', 'mensaje', 'true', 'monedaID','exitoSubCtaTipoMoneda','errorSubCtaTipoMoneda');
					$('#tipoTransaccionCM').val(0);
					$('#tipoTransaccionSP').val(0);
					$('#tipoTransaccionTPR').val(0);
					$('#tipoTransaccionTPE').val(0);
					$('#tipoTransaccionSM').val(0);
    		  }
    	  }else{
     		 mensajeSis("Seleccione un Concepto Contable");
     		 event.preventDefault();
     	 }
      }
   });		


	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#grabaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiaAportacion.graba);
	});
	$('#grabaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionGuiaAportacion.graba); 
		agregaPlazos();	
	});
	$('#grabaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionGuiaAportacion.graba);
	}); 
	$('#grabaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionGuiaAportacion.graba);
	});
	$('#grabaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionGuiaAportacion.graba);
	});
	
	$('#modificaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiaAportacion.modifica);
	});
	$('#modificaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionGuiaAportacion.modifica); 
		agregaPlazos();
	}); 
	$('#modificaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionGuiaAportacion.modifica);
	});
	$('#modificaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionGuiaAportacion.modifica);
	});
	$('#modificaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionGuiaAportacion.modifica);
	});
	
	$('#eliminaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiaAportacion.elimina);
	});
	$('#eliminaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionGuiaAportacion.elimina); 
		agregaPlazos();
	}); 
	$('#eliminaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionGuiaAportacion.elimina);
	});
	$('#eliminaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionGuiaAportacion.elimina);
	});
	$('#eliminaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionGuiaAportacion.elimina);
	}); 
	
	
	$('#conceptoAportacionID').change(function() {	
		validaConcepto('conceptoAportacionID');	
		$('#conceptoAportacionID2').val($('#conceptoAportacionID').val());
		$('#conceptoAportacionID3').val($('#conceptoAportacionID').val());
		$('#conceptoAportacionID4').val($('#conceptoAportacionID').val());
		$('#conceptoAportacionID5').val($('#conceptoAportacionID').val());
	});	
	
	$('#tipoProductoID').change(function() {	
		consultaSubTipoPro($('#conceptoAportacionID').val());
		consultaPlazo();
	});
	
	$('#monedaID').change(function() {	
		consultaSubCuentaM($('#conceptoAportacionID').val());	
	});
	
	$('#subCtaPlazoAportacionID').change(function() {	
		consultaSubPlazo($('#conceptoAportacionID').val());	
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
	
	$('#cuenta').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		});

	consultaConceptosAportaciones();
  	consultaTiposAportaciones();
  	consultaMoneda();
  	

	//------------ Validaciones de la Forma -------------------------------------
	
	
	$('#formaGenerica').validate({
		rules: {
			conceptoAportacionID: 'required',
			cuenta		: {
				maxlength	: 	4
			}
		},
		
		messages: {
			conceptoAportacionID: 'Especifique Concepto',
			cuenta		: {
				maxlength	: 	'Maximo Cuatro Digitos'
			}
		}		
	});

	$('#formaGenerica2').validate({
		rules: {
			conceptoAportacionID2: 'required'
		},
		
		messages: {
			conceptoAportacionID2: 'Especifique Concepto'
		}		
	}); 
	
	$('#formaGenerica3').validate({
		rules: {
			conceptoAportacionID3	: 'required',
			subCuenta		: {
				maxlength	: 	2
			}

		},
		
		messages: {
			conceptoAportacionID3: 'Especifique Concepto',
			subCuenta		: {
				maxlength	: 	'Como maximo Dos Digitos'
			}

		
		}		
	}); 
	
	$('#formaGenerica4').validate({
		rules: {
			conceptoAportacionID4: 'required'
		},
		
		messages: {
			conceptoAportacionID4: 'Especifique Concepto'
		}		
	}); 
	
	$('#formaGenerica5').validate({
		rules: {
			conceptoAportacionID5: 'required',
			subCuenta2		: {
				maxlength	: 	2
			}
		},
		
		messages: {
			conceptoAportacionID5: 'Especifique Concepto',
			subCuenta2		: {
				maxlength	: 	'Como maximo Dos Digitos'
			}
		}		
	});
	
	
	
	function consultaConceptosAportaciones() {	
  		dwr.util.removeAllOptions('conceptoAportacionID'); 
  		dwr.util.addOptions('conceptoAportacionID', {0:'SELECCIONAR'}); 
  		conceptosAportacionServicio.listaCombo(1, function(conceptosAportacion){
			dwr.util.addOptions('conceptoAportacionID', conceptosAportacion, 'conceptoAportacionID', 'descripcion');
		});
	}
		
	function consultaMoneda() {			
  		dwr.util.removeAllOptions('monedaID');
  		
  		dwr.util.addOptions('monedaID', {0:'SELECCIONAR'}); 
	
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}
	
	function consultaTiposAportaciones() {			
  		dwr.util.removeAllOptions('tipoProductoID'); 
  		
  		dwr.util.addOptions('tipoProductoID', {0:'SELECCIONAR'}); 

		
		tiposAportacionesServicio.listaCombo(2, function(tiposAportaciones){
		dwr.util.addOptions('tipoProductoID', tiposAportaciones, 'tipoAportacionID', 'descripcion');
		});
	}
	
	function consultaPlazo() {			
  		dwr.util.removeAllOptions('subCtaPlazoAportacionID');
  		
  		dwr.util.addOptions('subCtaPlazoAportacionID', {0:'SELECCIONAR'}); 
  		var plazoB = {
			'tipoAportacionID'	:$('#tipoProductoID').val()
		};	
  		$('#tipoAportacionID').val($('#tipoProductoID').val());
  		
  		plazosAportacionesServicio.listaCombo( 3,plazoB,function(plazo){
			dwr.util.addOptions('subCtaPlazoAportacionID', plazo, 'plazosDescripcion', 'plazosDescripcion');
		});
	}	
});

	//------------ Validaciones de Controles -------------------------------------
	
	function validaConcepto(idControl) {
		var jqConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();	
		var tipConPrincipal = 1;
		var CuentaMayorBeanCon = {
			'conceptoAportacionID'	:numConcepto
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){	
			if(numConcepto=='-1'){

				deshabilitaBoton('grabaCM', 'submit');     
				deshabilitaBoton('grabaSP', 'submit');
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
				cuentasMayorAportacionServicio.consulta(tipConPrincipal, CuentaMayorBeanCon,function(cuentaM) {
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
							$('#fisicaActEmp').val('');
							$('#subCuenta').val('');
							$('#subCuentaP').val('');
							$('#nomenclaturaCR').val('');									
						}
				});														
			}												
		}
	}
	
	function consultaSubCuentas(numConcepto) {	
		consultaSubTipoPro(numConcepto);
		consultaSubTipoPer(numConcepto);
		consultaSubCuentaM(numConcepto);
	}
	
	function consultaSubPlazo(numConcepto){	
		var tipConPrincipal = 1;
		
		var plazoDescri=$("#subCtaPlazoAportacionID option:selected").html();
		var resultadoPlazo =plazoDescri.split(" - ");
		var j =0;

		for (j=0; j<resultadoPlazo.length; j++){
			if(j==0){
				$('#plazoInferior').val(resultadoPlazo[j]);
			}else{
				$('#plazoSuperior').val(resultadoPlazo[j]);
			}
		}
		var SubPlazoBeanCon = {
			'conceptoAportacionID'	:numConcepto,
			'tipoAportacionID': $('#tipoAportacionID').val() ,
			'plazoInferior': $('#plazoInferior').val(), 
			'plazoSuperior': $('#plazoSuperior').val() 
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && plazoDescri!="SELECCIONAR" && esTab){
			subCtaPlazoAportacionServicio.consulta(tipConPrincipal, SubPlazoBeanCon,function(subCuentaSP) {
				if(subCuentaSP!=null){
					$('#conceptoAportacionID2').val(subCuentaSP.conceptoAportacionID);
					$('#subCuentaP').val(subCuentaSP.subCuenta);					
					deshabilitaBoton('grabaSP', 'submit');
					habilitaBoton('modificaSP', 'submit');
					habilitaBoton('eliminaSP', 'submit');										
				}else{
					deshabilitaBoton('modificaSP', 'submit');
					deshabilitaBoton('eliminaSP', 'submit');
					habilitaBoton('grabaSP', 'submit');
					$('#subCuentaP').val('');
				}
			});											
		}
		deshabilitaBoton('modificaSP', 'submit');
		deshabilitaBoton('eliminaSP', 'submit');
		deshabilitaBoton('grabaSP', 'submit');
		$('#subCuentaP').val('');
	}


	function consultaSubTipoPro(numConcepto){	
		var tipConPrincipal = 1;
		var SubTipoProBeanCon = {
			'conceptoAportacionID'	:numConcepto,
			'tipoAportacionID': $('#tipoProductoID').val() 
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && $('#tipoProductoID').val() !=0 && esTab){
			subCtaTiProAportacionServicio.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoAportacionID3').val(subCuentaTP.conceptoAportacionID);
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
		deshabilitaBoton('modificaTPR', 'submit');
		deshabilitaBoton('eliminaTPR', 'submit');
		deshabilitaBoton('grabaTPR', 'submit');
		$('#subCuenta').val('');
	}
	
	function consultaSubTipoPer(numConcepto) {	
		var tipConPrincipal = 1;
		var SubTipoPerBeanCon = {
			'conceptoAportacionID'	:numConcepto
		};
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaTiPerAportacionServicio.consulta(tipConPrincipal, SubTipoPerBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoAportacionID4').val(subCuentaTP.conceptoAportacionID);
					$('#fisica').val(subCuentaTP.fisica);
					$('#fisicaActEmp').val(subCuentaTP.fisicaActEmp);
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
					$('#fisicaActEmp').val('');
				}
			});											
		}
	}
	
	function consultaSubCuentaM(numConcepto) {	
		var tipConPrincipal = 1;
		var SubMonedaBeanCon = {
			'conceptoAportacionID'	:numConcepto,
			'monedaID'		:$('#monedaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaMonedaAportacionServicio.consulta(tipConPrincipal, SubMonedaBeanCon,function(subCuentaM) {
				if(subCuentaM!=null){
					$('#conceptoAportacionID5').val(subCuentaM.conceptoAportacionID);			
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


function agregaPlazos(){
	var plazoDescri=$("#subCtaPlazoAportacionID option:selected").html();
	var resultadoPlazo =plazoDescri.split(" - ");
	var j =0;

	for (j=0; j<resultadoPlazo.length; j++){
		if(j==0){
			$('#plazoInferior').val(resultadoPlazo[j]);
		}else{
			$('#plazoSuperior').val(resultadoPlazo[j]);
		}
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
			'<legend class="ui-widget ui-widget-header ui-corner-all">Claves de Nomenclatura:</legend>'+
			'<div id="ContenedorAyuda">'+ 			
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="encabezadoLista">&CM</td><td id="contenidoAyuda" align="left"><b>Cuentas de Mayor</b></td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoLista">&TP</td><td id="contenidoAyuda" align="left"><b> SubCuenta por Tipo de Producto</b></td>'+
				'</tr>'+
				'<tr>'+
				'<td id="encabezadoLista" >&TD</td><td id="contenidoAyuda" align="left"><b>SubCuenta por Tipo de Plazo</b></td>'+
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
					'<td id="contenidoAyuda" colspan="8">2315</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda" colspan="9"><b>Nomenclatura:</b></td>'+ 
				'</tr>'+
				'<tr align="center" id="contenidoAyuda" >'+
					'<td>&CM</td><td>-</td><td>&TP</td>'+
					'<td>-</td><td>&TD</td><td>-</td>'+
					'<td>&TC</td><td>-</td><td>&TM</td>'+
				'</tr>'+
				'<tr>'+
					'<td colspan="9" id="encabezadoAyuda"><b>Cuenta Completa:</b></td>'+ 
				'</tr>'+
				'<tr align="center" id="contenidoAyuda">'+
					'<td>2315</td><td>-</td><td>02</td>'+
					'<td>-</td><td>01</td><td>-</td>'+
					'<td>00</td><td>-</td><td>00</td>'+
				'</tr>'+
				'<tr>'+
					'<td id="encabezadoAyuda"><b>Descripci&oacute;n:</b></td>'+ 
					'<td colspan="8" id="contenidoAyuda"><i> POR SERVICIOS DE CAPTACIÓN</i></td>'+
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



	//-------------------Cuentas del Mayor-----------------
function exitoCuentaMAyor(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
	$('#cuenta').val('');
	$('#nomenclatura').val('');
	$('#nomenclaturaCR').val('');
	validaConcepto('conceptoAportacionID');
}

function errorCuentaMayor(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
	
}

//-------------------Por tipo de moneda -------------
function exitoSubCtaTipoMoneda(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
	$('#subCuenta2').val('');
	consultaSubCuentaM($('#conceptoAportacionID').val());
	
}
function errorSubCtaTipoMoneda(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
}


//---------------Por plazo de aportaciones ------------------

function exitoSubCtaPlazo(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
	$('#subCuentaP').val('');
	consultaSubPlazo($('#conceptoAportacionID').val());
	
}
function errorSubCtaPlazo(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
}

//---------------Por tipo de producto------------------
function exitoSubCtaTipoProd(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
	$('#subCuenta').val('');
	consultaSubTipoPro($('#conceptoAportacionID').val());
	
}
function errorSubCtaTipoProd(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
}
//---------Por tipo de persona -------------------
function exitoSubCtaTipoPE(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
	$('#fisica').val('');
	$('#moral').val('');
	$('#fisicaActEmp').val('');
	consultaSubTipoPer($('#conceptoAportacionID').val());
	
}
function errorSubCtaTipoPE(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
}