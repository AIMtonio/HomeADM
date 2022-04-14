//Definicion para el tamaño de los archivos
var sizeArchivoByte ;
var sizeArchivoMB;
$(document).ready(function() {
	esTab = true;
	tamanioarchivo();
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
	  		'enviar':1,
	}; 
	var nomAr = "";	
  	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	deshabilitaBoton('pdf', 'submit');
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID');
	  	}
	});	

	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {	
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
		
	});
	
	$('#file').change(function(){
		nomAr= $('#file').val();
		
			$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
			conta = 1;
			$('#comentario').focus();
		
	});
	
	$('#tipoDocumentoID').blur(function() {
		esTab=true;
  		consultaArchivCliente();
		ConsultaFotoCte('numero');
	});	

	$('#comentario').focus(function() {	
		if(nomAr!=null){
			nomAr= $('#file').val();
			$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		}
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);

	//------------ Validaciones de la Forma -------------------------------------
	
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	if(sizeArchivoByte > 0){
		$('#formaGenerica').validate({
			rules: {
				tipoDocumentoID: {
					required: true
				},
				comentario: {
					required: true
				},
				file: { required: true,filesize: sizeArchivoByte  }
		
			},
			messages: {
				tipoDocumentoID: {
					required: 'Especificar Tipo de Documento'
				},
				comentario: {
					required: 'Especificar Observación'
				}	,
				file: {
					required: 'Seleccionar Archivo',
					filesize: 'El archivo seleccionado debe tener un tamanio maximo de '+ sizeArchivoMB +' MB'
				}	 
			}			
		});
	}
	else{
		$('#formaGenerica').validate({
			rules: {
				tipoDocumentoID: {
					required: true
				},
				comentario: {
					required: true
				}
			},
			messages: {
				tipoDocumentoID: {
					required: 'Especificar Tipo de Documento'
				},
				comentario: {
					required: 'Especificar Observación'
				} 
			}			
		});
	}
	
//------------ Validaciones de Controles -------------------------------------	
	//funcion para consultar el limite de MB del archivo
	function  tamanioarchivo(){
				var paramGeneralesConsulBean = {
							'llaveParametro' : 0
						};
				var tipConPrincipal = 2;
	
				sizeArchivoByte='';
				sizeArchivoMB='';
	
			solicitudArchivoServicio.consulParam(tipConPrincipal,paramGeneralesConsulBean,{
				async: false,callback:function(param) {
						if(param!=null){
							sizeArchivoByte = param.valorParametro*1048576;
								
							sizeArchivoMB =param.valorParametro ;
						}
						else{ 
							mensajeSis("No se puede realizar la acción.");
							deshabilitaBoton('enviar', 'submit');
						}
					}});
	}
});
