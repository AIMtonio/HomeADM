//DECLARACION DE VARIABLES GLOBALES
var parametroBean = "";
var fechaSis = "";
var anio = "";
var mes = "";
var anioAnterior = "";



$("#anio").change(function(){
	$("#anio").val();
});

$("#mes").change(function(){
	if(mes<$("#mes").val()){
		mensajeSis("El mes no puede ser mayor a del sistema");
		deshabilitaBoton('generar','submit');
	}else{
		habilitaBoton('generar','submit');
	}
});

$("#generar").click(function(){
	generaReporteExcel();
});

$(document).ready(function() {

	parametroBean = consultaParametrosSession();
	fechaSis = parametroBean.fechaSucursal;
	anio = fechaSis.substring(0,4);
	mes = fechaSis.substring(5,7);
	$('#mes').val(mes);
	for (var i = 1; i >=1; i--) {
		anioAnterior = anio-i;
		$("#anio").prepend("<option value='"+anioAnterior+"' >"+anioAnterior+"</option> ");
		if(i ==1){
			$("#anio").prepend("<option value='"+anio+"' >"+anio+"</option> ");
			$("#anio").val(1);
			$("#anio").select();
			$("#anio").focus();
		}
	}



	$.validator.setDefaults({
	    submitHandler: function(event) {
	    	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoGeneracion', 'funcionExito','funcionError');

	  }
	});


	$('#formaGenerica').validate({

		rules: {

		},
		messages: {

		}
	});

});


// ------------ Validaciones de la Forma
function funcionExito(){
}

function funcionError(){
}


function generaReporteExcel() {
	var tl = 1;
	var tr = 1;
	var fechaEmision 		= parametroBean.fechaSucursal;
	var usuario 			= parametroBean.claveUsuario;
	var nombreCte 			= parametroBean.nombreUsuario;
	var nombreSucursal 		= parametroBean.nombreSucursal;
	var nombreInstitucion 	= parametroBean.nombreInstitucion;
	var nombreUsuario 		= parametroBean.nombreUsuario;
	var sucursal 			= parametroBean.nombreSucursal;
	var institucionID		= parametroBean.clienteInstitucion;
	var anioTimbrado		= $("#anio").val();
	var mes 				= $("#mes").val();

	url = 'repOperVulnerables.htm?tipoReporte='+tr+
									'&parFechaEmision='+fechaEmision+
									'&fechaActual='+fechaEmision+
									'&nomCliente='+nombreCte+
									'&sucursal='+sucursal+
									'&usuario='+usuario+
									'&tipoReporte='+tr+
									'&tipoLista='+tl+
									'&nombreSucursal='+nombreSucursal+
									'&nombreUsuario='+nombreUsuario+
									'&anio='+anioTimbrado+
									'&mes='+mes+
									'&clienteInstitucion='+institucionID+
									'&nombreInstitucion='+nombreInstitucion;
	window.open(url);
}
