

$(document).ready(function() {
var parametroBean = consultaParametrosSession();  

$('#clienteInicio').val('0');
$('#clienteInicioDes').val('TODOS');
$('#clienteFin').val('0');
$('#clienteFinDes').val('TODOS');
var fechaSistema = parametroBean.fechaSucursal;	
	/* == Métodos y manejo de eventos ====  */
	agregaFormatoControles('formaGenerica');
	
	$('#clienteInicio').bind('keyup',function(e) {
		lista('clienteInicio', '2', '9','nombreCompleto', $('#clienteInicio').val(), 'listaCliente.htm');
	});
	$('#clienteFin').bind('keyup',function(e) {
		lista('clienteFin', '2', '9','nombreCompleto', $('#clienteFin').val(), 'listaCliente.htm');
	});

	$('#clienteInicio').blur(function() {
		consultaCliente(this.id);
	});
	$('#clienteFin').blur(function() {
		consultaCliente(this.id);
	});
	
	$('#generar').click(function() { 
		generaReporte();
	});
	
	$('#fechaInicial').change(function () {		
		if($('#fechaInicial').val() > fechaSistema ){						
			alert('La Fecha no Puede ser Mayor a la del Sistema');
			$('#fechaInicial').val('');						
		}
		if($('#fechaInicial').val() > $('#fechaFinal').val() && $('#fechaFinal').val() != ''){
			alert('La Fecha de Inicio no Pueder Mayor a la de Fin');
			$('#fechaInicial').val('');	
			}		
	});   
	$('#fechaFinal').change(function () {		
		if($('#fechaFinal').val() > fechaSistema ){						
			alert('La Fecha no Puede ser Mayor a la del Sistema');
			$('#fechaFinal').val('');						
		}
		if($('#fechaFinal').val() < $('#fechaInicial').val() && $('#fechaFinal').val() != ''){
			alert('La Fecha de Inicio no Pueder Mayor a la de Fin');
			$('#fechaFinal').val('');	
			}	
	});  
	
//	$('#generar').click(function(){		
//		if(($('#clienteInicio').val() == 0 && $('#clienteFin').val()==0) && ($('#fechaInicial').val() == '' && $('#fechaFinal').val() == '')){
//			$('#ligaGenerar').removeAttr("href");
//			alert('Seleccione un Filtro.');			
//			$('#clienteInicio').focus();
//		}
//		
//	});

	
	/* ====================== FUNCIONES ============================ */

	function generaReporte() {
			var clienteInicio = $("#clienteInicio").val();	
			var clienteFin = $("#clienteFin").val();	
			var fechaInicio = $('#fechaInicial').val();
			var fechaFin = $('#fechaFinal').val();
			var tipoReporte = 1; // PDF
			var fechaSis = parametroBean.fechaSucursal;
			var nombreUsuario = parametroBean.claveUsuario; 
			var nombreInstitucion = parametroBean.nombreInstitucion;
			
			if(fechaInicio == ''){
				fechaInicio = '0000-00-00';
			}
			if(fechaFin == ''){
				fechaFin = '0000-00-00';
			}
			

			$('#ligaGenerar').attr('href','reporteHiscambiosucurcli.htm?clienteInicio='+clienteInicio + '&clienteFin=' + clienteFin +'&fechaSistema='+fechaSis
					+'&nombreUsuario='+nombreUsuario+'&tipoReporte='+tipoReporte
					+'&nombreInstitucion='+nombreInstitucion+'&fechaInicial='+fechaInicio+'&fechaFinal='+fechaFin);
		
	}
	
	function consultaCliente (idControl){
		var jqcliente = eval("'#" + idControl + "'");
		var jqclienteDes = eval("'#" + idControl + "Des'");
		var numCliente = $(jqcliente).val();
		var conCliente = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
			clienteServicio.consulta(conCliente, numCliente, function(cliente) {
				if (cliente != null) {
					$(jqcliente).val(cliente.numero);
					$(jqclienteDes).val(cliente.nombreCompleto);
		
				} else {
					alert("No Existe el Socio");
					$(jqcliente).val('0');
					$(jqclienteDes).val('TODOS');
				}
			});
		}
		else {
			$(jqcliente).val('0');
			$(jqclienteDes).val('TODOS');
		}
	}
	
	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha,fechaIni){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicial').val(parametros.fechaAplicacion); 	
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaInicial').focus();

				}else{
					alert("Formato de Fecha Final Incorrecto");
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaFinal').focus();
				}
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
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicial').val(parametros.fechaAplicacion); 	
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaInicial').focus();

				}else{
					alert("Formato de Fecha Final Incorrecto");
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaFinal').focus();
				}

			return false;
			}
			if (dia>numDias || dia==0){
				if(fechaIni ==1){				
					alert("Formato de Fecha Inicial Incorrecto");
					$('#fechaInicial').val(parametros.fechaAplicacion); 	
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaInicial').focus();

				}else{
					alert("Formato de Fecha Final Incorrecto");
					$('#fechaFinal').val(parametros.fechaAplicacion);
					$('#fechaFinal').focus();
				}
				return false;
			}
			return true;
		}
	}

	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}	

	
});