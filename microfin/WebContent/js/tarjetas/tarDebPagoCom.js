$(document).ready(function() {			
	//Definicion de Constantes y Enums  		
	var tipoActualizacion = {
  		'pagoComisionAnual':2		
	};
	var tipoConTarjetaDeb = {
		'bitacoraPagoCom' : 21
	};
	var catListaTipoTar ={
		'tipoTarjetaCobro'	: 6	
	};
	/*------------ Metodos y Manejo de Eventos -----------------------*/  
   $('#imprimir').hide();  
   agregaFormatoControles('formaGenerica');
	
   $.validator.setDefaults({
	   submitHandler: function(event) { 
		   grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoTarjetaDebID',
				   'funcionExitoTransaccion','funcionFalloTransaccion'); 
	   }
   });
	
   $('#procesar').click(function() {		
	   $('#tipoActualizacion').val(tipoActualizacion.pagoComisionAnual);	
   });

   $('#imprimir').click(function() { 
	   generaReporteManual();
   });
   
   $('#tipoTarjetaDebID').change(function() {
	   validaReporte(this.value);
   });
	
    // conseguimos la fecha del sistema
    var parametroBean = consultaParametrosSession();
    $('#fechaSistema').val(parametroBean.fechaSucursal);
    $('#nombreUsuario').val(parametroBean.numeroUsuario);
        
	/*------------ Validaciones de la Forma -----------------------*/
	$('#formaGenerica').validate({
		rules: {
			tipoTarjetaDebID: 'required'
		},

		messages: {
			tipoTarjetaDebID: 'Especificar el Tipo de Tarjeta'
		}
	});
	
	/* ===============   FUNCIONES  ======================== */
	// funcion para llenar el combo de Tipos de Tarjeta
	llenaComboTiposTarjetasDeb();
	
	function validaReporte(valor){
		if (valor != '' && !isNaN(valor)) {
			var tarjetaBean ={
				'tipoTarjetaDebID' : valor
			};
			tarjetaDebitoServicio.consulta(tipoConTarjetaDeb.bitacoraPagoCom, tarjetaBean,function(bitacoraPagoCom) {
				if (bitacoraPagoCom != null) {
					$('#imprimir').show();
					deshabilitaBoton('procesar', 'submit');
				}else {
					$('#imprimir').hide();
					habilitaBoton('procesar', 'submit');
				}
			});
		}
	}
	
	function llenaComboTiposTarjetasDeb() {
		var tarDebBean = {
				'tipoTarjetaDebID' : ''
		};
		dwr.util.removeAllOptions('tipoTarjetaDebID'); 		
		dwr.util.addOptions('tipoTarjetaDebID', {"":'SELECCIONA'});
		tipoTarjetaDebServicio.listaCombo(catListaTipoTar.tipoTarjetaCobro, tarDebBean, function(tiposTarjetas){
			dwr.util.addOptions('tipoTarjetaDebID', tiposTarjetas, 'tipoTarjetaDebID', 'descripcion');
		});
	}
		
	/* ====================== FUNCIONES ============================ */
	function generaReporteManual() {
		var tipoTarjeta = $("#tipoTarjetaDebID").val();	
		var tipoReporte = 1;
		var nombreInstitucion = parametroBean.nombreInstitucion; 
		var fechaSis = parametroBean.fechaSucursal;
		var nombreUsuario = parametroBean.claveUsuario; 
		var tipo = $("#tipoTarjetaDebID option:selected").html();		
		$('#ligaGenerar').attr('href','reporteTarDebPagoCom.htm?tipoTarjetaDebID='+tipoTarjeta +'&fechaSistema='+fechaSis+'&tipo='+tipo
				+'&tipoReporte='+tipoReporte+'&nombreInstitucion='+nombreInstitucion+'&nombreUsuario='+nombreUsuario);		
	}
});//fin

function funcionExitoTransaccion (){	
	$('#imprimir').show();
	deshabilitaBoton('procesar','submit');
}

function funcionFalloTransaccion (){
	// console.warn('operacion fallida');
}