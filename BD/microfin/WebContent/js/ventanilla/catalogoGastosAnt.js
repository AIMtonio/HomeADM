$(document).ready(function() {
	parametros = consultaParametrosSession();	
	
	var catTipoTransaccionCatalogoAntGastos = {
		'alta' : '1',
		'modificacion' : '2'			
	};
	var catTipoConsultaCatalogoAntGastos = {
		'principal' : 1			
	};
	
		// ------------ Metodos y Manejo de Eventos
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	
	agregaFormatoControles('formaGenerica');
	$('#esGasto1').attr('checked',true);
	$('#tipoGastosTeso').show();
		
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoAntGastoID','funcionExitoCatalogo','funcionErrorCatalogo'); 
	      }
	 });

		   				
	$('#grabar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCatalogoAntGastos.alta);
	});
	$('#modificar').click(function() {	
		var tipoGastoID=$('#tipoGastoID').val();
		var tipo =tipoGastoID.length;
		if(tipo>11){
			 var maxLong=$('#tipoGastoID').val();
			 var max=maxLong.substring(0,10);
			 $('#tipoGastoID').val(max);
		}
		$('#tipoTransaccion').val(catTipoTransaccionCatalogoAntGastos.modificacion);
	});	
	
	$('#esGasto1').click(function() {	
		habilitaControl('tipoGastoID');
		soloLecturaControl('ctaContable');	
		$('#tipoGastosTeso').show();
		$('#tipoGastoID').focus();
	
	});
	
	$('#esGasto2').click(function() {		
		$('#tipoGastos').hide();
		habilitaControl('ctaContable');
		soloLecturaControl('tipoGastoID');
		$('#ctaContable').focus();
		$('#tipoGastoID').val('');
		$('#nombreGasto').val('');
		$('#tipoGastosTeso').hide();
	});
	
	
	$('#naturaleza1').click(function() {	
		soloLecturaControl('montoMaxEfect');	
		$('#montoMaxEfect').val('999,999.00');
		$('#montoMaxTransaccion').val('999,999.00');

	});

	$('#naturaleza2').click(function() {
		habilitaControl('montoMaxEfect');
		$('#montoMaxEfect').val('');
		$('#montoMaxTransaccion').val('');
	});
	
	$('#tipoGastoID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#tipoGastoID').val();
			listaAlfanumerica('tipoGastoID', '2', '2', camposLista, parametrosLista, 'listaTipoGas.htm');
		}
	});
	$('#tipoGastoID').blur(function() {		
		var tipoGastoID=$('#tipoGastoID').val();
		if(!isNaN(tipoGastoID)){
			var tipo =tipoGastoID.length;
			if(tipo>11){
			 var maxLong=$('#tipoGastoID').val();
			 var max=maxLong.substring(0,10);
			 $('#tipoGastoID').val(max);
			 validaTipoGas();
			}
			 validaTipoGas();
		}
		
		
	});
	$('#centroCosto').blur(function() {
		centroCostoValida();
	
	});
	
	
	$('#reqNoEmp1').click(function() {
		$('#tipoInstrumentoID').val(5);
		consultaTipoInstrumento();
	});
	
	$('#reqNoEmp2').click(function() {
		$('#tipoInstrumentoID').val(15);
		consultaTipoInstrumento();
	});
		
	$('#tipoAntGastoID').bind('keyup',function(e){		
		lista('tipoAntGastoID', '2', '1', 'tipoAntGastoID', $('#tipoAntGastoID').val(), 'listaTiposGastos.htm');
		
	});
	
	$('#tipoAntGastoID').blur(function() {	
		var tipoAntGastoID=$('#tipoAntGastoID').val();
		if(!isNaN(tipoAntGastoID)){
			var tipo =tipoAntGastoID.length;
			if(tipo>11){
			 var maxLong=$('#tipoAntGastoID').val();
			 var max=maxLong.substring(0,10);
			 $('#tipoAntGastoID').val(max);
		 
			}
		}
		validaCatalogoAntGastos('tipoAntGastoID');
	
	});

	
	$('#ctaContable').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#ctaContable').val();
			lista('ctaContable', '3', '7', camposLista, parametrosLista, 'listaCuentasContables.htm');
		}
	});
	
	$('#ctaContable').blur(function(){
		validaCuentaContable('ctaContable');
	});
