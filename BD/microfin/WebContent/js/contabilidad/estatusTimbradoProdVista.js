//DECLARACION DE VARIABLES GLOBALES
var parametroBean = "";
var fechaSis = "";
var anio = "";
var mes = "";
var anioAnterior = "";

$("#tipoGeneracion").click(function(){
	$('.mes').show();
	$('.semestre').hide();
	$('.semestre1').hide();
	$('.semestre2').hide();
	$('#mes').val(mes);
	$('.gridProd').html("");
	$('#semestre').val("");
});


$("#anio").change(function(){
	consultaGridEstatusTimbrado($("#anio").val());
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

	for (var i = 14; i >=1; i--) {
		anioAnterior = anio-i;
		$("#anio").prepend("<option value='"+anioAnterior+"' >"+anioAnterior+"</option> ");
		if(i ==1){
			$("#anio").prepend("<option value='"+anio+"' >"+anio+"</option> ");
			$("#anio").val(1);
			$("#anio").select();
			$("#anio").focus();
			consultaGridEstatusTimbrado(anio);
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

function consultaGridEstatusTimbrado(anio){	
	var params = {};
	params['tipoLista'] = 1;
	params['anio'] = anio;
	
	$.post("estatusTimbradoGrid.htm", params, function(data){
			if(data.length >1983) {		
				$('#gridProductos').html(data);
				$('#gridProductos').show();
				habilitaBoton('generar', 'submit');
			}else{
				$('#gridProductos').html("");
				$('#gridProductos').hide();
				deshabilitaBoton('generar', 'submit');
			}
	});
}


function generaReporteExcel() {
	var tl = 1;
	var tr = 1;
	var fechaEmision = parametroBean.fechaSucursal;
	var usuario =	parametroBean.claveUsuario;
	var nombreCte = parametroBean.nombreUsuario;
	var nombreSucursal = parametroBean.nombreSucursal;
	var nombreInstitucion = parametroBean.nombreInstitucion;
	var nombreUsuario = parametroBean.claveUsuario;
	var sucursal = parametroBean.nombreSucursal;
	var anioTimbrado	= $("#anio").val();

	url = 'reporteEstatusTimRep.htm?tipoReporte='+tr+
									'&parFechaEmision='+fechaEmision+
									'&nomCliente='+nombreCte+
									'&sucursal='+sucursal+
									'&usuario='+usuario+
									'&tipoReporte='+tr+
									'&tipoLista='+tl+
									'&nombreSucursal='+nombreSucursal+
									'&nombreUsuario='+nombreUsuario+
									'&anio='+anioTimbrado+
									'&nombreInstitucion='+nombreInstitucion;
	window.open(url);
}
