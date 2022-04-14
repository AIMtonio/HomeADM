$(document).ready(function() {
    esTab = true;
    
    //Definicion de Constantes y Enums  
	var catTipoTransaccion = {   
  		'procesa':'1',
  		'limpia':'2'	};
	
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
			//grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'institucionID');
			grabaFormaArchivo(event, 'formaGenerica2', 'contenedorForma', 'mensaje', 'true', 'institucionID');
    	}
    });
       
        
    $('#procesar').click(function() {		
    	 
			  	$('#tipoTransaccion').val(catTipoTransaccion.procesa);
		 
    });

    //------------ Validaciones de la Forma -------------------------------------
    
 $.validator.addMethod('filesize', function(value, element, param) {
	 return this.optional(element) || (element.files[0].size <= param);
  });

	$('#formaGenerica2').validate({
		rules: {
			file: { required: true,filesize: 3145728  }
		},
		
		messages: {
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamaño máximo de 3MB' 
			}	 
		}
		
	});
	
	
        
});