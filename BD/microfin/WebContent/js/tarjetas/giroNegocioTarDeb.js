$(document).ready(function() {
		esTab = true;
	//Definicion de Constantes y Enums  
	var catTipoTransaccionTipoTarjeta = {  
  		'agrega':'1',
  		'modifica':'2'	};
	
	var catTipoConsultaGiroNeg = {
  		'principal'	: 1,
  		'giros'	: 2
  		
	};	
	var catListaGiros ={
		'giros'	: 2
	};
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');

    $(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$(':text').focus(function() {	
	 	esTab = false;
	});
	

	$.validator.setDefaults({
            submitHandler: function(event) { 
            	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','giroID','funcionExitoTipoTarjetaDebito','funcionErrorTipoTarjetaDebito'); 
            }
    });				
	
	$('#agrega').click(function() {	
			$('#tipoTransaccion').val(catTipoTransaccionTipoTarjeta.agrega);
	});
	
	$('#modifica').click(function() {	
			$('#tipoTransaccion').val(catTipoTransaccionTipoTarjeta.modifica);
	});

	$('#giroID').bind('keyup',function(e){
		lista('giroID', '1', catListaGiros.giros, 'giroID', $('#giroID').val(), 'giroNegTarDebLista.htm');
	});
	
	$('#giroID').blur(function() { 
		insertaTipoTarjetaDebito(this.id); 
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({				
		rules: {			
			giroID: {
				required: true,
				minlength : 4,
				maxlength : 4
			},	
			descripcion: {
				required: true,
				maxlength : 200
			},	
			nombreCorto: {
				required: true,
				maxlength : 30
			},
			estatus: { 
				required: true
			}
		},
		messages: {
			giroID: {
				required	 : 'Especificar el Giro',
				minlength : 'Mínimo 4 caracteres',
				maxlength : 'Máximo 4 caracteres'
			},
			descripcion: {
				required: 'Especificar la Descripción',
				maxlength : 'Maximo 200 caracteres'
			},
			nombreCorto: {
				required: 'Especificar el Nombre Corto',
				maxlength : 'Maximo 30 caracteres'
			},
			estatus: {
				required: 'Especificar el Estatus'
			}
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	function insertaTipoTarjetaDebito(control) {
		var tipoGiroID = $('#giroID').val();
		var giroNegBeanCon  = {
			'giroID' : tipoGiroID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoGiroID != '' && !isNaN(tipoGiroID) && esTab){
			giroNegocioTarDebServicio.consulta(catTipoConsultaGiroNeg.giros,giroNegBeanCon,function(TipoTarDeb) {
				if(TipoTarDeb != null){
					$('#giroID').val(TipoTarDeb.giroID);
					$('#descripcion').val(TipoTarDeb.descripcion);
					$('#nombreCorto').val(TipoTarDeb.nombreCorto);
					$('#estatus').val(TipoTarDeb.estatus);
					habilitaBoton('modifica','submit');
					deshabilitaBoton('agrega','submit');
				}else{
					//alert("No Existe el Tipo de Giro Negocio");
					habilitaBoton('agrega','submit');
					deshabilitaBoton('modifica','submit');
					$('#descripcion').val('');
					$('#nombreCorto').val('');
					$('#estatus').val('');
				}	
			});
		}else {
			$('#giroID').val('');
			$('#descripcion').val('');
			$('#nombreCorto').val('');
			$('#estatus').val('');
		}
	}		
});

//funcion que se ejecuta cuando el resultado fue exito
function funcionExitoTipoTarjetaDebito(){
	$('#giroID').focus();
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	$('#nombreCorto').val('');
	$('#estatus').val('');
	$('#descripcion').val('');
}

// funcion que se ejecuta cuando el resultado fue error
// diferente de cero
function funcionErrorTipoTarjetaDebito(){
	$('#giroID').focus();	
}