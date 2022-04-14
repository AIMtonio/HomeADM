var numeroDocumentos = 0;
$(document).ready(function() { 
	esTab = false; 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
	  		'enviar':1,
	  		'modificar':2,
	  		'eliminar':3
	}; 	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','recurso', 'inicializa');
	  	}
	});	
	 $('#tipoCarga').focus();  	
	 $('#enviar').click(function() {		
			if ($('#tipoCarga').val()==null || $('#tipoCarga').val()==''){
				mensajeSis("Seleccione un tipo de Documento");
				$('#tipoCarga').focus();
			}else{
				subirArchivos();
			}
	});
	$('#cargar').click(function() {		
			if ($('#tipoCarga').val()==null || $('#tipoCarga').val()==''){
				mensajeSis("Seleccione un tipo de Documento");
				$('#tipoCarga').focus();
			}else{
				$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
			}
	});
	var parametroBean = consultaParametrosSession();
	$('#fechaCarga').val(parametroBean.fechaSucursal);

	function subirArchivos() {
		var url ="cargaFileTarjetasVista.htm?tipoCarga="+$('#tipoCarga').val();
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
		ventanaArchivosCliente = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
										"left="+leftPosition+
										",top="+topPosition+
										",screenX="+leftPosition+
										",screenY="+topPosition);	
	}
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			tipoCarga: {
				required: true
			},
			nombreArchivo: {
				required: true
			},
		},
		messages: {
			tipoCarga: {
				required: 'Especificar Tipo de Documento'
			},
			nombreArchivo: {
				required: 'Especificar el Archivo'
			},
		}			
	});	
});
	function inicializa() {
		$('#nombreArchivo').val('');
		$('#numTransaccion').val('');
		$("#tipoCarga option[value="+ '' +"]").attr("selected",true);
	}