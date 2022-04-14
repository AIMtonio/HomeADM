$(document).ready(function() {

	esTab = true;
	var catTipoListaTipoAportacion = {
			'principal':1
		};	
	var catTipoConsultaTipoAportacion = {
			'principal':1
		};
	// Definicion de Constantes y Enums
	var catTipoTransaccionInversiones = {
			'agrega' : 1,
			'modifica' : 2
	};
	 
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#tipoAportacionID').val("");
	$('#tipoAportacionID').focus();
	deshabilitaBoton('agrega', 'submit');
	$.validator.setDefaults({
			submitHandler: function(event) { 
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoAportacionID','exitoTransaccionGrabar','falloTransaccionGrabar');
			}
    });			
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInversiones.agrega);
		creaMontosAPORTACIONES();
		consultaMontosInfSup();
		
	});
	$('#tipoAportacionID').bind('keyup',function(e){	
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "descripcion";
		 parametrosLista[0] = $('#tipoAportacionID').val();
		
		lista('tipoAportacionID', 2, catTipoListaTipoAportacion.principal, camposLista, parametrosLista, 'listaTiposAportaciones.htm');
	});
	
	$('#tipoAportacionID').blur(function() {
		if(esTab == true & !isNaN($('#tipoAportacionID').val())){
			validaTipoAportacion($('#tipoAportacionID').val());
			if(!isNaN($('#tipoAportacionID').val()) & esTab == true){
			consultaMontos();
			}
		}
		
	});

	 //Funcion para consultar rango de montos
	function consultaMontos(){	
		var params = {};
		params['tipoLista'] = 2;
		params['tipoAportacionID'] = $('#tipoAportacionID').val();
		
		$.post("gridMontosAportaciones.htm", params, function(data){	
		
				if(data.length >0) {	
					$('#gridMontos').html(data);
					$('#gridMontos').show();
				}else{					
					$('#gridMontos').html("");
					$('#gridMontos').show();
				}
		});
	}
	
	/*=====Valida Forma========*/
	$('#formaGenerica').validate({
		rules: {
			tipoInversionID: { 
				minlength: 1
			}
		},
		messages: { 			
		 	tipoInversionID: {
				minlength: 'Al menos un Caracter'
			}
		}		
	});
		
	
	/*Funcion para consultar el tipo de Aportación y moneda*/
	function validaTipoAportacion(tipAportacion){
		var TipoAportacionBean ={
			'tipoAportacionID' :tipAportacion
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipAportacion != '' && !isNaN(tipAportacion) && esTab){
		
				habilitaBoton('agrega', 'submit');
				tiposAportacionesServicio.consulta(catTipoConsultaTipoAportacion.principal,TipoAportacionBean, function(tipoAportacion){
					if(tipoAportacion!=null){
						$('#descripcion').val(tipoAportacion.descripcion);	
						$('#tipoAportacionID').val(tipoAportacion.tipoAportacionID);
						$('#monedaID').val(tipoAportacion.monedaID);	
						$('#descripcionMoneda').val(tipoAportacion.descripcionMon);
					}else{
						$('#descripcion').val('');
						mensajeSis("El Tipo de Aportación no Existe.");
						$('#tipoAportacionID').focus();
						$('#tipoAportacionID').val('');
						$('#monedaID').val("");	
						$('#descripcionMoneda').val("");
						deshabilitaBoton('agrega', 'submit');
					}
				});
			
		}				
	}
	
	
	/*Funcion para crear la lista de montos*/
	function creaMontosAPORTACIONES(){
		var contador = 1;	
		$('#montosInferior').val("");
		$('#montosSuperior').val("");		
		quitaFormatoControles('gridMontos');
		
		$('input[name=montoInferior]').each(function() {	
			var MontoInferioruno =$('#inferior'+contador).asNumber();			
			if (contador != 1){
				$('#montosInferior').val($('#montosInferior').val() + ','  + MontoInferioruno);
			}else{				
				$('#montosInferior').val(MontoInferioruno);
			}

			contador = contador + 1;
			MontoInferioruno='';
		});
		contador = 1;
		$('input[name=montoSuperior]').each(function() {
			var montoSuperiorUno=$('#superior'+contador).asNumber();
			if (contador != 1){
				$('#montosSuperior').val($('#montosSuperior').val() + ','  + montoSuperiorUno);
			}else{
				
				$('#montosSuperior').val(montoSuperiorUno);
			}
			contador = contador + 1;
			montoSuperiorUno='';
		});	
	}
	

});

/*Funcion para validar que el monto inferior no sea mayor al superior*/
function consultaMontosInfSup(){
	var contador = 1;	
	$('input[name=montoSuperior]').each(function() {	
		$('#inferior'+contador).asNumber();			
		$('#superior'+contador).asNumber();			
		if($('#inferior'+contador).asNumber()	> $('#superior'+contador).asNumber()){
			mensajeSis("El Monto Superior debe de ser Mayor al Monto Inferior.");	
		 $('#superior'+contador).focus();	
		 agregaFormatoControles('gridMontosAportaciones');
		 event.preventDefault();
		}
		contador = contador + 1;
	});
	
}

function exitoTransaccionGrabar(){
	agregaFormatoControles('gridMontosAportaciones');
	
}
function falloTransaccionGrabar(){
	agregaFormatoControles('gridMontosAportaciones');
	
}