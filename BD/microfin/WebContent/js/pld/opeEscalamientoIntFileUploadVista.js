$(window).load(function(){  
	comboTiposDocumento();  
}); 

$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
			'enviar':1,
			'modificar':2,
			'eliminar':3
	}; 
	var nomAr = "";	
  	var conta = 0;
  	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
  	habilitaBoton('enviar', 'submit');
  	consultaCliente('clienteID'); 
  	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID');
	  	}
	});	
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {	
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
	});
	
	$('#pdf').click(function() {
		consultaNumeroDocumentosPorCliente();
	});

	$('#tipoDocumento').blur(function() {
		esTab=true;
	});	
	
	$('#file').change(function(){
		nomAr= $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		$('#observacion').focus();
	});

	$('#observacion').change(function() {	
		nomAr= $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});

	

	var parametrosBean = consultaParametrosSession();
	var rutaArchivos = parametrosBean.rutaArchivos;
	$('#recurso').val(rutaArchivos);
	
	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({	
		rules: {
			clienteID: {
				required: true,
				minlength: 1
			},
			tipoDocumento: {
				required: true,
				minlength: 1
			},
			observacion: {
				required: true
			},
			file: { required: true ,filesize: 3145728  }
		},
		messages: {
			clienteID: {
				required: 'Especificar Cliente.',
			},
			tipoDocumento: {
				required: 'Especificar Tipo de Documento.', 
			}	, 
			observacion: {
				required: 'Especificar Observación.'
			}	,
			file: {
				required: 'Seleccionar Archivo.',
				filesize: 'El archivo seleccionado debe tener un tamaño máximo de 3MB.' 
			}	 
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	
	function consultaCliente(idControl) { 
		esTab="true";
		var jqcliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqcliente).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(2,numCliente,function(cliente) { 
				if(cliente!=null){
					$('#clienteID').val(cliente.numero)	;
					$('#nombreCliente').val(cliente.nombreCompleto)	;	
				}else{
					alert("No Existe el Cliente");
					$('#clienteID').focus();
					$('#clienteID').select();											
				}
			});
		}
	}
	
	//Funcion para consultar el numero de documentos por cliente. y generar reporte
	function consultaNumeroDocumentosPorCliente() { 
		var  clienteArchivosBean={
			'prospectoID' :"0",
			'clienteID' : $('#clienteID').val() 
		};			
		setTimeout("$('#cajaLista').hide();", 200);
		esTab = true; 
		if( $('#clienteID').val() != '' || !isNaN( $('#clienteID').val()) && esTab){
			clienteArchivosServicio.consulta(3,clienteArchivosBean,function(clienteArchivos) { 
				if(clienteArchivos!=null){
					numeroDocumentos = 	clienteArchivos.numeroDocumentos;				
					if(numeroDocumentos > 0 ){
						var parametrosBean = consultaParametrosSession();
						var fechaEmision = parametrosBean.fechaSucursal;
						var nombreUsuario = parametrosBean.nombreUsuario;
						var nombreInstitucion = parametrosBean.nombreInstitucion;
						var clienteID = $('#clienteID').val();
						var nombre=$('#nombreCliente').val();
						var prospectoID = "0";
						var nombreProspecto="";
						var pagina='clientesFilePDF.htm?clienteID='+clienteID+'&nombreCliente='+nombre+
							'&prospectoID='+prospectoID+'&nombreProspecto='+nombreProspecto+
							'&nombreUsuario='+nombreUsuario+'&fechaEmision='+fechaEmision+'&nombreInstitucion='	+nombreInstitucion;
						window.open(pagina,'_blank');
					} else{
						alert("El cliente no tiene documentos digitalizados.");
					}
				}else{
					alert("El cliente no tiene documentos digitalizados.");
				}
			});																										
		}
	}

});

//funcion para llenar el combo de procesos de escalamiento
function comboTiposDocumento() {	
	var tiposDoc = {
		'requeridoEn':'P'			
	};
		dwr.util.removeAllOptions('tipoDocumento'); 
	dwr.util.addOptions('tipoDocumento', {'':'SELECCIONAR'}); 
	tiposDocumentosServicio.listaCombo(1,tiposDoc, function(tiposDocumentos){
		dwr.util.addOptions('tipoDocumento', tiposDocumentos, 'tipoDocumentoID', 'descripcion');
	});
}



function eliminaArchivo(idControl) { 
	$('#tipoTransaccion').val('3');
	confirmarEliminar() ;
}


function confirmarEliminar() {		
	$('#tipoTransaccion').val('3');
	var formulario = document.getElementById('formaGenerica'); 
	confirmar=confirm("¿Deseas eliminar el archivo?"); 
	if (confirmar) {
		// si pulsamos en aceptar
		$('#tipoTransaccion').val('3');
		formulario.submit();
	}				
	else {
		event.preventDefault();  
	} 		
}