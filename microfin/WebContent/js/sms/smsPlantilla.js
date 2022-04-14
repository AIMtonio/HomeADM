$(document).ready(function(){
		
		//DefiniciÃ³n de constantes y Enums
		
	var catTipoTranPlantilla= { 
  		'alta'	: 1,
  		'modifica'	: 2,
  		'elimina'	: 3
  		 
	};		
	//-----------------------MÃ©todos y manejo de eventos-----------------------
	deshabilitaBoton('guardar', 'submit');
	deshabilitaBoton('modificar', 'submit');	
	deshabilitaBoton('eliminar', 'submit');
	
	$('#plantillaID').focus();


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){			
		}
	});			
    
   	$.validator.setDefaults({
   		submitHandler: function(event) { 
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','plantillaID','exitoPlantilla', 'falloPlantilla'); 
   				deshabilitaBoton('guardar', 'submit');
            }
    });

   	$('#guardar').click(function(){
		$('#tipoTransaccion').val(catTipoTranPlantilla.alta);
	});
   	$('#modificar').click(function(){
		$('#tipoTransaccion').val(catTipoTranPlantilla.modifica);
	});
   	$('#eliminar').click(function(){
		$('#tipoTransaccion').val(catTipoTranPlantilla.elimina);
	});
		
	$('#plantillaID').blur(function(){
		validaPlantilla(this.id);
	});	
	
	$('#plantillaID').bind('keyup',function(e){
		if(this.value.length >= 2){ 
			var camposLista = new Array();
			var parametrosLista = new Array();
			//camposLista[0] = "plantillaID";
			camposLista[0] = "nombre";			
			parametrosLista[0] = $('#plantillaID').val();
			listaAlfanumerica('plantillaID', '1', '1', camposLista, parametrosLista, 'listaPlantilla.htm');
		}
	});
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			plantillaID:{
				required: true
			},
			nombre: {
				required: true
			},
			descripcion: {
				required: true
			}
		},		
		messages: {
			plantillaID: {
				required: 'Especificar No de Plantilla'
			},
			nombre: {
				required: 'Especificar Nombre'
			},
			descripcion: {
				required: 'Especificar Descripción'
			}
		}
	});

	
//-------------Validaciones de controles---------------------
			
	function validaPlantilla(idControl){
		var jqCampania  = eval("'#" + idControl + "'");
		var numPlantilla = $(jqCampania).val();	

		setTimeout("$('#cajaLista').hide();", 200);
		
		if( numPlantilla != '' && !isNaN(numPlantilla)){
		if( numPlantilla == '0'){
			inicializaForma('formaGenerica', idControl);
			habilitaBoton('guardar', 'submit');
			deshabilitaBoton('modificar', 'submit');	
			deshabilitaBoton('eliminar', 'submit');
		}else {
			var tipoConsulta = 1;				
			var plantillaBean = {
				'plantillaID' :	$('#plantillaID').val()
			}; 
			smsPlantillaServicio.consulta(tipoConsulta, plantillaBean, function(plantilla){
				if(plantilla != null){
					dwr.util.setValues(plantilla);
					
					deshabilitaBoton('guardar', 'submit');
					habilitaBoton('modificar', 'submit');
					habilitaBoton('eliminar', 'submit');
				}else{
					mensajeSis("Plantilla no encontrada");
					inicializaForma('formaGenerica', idControl);
					$('#plantillaID').val('');
					$('#plantillaID').focus();
					$('#plantillaID').select();
					deshabilitaBoton('guardar', 'submit');
					deshabilitaBoton('modificar', 'submit');	
					deshabilitaBoton('eliminar', 'submit');
				}
			});
		}// else
	}
	
}
});

function poner_texto(){
	document.formaGenerica.descripcion.value +=' '+document.formaGenerica.clasificacion.value;
}

function exitoPlantilla(){	
	deshabilitaBoton('guardar', 'submit');
	deshabilitaBoton('modificar', 'submit');	
	deshabilitaBoton('eliminar', 'submit');
	inicializaForma('formaGenerica','campaniaID');
	$('#plantillaID').val('');
}

function falloPlantilla(){
	
}

