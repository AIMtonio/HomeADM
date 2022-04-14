/*popup*/
var parametroBean = consultaParametrosSession();
var rutaArchivos = parametroBean.rutaArchivos;
var esTab = true;
//Definicion de Constantes y Enums  
var catTipoTransaccionFileUpload = {
'enviar' : 1,
'modificar' : 2,
'eliminar' : 3
};
var nomAr = "";
var fechaAplicacion = parametroBean.fechaAplicacion;
//Definicion para el tamaño de los archivos
var sizeArchivoByte ;
var sizeArchivoMB;

$(document).ready(function() {
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	tamanioarchivo();
	inicializaClienteArchivos();
	deshabilitaBoton('pdf', 'submit');

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'clienteID');
		}
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#enviar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
	});

	$('#file').change(function() {
		nomAr = $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});

	$('#observacion').change(function() {
		nomAr = $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});

	$('#fechaRegistro').change(function() {
		var fechaSeleccionada = $('#fechaRegistro').val();
		if (validacion.esFechaValida(fechaSeleccionada)) {
			if (fechaSeleccionada > fechaAplicacion) {
				mensajeSis("La fecha de Registro no puede ser mayor a la fecha del Sistema.");
			}
		} else {
			mensajeSis("La fecha de Registro no es válida.");
		}
	});

	$('#recurso').val(parametroBean.rutaArchivos);

	//------------ Validaciones de la Forma -------------------------------------

	$.validator.addMethod('filesize', function(value, element, param) {
		// param = size (en bytes) 
		// element = element to validate (<input>)
		// value = value of the element (file name)
		return this.optional(element) || (element.files[0].size <= param);
	});

	if(sizeArchivoByte > 0){
		$('#formaGenerica').validate({
			rules : {
				tipoDocumento : {
					required : true
				},
				observacion : {
					required : true
				},
				file: { 
					required: true,
					filesize: sizeArchivoByte 
				}
			},
			messages : {
				tipoDocumento : {
					required : 'Especificar Tipo de Documento'
				},
				observacion : {
					required : 'Especificar Observación'
				},
				file : {
					required : 'Seleccionar Archivo',
					filesize: 'El archivo seleccionado debe tener un tamanio maximo de '+ sizeArchivoMB +' MB' 
				}
			}
		});
	}
	else{
		$('#formaGenerica').validate({
			rules : {
				tipoDocumento : {
					required : true
				},
				observacion : {
					required : true
				}
			},
			messages : {
				tipoDocumento : {
					required : 'Especificar Tipo de Documento'
				},
				observacion : {
					required : 'Especificar Observación'
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

function inicializaClienteArchivos() {
	parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	fechaAplicacion = parametroBean.fechaAplicacion;
	$("#fechaRegistro").val(fechaAplicacion);
	agregaFormatoControles('formaGenerica');

}