$(document).ready(function (){
	esTab = true;

	parametros = consultaParametrosSession();	
	$('#fechaRegistro').val(parametroBean.fechaSucursal); // fechas actual del sistema
	$('#sucursalID').val(parametroBean.numeroUsuario); // usuario de sesion

	var catTipoTransaccion = {  
			'procesar':'1'
	};

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	agregaFormatoControles('formaGenerica');

	//------------ Metodos y Manejo de Eventos ----------
	//inicializaLimpia($('#formaGenerica'));
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false','fechaRegistro');
			$('#ruta').val('');
			$('#fechaRegistro').val(parametroBean.fechaSucursal); // fechas actual del sistema
			$('#sucursalID').val(parametroBean.numeroUsuario); // usuario de sesion
		}
	});

	$('#procesar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.procesar);
		//deshabilitaBoton('cancelar', 'submit');
	});


	$('#adjuntar').click(function() {
		var tipocheck = 0;
		$('#regCorrectos').val("");
		$('#regIncorrectos').val("");
		$('#ruta').val("");
		$('#bitCargaID').val("");
		$('#gridBitacoraCargaLote').html("");
		if($('#importar').attr('checked')== false && $('#generar').attr('checked')==false){
			alert(" Seleccionar alguna opción para lote de tarjetas");
			$('#importar').focus();
		}else{
			if($('#importar').attr('checked')== true){
				tipocheck= 2;
				subirArchivos(tipocheck);	
			}
			else{
				tipocheck= 3;
				subirArchivos(tipocheck);
			}
		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			ruta : {
				required : true
			}
		},	
		messages: {
			ruta: {
					required: "Adjunte un Archivo"
			}
		}
	});


	function subirArchivos() {
		var url ="cargaConciliaPOSSubirArch.htm"+
		"?fechaRegistro="+$('#fechaRegistro').val();
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

		ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
				"left="+leftPosition+
				",top="+topPosition+
				",screenX="+leftPosition+
				",screenY="+topPosition);	
		//$.blockUI({message: "Favor de terminar el proceso"});
		
	}

	function consultaGridBitacoraLote(){
		if($('#loteDebitoID').val()!= ""){

			var params = {};
			var lote=$('#loteDebitoID').val();
			$('#bitCargaID').val(lote);
			params['tipoLista'] = catTipoConsulBitacora.conBitacoraFallidos;
			params['bitCargaID'] =$('#bitCargaID').val();

			$.post("bitacoraCargaLoteGridVista.htm", params, function(data){		
				if(data.length >0) {
					$('#gridBitacoraCargaLote').html(data);
					$('#gridBitacoraCargaLote').show();
					
				}else{
					$('#gridBitacoraCargaLote').html("");
					$('#gridBitacoraCargaLote').show(); 
				}
			});
		}	
	}


	function inicializaLimpia(limforma) {
		$(':input', limforma).each(function() {
		var type = this.type;
		if (type == 'checkbox' || type == 'radio')
			this.checked = false;
		else if (type == 'select')
			this.selectedIndex = -1;
		});
	}
});	