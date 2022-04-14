$(document).ready(function() {
	esTab = true;
	var tab2 = false;
	 
	//Definicion de Constantes y Enums  
	var catTipoTranFileUpload = {
	  		'enviar':2,
	  	
	}; 
	var nombreArchivo = "";	
  	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','polizaID');
	  	}
	});		
	
	$('#procesar').click(function() {		
		$('#tipoTransaccion').val(catTipoTranFileUpload.enviar);
	});
	
	$('#file').change(function(e){
		nombreArchivo= $('#file').val();
		var extencion = $("input#file").val().split(".").pop().toLowerCase();	
		if($.inArray(extencion, ["csv"]) == -1) {
			mensajeSis('Subir un archivo tipo CSV');
			$('#file').val("");
			return false;
		}
		if (e.target.files != undefined) {			
			var reader = new FileReader();
			reader.onload = function(e) {
				var csvval=e.target.result.split("\n");
				var csvvalue=csvval[0].split(",");
				var str=csvvalue.toString();
				var numero=str.split("|").length-1;
				
				if(numero < 1){
					
					mensajeSis('La Separación Debe Ser Por PIPE |');
					$('#file').val("");
				}				
			}
			reader.readAsText(e.target.files.item(0));
		}
		return false;
			
	});
	//------------ Validaciones de la Forma -------------------------------------
	
	$.validator.addMethod('filesize', function(value, element, param) {
	    // param = size (en bytes) 
	    // element = element to validate (<input>)
	    // value = value of the element (file name)
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {		
			file: { 
				required: true,
				filesize: 3145728  
			},	
		},
		messages: {		
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamaño máximo de 3MB' 
			},	 
		}			
	});
	
//------------ Validaciones de Controles -------------------------------------	
});
