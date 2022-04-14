$(document).ready(function() {
	var catTipoListaSucursal = {
			'combo': 2
	};
	
	var tipoReporte = {
			'excel': 1,
			'pdf': 2
	}
	
	var parametros = consultaParametrosSession();
	var usuario = parametros.claveUsuario; // parametros del sesion para el reporte
	var institucion = parametros.nombreInstitucion;
	var fechaSucursal = parametroBean.fechaSucursal;
	
	agregaFormatoControles('formaGenerica');
	cargarSucursales();
	
	$('select').first().focus(); //Focus en el combo de sucursales
	
	$('#generar').click(function(){		
		generarReporte(); 
	});
	
	function cargarSucursales(){
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0': 'TODAS'});
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}
	
	function obtenerSucursalSeleccionada(){
		return $("#sucursalID option:selected").val();
	}
	
	function obtenerEstatusCteSeleccionado(){
		return $("#estatus option:selected").val();
	}
	
	function obtenerTextoSucursalSeleccionada(){
		return $("#sucursalID option:selected").text();
	}
	
	function obtenerTextoEstatusCteSeleccionado(){
		return $("#estatus option:selected").text();
	}
	
	function generarReporte(){
		var sucursal = obtenerSucursalSeleccionada();
		var estatusCte = obtenerEstatusCteSeleccionado();
		var nombreSucursal = obtenerTextoSucursalSeleccionada();
		var textoEstatusCte = obtenerTextoEstatusCteSeleccionado();
		var horaEmision = hora();
		
		var pagina ='repGeneralClientes.htm?sucursalID=' + sucursal + '&nombSucursal=' +
		nombreSucursal + '&estatus=' + estatusCte + '&textoEstatus=' + textoEstatusCte
		+'&tipoReporte=' + tipoReporte.excel +'&institucion=' + institucion
		+'&usuario=' + usuario + '&fechaEmision=' + fechaSucursal + '&horaEmision=' + horaEmision;
		$('#ligaGenerar').attr('href', pagina);
	}
	
	// funcion para obtener la hora del sistema
	function hora(){
		var digital = new Date();
		var hours = digital.getHours();
		var minutes = digital.getMinutes();
		
		if (minutes <= 9){
			minutes="0" + minutes;
		}
		return  hours + ":" + minutes;
	 }	
});