$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

	var catTipoLisVencimientos  = {
			'vencimientosExcel'	: 1
	};	

	var catTipoRepVencimientos = { 
			'Pantalla'	: 1,
			'PDF'		: 2,
			'Excel'		: 3 
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');


	$('#pdf').attr("checked",true) ; 
	$('#detallado').attr("checked",true) ; 



	$(':text').focus(function() {	
		esTab = false;
	});
	$('#institutFondID').bind('keyup',function(e){
		 if(this.value.length >= 2 && isNaN($('#institutFondID').val())){
			 lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
		 }
	});
	
	$('#institutFondID').blur(function() { 
		consultaInstitucionFondeo(this.id);
	});
	
	$('#lineaFondeoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "descripLinea";
		camposLista[1] = "institutFondID";


		parametrosLista[0] = $('#lineaFondeoID').val();
		parametrosLista[1] = $('#institutFondID').val();
		
		lista('lineaFondeoID', '2', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
	});
	
	$('#lineaFondeoID').blur(function() { 
		validaLineaFondeo(); 
	});	
	$('#excel').click(function() {
		if($('#excel').is(':checked')){	
			$('#tdPresenacion').hide('slow');
		}
	});

	$('#pdf').click(function() {
		if($('#pdf').is(':checked')){	
			$('#tdPresenacion').show('slow');
		}
	});


	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaVencimien').val();
			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaVencimien').change(function() {
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= $('#fechaVencimien').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaVencimien').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La Fecha de Inicio es mayor a la Fecha de Fin.")	;
				$('#fechaVencimien').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaVencimien').val(parametroBean.fechaSucursal);
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

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaVencimien').val(parametroBean.fechaSucursal);


	function consultaInstitucionFondeo(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);
		var numInstituto = $('#institutFondID').val();	
		if(numInstituto == ''|| numInstituto == 0){
			$('#institutFondID').val(0);
			$('#nombreInstitFondeo').val('TODOS');
		}else
			
		if (numInstituto != '' && !isNaN(numInstituto)) {
			var instFondeoBeanCon = { 
	  				'institutFondID':$('#institutFondID').val()  				
					};
			fondeoServicio.consulta(2,instFondeoBeanCon,function(instituto) {
					if (instituto != null) {
						$('#nombreInstitFondeo').val(instituto.nombreInstitFon);
					} else {
						alert("No Existe la Institucion de Fondeo");
						$('#institutFondID').val(0);
						$('#nombreInstitFondeo').val('TODOS');
					}
				});
		}
	}
	
	function validaLineaFondeo() {
		var numLinea = $('#lineaFondeoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		esTab=true;
		if(numLinea == ''|| numLinea == 0){
			$('#lineaFondeoID').val(0);
			$('#descripLinea').val('TODOS');
		}else
		if (numLinea != '' && !isNaN(numLinea)) {
			
			lineaFonServicio.consulta(2,numLinea,function(lineaFond) {
					if (lineaFond != null) {
						$('#descripLinea').val(lineaFond.descripLinea);
					} else {
						alert("No Existe la Linea de Fondeo");
						$('#lineaFondeoID').val(0);
						$('#descripLinea').val('TODOS');
					}
				});
		}
	}
	
	function consultaMoneda() {		
		var tipoCon = 3;
		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions( 'monedaID', {'0':'Todas'});
		monedasServicio.listaCombo(tipoCon, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	function generaExcel() {
		$('#pdf').attr("checked",false) ;
		$('#pantalla').attr("checked",false); 
		if($('#excel').is(':checked')){	
			var tr= catTipoRepVencimientos.Excel; 
			var tl= catTipoLisVencimientos.vencimientosExcel;  
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaVencimien').val();	
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;			
			var calculoInteres=$("#calculoInt option:selected").val();

			/// VALORES TEXTO
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
            var nombreInstFon = $("#nombreInstitFondeo").val();
			

			$('#ligaGenerar').attr('href','repVencimientosPasivos.htm?fechaInicio='+fechaInicio+'&fechaVencimien='+
					fechaFin+'&parFechaEmision='+fechaEmision+
					'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+'&nombreInstitFon='+nombreInstFon+'&calculoInteres='+calculoInteres);
			
		}
	}

	function generaPDF() {	
		if($('#pdf').is(':checked')){	
			$('#pantalla').attr("checked",false) ; 
			$('#excel').attr("checked",false); 
			var tr= catTipoRepVencimientos.PDF; 
			var fechaInicio = $('#fechaInicio').val();	 
			var fechaFin = $('#fechaVencimien').val();	
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;

			/// VALORES TEXTO
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
			var nombreInstFon = $("#nombreInstitFondeo").val();
			var calculoInteres=	$("#calculoInt option:selected").val();
			var nivelDetalle=1;
			if($('#detallado').is(':checked'))	{
				nivelDetalle=1;
			}
			else 			
				if($('#sumarizado').is(':checked'))	{
					nivelDetalle=0;
				}

			$('#ligaGenerar').attr('href','repVencimientosPasivos.htm?fechaInicio='+fechaInicio+'&fechaVencimien='+
					fechaFin+
					'&usuario='+usuario+'&tipoReporte='+tr+
					'&nivelDetalle='+nivelDetalle+'&parFechaEmision='+fechaEmision+
					'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+'&nombreInstitFon='+nombreInstFon+'&calculoInteres='+calculoInteres);
			
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
	/***********************************/


});
