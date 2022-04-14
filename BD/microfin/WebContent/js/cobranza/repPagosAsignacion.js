$(document).ready(function() {
	esTab = false;
	
	// Par+ametros de Sesión
	var parametroBean = consultaParametrosSession();

	// Tipo de Reporte a Generar
    var catTipoRepPagoAsignacion = { 
			'Excel'	: 1
		};	
	//------------ Metodos y Manejo de Eventos -----------------------
	agregaFormatoControles('formaGenerica');

	$('#fechaInicioAsigna').val(parametroBean.fechaSucursal);
	$('#fechaFinAsigna').val(parametroBean.fechaSucursal);
	$('#fechaInicioAsigna').focus();

	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	
	$('#fechaInicioAsigna').change(function() {
		var Xfecha= $('#fechaInicioAsigna').val();
		$('#fechaInicioAsigna').focus();
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicioAsigna').val(parametroBean.fechaSucursal);
			var Yfecha= $('#fechaFinAsigna').val();
			if (mayor(Xfecha, Yfecha))
			{
				alert("La Fecha Inicio Asignación no debe ser mayor a la Fecha Fin Asignación.");
				$('#fechaInicioAsigna').val(parametroBean.fechaSucursal);
				$('#fechaInicioAsigna').focus();
			}
		}else{
			$('#fechaInicioAsigna').val(parametroBean.fechaSucursal);
			$('#fechaInicioAsigna').focus();
		}
	});

	$('#fechaFinAsigna').change(function() {
		var Xfecha= $('#fechaInicioAsigna').val();
		var Yfecha= $('#fechaFinAsigna').val();
		$('#fechaFinAsigna').focus();
		if(esFechaValida(Yfecha)){
			if(Yfecha=='')$('#fechaFinAsigna').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha))
			{
				alert("La Fecha Fin Asignación no debe ser menor a la Fecha Inicio Asignación.");
				$('#fechaFinAsigna').val(parametroBean.fechaSucursal);
				$('#fechaFinAsigna').focus();
			}
		}else{
			$('#fechaFinAsigna').val(parametroBean.fechaSucursal);
			$('#fechaFinAsigna').focus();
		}

	});

	$('#gestorID').bind('keyup', function(e){
		lista('gestorID', '2', '1', 'nombre', $('#gestorID').val(),'listaGestoresCobranza.htm');
	});


	$('#gestorID').blur(function(){
		if(esTab){
			//inicializaParametros();
			consultaGestorCobranza(this.id);	
		}
	});
	
	
	$('#generar').click(function() {		
		generaReportePagoAsignacion();
	});
   
	$('#excel').click(function() {
		$('#excel').attr('checked', true);
		$('#excel').focus();
	});

   

	
	// Validaciones
	$('#formaGenerica').validate({
		rules: {			
			fechaInicioAsigna: {
				required: true,
			},
			fechaFinAsigna:{
				required: true,
			}
		},		
		messages: {
			fechaInicioAsigna: {
				required: 'Especifique Fecha Inicio Asignación'

			},
			fechaFinAsigna:{
				required: 'Especifique Fecha Fin Asignación'
			}
		}
	});

	// Funcion para Generar el Reporte de Pagos Asignación de Cartera   
	function generaReportePagoAsignacion(){
		// Declaracion de variables
		var tipoLista	= catTipoRepPagoAsignacion.Excel; 
		var fechaInicio = $('#fechaInicioAsigna').val();	 
		var fechaFin 	= $('#fechaFinAsigna').val();
		var varGestorID	= $('#gestorID').val();

		var varNombreInstitucion = parametroBean.nombreInstitucion;
		var varClaveUsuario		= parametroBean.claveUsuario;
	    var varFechaSistema     = parametroBean.fechaAplicacion;

		// Valores de Texto
		var nombreGestor = $('#nombreGestor').val();


		var pagina ='reportePagosAsignacion.htm?fechaInicioAsigna='+fechaInicio+'&fechaFinAsigna='+fechaFin+ '&gestorID='+varGestorID
									+ '&nombreInstitucion='+varNombreInstitucion+'&claveUsuario='+varClaveUsuario.toUpperCase()		
									+ '&tipoLista='+tipoLista+'&tipoReporte=1'+'&nombreGestor='+nombreGestor+'&fechaSistema='+varFechaSistema;
		window.open(pagina);	   
	};  
	

	// Función para consultar los Gestores
	function consultaGestorCobranza(idControl) {
		var jqGestor = eval("'#" + idControl + "'");
		var numGestor = $(jqGestor).val();	
		var conGestor=1;
		var gestorBeanCon = {
  				'gestorID':numGestor 
				};	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numGestor == '' || numGestor==0){
			$(jqGestor).val(0);
			$('#nombreGestor').val('TODOS');
		}
		else
		if(numGestor != '' && !isNaN(numGestor) && $('#gestorID').val() > 0 && esTab){

			gestoresCobranzaServicio.consulta(conGestor,gestorBeanCon,function(gestor) {
				if(gestor!=null){
					$('#gestorID').val(gestor.gestorID);
					$('#nombreGestor').val(gestor.nombreCompleto);	
				}else{							
					alert("No Existe el Gestor de Cobranza");
					$('#gestorID').focus();
					$('#gestorID').val(0);
					$('#nombreGestor').val('TODOS');
				}  
			});
		}
		else{
			if(isNaN(numGestor) && esTab){
				alert("No Existe el Gestor de Cobranza");
				$('#gestorID').focus();
				$('#gestorID').val(0);
				$('#nombreGestor').val('TODOS');
			}
			}
	}

	//	Función para validar las fechas
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


	// Funcion valida fecha formato (yyyy-MM-dd) 
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de fecha no válido (aaaa-mm-dd)");
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

	// Funcion para comprobar el año bisiesto
	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
	}
	
}); // fin ready