$(document).ready(function() {
    esTab = true;    
    //Definicion de Constantes y Enums
	var catTipoTransaccion = {
  		'procesa':'1',
  		'limpia':'2'	
	};
	
	var catTipoConsultaTesoMvts = {
  		'principal'	: 1,
  		'foranea'	: 2
	};	
	
	var catTipoConsultaInstituciones = {
  		'principal':1, 
  		'foranea':2
	};        
 
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

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
			grabaFormaArchivo(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'institucionID');
    	}
    });
        
    $('#procesarArchivo').click(function() {
    	nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
    	$('#tipoTransaccion').val(catTipoTransaccion.procesa);
    });

    //------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica2').validate({
		rules: {
			file: 'required'
		},		
		messages: {
			file: 'Se requiere un archivo para subir'
		}
	});
	
	$('#validacion').click(function(){
		alert("Correctos: "+ $('#regCorrectos').val());
	});
});