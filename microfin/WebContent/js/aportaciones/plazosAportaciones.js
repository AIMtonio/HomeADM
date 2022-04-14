$(document).ready(function() {

	esTab = true;

	// Definicion de Constantes y Enums
	var catTipoTransaccionInversiones = {
			'agrega' : 1,
			'modifica' : 2
	};
	
	var catTipoConsultaTipoAportacion = {
			'principal':1
	};
	
	var catTipoListaTipoAportacion={
			'principal':1
	}; 
	
	deshabilitaBoton('agrega', 'submit');
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$('#tipoAportacionID').val("");
	$('#tipoAportacionID').focus();

	$.validator.setDefaults({
			submitHandler: function(event) { 
         	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoAportacionID'); 
			}
    });			
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInversiones.agrega);
		creaPlazosInversion();
		consultaPlazosInfSup();
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
				consultaPlazos();
			}
		}		
	});

	
	function consultaPlazos(){	
		var params = {};
		params['tipoLista'] = 2;
		params['tipoAportacionID'] = $('#tipoAportacionID').val();
		
		$.post("gridPlazosAportaciones.htm", params, function(data){
				if(data.length >0) {
					$('#gridPlazos').html(data);
					$('#gridPlazos').show();
				}else{
					$('#gridPlazos').html("");
					$('#gridPlazos').show();
				}
		});
	}

	$('#formaGenerica').validate({
		rules: {
			tipoAportacionID: { 
				minlength: 1
			}
		},
		messages: { 			
			tipoAportacionID: {
				minlength: 'Al menos un Caracter'
			}
		}		
	});
	
	/*Función para consultar el tipo de Aportación y moneda*/
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
						$('#tipoAportacionID').val('');
						$('#monedaID').val("");	
						$('#descripcionMoneda').val("");
						$('#tipoAportacionID').focus();
						mensajeSis("El Tipo de Aportación no Existe.");
						deshabilitaBoton('agrega', 'submit');
					}
				});
		}				
	}
	
	
	function creaPlazosInversion(){
		var contador = 1;	
		$('#diasInferior').val("");
		$('#diasSuperior').val("");		
		
		$('input[name=plazoInferior]').each(function() {					
			if (contador != 1){
				$('#diasInferior').val($('#diasInferior').val() + ','  + this.value);
			}else{
				$('#diasInferior').val(this.value);
			}
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=plazoSuperior]').each(function() {
			if (contador != 1){
				$('#diasSuperior').val($('#diasSuperior').val() + ','  + this.value);
			}else{
				$('#diasSuperior').val(this.value);
			}
			contador = contador + 1;
		});
	}
	

});
/*Funcion para validar que el monto inferior no sea mayor al superior*/
function consultaPlazosInfSup(){
	var contador = 1;	
	$('input[name=plazoSuperior]').each(function() {	
		$('#inferior'+contador).asNumber();			
		$('#superior'+contador).asNumber();			
		if($('#inferior'+contador).asNumber()	> $('#superior'+contador).asNumber()){
			mensajeSis("El Día Superior debe de ser Mayor al Día Inferior.");	
		 $('#superior'+contador).focus();	
		 agregaFormatoControles('gridPlazos');
		 event.preventDefault();
		}
		contador = contador + 1;
	});
	
}
