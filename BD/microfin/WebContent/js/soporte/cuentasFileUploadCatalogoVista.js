/*$(window).load(function(){  
	comboTiposDocumento();  
});*/ 
//Definicion para el tamaño de los archivos
var sizeArchivoByte ;
var sizeArchivoMB;
$(document).ready(function() {
	esTab = true;
	tamanioarchivo();
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
  		'enviar':4,
  		'modificar':5,
  		'eliminar':6
  	}; 
	var nomAr = "";	
	var ext   = "";
  		
//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('pdf', 'submit');
  	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 	
		grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cuentaAhoID');
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
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		ext = $('#extarchivo').val();
		if (['.txt', '.jpg', '.jpeg','.png','.gif','.csv','.xls','.xlsx','.tiff','.pdf','.doc','.dox'].includes(ext.toLowerCase())){
			$('#observacion').focus();
		}else{
			mensajeSis("Tipo de Archivo No Permitido.");
			$(this).val("");
			$(this).focus();
		}
		
	});
	
	$('#observacion').change(function() {	
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
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
	
	if(sizeArchivoByte > 0){
		$('#formaGenerica').validate({
			rules: {
				cuentaAhoID: {
					required: true
				},
				tipoDocumento: {
					required: true
				},
				observacion: {
					required: true
				},
				file: { required: true,filesize: sizeArchivoByte  }

			},
			messages: {
				cuentaAhoID: {
					required: 'Especificar Cuenta'
				},
				tipoDocumento: {
					required: 'Especificar Tipo de Documento'
				},
				observacion: {
					required: 'Especificar Observacion'
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
				cuentaAhoID: {
					required: true
				},
				tipoDocumento: {
					required: true
				},
				observacion: {
					required: true
				}
			},
			messages: {
				cuentaAhoID: {
					required: 'Especificar Cuenta'
				},
				tipoDocumento: {
					required: 'Especificar Tipo de Documento'
				},
				observacion: {
					required: 'Especificar Observacion'
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


