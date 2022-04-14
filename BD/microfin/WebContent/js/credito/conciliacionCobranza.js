$(document).ready(function() {
	
	var parametroBean = consultaParametrosSession();   
	$('#fecha').focus();
	
	var tipoTransaccion = 0;
	
	agregaFormatoControles('formaGenerica');
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			if(tipoTransaccion == 2){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','fecha','funcionExito','funcionError');
			}
		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			fecha: 'required'
		},

		messages: {
			fecha: 'La fecha es requerida.'
		}
	});
	
	$('#exportar').click(function() {
		tipoTransaccion = 1;
		generaExcel();
	});
	
	$('#guardar').click(function() {
		tipoTransaccion = 2;
	});
	
	$('#conciliado').change(function () {
		if($('#conciliado').attr('checked')){
			$('#conciliado').val("S");
		}else{
			$('#conciliado').val("N");
		}
	});
	
	consultaAsesores();
	
	$('#fecha').blur(function() {
		var Xfecha= $('#fecha').val();
		
		if(esFechaValida(Xfecha)){
			
		}else{
			$('#fecha').val(parametroBean.fechaSucursal);
		}
	});
	
	function mayor(fecha, fecha2){
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);

		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
						return true;
					}else{
						return false;
					}
				}else{
					return false;
				}
			}else{
				return false ;
			}
		} 
	}
	
	function esFechaValida(fecha){

		if (fecha != undefined && fecha!= "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
				return false;
			}

			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;

			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
				break;
			default:
				mensajeSis("Fecha introducida errónea  ");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea  ");
				return false;
			}
			return true;
		}
	}
	
	function consultaAsesores() {		
		var tipoCon = 19;
		dwr.util.removeAllOptions('asesor');
		dwr.util.addOptions( 'asesor', {'0':'TODOS'});
		usuarioServicio.listaCombo(tipoCon, function(asesores){
			dwr.util.addOptions('asesor', asesores, 'usuarioID', 'nombreCompleto');
		});
	}
	
	
});


function buscarPagos(){
	$('#gridConcialiadoPagos').html("");
    $('#gridConcialiadoPagos').show();
    
    var datos = {
    		"fecha" : $("#fecha").val(),
    		"asesor" : $("#asesor").val(),
    		"conciliado" : $("#conciliado").val()
    };
    
	$.post("conciliadoCobranzaGridCredito.htm", datos, function(data){		
	    if(data.length > 0) {
	        $('#gridConcialiadoPagos').html(data);
	        $('#gridConcialiadoPagos').show();
	    }else{
	        $('#gridConcialiadoPagos').html("");
	        $('#gridConcialiadoPagos').show();
	    }
	});
}

function generaExcel(){
	
	var fecha = $('#fecha').val();	 
	var asesor = $('#asesor').val();	
	var conciliado = $("#conciliado").val();
	var nombreAsesor = $("#asesor option:selected" ).text();

	$('#ligaGenerar').attr('href','reporteConciliadoPago.htm?'+
			
		'&fecha='+fecha+
		'&asesor='+asesor+
		'&conciliado='+conciliado+
		'&nombreAsesor='+nombreAsesor

	);
}



function funcionExito(){
}

function funcionError(){
}


