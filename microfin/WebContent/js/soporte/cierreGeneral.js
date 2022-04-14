$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
  		 
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
  
  
	$(':text').focus(function() {	
	 	esTab = false;
	});

  
	//------------ Validaciones de la Forma -------------------------------------
 
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
 
	var parametroBean = consultaParametrosSession();
	$('#fechaBloqueo').val(parametroBean.fechaSucursal);

	//Graba la Transaccion: Realiza el Cierre
	$.validator.setDefaults({
	      submitHandler: function(event) { 	
	    	  if(confirmar() == true){
	    		  grabaFormaTransaccionCierre(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','procesar');
	    	  }	      	
	      }
	});
	
	consultaCierre();
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fechaBloqueo: 'required'
		},
		
		messages: {
			fechaBloqueo: 'Especifique la Fecha de Cierre'
		}		
	});	
	
	function grabaFormaTransaccionCierre(event, idForma, idDivContenedor, idDivMensaje,
			inicializaforma, idCampoOrigen) {
		consultaSesion();
		var jqForma = eval("'#" + idForma + "'");
		var jqContenedor = eval("'#" + idDivContenedor + "'");
		var jqMensaje = eval("'#" + idDivMensaje + "'");
		var url = $(jqForma).attr('action');
		var resultadoTransaccion = 0;	

		quitaFormatoControles(idForma);
		//No descomentar la siguiente linea
		//event.preventDefault();
		$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');   
		$(jqContenedor).block({
			message: $(jqMensaje),
			css: {border:		'none',
					background:	'none'}
			});
		// Envio de la forma
		$.post( url, serializaForma(idForma), function( data ) {
			if(data.length >0) {
				$(jqMensaje).html(data);
				var exitoTransaccion = $('#numeroMensaje').val();
				resultadoTransaccion = exitoTransaccion; 
				
				if (exitoTransaccion == 0 && inicializaforma == 'true' ){
					inicializaForma(idForma, idCampoOrigen);
					$('#ligaCerrar').click(function () {
						cerrarSession();
					});					
				}
				var campo = eval("'#" + idCampoOrigen + "'");
				if($('#consecutivo').val() != 0){
					$(campo).val($('#consecutivo').val());
				}		
			}
		});
	return resultadoTransaccion;
	}	
	

});

// FUNCION PARA CONFIRMAR EJECUCIÓN DEL CIERRE
function confirmar(){
	var confir = true;
	var BeanCon = {
			'fechaSis':$('#fechaBloqueo').val() 
		};	
	generalServicio.consulta(1,BeanCon,{ async: false, callback: function(cierreBean){
		if(cierreBean != null){
			if(cierreBean.confirmaCierre == 'S'){
				var msj = cierreBean.msjValidacion;
				confir = confirm(msj);	//true acepta realizar cierre - false cancela realizar el cierre		
			}
		}else{
			confir = true;
		}
	}});	
	
	return confir;
}

// FUNCION PARA CONFIRMAR EJECUCION DEL CIERRE
function consultaCierre(){
	var numEmpresaID = 1;
	var tipoCon = 27;
	var ParametrosSisBean = {
		'empresaID'	:numEmpresaID
	};
	parametrosSisServicio.consulta(tipoCon,ParametrosSisBean, { async: false, callback:function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			if (parametrosSisBean.cierreAutomatico == 'M'){
				habilitaBoton('procesar','submit');
			}else{
				deshabilitaBoton('procesar','submit');
			}
		}else{
			deshabilitaBoton('procesar','submit');
		}
	}});
}