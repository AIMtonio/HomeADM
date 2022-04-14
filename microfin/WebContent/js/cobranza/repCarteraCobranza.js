$(document).ready(function() {
	
	var parametroBean = consultaParametrosSession();
	$('#fechaReporte').val(parametroBean.fechaSucursal);
	
	$("#excel").focus();
	
	$('#generar').click(function() {		
		generaExcel();
	});
	
	function generaExcel(){	
		
		
		var usuario = 	parametroBean.claveUsuario;
	
		/// VALORES TEXTO
	
		var nombreUsuario = parametroBean.claveUsuario; 			
		var nombreInstitucion =  parametroBean.nombreInstitucion; 
		var fechaEmision=parametroBean.fechaSucursal;
		var hora='';
		var horaEmision= new Date();
		hora = horaEmision.getHours();
		hora = hora+':'+horaEmision.getMinutes();
		hora = hora+':'+horaEmision.getSeconds();

		var paginaReporte= 'reporteCarteraCobranza.htm?fechaReporte='+fechaEmision
		+ '&nomUsuario='+ nombreUsuario
		+ '&nombreInstitucion='+ nombreInstitucion
		+ '&tipoLista=1'
		+ '&tipoReporte=3';			
		window.open(paginaReporte);
}

	
});
