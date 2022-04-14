$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCaja = {
  		'alta'		:'1',
  		'elimina'	:'2',
  		'modifica'	:'3',	
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------


	$('#conceptoTarDeb').focus();
	$(':text').focus(function() {	
	 	esTab = false;
	});

	deshabilitaBoton('grabaCM', 'submit');     
	deshabilitaBoton('modificaCM', 'submit');
	deshabilitaBoton('eliminaCM', 'submit');
	$('#tipoTransaccionCM').val(0);
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'cuenta','funcionExitoGuiaCuenta','funcionErrorGuiaCuenta');
		}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#grabaCM').click(function() {
		$('#tipoTransaccionCM').val(catTipoTransaccionCaja.alta);
	});
	
	$('#eliminaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionCaja.elimina);
	});
	
	$('#modificaCM').click(function() {		
		$('#tipoTransaccionCM').val(catTipoTransaccionCaja.modifica);
	});
	
	$('#conceptoTarDeb').change(function() {	
		validaConcepto('conceptoTarDeb');		
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
	
	$('#cuenta').blur(function () {
		setTimeout("$('#cajaLista').hide();", 200);
	});
  	consultaConceptosTarDeb();

  	$('#formaGenerica').validate({
  		rules : {
			conceptoTarDeb : {
				required : true
			},
			cuenta : {
				required: true,
				minlength : 4,
				maxlength :	4
			}
		},		
		messages: {
			conceptoTarDeb : {
				required: 'Especifique Concepto'
			},	
			cuenta		: {
				required: 'Especificar la Cuenta',
				minlength : 'Mínimo 4 caracteres',
				maxlength :	'Máximo Cuatro Dígitos'
			}
		}		
	});
});

	function consultaConceptosTarDeb() {	
		dwr.util.removeAllOptions('conceptoTarDeb'); 
		dwr.util.addOptions('conceptoTarDeb', {0:'SELECCIONAR'}); 
		tarDebGuiaContableServicio.listaCombo(3, function(conceptosTarDeb){
			dwr.util.addOptions('conceptoTarDeb', conceptosTarDeb, 'conceptoTarDebID', 'descripcion');
		});
	}

	function validaConcepto(idControl) {
		var jqConcepto = eval("'#" + idControl + "'");
		var numConcepto = $(jqConcepto).val();	
		var tipConPrincipal = 1;
		var CuentaMayorBeanCon = {
			'conceptoTarDebID'	:numConcepto
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numConcepto != '' && !isNaN(numConcepto) && esTab){		
			if($('#conceptoTarDeb').val()==0){
				$('#cuenta').focus();
				$('#cuenta').val('');
				$('#nomenclatura').val('');
				$('#nomenclaturaCR').val('');								
			
				deshabilitaBoton('grabaCM', 'submit');     
				deshabilitaBoton('modificaCM', 'submit');
				deshabilitaBoton('eliminaCM', 'submit');
				inicializaForma('formaGenerica','conceptoTarDeb');
				
			} else {
				tarDebGuiaContableServicio.consulta(tipConPrincipal, CuentaMayorBeanCon,function(cuentaM) {
					if(cuentaM!=null){
						$('#cuenta').val(cuentaM.cuenta);
						$('#nomenclatura').val(cuentaM.nomenclatura);
						$('#nomenclaturaCR').val(cuentaM.nomenclaturaCR);
						deshabilitaBoton('grabaCM', 'submit'); 
						habilitaBoton('modificaCM', 'submit');
						habilitaBoton('eliminaCM', 'submit');															
					}
					else{
						deshabilitaBoton('modificaCM', 'submit');
						deshabilitaBoton('eliminaCM', 'submit');
						habilitaBoton('grabaCM', 'submit');
						$('#cuenta').focus();
						$('#cuenta').val('');
						$('#nomenclatura').val('');
						$('#nomenclaturaCR').val('');								
										
					}
				});														
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
				'</table>'+
				'<br>'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
				'<div id="ContenedorAyuda">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Ejemplo: Cuenta Mayor</legend>'+
				
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
							'<td>-</td><td>00</td><td>-</td>'+
							'<td>00</td><td>-</td><td>00</td>'+
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
	
	//funcion que se ejecuta cuando el resultado fue exito
	function funcionExitoGuiaCuenta(){
		esTab=true;
		validaConcepto('conceptoTarDeb');
	}
	
	// funcion que se ejecuta cuando el resultado fue error
	// diferente de cero
	function funcionErrorGuiaCuenta(){
		
	}