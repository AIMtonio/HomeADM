$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	
	var parametroBean = consultaParametrosSession(); 
	var catTipoLisFondeo  = {
			'FondeoExcel'	: 1
	};	
	var catTipoRepFondeo = { 
			'PDF'		: 1,
			'Excel'		: 2
	}
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');  
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	
	$('#pdf').attr("checked",true) ; 

	$('#generar').click(function() { 

		if($('#pdf').is(":checked") ){
			generaPDF();
		}

		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});
	//------------ Validaciones de la Forma -------------------------------------s
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#excel').click(function() {
		if($('#excel').is(':checked')){	
			$('#tdPresenacion').hide('slow');
		}
	});

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresenacion').show('slow');
		}
	});

	
  	$.validator.setDefaults({
        submitHandler: function(event) { 
               grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','generar');
               $('#fechaInicio').val(parametroBean.fechaSucursal);
        }
  	});
	
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	
  	function generaPDF() {	
		if($('#pdf').is(':checked')){
			
				$('#excel').attr("checked",false); 
				var tr= catTipoRepFondeo.PDF; 
			 
	

			var fechaEmision = parametroBean.fechaSucursal;
			var usuario = 	parametroBean.claveUsuario;
			/// Valores Texto
			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nombreUsuario = parametroBean.claveUsuario;
			$('#ligaGenerar').attr('href','fondSucursales.htm?parFechaEmision='+fechaEmision
					+'&tipoReporte='+tr+'&usuario='+usuario+'&nombreUsuario='+nombreUsuario
					+'&nombreInstitucion='+nombreInstitucion);
		}
	}
  	
function generaExcel() {
	
	
	
	
		
		$('#pdf').attr("checked",false) ;
		if($('#excel').is(':checked')){	
			var tr= catTipoRepFondeo.Excel; 
			var tl= catTipoLisFondeo.FondeoExcel;  

		        var fechaEmision = parametroBean.fechaSucursal;
			var usuario = 	parametroBean.claveUsuario;
			/// Valores Texto
			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nombreUsuario = parametroBean.claveUsuario;

			$('#ligaGenerar').attr('href','fondSucursales.htm?parFechaEmision='+fechaEmision
					+'&tipoReporte='+tr+'&tipoLista='+tl+'&usuario='+usuario+'&nombreUsuario='+nombreUsuario
					+'&nombreInstitucion='+nombreInstitucion);
			
		
		
		}
	}
});

	