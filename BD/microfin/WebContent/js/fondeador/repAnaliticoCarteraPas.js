$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;

	var parametroBean = consultaParametrosSession();   

	var catTipoLisAnaCart  = {
			'analiticoCartExcel'	: 2
	};	

	var catTipoRepAnalitico = { 
			'Excel'		: 3 
	};	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');


	
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
		
	$('#excel').attr("checked",true) ;

	$('#generar').click(function() { 		

		if($('#excel').is(":checked") ){
			generaExcel();
		}

	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#fechaACP').val(parametroBean.fechaSucursal);
	
	$('#fechaACP').change(function() {
		if(esFechaValida($('#fechaACP').val())){
			
		}else{
			$('#fechaACP').val(parametroBean.fechaSucursal);
		}
	});
	
	
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
		//$('#pdf').attr("checked",false) ;
		//$('#pantalla').attr("checked",false); 
		if($('#excel').is(':checked')){	
			var tr= catTipoRepAnalitico.Excel; 
			var tl= catTipoLisAnaCart.analiticoCartExcel;  
			var fechaACP = $('#fechaACP').val();	 
			var usuario = 	parametroBean.claveUsuario;
			var fechaEmision = parametroBean.fechaSucursal;
			var institutFondID = $('#institutFondID').val();
			

			/// VALORES TEXTO
			var nombreUsuario = parametroBean.nombreUsuario; 
			var nombreInstitucion =  parametroBean.nombreInstitucion; 
            var nombreInstFon = $("#nombreInstitFondeo").val();
			          
			$('#ligaGenerar').attr('href','repAnaliticoCarteraPas.htm?fechaACP='+fechaACP+'&parFechaEmision='+fechaEmision+
					'&usuario='+usuario+'&tipoReporte='+tr+'&tipoLista='+tl+
					'&nombreUsuario='+nombreUsuario+
					'&nombreInstitucion='+nombreInstitucion+'&nombreInstitFon='+nombreInstFon+'&institutFondID='+institutFondID);
			
		}
	}

	

//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE
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
