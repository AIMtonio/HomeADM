$(document).ready(function() {
	esTab = false;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransConDisp = {
  		'agrega':'1',
  		'modifica':'2'};
	
	var catTipoConsultaConDisp = {
  		'principal'	: 1
  		
	};	
	
	//------------ Msetodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('agrega', 'submit');
    deshabilitaBoton('modifica', 'submit');

    $('#conceptoID').focus();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','conceptoID','funcionExito', 'funcionError');
		}
    });	
    	
	$('#conceptoID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "nombre"; 
			parametrosLista[0] = $('#conceptoID').val();
			listaAlfanumerica('conceptoID', '2', '1', camposLista, parametrosLista, 'listaConceptoDisp.htm');
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransConDisp.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransConDisp.modifica);
	});	

	$('#conceptoID').blur(function() { 
  		validaConcepto(this.id); 
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({	
		rules: {
			conceptoID: {
				required: true,
				numeroPositivo: true
			},
			nombre: {
				required: true,
				maxlength: 100,
				minlength: 5
			},
			descripcion: {
				required: true,
				maxlength: 200,
				minlength: 5
			},
			estatus:{
				required: true
			}
		},		
		messages: {
			conceptoID: {
				required: 'Especificar No. de Concepto de Dispersión.',
				numeroPositivo: 'Solo Números'
			},
			nombre: {
				required: 'Especificar Nombre del Concepto de Dispersión.',
				maxlength: 'maximo 100 caracteres',
				minlength: 'minimo 5 caracteres'
			},
			descripcion: {
				required: 'Especificar Descripción para el Concepto de Dispersión.',
				maxlength: 'maximo 200 caracteres',
				minlength: 'minimo 5 caracteres'
			},			
			estatus: {
				required: 'Especificar Estatus. '
			}
			
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	function validaConcepto(control) {
		var tipoConcepto = $('#conceptoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoConcepto != '' && !isNaN(tipoConcepto)){
			if(tipoConcepto=='0'){
				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				$('#nombre').val("");
				$('#descripcion').val("");
				$('#estatus').val("");
				habilitaControl("estatus");
			} else {
				deshabilitaBoton('agrega', 'submit'); 
				habilitaBoton('modifica', 'submit');
				var tipoConDisBeanCon = { 
  					'conceptoID':$('#conceptoID').val()
				};
				 
				conceptoDispersionServicio.consulta(catTipoConsultaConDisp.principal,tipoConDisBeanCon,function(concepto) {
					if(concepto!=null){
						$('#nombre').val(concepto.nombre);
						$('#descripcion').val(concepto.descripcion);
						$('#estatus').val(concepto.estatus);
						
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');
						habilitaControl("estatus");
					}else{
						mensajeSis("No Existe el Concepto de Dispersión");
						$('#nombre').val("");
						$('#descripcion').val("");
						$('#estatus').val("");
						habilitaControl("estatus");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
					}
				});
			}
		}
	}

}); // DOCUMENT READY FIN


//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	inicializaForma('formaGenerica','conceptoID');
	$('#nombre').val("");
	$('#descripcion').val("");
	$('#estatus').val("");
	habilitaControl("estatus");
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
}