/**
 * JS PARA LA PANTALLA TOTAL APLICADOS WS
 * Programador: LVICENTE
 * Version: 1.76
 */

	var parametroBean = null;
	var esTab= true;
	var tipoReporte = null;
	
	var tipoLista = {
			'listaAyuda': 1
		};
	
	$(document).ready(function(){
		parametroBean = consultaParametrosSession();

		agregaFormatoControles('formaGenerica');
		
		$('#excel').attr("checked",true) ; 
		$('#fechaInicio').val(parametroBean.fechaAplicacion);
		$('#fechaFin').val(parametroBean.fechaAplicacion);
		$('#institNominaID').val('0');
		$('#institNomina').val('TODAS');
		$('#convenioNominaID').val('0');
		$('#nombreConvenio').val('TODAS');
		
		
		
		tipoReporte= '1';
		/*pone tap falso cuando toma el foco input text */
		$(':text').focus(function() {	
		 	esTab = false;
		});
		
		/*pone tab en verdadero cuando se presiona tab */
		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});
		
		
		$.validator.setDefaults({
			submitHandler: function(event) { 	
			
		  }
		});
		
		
		
		$('#formaGenerica').validate({			
			rules: {
				institNominaID :{ 
					required:true
					},
					convenioNominaID :{
					required:true
					}
			},		
			messages: {
				institNominaID :{
					required:'Ingrese una Empresa de Nómina.',
				},
				convenioNominaID :{
					required:'Ingrese un Convenio de Nómina.'
					}
			}		
		});
		
		
		$('#institNominaID').bind('keyup',function(){
			lista('institNominaID', '1', '1', 'institNominaID', $('#institNominaID').val(), 'institucionesNomina.htm');
		});
		
		$('#institNominaID').blur(function(){
			setTimeout("$('#cajaLista').hide();", 200);
			var institNominaID= $("#institNominaID").val();
			if(institNominaID=='' || institNominaID==null || institNominaID=='0'){
				$('#institNominaID').val('0');
				$('#institNomina').val('TODAS');
			}else{
				if(esTab){
					consultaInstitucionNomina(this.id);
					$('#convenioNominaID').val('0');
					$('#nombreConvenio').val('TODOS');
				}
			}
		});
		
		$('#convenioNominaID').blur(function() {
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#convenioNominaID').val() == null || $('#convenioNominaID').val() == '' || $('#convenioNominaID').val() =='0') {
				$('#convenioNominaID').val('0');
				$('#nombreConvenio').val('TODAS');
			} else {
				if(esTab){
					consultaConvenioNomina(this.id);
				
				}
			}
		});

		$('#convenioNominaID').bind('keyup', function(e) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = 'institNominaID';
			camposLista[1] = 'descripcion';
			parametrosLista[0] = $('#institNominaID').val();
			parametrosLista[1] = $('#convenioNominaID').val();
			lista('convenioNominaID', '2', tipoLista.listaAyuda, camposLista, parametrosLista, 'listaConveniosNomina.htm');
		});

		
		
		
		//Valida la fecha de inicio del reporte
		$('#fechaInicio').change(function() {
			var Xfecha= $('#fechaInicio').val();
			if(esFechaValida(Xfecha)){
				if(Xfecha==''){
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
				var Yfecha= $('#fechaFin').val();
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha Inicio no Debe ser Mayor a la Fecha Fin.")	;
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}else{
					if($('#fechaInicio').val() > parametroBean.fechaSucursal) {
						mensajeSis("La Fecha Inicio no Debe ser Mayor a la Fecha del Sistema.");
						$('#fechaInicio').val(parametroBean.fechaSucursal);
					}
				}
			}else{
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
			regresarFoco('fechaInicio');
		});

		//Valida la fecha de fin del reporte
		$('#fechaFin').change(function() {
			var Xfecha= $('#fechaInicio').val();
			var Yfecha= $('#fechaFin').val();
			if(esFechaValida(Yfecha)){
				if(Yfecha ==''){
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}
				if ( mayor(Xfecha, Yfecha) ){
					mensajeSis("La Fecha Fin no Debe ser Menor a la Fecha Inicio.")	;
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}else{
					if($('#fechaFin').val() > parametroBean.fechaSucursal) {
						mensajeSis("La Fecha  Final  es Mayor a la Fecha del Sistema.");
						$('#fechaFin').val(parametroBean.fechaSucursal);
					}				
				}
			}else{
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			regresarFoco('fechaFin');
		});
		
		$('#excel').click(function() {
			$('#excel').attr("checked",true); 
			$('#pdf').attr("checked",false);
			tipoReporte='1';
		});
	
		$('#ligaGenerar').click(function(){
			generaReporte();
		});
	});//Fin de Document Ready
	
	
	
	
	/*funciones para validar las fechas*/
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
					mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
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
					mensajeSis("Fecha Introducida Errónea");
				return false;
				}
				if (dia>numDias || dia==0){
					mensajeSis("Fecha Introducida Errónea");
					return false;
				}
				return true;
			}
	   }


	 function comprobarSiBisisesto(anio){
			if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
				return true;
			}else {
				return false;
			}
	   }
	 
	 function regresarFoco(idControl){
			
			var jqControl=eval("'#"+idControl+"'");
			setTimeout(function(){
				$(jqControl).focus();
			 },0);
		}
	 
	 //Consulta de Institucion de Nomina
	 function consultaInstitucionNomina(idControl) {
	 	var jqNombreInst = eval("'#" + idControl + "'");
	 	var institucionID = $(jqNombreInst).val();	
	 	var tipoConsulta = 1 ;
	 	var institucionBean = {
	 			'institNominaID': institucionID				
	 	};	
	 	if(institucionID != '' && esTab){ 
	 		if(institucionID == '0' || institucionID ==0){
	 			$('#institNomia').val('TODOS');
	 		}else{
	 			if(!isNaN(institucionID)) {
	 				institucionNomServicio.consulta(tipoConsulta,institucionBean,function(institNomina) {
	 				if(institNomina!= null){
	 					$('#institNomina').val(institNomina.nombreInstit);
	 					}
	 				else {
	 					mensajeSis("El Número de Empresa No Existe");
	 					$('#institNominaID').focus();
	 					$('#institNominaID').val('0');
	 					$('#institNomina').val('TODAS');
	 				}
	 				});
	 			 }
	 			else{
	 				mensajeSis('La Empresa de Nómina es Incorrecta.');
	 				$('#institNominaID').focus();
	 				$('#institNominaID').val('0');
	 				$('#institNomina').val('TODAS');
	 			}
	 	}
	 	}else{
	 		mensajeSis('Especifique la Empresa de Nómina.');
	 		$('#institNominaID').focus();
	 		$('#institNominaID').val('0');
			$('#institNomina').val('TODAS');
	 	}
	 }
	 
	 
	 
	 function consultaConvenioNomina(idControl) {
		 var jqConvNomina = eval("'#" + idControl + "'");
			var convenioBean = {
				'convenioNominaID': $(jqConvNomina).val()
			};
			setTimeout("$('#cajaLista').hide();", 200);
			conveniosNominaServicio.consulta(1, convenioBean, function(resultado) {
				if(resultado != null) {
					if($('#institNominaID').val()!=0 &&
							(resultado.institNominaID == $('#institNominaID').val())){
						$("#nombreConvenio").val(resultado.descripcion);
					}else{
						
						mensajeSis("El convenio "+$("#convenioNominaID").val()+" no corresponde con la Empresa de Nómina.");
						$("#convenioNominaID").val(0);
						$("#nombreConvenio").val("TODOS");
					}
					
				}else{
					mensajeSis("El convenio no existe");
				}
			});
		}
	 
	 function generaReporte(){
		  var fechaIni = $('#fechaInicio').val();
		  var fechaFin	= $('#fechaFin').val();
		  var nombreInstit    =  parametroBean.nombreInstitucion;
		  var fechaEm = parametroBean.fechaAplicacion;
		  var institNominaID = $('#institNominaID').val();
		  var institNomina = $('#institNomina').val();
		  var convenioID =$('#convenioNominaID').val();
		  var nombreConvenio = $("#nombreConvenio").val();
		  var usuario = parametroBean.claveUsuario;

			$('#ligaGenerar').attr('href','repTotalAplicadosWS.htm?fechaInicial='+fechaIni+
																'&fechaFin='+fechaFin+
																'&institNominaID='+institNominaID+
																'&institNomina='+institNomina+
																'&convenioNominaID='+convenioID+
																'&nombreConvenio='+nombreConvenio+
																'&usuario='+usuario+
																'&nombreInstitucion='+nombreInstit+
																'&fechaSis='+fechaEm+
																'&tipoReporte='+tipoReporte);	
}
	 

	 
	 function encoding(cadena){
			return btoa(cadena);
		}

		function decoding(cadena){
			return atob(cadena)
		}