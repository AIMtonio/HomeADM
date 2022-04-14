/*$(window).load(function(){  
	comboTiposDocumento();  
});*/ 
$(document).ready(function() {
	esTab = true;	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
  		'actualizarRuta':5,
  		'eliminar':6
  	}; 
  	var catTipoActualizaFileUpload = {
  		'actualizar':2
  	}; 
	var nomAr = "";	
		
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
				grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','campaniaID');
	 	}
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	 
	
	$('#enviar').click(function() {
		var tipoArchivo = $('#tipoArchivo').val();
		var retorno =false;
		if(tipoArchivo == 'A'){
			$('#tipoTransaccion').val(catTipoTransaccionFileUpload.actualizarRuta);
			$('#tipoActualizacion').val(catTipoActualizaFileUpload.actualizar);
			nomAr= $('#file').val();
			if(nomAr!=''){
			var extension = (nomAr.substring(nomAr.lastIndexOf("."))).toLowerCase(); 
			$('#extarchivo').val(extension);
			 	retorno = validaExtensionXML(extension);
			}else{
				retorno = true;
			}
		
		}if(tipoArchivo == 'I'){			
			$('#tipoTransaccion').val(catTipoTransaccionFileUpload.actualizarRuta);
			$('#tipoActualizacion').val(catTipoActualizaFileUpload.actualizar);
			nomAr= $('#file').val();
			if(nomAr!=''){
			var extension = (nomAr.substring(nomAr.lastIndexOf("."))).toLowerCase(); 
			$('#extarchivo').val(extension);
			 retorno = validaExtensionImagen(extension);			 
			}else{
				retorno = true;
			}						
		}
		
		return retorno;
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
			file: { required: true,filesize: 3145728  }		
		},
		messages: {
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB' 
			}	 
		}		
	});
	
	
	function validaExtensionImagen(extension) {		
		  var extensiones_permitidas = new Array(".gif", ".jpg", ".png", ".jpeg", ".wmf", ".bmp", ".ico", ".tiff", ".odg",".pdf"); 
		  var extensiones_permitidasMSG = new Array("*.gif", "*.jpg", "*.png", "*.jpeg", "*.wmf", "*.bmp", "*.ico", "*.tiff", "*.odg","*.pdf"); 
		  var mierror = ""; 
		  var retorno=false;	      
		      
		      permitida = false; 
		      for (var i = 0; i < extensiones_permitidas.length; i++) { 
		         if (extensiones_permitidas[i] == extension) { 
		         permitida = true;		         
		         break; 
		         } 
		      } 
		      if (!permitida) { 
		         mierror = "Verifique el archivo a subir. \nSólo se pueden subir archivos con extensiones: \n" + extensiones_permitidasMSG.join(); 
		         alert (mierror); 
		         retorno = false; 	
		      }else{ 
		          	         
		      		retorno = true; 
		      	} 
		  		  
		   
		   return retorno; 
		} 
	
	
	function validaExtensionXML(extension) { 
		  var extensiones_permitidas = new Array(".xml"); 
		  var mierror = ""; 
		  var retorno=false;	      
		      
		      permitida = false; 
		      for (var i = 0; i < extensiones_permitidas.length; i++) { 
		         if (extensiones_permitidas[i] == extension) { 
		         permitida = true; 
		         break; 
		         } 
		      } 
		      if (!permitida){
		    	  alert( "Verifique el archivo a subir. \nSólo se pueden subir archivos con extensiones: *.xml\n" );
		         retorno = false;
		      }else{ 
		          	         
		      		retorno = true; 
		      } 
		  		  
		   
		   return retorno; 
		} 
//------------ Validaciones de Controles -------------------------------------	
});
