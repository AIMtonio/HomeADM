$(document).ready(function(){

	esTab = false;
	var parametroBean = consultaParametrosSession();

	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	//Definición de constantes y Enums
	var catTipoConSms = {
			'principal'	: 1,
			'foranea'	: 2,
			'numInst'	: 3,
			'prinSalCamp':4
		};
	
	var catTipoRepSms = { 
			'Pantalla'	: 1,
			'PDF'		: 2,
	};	
	
	$('#enviado').attr("checked",true);
	$('#fechaInicio').focus();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	$('#campaniaID').val(0);
	$('#nombreCampania').val('TODAS');

	$('#generar').click(function() {
		if ($('#campaniaID').val() == ''){
			mensajeSis("Seleccione una campaña");
			$('#campaniaID').focus();
			return false;
		}else{
			if ($('#fechaInicio').val() == '' || $('#fechaFin').val() == ''){
				mensajeSis("Seleccione un rango de fechas");
				return false;
			}else{
				generaPDF();
			}
		}			
	});
	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if (Yfecha != ''){
				if ( mayor(Xfecha, Yfecha) )
				{
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					$('#fechaInicio').focus();
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		var zfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) ){
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
			if (mayor(Yfecha, zfecha)){
					mensajeSis("La Fecha es Mayor a la del Sistema");
					$('#fechaFin').val(parametroBean.fechaSucursal);
					$('#fechaFin').focus();
				}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});
	function generaPDF() {
			var tr= catTipoRepSms.PDF;
			var campaniaID = $('#campaniaID').val();
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();
			var estatus = $("input[name='estatus']:checked").val();
			var fechaEmision = parametroBean.fechaSucursal;
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var nombreUsuario = parametroBean.claveUsuario;
			
			$('#ligaGenerar').attr('href','RepActividadEnvioSMS.htm?'+
						'campaniaID='+campaniaID+
						'&fechaInicio='+fechaInicio+
						'&fechaFin='+fechaFin+
						'&estatus='+estatus+
						'&nomInstitucion='+nombreInstitucion+
						'&nomUsuario='+nombreUsuario +'&fechaEmision='+fechaEmision+
						'&tipoReporte='+tr);
	}

//-----------------------Métodovalidas y manejo de eventos-----------------------
	agregaFormatoControles('formaGenerica');
	
	// lista solo campañas Clasificacion=Salida y categoria campaña
	$('#campaniaID').bind('keyup',function(e) {
		lista('campaniaID', '2', '2', 'nombre', $('#campaniaID').val(),'campaniasLista.htm');
	});
	
	$('#campaniaID').blur(function(){
		if(esTab){
			validaCampania(this.id);
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
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
				mensajeSis("Fecha introducida errónea");
			return false;0
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

	
	
	
	
 	function validaCampania(idControl){
		var jqCampania  = eval("'#" + idControl + "'");
		var numCamp = $(jqCampania).val();	
		if(numCamp != 0){
			if(numCamp != '' && !isNaN(numCamp)){
				var campaniaBeanCon = { 
					'campaniaID' :numCamp
				};
				campaniasServicio.consulta(catTipoConSms.prinSalCamp,campaniaBeanCon,{ async: false, callback:function(campanias) {
					if(campanias!=null){
						consultaNomCampania();
						habilitaBoton('generar', 'submit');
					}else{
						mensajeSis ("La campaña no existe");	
						$('#nombreCampania').val('');
						$('#campaniaID').val('');
						$('#campaniaID').focus();	
					}
				}});
			}else{
				mensajeSis ("La campaña no existe");	
				$('#nombreCampania').val('');
				$('#campaniaID').val('');
				$('#campaniaID').focus();
			}
		}
	}

 	function consultaNomCampania(){
		var numCamp = $('#campaniaID').val();
		var campaniaBeanCon = {
				'campaniaID' : numCamp
		};
		campaniasServicio.consulta(catTipoConSms.foranea, campaniaBeanCon, function(nombre){
			if (nombre != null){
				$('#nombreCampania').val(nombre.nombre);
			}
		});
	} 	
 	function guardaFechas(){
 		var numFechas = $('input[name=envioID]').length;
 		$('#listaFechas').val("");
 		for (var i = 1; i<= numFechas; i++){
 			if (i == 1){
 				$('#listaFechas').val($('#listaFechas').val() + 
 										document.getElementById("fechaInicio"+i+"").value +']');
 			}else{
 				$('#listaFechas').val($('#listaFechas').val() + 
 										document.getElementById("fechaInicio"+i+"").value+']');
 			}
 		}
 	}
 	
 	 	
});
