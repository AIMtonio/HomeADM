var diaAnterior ;
$(document).ready(function (){

	esTab = true;
	parametros = consultaParametrosSession();
	var fechaSistema = parametroBean.fechaSucursal;
	consultaFechaAnterior();
	
	// Definicion de Constantes y Enums

	var catFormatoReporte = {
			'pdf'   :1,
					
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	$('#fechaInicial').change(function() {
		var Xfecha= $('#fechaInicial').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha==''){
				$('#fechaInicial').val(diaAnterior);
			}
			var Yfecha= $('#fechaFinal').val();
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha Inicial no debe ser mayor a la Fecha Final.")	;
				$('#fechaInicial').val(diaAnterior);
				

			}else{
				if($('#fechaInicial').val() > parametroBean.fechaSucursal) {
					alert("La Fecha Inicial no puede ser mayor a la Fecha del Sistema.");
					$('#fechaInicial').val(diaAnterior);
				
				}
			}
		}else{
			$('#fechaInicial').val(diaAnterior);
			
		}
		regresarFoco('fechaInicial');
	});

	$('#fechaFinal').change(function() {
		var Xfecha= $('#fechaInicial').val();
		var Yfecha= $('#fechaFinal').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha ==''){
				$('#fechaFinal').val(diaAnterior);
			}
			if ( mayor(Xfecha, Yfecha) ){
				alert("La Fecha Inicial no debe ser mayor a la Fecha Final.")	;
				$('#fechaFinal').val(diaAnterior);
			}else{
				if($('#fechaFinal').val() > parametroBean.fechaSucursal) {
					alert("La Fecha Final no puede ser mayor a la Fecha del Sistema.");
					$('#fechaFinal').val(diaAnterior);
				}				
			}
		}else{
			$('#fechaFinal').val(diaAnterior);
		}
		regresarFoco('fechaFinal');
	});
	
	
	
	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 

		}
	});		
	agregaFormatoControles('formaGenerica');	

	
	
	

	$(':text').focus(function() {	
		esTab = false;
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#generar').click(function(){			
		if($('#pdf').is(':checked')){		
			enviaDatosRepPDF();
		}					
	});
	
	
	
//	------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			fechaInicial :{
				required: true
			},
			fechaFinal:{
				required: true
			},
			
		},
		
		messages: {
			fechaInicial :{
				required: 'Especifique la Fecha Inicio.'
			},
			fechaFinal :{
				required: 'Especifique la Fecha Final.'
			},
			
		}
	});

	
	
	function enviaDatosRepPDF(){
		var nombreusuario 		= parametros.claveUsuario; // parametros del sesion para el reporte
		var nombreInstitucion    = parametros.nombreInstitucion;
		var fechaEmision	    = parametroBean.fechaSucursal
		var fechaInicial		= $('#fechaInicial').val();
		var fechaFinal	 		= $('#fechaFinal').val();		
		var tipoReporte			= 1;
		var tipoLista			= catFormatoReporte.pdf;

			var pagina ='repExcepcionesInversion.htm?tipoReporte='+tipoReporte+
						
						'&nombreUsuario='+nombreusuario+
						'&nombreInstitucion='+nombreInstitucion+
						'&fechaInicial='+fechaInicial+
						'&fechaFinal='+ fechaFinal+
						'&fechaEmision='+fechaEmision+
						'&tipoLista='+tipoLista;														
						window.open(pagina,'_blank');
						
									
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
					
					$('#fechaInicial').val(parametros.fechaSistema);
					$('#fechaFinal').val(parametros.fechaSistema);
					
				}   	 						
			});
		
	}

	 //funcion para validar las fechas
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

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de Fecha no Válida (aaaa-mm-dd)");
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
	
	function regresarFoco(idControl){
		
		var jqControl=eval("'#"+idControl+"'");
		setTimeout(function(){
			$(jqControl).focus().select();
		 },0);
	}
	

}); // Fin Document

