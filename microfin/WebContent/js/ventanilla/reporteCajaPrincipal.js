	var tr= ''; 
	var diaAnterior ;
$(document).ready(function() {
	parametros = consultaParametrosSession();	
	
	var catTipoReCajaPrincipal = { 
			'PDF'		: 1,
			'Excel'		: 2 
	};	
	
	var parametroBean = consultaParametrosSession();  
	agregaFormatoControles('formaGenerica');
	consultaMoneda(); 
	consultaComboCP();
	consultaFechaAnterior();

	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				if($('#fechaFin').val() !=''){
					alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
					$('#fechaInicio').val(diaAnterior);
					$('#fechaFin').val(diaAnterior);
				}				
			}
		}else{
			$('#fechaInicio').val(diaAnterior);
			$('#fechaFin').val(diaAnterior);
		}
	});

	
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(diaAnterior);
				$('#fechaInicio').val(diaAnterior);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					alert("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
					$('#fechaFin').val(diaAnterior);
					$('#fechaInicio').val(diaAnterior);
				}				
			}
		}else{
			$('#fechaFin').val(diaAnterior);
		}

	});
	$('#generar').click(function() { 
		if($('#pdf').is(":checked") ){
			tr= catTipoReCajaPrincipal.PDF; 
			generaPDF();
		}

		if($('#excel').is(":checked") ){
			tr= catTipoReCajaPrincipal.Excel; 
			generaPDF();
		}
	});
	
	$('#formaGenerica').validate({
		rules: {
			fechaInicio :{
				required: true,
			},
			fechaFin :{
				required: true
			}
		},
		
		messages: {
			fechaInicio :{
				required: 'Ingrese la Fecha de Inicio',
			}
			,fechaFin :{
				required: 'Ingrese la Fecha Final'
			}
		}
	});
	
	
	function consultaMoneda() {		
		var tipoCon = 3;
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'TODAS'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
			//dwr.util.addOptions( 'monedaID', {'1':'TODAS'});
			$('#monedaID').val(1).selected= true;
		});
	}
	
	//int tipoLista, CajasVentanillaBean sucursalOrigen
	function consultaComboCP() {		
		var tipoLista = 9;
		var CajasVentanillaBean = {
				'descripcionCaja' : '',
				'sucursalID' : 0,
				'tipoCaja':'',
				'cajaID' :0
		};
		
		dwr.util.removeAllOptions('cajaID');
		dwr.util.addOptions( 'cajaID', {'0':'TODAS'});
		cajasVentanillaServicio.listaCombo(tipoLista, CajasVentanillaBean, function(monedas){
			dwr.util.addOptions('cajaID', monedas, 'cajaID', 'descripcionCaja');
		});
	}
	
	
	function generaPDF() {	
//		if($('#pdf').is(':checked')){	 
//			$('#excel').attr("checked",false); 
//			
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaFin').val();	
			var moneda = $("#monedaID option:selected").val();
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
			var cajaID		= 	$("#cajaID option:selected").val();
			/// VALORES TEXTO
			var nombreMoneda = $("#monedaID option:selected").val();
			var nombreUsuario = parametroBean.nombreUsuario; 			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nombreCaja			= $("#cajaID option:selected").html();

			if(nombreMoneda=='0'){
				nombreMoneda='';
			}else{
				nombreMoneda = $("#monedaID option:selected").html();
			}
			
			if(cajaID =='0'){
				nombreCaja='';
			}else{
				nombreCaja = $("#cajaID option:selected").html();
			}

			
			window.open('reporteCajaPrincipal.htm?fechaInicio='+fechaInicio+'&fechaFin='+
					fechaFin+'&monedaID='+moneda+'&fechaEmision='+fechaEmision+
					'&claveUsuario='+usuario+'&tipoReporte='+tr+
					'&nombreMoneda='+nombreMoneda+'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+'&cajaID='+cajaID+'&nombreCaja='+nombreCaja , '_blank');		
		//}
	}


	
	function consultaFechaAnterior() {
	
		var tipConPrincipal = 9;	
		setTimeout("$('#cajaLista').hide();", 200);		
		var ParametrosBean = {
				'empresaID'	:1
		};
		
			parametrosSisServicio.consulta(tipConPrincipal,ParametrosBean,function(parametros) {
				if(parametros!=null){
					diaAnterior	= parametros.fechaSistema;
					
					$('#fechaInicio').val(parametros.fechaSistema);
					$('#fechaFin').val(parametros.fechaSistema);
					
				}   	 						
			});
		
	}
	

	function mayor(fecha, fecha2){
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
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
//	FIN VALIDACIONES DE REPORTES

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("formato de fecha no válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea");
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

	
	
}); // cerrar
	

function funcionExitoCatalogo(){
	
	
}
function funcionErrorCatalogo(){
	agregaFormatoMoneda('formaGenerica');
}