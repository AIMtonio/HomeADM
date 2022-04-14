/*$(window).load(function(){  
	comboTiposDocumento();  
}); 
*/
$(document).ready(function() {
	esTab = false;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
	  		'enviar':1,
	  		'modificar':2,
	  		'eliminar':3
	}; 
	var nomAr = "";	
  	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	deshabilitaBoton('pdf', 'submit');
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
  	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID');
	  	}
	});	

	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
	});
	
	$('#file').change(function(){
		nomAr= $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});
	

	$('#observacion').change(function() {	
		nomAr= $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);

	//------------ Validaciones de la Forma -------------------------------------
	
	$.validator.addMethod('filesize', function(value, element, param) {
	    // param = size (en bytes) 
	    // element = element to validate (<input>)
	    // value = value of the element (file name)
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			tipoDocumento: {
				required: true
			},
			observacion: {
				required: true
			},
			file: { required: true,filesize: 3145728  }
	
		},
		messages: {
			tipoDocumento: {
				required: 'Especificar Tipo de Documento'
			},
			observacion: {
				required: 'Especificar Observación'
			}	,
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamaño máximo de 3MB' 
			}	 
		}			
	});
	
//------------ Validaciones de Controles -------------------------------------	
});
