$(document).ready(function (){

	esTab = true;
	parametros = consultaParametrosSession();
	$('#nombreUsuario').val(parametros.claveUsuario); // parametros del sesion para el reporte
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#fechaEmision').val(parametroBean.fechaSucursal);
	var fechaSistema = parametroBean.fechaSucursal;
		
	// Definicion de Constantes y Enums

	var catFormatoReporte = {
			'pdf'   :1,
			'excel' :2
			
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) { 

		}
	});		
	agregaFormatoControles('formaGenerica');	

	$('#fechaInicial').change(function () {		
		if($('#fechaInicial').val() > fechaSistema ){						
			alert('La Fecha no Puede ser Mayor a la del Sistema');
			$('#fechaInicial').val(fechaSistema);						
		}
		if($('#fechaInicial').val() > $('#fechaFinal').val()){
			alert('La Fecha de Inicio no Pueder Mayor a la de Fin');
			$('#fechaInicial').val(fechaSistema);	
			}		
		
	});   
	$('#fechaFinal').change(function () {		
		if($('#fechaFinal').val() > fechaSistema ){						
			alert('La Fecha no Puede ser Mayor a la del Sistema');
			$('#fechaFinal').val(fechaSistema);						
		}
		if($('#fechaFinal').val() < $('#fechaInicial').val()){
			alert('La Fecha de Inicio no Pueder Mayor a la de Fin');
			$('#fechaFinal').val(fechaSistema);	
			}
	
	});  
	
	
	$('#fechaInicial').val(parametros.fechaAplicacion); 	
	$('#fechaFinal').val(parametros.fechaAplicacion);
	

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
			}else if($('#excel').is(':checked')){				
				enviaDatosRepExcel();
			}					
	});
	$('#fechaInicial').change(function() {
		var fechaIni=1;
		
		var Xfecha= $('#fechaInicial').val();
		if(esFechaValida(Xfecha, fechaIni)){
			if(Xfecha=='')$('#fechaInicial').val(parametroBean.fechaSucursal);
			
		}else{
			$('#fechaInicial').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFinal').change(function() {
		var fechaIni=2;
		
		var Yfecha= $('#fechaFinal').val();
		if(esFechaValida(Yfecha, fechaIni)){
			if(Yfecha=='')$('#fechaFinal').val(parametroBean.fechaSucursal);

		}else{
			$('#fechaFinal').val(parametroBean.fechaSucursal);
		}

	});	
	
//	------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({	
		rules: {
			
			fechaInicial: {
				date: true

			},
			fechaFinal: {
				date: true

			}
			
		},		
		messages: {
			
			fechaInicial: {
				date: 'Fecha Incorrecta.'

			},
			fechaFinal: {
				date: 'Fecha Incorrecta.'

			}
		}		
	});

		
	function enviaDatosRepExcel(){
		var nombreusuario 		= $('#nombreUsuario').val();
		var nombreInstitucion	= $('#nombreInstitucion').val();
		var fechaEmision 		= $('#fechaEmision').val();	
		var fechaInicial		= $('#fechaInicial').val();
		var fechaFinal	 		= $('#fechaFinal').val();		
		var tipoReporte			= 2;
		var tipoLista			= catFormatoReporte.excel;

			var pagina ='reporteRetensionISR.htm?tipoReporte='+tipoReporte+'&nombreUsuario='+nombreusuario+'&nombreInstitucion='+
						nombreInstitucion+'&fechaInicial='+fechaInicial+'&fechaFinal='+ fechaFinal+'&fechaEmision='+fechaEmision+
						'&tipoLista='+tipoLista;														
						window.open(pagina,'_blank');
						//deshabilitaBoton('generar','submit');
									
	}
	
	function enviaDatosRepPDF(){
		var nombreusuario 		= $('#nombreUsuario').val();
		var nombreInstitucion	= $('#nombreInstitucion').val();
		var fechaEmision 		= $('#fechaEmision').val();	
		var fechaInicial		= $('#fechaInicial').val();
		var fechaFinal	 		= $('#fechaFinal').val();		
		var tipoReporte			= 1;
		var tipoLista			= catFormatoReporte.pdf;

			var pagina ='reporteRetensionISR.htm?tipoReporte='+tipoReporte+'&nombreUsuario='+nombreusuario+'&nombreInstitucion='+
						nombreInstitucion+'&fechaInicial='+fechaInicial+'&fechaFinal='+ fechaFinal+'&fechaEmision='+fechaEmision+
						'&tipoLista='+tipoLista;														
						window.open(pagina,'_blank');
						//deshabilitaBoton('generar','submit');
									
	}
					
	
		

	function cargaSucursales(){
		dwr.util.removeAllOptions('sucursalID');
		dwr.util.addOptions( 'sucursalID', {'0':'TODAS'});
		sucursalesServicio.listaCombo(catTipoListaSucursal.combo, function(sucursales){
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		});
	}


//	FIN VALIDACIONES DE REPORTES

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
	
	   //Funcion de consulta para obtener el nombre de la institucion	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto!='' && !isNaN(numInstituto)){
				institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){		
					if(instituto!=null){							
						$('#desnombreInstitucion').val(instituto.nombre);
					}else{
						alert("No existe la Institución"); 
						$('#institucionID').val('');
						$('#institucionID').focus();
						$('#nombreInstitucion').val("");
					}    						
				});
		}else{
			$('#institucionID').val('');
			$('#nombreInstitucion').val("");
		}
	}	
	
	function consultaCliente(idControl) {	
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();
			setTimeout("$('#cajaLista').hide();", 200);

			if (numCliente != '' && !isNaN(numCliente) && esTab) {
				clienteServicio.consulta(1, numCliente, function(cliente) {
					if (cliente != null) {					
						$('#nombreCliente').val(cliente.nombreCompleto);			

					} else {
						alert("No Existe el Cliente");
						$('#clienteID').val(0);
						$('#nombreCliente').val('');						
					}
				});
			}
		}
	
	function fechamayorI(){
		if($('#fechaInicial').val() > fechaSistema ){						
			alert('La Fecha no Puede ser Mayor a la del Sistema');
			$('#fechaInicial').val(fechaSistema);						
		}
		else if($('#fechaInicial').val() > $('#fechaFinal').val()){
			alert('La Fecha de Inicio no Pueder Mayor a la de Fin');
			$('#fechaInicial').val(fechaSistema);	
			}
		}
	function fechamayorF(){
		}
		
	

	

}); // Fin Document

