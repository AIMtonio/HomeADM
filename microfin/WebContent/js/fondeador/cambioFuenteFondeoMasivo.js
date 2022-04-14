var catTipoTransaccion = {
	'procesar':3
};

$(document).ready(function() {
	esTab = true;
	
	$('#fecha').val(parametroBean.fechaAplicacion);
	deshabilitaBoton('procesar','submit');

	parametroBean = consultaParametrosSession();

	$.validator.setDefaults({submitHandler : function(event) {
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero','exitoTransParametro','falloTransParametro');
		}
	});

	/***********MANEJO DE EVENTOS******************/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});


	$('#formaGenerica').validate({
		rules : {
		},

		messages : {
		}
	});
	
	$('#procesar').click(function(event) {
		$('#tipoTransaccion').val(catTipoTransaccion.procesar);
	});
	

	});


	function exitoTransParametro(){
		limpiaCampos();
	}

	function falloTransParametro(){

	}



	function subirArchivos() {
		var url ="CambioFuenteFondeoMasivoUpload.htm?";
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

		ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
										"left="+leftPosition+
										",top="+topPosition+
										",screenX="+leftPosition+
										",screenY="+topPosition);
	}

	function resultadoCargaArchivo(bean){
		$('#numeroTransacion').val(bean.nombreControl);
		$('#nombreArchivo').val(bean.recursoOrigen);
		if(bean.numeroMensaje == 0){
			consultaValidaciones();
		}
		
	}

	function consultaValidaciones(){
		var params = {};
		params['tipoLista']	= 1;
		params['pagina'] = 0;
		params['numeroTransacion'] = $('#numeroTransacion').val();
		$.post("camFondeoMasivoListaVal.htm", params, function(data){
			if(data!=null){
				$('#listaValidaciones').html(data);
				$('#listaValidaciones').show();
				if($('#totalError').asNumber()>0){
					deshabilitaBoton('procesar','submit');
				}else{
					habilitaBoton('procesar','submit');;
				}
			}
	});
	}

	function limpiaCampos(){
		$('#nombreArchivo').val('');
		$('#listaValidaciones').html("");
		$('#listaValidaciones').hide();
		deshabilitaBoton('procesar','submit');
		$('#numeroTransacion').val(0);
	}
	