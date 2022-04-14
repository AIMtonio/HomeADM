
$(document).ready(function() {
	
	esTab = false;
	
	var tipoTransaccion = {
		'procesar'    : 1
	};
	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 	
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'procesar','funcionExito', 'funcionError');  
    	}
     });
	
	var parametroBean = consultaParametrosSession();


	$('#tipo').focus();
	$('#procesar').hide();
	/**
	 * METODOS  Y MANEJO DE EVENTOS
	 */
	agregaFormatoControles('formaGenerica');	
	/**
	 * Pone tap falso cuando toma el foco input text
	 */
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	/**
	 * Pone tab en verdadero cuando se presiona tab
	 */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	/**
	 * Adjuntar Archivos para Procesar Afiliación/Bajas Cuenta Clabe
	 */
	$('#adjuntar').click(function() {
		if($('#tipo').val()==""){
			mensajeSis("Seleccionar un tipo de proceso");
			$('#tipo').focus();
		}
		else{
			subirArchivos();
		}
		
	});
	
	/**
	 * Procesa Afiliación/Bajas Cuenta Clabe
	 */
	$('#procesar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.procesar);
	});

		
	/**
	 * VALIDACIONES DE LA FORMA
	 */
	$('#formaGenerica').validate({			
		rules: {
			tipo :{
				required:true
			}
		},		
		messages: {
			tipo :{
				required:'Seleccione un Tipo.'
			}
		}		
	});
	
	});// fin document.ready
	
	/**
	 * Consulta para el grid de Afiliación/Bajas Cuenta Clabe
	 */
	function consultaAfiliacionProcesar(){
	  var tipo = $('#tipo').val();
	  var params = {};
	  params['tipo'] = tipo;
	  params['tipoLista'] = 1;
		$.post("procAfiliaBajaCtaClabeGrid.htm", params, function(data){		
			if(data.length >0) {
				$('#gridAfiliacionBajasCtaClabe').html(data);
				$('#gridAfiliacionBajasCtaClabe').show();
				$('#procesar').show();
				$('#procesar').focus();
			}else{
				$('#gridAfiliacionBajasCtaClabe').html("");
				$('#gridAfiliacionBajasCtaClabe').show();
				$('#procesar').hide();
			}
		});
	}

	/**
	 * Función para Subir Archivos para leer el Layout para Procesar Afiliación/Bajas Cuenta Clabe
	 */
	function subirArchivos() {
	    var url = "archivoAfiliacionCtaClabe.htm" +
	    	 "?tip=" + $('#tipo').val();
	    var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
	    var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
	
	    ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=320,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0" +
	        "left=" + leftPosition +
	        ",top=" + topPosition +
	        ",screenX=" + leftPosition +
	        ",screenY=" + topPosition);
	}
	
	/**
	 * Función de Éxito
	 */
	function funcionExito(){
		$('#gridAfiliacionBajasCtaClabe').html("");
		$('#gridAfiliacionBajasCtaClabe').hide();
		$('#procesar').hide();
	}
	
	/**
	 * Función de Error
	 */
	function funcionError(){
		agregaFormatoControles('formaGenerica');	
	}
	
	function recargarGridArchivos() {
	    consultaAfiliacionProcesar();
	}
