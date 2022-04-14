$(document).ready(function() {

	// Definicion de Constantes y Enums
	esTab = true;

	var catTipoRepMovimiento = { 
			'PDF' : 1
	};
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	var parametroBean = consultaParametrosSession();
	
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#resumen').attr("checked",true); 
	$('#formaRep').val('1');

	$(':text').focus(function() {
		esTab = false;
	});
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({			
	   submitHandler: function(event) { 	    	  
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','tipoOperacion');	   	 
		}
	});

	$('#fechaInicio').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		var Zfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
		
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaFin').blur(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha)){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(Xfecha);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(Xfecha);
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});

	$('#resumen').click(function() {
		if($('#resumen').is(":checked") ){
			$('#tipoOperacion').val('');
			$('#formaRep').val(1);
			agregaOpcionEstatusNivel();
		
		}
	});
	
	$('#detallado').click(function() {
		if($('#detallado').is(":checked") ){
			$('#tipoOperacion').val('');
			$('#formaRep').val(2);	
			agregaOpcionEstatusNivel();
		}
	});
	
	
	$('#tipoOperacion').change(function() {
		if ($('#tipoOperacion').val() != '') {	
		var opcion  =	$('#tipoOperacion').val();
		agregaOpcionEstatus(opcion);	
		
			} 

	});
	
	$('#generar').click(function(){		
	var tipoOper = $('#tipoOperacion').val();   
	var claseRep = $('#formaRep').val();
	var estadoRer = $('#estado').val();
	
	if(tipoOper == ''){
		mensajeSis("Especifique Tipo de Operación");
		$('#tipoOperacion').focus();  
	}else 
		if(estadoRer == ''){
			mensajeSis("Especifique Estatus");
			$('#estado').focus();
		}else
		if(claseRep == ''){
			mensajeSis("Especifique Nivel de Reporte");
			$('#resumen').val();
		  }else
			if(claseRep == '1'){
			generaReporteResumen();
		      }else
	            if(claseRep == '2'){
			generaReporteDetalle();
			
		}
	});

	//------------ Validaciones de Controles -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			fechaInicio :{
				required: true
			},
			fechaFin:{
				required: true
			},		
			tipoOperacion:{
				required: true
			},
			estado:{
				required: true
			},
			
			
		},
		
		messages: {
			fechaInicio:{
				required: 'Especifique la Fecha de Inicio.'
			},
			fechaFin:{
				required: 'Especifique la Fecha Final.'
			},
			tipoOperacion:{
				required: 'Especifique el Tipo de Operación.'
			},
			estado:{
				required: 'Especifique el Estatus.'
			}
		}
	});

	
	
	//funciones controles
	
function agregaOpcionEstatusNivel(){
	if($('#formaRep').val() == '1'){
				dwr.util.removeAllOptions('estado');
				dwr.util.addOptions('estado', {'':'SELECCIONAR' });
				dwr.util.addOptions('estado', {'1':'TODOS' });	
		}
	
	if($('#formaRep').val() == '2'){
		dwr.util.removeAllOptions('estado');
		dwr.util.addOptions('estado', {'':'SELECCIONAR' });
		dwr.util.addOptions('estado', {'1':'TODOS' });
		dwr.util.addOptions('estado', {'2':'CORRECTOS' });
		dwr.util.addOptions('estado', {'4':'PENDIENTES' });
		dwr.util.addOptions('estado', {'3':'ERRORES' });
		}
	}
	
	
	function agregaOpcionEstatus(){
		
		if($('#tipoOperacion').val() == '1' && $('#formaRep').val() == '2'){
			dwr.util.removeAllOptions('estado');
			dwr.util.addOptions('estado', {'':'SELECCIONAR' });
			dwr.util.addOptions('estado', {'1':'TODOS' });
			dwr.util.addOptions('estado', {'2':'CORRECTOS' });
			dwr.util.addOptions('estado', {'4':'PENDIENTES' });
			dwr.util.addOptions('estado', {'3':'ERRORES' });
		}
		
		if($('#tipoOperacion').val() == '2' && $('#formaRep').val() == '2'){
			dwr.util.removeAllOptions('estado');
			dwr.util.addOptions('estado', {'':'SELECCIONAR' });
			dwr.util.addOptions('estado', {'1':'TODOS' });
			dwr.util.addOptions('estado', {'2':'CORRECTOS' });
			dwr.util.addOptions('estado', {'4':'PENDIENTES' });
			
		}
		
		if($('#tipoOperacion').val() == '3' && $('#formaRep').val() == '2'){
			dwr.util.removeAllOptions('estado');
			dwr.util.addOptions('estado', {'':'SELECCIONAR' });
			dwr.util.addOptions('estado', {'1':'TODOS' });
			dwr.util.addOptions('estado', {'2':'CORRECTOS' });
			dwr.util.addOptions('estado', {'4':'PENDIENTES' });
			dwr.util.addOptions('estado', {'3':'ERRORES' });	
		}
		
	}
		
	function generaReporteResumen(){
		
		parametroBean = consultaParametrosSession();
		var tipoReporte			= 1;
		var nombreInstitucion	= parametroBean.nombreInstitucion;
		var varFechaSistema		= parametroBean.fechaSucursal;
		var sucursal			= parametroBean.sucursal;
		var usuario			    = parametroBean.claveUsuario;
		var fechaI              = $('#fechaInicio').val();
		var fechaF              = $('#fechaFin').val();
		var tipoOper            = $('#tipoOperacion').val();
		var estRep              = $('#estado').val();
		var nivel               = $('#formaRep').val();
		
		window.open('reportePagoRemesasResumen.htm?tipoReporte='+tipoReporte+
					'&nombreInstitucion='+nombreInstitucion+
					'&fechaSistema='+varFechaSistema+
					'&sucursalID='+sucursal+
					'&claveUsuario='+usuario+
					'&fechaInicio='+fechaI+
					'&fechaFin='+fechaF+
					'&tipoOperacion='+tipoOper+
					'&estado='+estRep+
					'&nivelReporte='+nivel,'_blank' );
	}
	
	function generaReporteDetalle(){
		
		parametroBean = consultaParametrosSession();
		var tipoReporte			= 2;
		var nombreInstitucion	= parametroBean.nombreInstitucion;
		var varFechaSistema		= parametroBean.fechaSucursal;
		var sucursal			= parametroBean.sucursal;
		var usuario			    = parametroBean.claveUsuario;
		var fechaI              = $('#fechaInicio').val();
		var fechaF              = $('#fechaFin').val();
		var tipoOper            = $('#tipoOperacion').val();
		var estRep              = $('#estado').val();
		var nivel               = $('#formaRep').val();
		
		window.open('reportePagoRemesasDetallado.htm?tipoReporte='+tipoReporte+
					'&nombreInstitucion='+nombreInstitucion+
					'&fechaSistema='+varFechaSistema+
					'&sucursalID='+sucursal+
					'&claveUsuario='+usuario+
					'&fechaInicio='+fechaI+
					'&fechaFin='+fechaF+
					'&tipoOperacion='+tipoOper+
					'&estado='+estRep+
					'&nivelReporte='+nivel,'_blank' );
	}
		
	
//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

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
				mensajeSis("Formato de Fecha no Válida (aaaa-mm-dd)");
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
				mensajeSis("Fecha introducida errónea");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea");
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