$(document).ready(function() {
	
	var parametroBean = consultaParametrosSession();	
	// Definicion de Constantes y Enums
	esTab = true;
	
	var catTipoRepOpVentanilla = { 
			
			'PDF'		: 2,
			'Excel'		: 3 
	};
		
	
//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	agregaFormatoControles('formaGenerica');
	$('#pdf').attr("checked",true) ; 
	
	$(':text').focus(function() {	
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	//poner valores pordefault
	$('#estadoMarginadasID').val(0);
	$('#nombreEstadoMarginadas').val('TODOS');
	$('#municipioMarginadasID').val(0);
	$('#nombreMunicipioMarginadas').val('TODOS');
	$('#localidadMarginadasID').val(0);
	$('#nombreLocalidadMarginadas').val('TODAS');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	
	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFin').val();
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					alert("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					alert("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}				
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});


	$('#estadoMarginadasID').change(function(){
		if(this.value == 0){
			$('#estadoMarginadasID').val(0);
			$('#nombreEstadoMarginadas').val('TODOS');
		}
	});
	$('#generar').click(function() { 
		if($('#pdf').is(":checked") ){
			generaPDF();
		}
		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});


	$('#estadoMarginadasID').bind('keyup',function(e){
		lista('estadoMarginadasID', '2', '1', 'nombre', $('#estadoMarginadasID').val(), 'listaEstados.htm');
	});
	

	$('#estadoMarginadasID').blur(function() {
  		consultaEstado(this.id);
  		$('#estadoID').val(	$('#estadoMarginadasID').val());
	});
	

	$('#municipioMarginadasID').bind('keyup',function(e){
		
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		
		camposLista[0] = "estadoID"; //valor que trae de la anterior
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioMarginadasID').val();
		
		lista('municipioMarginadasID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});
	
	$('#localidadMarginadasID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#localidadMarginadasID').val();
		
		lista('localidadMarginadasID', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
	});
	
	$('#municipioMarginadasID').blur(function() {
  		consultaMunicipio(this.id);
  		$('#municipioID').val(	$('#municipioMarginadasID').val());
	});
	
	$('#localidadMarginadasID').blur(function() {
		consultaLocalidad(this.id);
	});

	//-------  funciones------///	
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && numEstado >0){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if(estado!=null){							
					$('#nombreEstadoMarginadas').val(estado.nombre);
				}else{
					alert("No Existe el Estado");					
					$('#estadoMarginadasID').val("0");
					$('#estadoMarginadasID').focus();
					$('#nombreEstadoMarginadas').val("TODOS");
				}    	 						
			});
		}else{
			$('#estadoMarginadasID').val("0");
			$('#nombreEstadoMarginadas').val("TODOS");

		}
	}
	
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio) && numMunicipio >0 ){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
				if(municipio!=null){							
					$('#nombreMunicipioMarginadas').val(municipio.nombre);
				}else{
					alert("No Existe el Municipio");
					$('#municipioMarginadasID').val("0");
					$('#municipioMarginadasID').focus();
					$('#nombreMunicipioMarginadas').val("TODOS");
				}    	 						
			});
		}else{
			$('#municipioMarginadasID').val("0");
			$('#nombreMunicipioMarginadas').val("TODOS");
		}
	}	
	
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numLocalidad != '' && !isNaN(numLocalidad) && numLocalidad >0 ){
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
				if(localidad!=null){							
					$('#nombreLocalidadMarginadas').val(localidad.nombreLocalidad);
				}else{
					alert("No Existe la Localidad");
					$('#localidadMarginadasID').val("0");
					$('#localidadMarginadasID').focus();					
					$('#nombreLocalidadMarginadas').val('TODAS');
				}    	 						
			});
		}else{
			$('#localidadMarginadasID').val("0");
			$('#nombreLocalidadMarginadas').val("TODAS");
		}
	}

	
	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			$('#excel').attr("checked",false); 
			var tipoReporte= 2; 
			var numRep = 1;
			var estadoMarginadasID = $('#estadoMarginadasID').val();
			var nombreEstadoMarginadas = $('#nombreEstadoMarginadas').val();
			var municipioMarginadasID = $('#municipioMarginadasID').val();
			var nombreMunicipioMarginadas = $('#nombreMunicipioMarginadas').val();
			var localidadMarginadasID = $('#localidadMarginadasID').val();
			var nombreLocalidadMarginadas = $('#nombreLocalidadMarginadas').val();
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaFin').val();
		
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;			
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			
			$('#ligaGenerar').attr('href','generaRepClienteLocMarginadas.htm?estadoMarginadasID='+estadoMarginadasID+
					'&nombreEstadoMarginadas='+nombreEstadoMarginadas+'&municipioMarginadasID='+municipioMarginadasID+
					'&nombreMunicipioMarginadas='+nombreMunicipioMarginadas+'&localidadMarginadasID='+localidadMarginadasID+
					'&nombreLocalidadMarginadas='+nombreLocalidadMarginadas+'&nombreUsuario='+usuario+'&tipoReporte='+tipoReporte+
					'&fechaEmision='+fechaEmision+'&nombreInstitucion='+nombreInstitucion+'&numRep='+numRep+'&fechaInicio='+
					fechaInicio+'&fechaFin='+fechaFin);
		}
	}
	
	// cachando los valores que necesito para el reporte de excel
	function generaExcel() {
		
		if($('#excel').is(':checked')){	
			$('#pdf').attr("checked",false) ;
			var tipoReporte= 3;
			var tipoLista = 1;
			var estadoMarginadasID = $('#estadoMarginadasID').val();
			var nombreEstadoMarginadas = $('#nombreEstadoMarginadas').val();
			var municipioMarginadasID = $('#municipioMarginadasID').val();
			var nombreMunicipioMarginadas = $('#nombreMunicipioMarginadas').val();
			var localidadMarginadasID = $('#localidadMarginadasID').val();
			var nombreLocalidadMarginadas = $('#nombreLocalidadMarginadas').val();
			var fechaInicio = $('#fechaInicio').val();
			var fechaFin = $('#fechaFin').val();
			
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;			
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
							
			$('#ligaGenerar').attr('href','generaRepClienteLocMarginadas.htm?estadoMarginadasID='+estadoMarginadasID+
					'&nombreEstadoMarginadas='+nombreEstadoMarginadas+'&municipioMarginadasID='+municipioMarginadasID+
					'&nombreMunicipioMarginadas='+nombreMunicipioMarginadas+'&localidadMarginadasID='+localidadMarginadasID+
					'&nombreLocalidadMarginadas='+nombreLocalidadMarginadas+'&nombreUsuario='+usuario+'&tipoReporte='+tipoReporte+
					'&fechaEmision='+fechaEmision+'&nombreInstitucion='+nombreInstitucion+'&fechaInicio='+
					fechaInicio+'&fechaFin='+fechaFin+'&tipoLista='+tipoLista);
		}
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
				if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
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


	
});
	