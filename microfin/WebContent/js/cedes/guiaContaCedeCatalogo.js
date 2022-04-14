$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionGuiaCede = {
  		'graba':'1',
  		'modifica':'2',
  		'elimina':'3'
	};

 
	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {	
	 	esTab = false;
	});
	$('#conceptoCedeID').focus();
	
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
    	  if($('#conceptoCedeID').asNumber() >0){
    		  
    		  if($('#tipoTransaccionCM').val()==1||$('#tipoTransaccionCM').val()==2||$('#tipoTransaccionCM').val()==3){
    			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuenta','exitoCuentaMAyor','errorCuentaMayor');
	   				$('#tipoTransaccionSP').val(0);
	   				$('#tipoTransaccionTPR').val(0);
					$('#tipoTransaccionTPE').val(0);
					$('#tipoTransaccionSM').val(0);
					$('#tipoTransaccionCM').val(0);
    		  	}   

    		  if($('#tipoTransaccionSP').val()==1 || $('#tipoTransaccionSP').val()==2 || $('#tipoTransaccionSP').val()==3 ){
    			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'subCtaPlazoCedeID','exitoSubCtaPlazo','errorSubCtaPlazo');
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
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiaCede.graba);
	});
	$('#grabaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionGuiaCede.graba); 
		agregaPlazos();	
	});
	$('#grabaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionGuiaCede.graba);
	}); 
	$('#grabaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionGuiaCede.graba);
	});
	$('#grabaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionGuiaCede.graba);
	});
	
	$('#modificaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiaCede.modifica);
	});
	$('#modificaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionGuiaCede.modifica); 
		agregaPlazos();
	}); 
	$('#modificaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionGuiaCede.modifica);
	});
	$('#modificaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionGuiaCede.modifica);
	});
	$('#modificaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionGuiaCede.modifica);
	});
	
	$('#eliminaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionGuiaCede.elimina);
	});
	$('#eliminaSP').click(function() {		
		$('#tipoTransaccionSP').val(catTipoTransaccionGuiaCede.elimina); 
		agregaPlazos();
	}); 
	$('#eliminaTPR').click(function() {		
		$('#tipoTransaccionTPR').val(catTipoTransaccionGuiaCede.elimina);
	});
	$('#eliminaTPE').click(function() {		
		$('#tipoTransaccionTPE').val(catTipoTransaccionGuiaCede.elimina);
	});
	$('#eliminaSM').click(function() {		
		$('#tipoTransaccionSM').val(catTipoTransaccionGuiaCede.elimina);
	}); 
	
	
	$('#conceptoCedeID').change(function() {	
		validaConcepto('conceptoCedeID');	
		$('#conceptoCedeID2').val($('#conceptoCedeID').val());
		$('#conceptoCedeID3').val($('#conceptoCedeID').val());
		$('#conceptoCedeID4').val($('#conceptoCedeID').val());
		$('#conceptoCedeID5').val($('#conceptoCedeID').val());
	});	
	
	$('#tipoProductoID').change(function() {	
		consultaSubTipoPro($('#conceptoCedeID').val());
		consultaPlazo();
	});
	
	$('#monedaID').change(function() {	
		consultaSubCuentaM($('#conceptoCedeID').val());	
	});
	
	$('#subCtaPlazoCedeID').change(function() {	
		consultaSubPlazo($('#conceptoCedeID').val());	
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

	consultaConceptosCedes();
  	consultaTiposCedes();
  	consultaMoneda();
  	

	//------------ Validaciones de la Forma -------------------------------------
	
	
	$('#formaGenerica').validate({
		rules: {
			conceptoCedeID: 'required',
			cuenta		: {
				maxlength	: 	4
			}
		},
		
		messages: {
			conceptoCedeID: 'Especifique Concepto',
			cuenta		: {
				maxlength	: 	'Maximo Cuatro Digitos'
			}
		}		
	});

	$('#formaGenerica2').validate({
		rules: {
			conceptoCedeID2: 'required'
		},
		
		messages: {
			conceptoCedeID2: 'Especifique Concepto'
		}		
	}); 
	
	$('#formaGenerica3').validate({
		rules: {
			conceptoCedeID3	: 'required',
			subCuenta		: {
				maxlength	: 	2
			}

		},
		
		messages: {
			conceptoCedeID3: 'Especifique Concepto',
			subCuenta		: {
				maxlength	: 	'Como maximo Dos Digitos'
			}

		
		}		
	}); 
	
	$('#formaGenerica4').validate({
		rules: {
			conceptoCedeID4: 'required'
		},
		
		messages: {
			conceptoCedeID4: 'Especifique Concepto'
		}		
	}); 
	
	$('#formaGenerica5').validate({
		rules: {
			conceptoCedeID5: 'required',
			subCuenta2		: {
				maxlength	: 	2
			}
		},
		
		messages: {
			conceptoCedeID5: 'Especifique Concepto',
			subCuenta2		: {
				maxlength	: 	'Como maximo Dos Digitos'
			}
		}		
	});
	
	
	
	function consultaConceptosCedes() {	
  		dwr.util.removeAllOptions('conceptoCedeID'); 
  		dwr.util.addOptions('conceptoCedeID', {0:'SELECCIONAR'}); 
  		conceptosCedeServicio.listaCombo(1, function(conceptosCede){
			dwr.util.addOptions('conceptoCedeID', conceptosCede, 'conceptoCedeID', 'descripcion');
		});
	}
		
	function consultaMoneda() {			
  		dwr.util.removeAllOptions('monedaID');
  		
  		dwr.util.addOptions('monedaID', {0:'SELECCIONAR'}); 
	
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}
	
	function consultaTiposCedes() {			
  		dwr.util.removeAllOptions('tipoProductoID'); 
  		
  		dwr.util.addOptions('tipoProductoID', {0:'SELECCIONAR'}); 

		
		tiposCedesServicio.listaCombo(4, function(tiposCedes){
		dwr.util.addOptions('tipoProductoID', tiposCedes, 'tipoCedeID', 'descripcion');
		});
	}
	
	function consultaPlazo() {			
  		dwr.util.removeAllOptions('subCtaPlazoCedeID');
  		
  		dwr.util.addOptions('subCtaPlazoCedeID', {0:'SELECCIONAR'}); 
  		var plazoB = {
			'tipoCedeID'	:$('#tipoProductoID').val()
		};	
  		$('#tipoCedeID').val($('#tipoProductoID').val());
  		
  		plazosCedesServicio.listaCombo( 3,plazoB,function(plazo){
			dwr.util.addOptions('subCtaPlazoCedeID', plazo, 'plazosDescripcion', 'plazosDescripcion');
		});
	}	
});

	//------------ Validaciones de Controles -------------------------------------
	
	function validaConcepto(idControl) {
		var jqConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();	
		var tipConPrincipal = 1;
		var CuentaMayorBeanCon = {
			'conceptoCedeID'	:numConcepto
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
				cuentasMayorCedeServicio.consulta(tipConPrincipal, CuentaMayorBeanCon,function(cuentaM) {
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
		
		var plazoDescri=$("#subCtaPlazoCedeID option:selected").html();
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
			'conceptoCedeID'	:numConcepto,
			'tipoCedeID': $('#tipoCedeID').val() ,
			'plazoInferior': $('#plazoInferior').val(), 
			'plazoSuperior': $('#plazoSuperior').val() 
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && plazoDescri!="SELECCIONAR" && esTab){
			subCtaPlazoCedeServicio.consulta(tipConPrincipal, SubPlazoBeanCon,function(subCuentaSP) {
				if(subCuentaSP!=null){
					$('#conceptoCedeID2').val(subCuentaSP.conceptoCedeID);
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
			'conceptoCedeID'	:numConcepto,
			'tipoCedeID': $('#tipoProductoID').val() 
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && $('#tipoProductoID').val() !=0 && esTab){
			subCtaTiProCedeServicio.consulta(tipConPrincipal, SubTipoProBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoCedeID3').val(subCuentaTP.conceptoCedeID);
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
			'conceptoCedeID'	:numConcepto
		};
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaTiPerCedeServicio.consulta(tipConPrincipal, SubTipoPerBeanCon,function(subCuentaTP) {
				if(subCuentaTP!=null){
					$('#conceptoCedeID4').val(subCuentaTP.conceptoCedeID);
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
			'conceptoCedeID'	:numConcepto,
			'monedaID'		:$('#monedaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){
			subCtaMonedaCedeServicio.consulta(tipConPrincipal, SubMonedaBeanCon,function(subCuentaM) {
				if(subCuentaM!=null){
					$('#conceptoCedeID5').val(subCuentaM.conceptoCedeID);			
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
	var plazoDescri=$("#subCtaPlazoCedeID option:selected").html();
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
	validaConcepto('conceptoCedeID');
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
	consultaSubCuentaM($('#conceptoCedeID').val());
	
}
function errorSubCtaTipoMoneda(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
}


//---------------Por plazo de cedes ------------------

function exitoSubCtaPlazo(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
	$('#subCuentaP').val('');
	consultaSubPlazo($('#conceptoCedeID').val());
	
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
	consultaSubTipoPro($('#conceptoCedeID').val());
	
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
	consultaSubTipoPer($('#conceptoCedeID').val());
	
}
function errorSubCtaTipoPE(){
	$('#tipoTransaccionSP').val(0);
	$('#tipoTransaccionTPR').val(0);
	$('#tipoTransaccionTPE').val(0);
	$('#tipoTransaccionSM').val(0);
	$('#tipoTransaccionCM').val(0);
}