//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({			
		rules: {
			montoMaxEfect:{
				maxlength:14
			},
			montoMaxTransaccion:{
				maxlength:14
			}	
		},		
		messages: {
			montoMaxEfect:{
				maxlength:"Máximo 14 Caracteres"
			},
	
			montoMaxTransaccion:{
				maxlength:"Máximo 14 Caracteres"
			}	
		}
	});
	
//-------------------- Métodos------------------	
	function validaCatalogoAntGastos(control) {
		var jqCatalogoAntGastos  = eval("'#" +control + "'");
		var catalogoAntGast = $(jqCatalogoAntGastos).val();	
		if(catalogoAntGast != '' && !isNaN(catalogoAntGast)){				
			if(catalogoAntGast == '0'){		
				habilitaBoton('grabar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				inicializaForma('formaGenerica', 'tipoAntGastoID');
				$('#tipoInstrumentoID').val('');
				$('#tipoGastoID').val('');
				$('#tipoGastosTeso').hide();
				habilitaControl('ctaContable');	
				$('#reqNoEmp1').attr('checked',true);
				$('#esGasto1').attr('checked',true);
				if($('#esGasto1').is(':checked')){
					$('#tipoGastosTeso').show();
				}
				if($('#reqNoEmp2').is(':checked')){
					$('#tipoInstrumentoID').val(15);
					consultaTipoInstrumento();
				}else{
					$('#tipoInstrumentoID').val(5);
					consultaTipoInstrumento();
				}
				if($('#naturaleza1').is(':checked')){
					soloLecturaControl('montoMaxEfect');
					$('#montoMaxEfect').val('999,999.00');
					$('#montoMaxTransaccion').val('999,999.00');
				}else{
					habilitaControl('montoMaxEfect');
					$('#montoMaxEfect').val('');
					$('#montoMaxTransaccion').val('');
				}
				
			}else{			
				
				var catalogoAntGastosBean = { 
						'tipoAntGastoID':catalogoAntGast	  				
				};				
				
				catalogoGastosAntServicios.consulta(catTipoConsultaCatalogoAntGastos.principal,catalogoAntGastosBean,function(tipoAntGastosBean) {
					if(tipoAntGastosBean != null){
						dwr.util.setValues(tipoAntGastosBean);	
						$('#montoMaxEfect').val(tipoAntGastosBean.montoMaxEfect);
						$('#montoMaxTransaccion').val(tipoAntGastosBean.montoMaxTransaccion);
						habilitaBoton('modificar','submit');
						deshabilitaBoton('grabar','sumbit');
						if(tipoAntGastosBean.naturaleza=="S"){
							habilitaControl('montoMaxEfect');
						}else{
							soloLecturaControl('montoMaxEfect');

						}
						
						if($('#esGasto1').is(':checked')){
							$('#tipoGastosTeso').show();
							soloLecturaControl('ctaContable');
							validaTipoGas();
						}else{
							$('#tipoGastosTeso').hide();
							habilitaControl('ctaContable');
						}
						/*if(tipoAntGastosBean.tipoGastoID=="0"){
							$('#tipoGastoID').val('');
							$('#nombreGasto').val('');
							$('#tipoGastosTeso').hide();
						}else{

							$('#tipoGastosTeso').show();
							validaTipoGas();
						}*/
						validaCuentaContable('ctaContable'); 
						consultaTipoInstrumento();
						centroCostosConsulta();
					}else{								
						alert("No existe el Tipo de Anticipo/Gasto");
						deshabilitaBoton('modificar', 'submit');		
						$('#tipoAntGastoID').focus();
						inicializaForma('formaGenerica','tipoAntGastoID' );		
						$('#tipoGastoID').val('');
					}
				});
						
			}											
		}
	}
	
	function validaTipoGas() {
		var tipoGas = $('#tipoGastoID').val();
		setTimeout("$('#cajaLista').hide();", 200);		
		if(tipoGas != '' && !isNaN(tipoGas) ){
				var tipoGasBeanCon = { 
  					'tipoGastoID':$('#tipoGastoID').val()
				};
				 
				tipoGasServicio.consulta(catTipoConsultaCatalogoAntGastos.principal,tipoGasBeanCon,function(gastos) {
					if(gastos!=null){	
						if(gastos.cajaChica=="N"){
							alert("No Existe el Tipo de Gasto");	
							$('#nombreGasto').val("");
							$('#ctaContable').val("");	
							$('#nombreCtaContable').val("");
							$('#tipoGastoID').focus();
							$('#tipoGastoID').val("");
							$('#tipoGastoID').select();
						}else{
						$('#nombreGasto').val(gastos.descripcion);
						$('#ctaContable').val(gastos.cuentaCompleta);
						
						if(gastos.cuentaCompleta !=null){
							validaCuentaContable('ctaContable');
						}else{
							$('#nombreCtaContable').val("");																
						}
						soloLecturaControl('nombreGasto');
						soloLecturaControl('ctaContable');
						soloLecturaControl('nombreCtaContable');
						$('#centroCosto').focus();
						}
					}else{
						alert("No Existe el Tipo de Gasto");				
						$('#nombreGasto').val("");
						$('#ctaContable').val("");	
						$('#nombreCtaContable').val("");
						$('#tipoGastoID').focus();
						$('#tipoGastoID').val("");
						$('#tipoGastoID').select();
					}
				});
			}
		}
	
	
	function validaCuentaContable(idControl) {
		var jqCtaContable = eval("'#" + idControl + "'");
		var numCtaContable = $(jqCtaContable).val();
		var conPrincipal = 1;
		var CtaContableBeanCon = {
				'cuentaCompleta':numCtaContable
		};
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaContable != '' && !isNaN(numCtaContable)){
			cuentasContablesServicio.consulta(conPrincipal,CtaContableBeanCon,function(ctaConta){
				
				if(ctaConta!=null){ 
					$('#nombreCtaContable').val(ctaConta.descripcion); 		
				}
				else{
					alert("No Existe la Cuenta Contable.");
					$('#nombreCtaContable').val("");
					$('#ctaContable').val("");	
					$('#ctaContable').focus();	
				}
			}); 																					
		}
	}
		
	
	function consultaTipoInstrumento() {
		var tipoInstrumento = $('#tipoInstrumentoID').val();		
		if(tipoInstrumento != '' && !isNaN(tipoInstrumento)){
				var tipoInstrumentoBean = { 
  					'tipoInstrumentoID':$('#tipoInstrumentoID').val()
				};
				tipoInstrumentosServicio.consulta(catTipoConsultaCatalogoAntGastos.principal,tipoInstrumentoBean,function(tipoInstrumento) {
					if(tipoInstrumento!=null){	
						$('#nombreInstrumento').val(tipoInstrumento.descripcion);						
					}else{
						alert("No Existe el Tipo de Instrumento");				
						$('#tipoInstrumentoID').val("");
						$('#nombreInstrumento').val("");
						$('#tipoInstrumentoID').focus();
					}
				});
			}
		}
	
	

});


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
					'<td id="encabezadoLista" >&SE</td><td id="contenidoAyuda"><b>Sucursal Empleado</b></td>'+
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
					'<td id="contenidoAyuda">&SE</td>'+
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

function centroCostosConsulta(){
		if($('#centroCosto').val()=="&SO"){
		   $('#nombreCentroCosto').val("CENTRO DE COSTOS DE LA SUCURSAL ORIGEN");
		}
		
		
		if($('#centroCosto').val()=="&SE"){
			$('#nombreCentroCosto').val("CENTRO DE COSTOS DE LA SUCURSAL DEL EMPLEADO");
		}
	
}

function centroCostoValida(){	
	if($('#centroCosto').val()=="&SO"){
		   $('#nombreCentroCosto').val("CENTRO DE COSTOS DE LA SUCURSAL ORIGEN");
		}else
	if($('#centroCosto').val()=="&SE"){
		$('#nombreCentroCosto').val("CENTRO DE COSTOS DE LA SUCURSAL DEL EMPLEADO");
	}else{
		$('#nombreCentroCosto').val('');
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

function funcionExitoCatalogo(){	
	inicializaForma('formaGenerica','tipoAntGastoID' );
	$('#tipoGastoID').val('');
	
}
function funcionErrorCatalogo(){
	
}